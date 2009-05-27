Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbZE0E3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbZE0E3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 00:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbZE0E31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 00:29:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56840 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZE0E31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 00:29:27 -0400
Message-ID: <4A1CC19C.3010409@jp.fujitsu.com>
Date: Wed, 27 May 2009 13:29:16 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org,
       Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 02/31] x86: MCE: Improve mce_get_rip v3
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org> <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com> <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> From: Huang Ying <ying.huang@intel.com>
> 
> Assume RIP is valid when either EIPV or RIPV are set.

Bad description.
If RIP means "restart IP" that is valid only if RIPV is set,
this sentence doesn't make sense completely.

Followings will be better:
"Assume IP stored on the stack indicates the address of instruction
 at the time of the MCE when either EIPV or RIPV are set."

> This influences
> whether the machine check exception handler decides to return or panic.

I suppose you are pointing logics in:

                mce_get_rip(&m, regs);
 :
                        panicm = m;
 :
                /*
                 * If the EIPV bit is set, it means the saved IP is the
                 * instruction which caused the MCE.
                 */
                if (m.mcgstatus & MCG_STATUS_EIPV)
                        user_space = panicm.ip && (panicm.cs & 3);

                /*
                 * If we know that the error was in user space, send a
                 * SIGBUS.  Otherwise, panic if tolerance is low.
                 *
                 * force_sig() takes an awful lot of locks and has a slight
                 * risk of deadlocking.
                 */
                if (user_space) {
                        force_sig(SIGBUS, current);
                } else if (panic_on_oops || tolerant < 2) {
                        mce_panic("Uncorrected machine check",
                                &panicm, mcestart);
                }

So EIPV without RIPV will be no ip and will result in panic,
while expected result is SIGBUS. 

> This fixes a test case in the mce-test suite and is more compliant
> to the specification.

It would be better to describe about the test case that need this fix.

> This currently only makes a difference in a artificial testing
> scenario with the mce-test test suite.
> 
> Also in addition do not force the RIP to be valid with the exact
> register MSRs.

I think the forced one is EIP:
> -		m->mcgstatus |= MCG_STATUS_EIPV;

And please note that it keep use CS on stack even if MSR is available.

I made an alternative patch for this, with no functional change.
Please consider replacing.


Thanks,
H.Seto

> [AK: combination of patches from Huang Ying and Hidetoshi Seto, with
> new description by me]
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 249e3cf..3f158d7 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -247,21 +247,22 @@ int mce_available(struct cpuinfo_x86 *c)
>  	return cpu_has(c, X86_FEATURE_MCE) && cpu_has(c, X86_FEATURE_MCA);
>  }
>  
> +/*
> + * Get the address of the instruction at the time of the machine check
> + * error.
> + */
>  static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
>  {
> -	if (regs && (m->mcgstatus & MCG_STATUS_RIPV)) {
> +
> +	if (regs && (m->mcgstatus & (MCG_STATUS_RIPV|MCG_STATUS_EIPV))) {
>  		m->ip = regs->ip;
>  		m->cs = regs->cs;
>  	} else {
>  		m->ip = 0;
>  		m->cs = 0;
>  	}
> -	if (rip_msr) {
> -		/* Assume the RIP in the MSR is exact. Is this true? */
> -		m->mcgstatus |= MCG_STATUS_EIPV;
> +	if (rip_msr)
>  		m->ip = mce_rdmsrl(rip_msr);
> -		m->cs = 0;
> -	}
>  }
>  
>  /*

