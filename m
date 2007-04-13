Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbXDMQNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbXDMQNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 12:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbXDMQNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 12:13:34 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61342 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbXDMQNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 12:13:34 -0400
Date: Fri, 13 Apr 2007 09:13:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bernhard Kaindl <bk@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH 1/4] Adds mtrr_save_fixed_ranges() for use in two later
 patches.
Message-Id: <20070413091358.cf8c426e.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0704131735570.17956@jbgna.fhfr.qr>
References: <20070413121533.082325752@mahler.suse.de>
	<Pine.LNX.4.64.0704131735570.17956@jbgna.fhfr.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 17:50:50 +0200 (CEST) Bernhard Kaindl wrote:

> ---
>  arch/i386/kernel/cpu/mtrr/generic.c |   16 +++++++++++++++-
>  include/asm-i386/mtrr.h             |    2 ++
>  include/asm-x86_64/proto.h          |    2 ++
>  3 files changed, 19 insertions(+), 1 deletion(-)
> 
> Index: 2.6.21-rc6-mm1/arch/i386/kernel/cpu/mtrr/generic.c
> ===================================================================
> --- 2.6.21-rc6-mm1.orig/arch/i386/kernel/cpu/mtrr/generic.c
> +++ 2.6.21-rc6-mm1/arch/i386/kernel/cpu/mtrr/generic.c
> @@ -37,7 +37,11 @@ get_mtrr_var_range(unsigned int index, s
>  	rdmsr(MTRRphysMask_MSR(index), vr->mask_lo, vr->mask_hi);
>  }
> 
> -static void __cpuinit
> +/**
> + * Retrieves the current fixed-range MTRRs from the current CPU
> + * \param frs address where to write the current MTRR contents
> + */

Please use correct kernel-doc notation.
See Documentation/kernel-doc-nano-HOWTO.txt for details.

Briefly:  "/**" begins a kernel-doc comment block.
Next line is "function short description" (when it's a function).
Parameters are referred to as @param, not \param.

Please check the entire patch series for this.

> +static void
>  get_fixed_ranges(mtrr_type * frs)
>  {
>  	unsigned int *p = (unsigned int *) frs;
> @@ -51,6 +55,16 @@ get_fixed_ranges(mtrr_type * frs)
>  		rdmsr(MTRRfix4K_C0000_MSR + i, p[6 + i * 2], p[7 + i * 2]);
>  }
> 
> +/**
> + * Updates our copy of the state of the fixed-range MTRR values
> + * with the current fixed-range MTRR contents from the current CPU
> + * \param info dummy needed for use by smp_call_function_single()
> + */
> +void mtrr_save_fixed_ranges(void *info)
> +{
> +	get_fixed_ranges(mtrr_state.fixed_ranges);
> +}
> +
>  static void __cpuinit print_fixed(unsigned base, unsigned step, const mtrr_type*types)
>  {
>  	unsigned i;
> Index: 2.6.21-rc6-mm1/include/asm-i386/mtrr.h
> ===================================================================
> --- 2.6.21-rc6-mm1.orig/include/asm-i386/mtrr.h
> +++ 2.6.21-rc6-mm1/include/asm-i386/mtrr.h
> @@ -69,6 +69,7 @@ struct mtrr_gentry
> 
>  /*  The following functions are for use by other drivers  */
>  # ifdef CONFIG_MTRR
> +extern void mtrr_save_fixed_ranges(void *);

We prefer to have a variable name in the prototype (cf. below).


>  extern int mtrr_add (unsigned long base, unsigned long size,
>  		     unsigned int type, char increment);
>  extern int mtrr_add_page (unsigned long base, unsigned long size,


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
