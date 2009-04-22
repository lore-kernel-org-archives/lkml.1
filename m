Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZDVLUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZDVLUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZDVLUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:20:46 -0400
Received: from mga12.intel.com ([143.182.124.36]:53720 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751511AbZDVLUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:20:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,230,1239001200"; 
   d="scan'208";a="134395033"
Message-ID: <49EEFD88.1030604@linux.intel.com>
Date: Wed, 22 Apr 2009 13:20:40 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com> <20090422092259.GC18226@elte.hu>
In-Reply-To: <20090422092259.GC18226@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Huang Ying <ying.huang@intel.com> wrote:
> 
>> Re-implement MCE log ring buffer as per-CPU ring buffer for better 
>> scalability. Basic design is as follow:
> 
> Before changing anything substantial in the MCE code it would be 
> necessary to clean up and then unify the 32-bit and 64-bit side of 
> the MCE code first. (Which essentially means extending the 
> 64-bit-only code to 32-bit)

I don't disagree. In fact my original patchkit had this first in 6-7 patches,
but I dropped the 32bit unification because you complained about
the interface. It's great that you changed your mind on that.
Anyways if we can go forward that now fine by me.

The big part is to make sure that the hardware workarounds in the
32bit code get applied to 64bit.  These are essentially the quirks
of PPro and K7.

Then there's some straight forward work needed to make the 64bit
code 32bit clean (mostly a few unsigned long -> u64)

And then there are the old non MCA handlers for p5 and winchip.
These are best kept separate, there isn't really much code commonality
here because they use completely different registers.
> 
> I've put a few cleanup patches into tip:x86/mce2 (warning: there are 
> a few broken ones at the tail - so consider it WIP), to help make 
> this happen:
> 
>  dd98699: x86, mce: print number of MCE banks
>  ef319a8: x86, mce: unify
>  be0f336: x86, mce: unify, prepare for 32-bit
>  90c99b7: x86, mce: prepare unification
>  1e1d4f8: x86, mce: prepare mce.h and mce_64.c for unification
>  fd6b13f: x86, mce: clean up mce_64.c
>  f7f8e03: x86, mce: clean up mce_intel.c
>  b19c8ea: x86, mce: unify the Intel thermal interrupt code
 >  6eade5b: mce: unify Intel thermal init, prepare

I don't think there's much to unify here, the 64bit code
can be just used as is on 32bit too (only needs the 64bit
mce_log infrastructure) and the 32bit code be dropped.

Would it be possible to drop these two changesets?

>  d393769: x86, mce: clean up mce.h
>  7bb2efa: x86, mce: clean up winchip.c
>  3b94f2b: x86, mce: clean up p5.c
>  13a219b: x86, mce: clean up mce_32.c
>  e69e307: x86, mce: clean up non-fatal.c
>  3b9a5bc: x86, mce: clean up k7.c
>  79e1d29: x86, mce: clean up p6.c
>  c5fac5b: x86, mce: clean up therm_throt.c
>  788a16a: x86, mce: clean up p4.c
>  07d7726: x86, mce: clean up mce_amd_64.c
>  a6a6958: x86, mce: clean up the sysfs variables namespace
>  895f799: x86, mce: clean up the mce_64.c code
> 
> these are the more questionable ones in need of restructurin

And then restart here? Add 32bit workarounds, add hook
to initialize p5/winchip, make 64bit code 32bit clean.
That can come straight from my patchkit. I can do that
if there is interest.

-Andi
