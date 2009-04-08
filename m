Return-Path: <linux-kernel-owner+w=401wt.eu-S1763822AbZDHIUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763822AbZDHIUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763190AbZDHIP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:15:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42747 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763111AbZDHIPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:15:21 -0400
Message-ID: <49DC5D11.4060505@jp.fujitsu.com>
Date: Wed, 08 Apr 2009 17:15:13 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: ying.huang@intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
References: <20090407506.675031434@firstfloor.org> <20090407150656.43E161D046D@basil.firstfloor.org>
In-Reply-To: <20090407150656.43E161D046D@basil.firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> From: Huang Ying <ying.huang@intel.com>
> 
> Return rip/cs if MCG_STATUS_EIPV is set in mce_get_rip(). Remain m->cs
> if RIP is read from rip_msr.

It means we use "Error IP" as "Return IP" if RIPV=0 but EIPV=1 ...?
Sounds strange.

> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  arch/x86/kernel/cpu/mcheck/mce_64.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
> +++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:15.000000000 +0200
> @@ -175,7 +175,7 @@
>  
>  static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
>  {
> -	if (regs && (m->mcgstatus & MCG_STATUS_RIPV)) {
> +	if (regs && (m->mcgstatus & (MCG_STATUS_RIPV | MCG_STATUS_EIPV))) {
>  		m->ip = regs->ip;
>  		m->cs = regs->cs;
>  	} else {
> @@ -186,7 +186,6 @@
>  		/* Assume the RIP in the MSR is exact. Is this true? */
>  		m->mcgstatus |= MCG_STATUS_EIPV;

Why this "forcing EIPV=1" still required?
I think remaining this line will make something wrong.

>  		rdmsrl(rip_msr, m->ip);
> -		m->cs = 0;
>  	}
>  }

The mce_get_rip() is called from inside of a for-loop.
And assume that we start with RIPV=0 and EIPV=0:

Before applying this patch:

   if (rip_msr) { (m->ip, m->cs) = ((data from msr), 0); }
   else         { (m->ip, m->cs) = (0, 0); }

And After:

 1st call:
   if (rip_msr) { (m->ip, m->cs) = ((data from msr), 0); }
   else         { (m->ip, m->cs) = (0, 0); }
 2nd call and later:
   if (rip_msr) { (m->ip, m->cs) = ((data from msr), regs->cs); }
   else         { (m->ip, m->cs) = (0, 0); }

Plus, after applying [3/28] of your patchset for 2.6.31 (that
removes "m->mcgstatus |= MCG_STATUS_EIPV"), it will be again:

   if (rip_msr) { (m->ip, m->cs) = ((data from msr), 0); }
   else         { (m->ip, m->cs) = (0, 0); }

So I bet this patch does not work stand alone.


Given that:

  1) the ip retrieved by mce_get_rip() is now only used for input of
     mce_log().

  2) code in mce_log():

        if (m->ip) {
                printk(KERN_EMERG "RIP%s %02x:<%016Lx> ",
                       !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
                       m->cs, m->ip);
                if (m->cs == __KERNEL_CS)
                        print_symbol("{%s}", m->ip);
                printk("\n");
        }

  3) code in mce_cap_init():

        /* Use accurate RIP reporting if available. */
        if ((cap & MCG_EXT_P) && (MCG_NUM_EXT(cap) >= 9))
                rip_msr = MSR_IA32_MCG_EIP;

I guess it would make much sense if we stop mixing RIP and EIP and rename
the mce_get_rip() to mce_get_eip(), and the rip_msr to eip_msr too.

And then it would be acceptable if we print RIP with "!INEXACT!" annotation
instead of printing precise EIP in case of RIPV=0 but EIPV=1.


Thanks,
H.Seto
