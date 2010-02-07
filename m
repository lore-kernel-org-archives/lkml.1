Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab0BGCAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 21:00:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51381 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab0BGCAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 21:00:46 -0500
Message-ID: <4B6E1DA3.50204@zytor.com>
Date: Sat, 06 Feb 2010 17:55:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for hweight_long(CONSTANT)
References: <20100203074251.e2caa3f3.akpm@linux-foundation.org> <20100203181425.GB1367@aftab> <1265222875.24455.1020.camel@laptop> <4B69D362.10608@zytor.com> <20100204151050.GC32711@aftab> <1265296432.22001.18.camel@laptop> <20100204155419.GD32711@aftab> <1265299457.22001.72.camel@laptop> <20100205121139.GA9044@aftab> <4B6C93A2.1090302@zytor.com> <20100206093659.GA28326@aftab>
In-Reply-To: <20100206093659.GA28326@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2010 01:36 AM, Borislav Petkov wrote:
> 
>> c) You call a C function, but you don't clobber the set of registers
>> that a C function would clobber.  You either need to put the function in
>> an assembly wrapper (which is better in the long run), or clobber the
>> full set of registers that is clobbered by a C function (which is better
>> in the short term) -- which is eax, edx, ecx on 32 bits, but rax, rdi,
>> esi, rdx, rcx, r8, r9, r10, r11 on 64 bits.
> 
> I think you mean rsi instead of esi here.
> 
> Well, the example Brian pointed me to - __mutex_fastpath_lock - lists
> the full set of clobbered registers. Please elaborate on the assembly
> wrapper for the function, wouldn't I need to list all the clobbered
> registers there too or am I missing something?
> 

The notion there would be that you do push/pop in the assembly wrapper.

>> d) On the other hand, you do *not* need a "memory" clobber.
> 
> Right, in this case we have all non-barrier like inlines so no memory
> clobber, according to the comment above alternative() macro.

OK, I'm missing something here.

A few more notions:

a. This is exactly the kind of code where you don't want to put
"volatile" on your asm statement, because it's a pure compute.

b. It is really rather pointless to go through the whole alternatives
work if you are then going to put it inside a function which isn't an
inline ...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

