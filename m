Return-Path: <linux-kernel-owner+w=401wt.eu-S1762958AbYESRvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762958AbYESRvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYESRvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:51:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57607 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759301AbYESRvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:51:08 -0400
Message-ID: <4831BCC1.8090709@zytor.com>
Date: Mon, 19 May 2008 10:45:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Mikael Pettersson <mikpe@it.uu.se>, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       andi@firstfloor.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
References: <20080513011030.GA31448@linux-os.sc.intel.com> <18477.35703.679574.760417@harpo.it.uu.se> <20080518013416.GB30034@linux-os.sc.intel.com> <18481.37905.297556.288317@harpo.it.uu.se> <4831AACD.8030607@zytor.com> <20080519165735.GC30034@linux-os.sc.intel.com>
In-Reply-To: <20080519165735.GC30034@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
>>>
>> It's also wrong, since OSXSAVE indicates that the CPU can do it, not 
>> that the kernel can.
> 
> OSXSAVE indicates the OS support and XSAVE indicates the cpu support.
> 

Sorry, brainfart.  Don't post so early in the morning.

>> All we need is a single field -- a single byte -- reserved indefinitely 
>> for software use.  Existing FXSAVE kernels will have set it to zero.
>>
>> There might be fields the existing FXSAVE format which can be equally 
>> abused, even.  I will do some looking.
> 
> All the reserved fields at the end of fxsave format are zeroed and
> presented as such to the user. If HW makes some of these fields SW available,
> then we can use those (will check). If there is any scope with the
> existing format it self, that will be much better.

I was thinking about what we'd really like earlier, and given a clean 
slate I'd like to see a structure looking like:

struct state_ptrs {
	size_t len;
	struct state_foo *foo;
	struct state_bar *bar;
	...
};

... where len is sizeof(struct state_ptrs).  This is not merely 
extensible, but it's easy for userspace to massage it into whatever 
format -- longer or shorter -- that it happens to know about, and it 
gives a natural way for the kernel to communicate "none of this state" 
by feeding a NULL pointer.  So pretty much we're looking for a way to 
backwards-compatible way to stash a pointer to this structure, I figure.

	-hpa
