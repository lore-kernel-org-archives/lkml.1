Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbZEUBrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbZEUBrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 21:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZEUBrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 21:47:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:36184 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbZEUBrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 21:47:02 -0400
Message-ID: <4A14B271.5010202@kernel.org>
Date: Thu, 21 May 2009 10:46:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: suresh.b.siddha@intel.com
CC: "H. Peter Anvin" <hpa@zytor.com>,
       "JBeulich@novell.com" <JBeulich@novell.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel-owner@vger.kernel.org" 
	<linux-kernel-owner@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap allocator
References: <1242305390-21958-1-git-send-email-tj@kernel.org>	 <1242436626.27006.8623.camel@localhost.localdomain>	 <4A0ED8D8.2010303@kernel.org>	 <1242500964.27006.8636.camel@localhost.localdomain>	 <4A0F672A.3000309@kernel.org>	 <1242674444.27006.8691.camel@localhost.localdomain>	 <4A11B9E7.8010707@zytor.com>	 <1242680835.27006.8734.camel@localhost.localdomain>	 <4A120B47.8060200@kernel.org>	 <1242860470.27006.10106.camel@localhost.localdomain>	 <4A149B89.3010104@kernel.org> <1242866163.27006.10125.camel@localhost.localdomain>
In-Reply-To: <1242866163.27006.10125.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 01:46:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Suresh Siddha wrote:
>> The dynamic onlining will probably use 4k pages so, yeah, it won't
>> have the alias issues but that's not the issue here, right?  You can
>> already avoid aliasing that way by simply using 4k allocator from the
>> get-go.
> 
> But now that I learnt about dynamic online allocation, can we avoid the
> complexity brought by this patchset, by simply using 4k allocator from
> get-go.

Sure, we can.

> i.e., can we drop this remap pageattr handling patchset and simply use
> 4k mapping for now? And move to dynamic allocation at a later point.

4k or not, x86 is already on dynamic allocation.  The only difference
is how the first chunk is allocated.

> This will simplify quite a bit of code.

Yes it will.  The question is which way would be better.  Till now,
there hasn't been any actual data on how remap compares to 4k.  The
only thing we know is that, on UMA, embed should behave exactly the
same for static percpu variables as before the whole dynamic
allocator.

On NUMA, both remap and 4k add some level of TLB pressure.  remap will
waste one more PMD TLB entry (dup) while 4k adds a bunch of 4k ones
(non-dup but what used to be accessed by PMD TLB is now accessed with
PTE TLB).  Some say using one more PMD TLB is better while others
disagree.  So, the best course of action here seems to offer both and
easy way to select between them so that data can be gathered, which is
what this patchset does.

I don't think the added complexity for cpa() justifies dropping remap
without further testing.  The added complexity isn't that big.  Most
of the confusion in this patchset came from my ignorance on the
subject.  cpa() is a fragile thing but we need it anyway, so...

Thanks.

-- 
tejun
