Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617AbXIREgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbXIREgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 00:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbXIREf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 00:35:56 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38267 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbXIREfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 00:35:55 -0400
Date: Tue, 18 Sep 2007 10:06:07 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/7] Use extended crashkernel command line on i386
Message-ID: <20070918043607.GB4842@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070913161428.343951643@strauss.suse.de> <20070913161429.087964162@strauss.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913161429.087964162@strauss.suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 06:14:30PM +0200, Bernhard Walle wrote:
> -
>  void arch_crash_save_vmcoreinfo(void)
>  {
>  #ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
> --- a/arch/i386/kernel/setup.c
> +++ b/arch/i386/kernel/setup.c
> @@ -381,6 +381,33 @@ extern unsigned long __init setup_memory
>  extern void zone_sizes_init(void);
>  #endif /* !CONFIG_NEED_MULTIPLE_NODES */
> 
> +#ifdef CONFIG_KEXEC
> +static void reserve_crashkernel(void)
> +{
> +	unsigned long long 	free_mem;
> +	unsigned long long 	crash_size, crash_base;
> +	int			ret;
> +
> +	free_mem = (max_low_pfn + highend_pfn - highstart_pfn) << PAGE_SHIFT;
> +
> +	ret = parse_crashkernel(boot_command_line, free_mem,
> +			&crash_size, &crash_base);
> +	if (ret == 0 && crash_size > 0 && crash_base > 0) {
> +		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
> +				"for crashkernel (System RAM: %ldMB)\n",
> +				(unsigned long)(crash_size >> 20),
> +				(unsigned long)(crash_base >> 20),
> +				(unsigned long)(free_mem >> 20));
> +		crashk_res.start = crash_base;
> +		crashk_res.end   = crash_base + crash_size - 1;
> +		reserve_bootmem(crash_base, crash_size);

Hi Bernhard,

I think we might need to do more here. Because [offset] is optional, one
would assume that things will work even if offset is not specified. But
in this patchset, that's not the case for i386 and x86_64. It will silently
fail if a user does not specify the offset. No memory will be reserved for
capture kernel.

I think we either need to make offset mandatory or put in additional
intelligence here to choose the offset automatically based on the memory
available.

Thanks
Vivek
