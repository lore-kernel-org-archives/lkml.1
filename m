Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZFBPnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZFBPnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbZFBPmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:42:54 -0400
Received: from www.tglx.de ([62.245.132.106]:51448 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbZFBPmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:42:54 -0400
Date: Tue, 2 Jun 2009 17:36:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 05/16] xen mtrr: Add mtrr_ops support for Xen mtrr
In-Reply-To: <1242163718-2934-6-git-send-email-jeremy@goop.org>
Message-ID: <alpine.LFD.2.00.0906021729260.3419@localhost.localdomain>
References: <1242163718-2934-1-git-send-email-jeremy@goop.org> <1242163718-2934-6-git-send-email-jeremy@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, Jeremy Fitzhardinge wrote:
>  	if (cpu_has_mtrr) {
>  		mtrr_if = &generic_mtrr_ops;
> +#ifdef CONFIG_XEN_DOM0
> +		xen_init_mtrr();
> +#endif
> +

  No #ifdefs please. Also isn't there some common place where Xen can
  do all of it's magic extra init ?

  Aside of that this patch needs to be split into two. One adding the
  num_var_ranges op and one adding the Xen bits.

> +#include <xen/interface/platform.h>
> +#include <asm/xen/hypervisor.h>
> +#include <asm/xen/hypercall.h>
> +
> +static int __init xen_num_var_ranges(void);

  Can we move the function here please ?

> +/* DOM0 TODO: Need to fill in the remaining mtrr methods to have full
> + * working userland mtrr support. */
> +static struct mtrr_ops xen_mtrr_ops = {
> +	.vendor            = X86_VENDOR_UNKNOWN,
> +	.get_free_region   = generic_get_free_region,
> +	.have_wrcomb       = positive_have_wrcomb,
> +	.use_intel_if	   = 0,
> +	.num_var_ranges	   = xen_num_var_ranges,
> +};
> +
> +static int __init xen_num_var_ranges(void)
> +{
> +	int ranges;
> +	struct xen_platform_op op;
> +
> +	for (ranges = 0; ; ranges++) {
> +		op.cmd = XENPF_read_memtype;

  Is op.cmd changed in the hypervisor call ?

> +		op.u.read_memtype.reg = ranges;
> +		if (HYPERVISOR_dom0_op(&op) != 0)
> +			break;
> +	}
> +	return ranges;
> +}
> +
> +void __init xen_init_mtrr(void)
> +{
> +	struct cpuinfo_x86 *c = &boot_cpu_data;
> +
> +	if (!xen_initial_domain())
> +		return;
> +
> +	if ((!cpu_has(c, X86_FEATURE_MTRR)) &&

  cpu_has_mtrr ..... please 

> +	    (!cpu_has(c, X86_FEATURE_K6_MTRR)) &&
> +	    (!cpu_has(c, X86_FEATURE_CYRIX_ARR)) &&
> +	    (!cpu_has(c, X86_FEATURE_CENTAUR_MCR)))
> +		return;

Thanks,

	tglx
