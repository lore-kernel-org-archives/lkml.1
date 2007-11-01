Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbXKAEir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbXKAEir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 00:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbXKAEij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 00:38:39 -0400
Received: from gw.goop.org ([64.81.55.164]:34044 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbXKAEii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 00:38:38 -0400
Message-ID: <47295846.8000700@goop.org>
Date: Wed, 31 Oct 2007 21:38:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com, tglx@linutronix.de,
       jun.nakajima@intel.com, glommer@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 16/16] make vsmp a paravirt client
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com> <1193858118284-git-send-email-gcosta@redhat.com> <11938581242810-git-send-email-gcosta@redhat.com> <1193858130443-git-send-email-gcosta@redhat.com> <11938581351064-git-send-email-gcosta@redhat.com> <11938581403478-git-send-email-gcosta@redhat.com> <11938581451804-git-send-email-gcosta@redhat.com> <11938581512730-git-send-email-gcosta@redhat.com> <11938581562552-git-send-email-gcosta@redhat.com> <11938581612389-git-send-email-gcosta@redhat.com> <11938581663639-git-send-email-gcosta@redhat.com> <11938581713998-git-send-email-gcosta@redhat.com> <11938581762150-git-send-email-gcosta@redhat.com> <11938581812241-git-send-email-gcosta@redhat.com> <1193858187364-git-send-email-gcosta@redhat.com>
In-Reply-To: <1193858187364-git-send-email-gcosta@redhat.com>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> This patch makes vsmp a paravirt client. It now uses the whole
> infrastructure provided by pvops. When we detect we're running
> a vsmp box, we change the irq-related paravirt operations (and so,
> it have to happen quite early), and the patching function
>
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> ---
>  arch/x86/Kconfig.x86_64    |    3 +-
>  arch/x86/kernel/setup_64.c |    3 ++
>  arch/x86/kernel/vsmp_64.c  |   72 +++++++++++++++++++++++++++++++++++++++----
>  include/asm-x86/setup.h    |    3 +-
>  4 files changed, 71 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
> index 04734dd..544bad5 100644
> --- a/arch/x86/Kconfig.x86_64
> +++ b/arch/x86/Kconfig.x86_64
> @@ -148,15 +148,14 @@ config X86_PC
>  	bool "PC-compatible"
>  	help
>  	  Choose this option if your computer is a standard PC or compatible.
> -
>  config X86_VSMP
>  	bool "Support for ScaleMP vSMP"
>  	depends on PCI
> +	select PARAVIRT
>  	 help
>  	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
>  	  supposed to run on these EM64T-based machines.  Only choose this option
>  	  if you have one of these machines.
> -
>  endchoice
>  
>  choice
> diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
> index 44a11e3..c522549 100644
> --- a/arch/x86/kernel/setup_64.c
> +++ b/arch/x86/kernel/setup_64.c
> @@ -335,6 +335,9 @@ void __init setup_arch(char **cmdline_p)
>  
>  	init_memory_mapping(0, (end_pfn_map << PAGE_SHIFT));
>  
> +#ifdef CONFIG_VSMP
> +	vsmp_init();
> +#endif
>  	dmi_scan_machine();
>  
>  #ifdef CONFIG_SMP
> diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
> index 414caf0..547d3b3 100644
> --- a/arch/x86/kernel/vsmp_64.c
> +++ b/arch/x86/kernel/vsmp_64.c
> @@ -8,18 +8,70 @@
>   *
>   * Ravikiran Thirumalai <kiran@scalemp.com>,
>   * Shai Fultheim <shai@scalemp.com>
> + * Paravirt ops integration: Glauber de Oliveira Costa <gcosta@redhat.com>
>   */
> -
>  #include <linux/init.h>
>  #include <linux/pci_ids.h>
>  #include <linux/pci_regs.h>
>  #include <asm/pci-direct.h>
>  #include <asm/io.h>
> +#include <asm/paravirt.h>
> +
> +/*
> + * Interrupt control for the VSMP architecture:
> + */
> +
> +static inline unsigned long vsmp_save_fl(void)
>   

No point being inline.

> +{
> +	unsigned long flags = native_save_fl();
> +
> +	if (flags & X86_EFLAGS_IF)
> +		return X86_EFLAGS_IF;
>   

Is this right, or should the if be testing _AC?  Otherwise, why not just
"return flags & X86_EFLAGS_IF"?

> +	return 0;
> +}
>  
> -static int __init vsmp_init(void)
> +static inline void vsmp_restore_fl(unsigned long flags)
> +{
> +	if (flags & X86_EFLAGS_IF)
> +		flags &= ~X86_EFLAGS_AC;
> +	if (!(flags & X86_EFLAGS_IF))
> +		flags &= X86_EFLAGS_AC;
>   

Just use "else"?

> +	native_restore_fl(flags);
> +}
> +
> +static inline void vsmp_irq_disable(void)
> +{
> +	unsigned long flags = native_save_fl();
> +
> +	vsmp_restore_fl((flags & ~X86_EFLAGS_IF));
>   

((double paren?))

> +}
> +
> +static inline void vsmp_irq_enable(void)
> +{
> +	unsigned long flags = native_save_fl();
> +
> +	vsmp_restore_fl((flags | X86_EFLAGS_IF));
> +}
> +
> +static unsigned __init vsmp_patch(u8 type, u16 clobbers, void *ibuf,
> +				  unsigned long addr, unsigned len)
> +{
> +	switch (type) {
> +	case PARAVIRT_PATCH(pv_irq_ops.irq_enable):
> +	case PARAVIRT_PATCH(pv_irq_ops.irq_disable):
> +	case PARAVIRT_PATCH(pv_irq_ops.save_fl):
> +	case PARAVIRT_PATCH(pv_irq_ops.restore_fl):
> +		return paravirt_patch_default(type, clobbers, ibuf, addr, len);
> +	default:
> +		return native_patch(type, clobbers, ibuf, addr, len);
> +	}
> +
> +}
> +
> +int __init vsmp_init(void)
>  {
>  	void *address;
> -	unsigned int cap, ctl;
> +	unsigned int cap, ctl, cfg;
>  
>  	if (!early_pci_allowed())
>  		return 0;
> @@ -29,8 +81,16 @@ static int __init vsmp_init(void)
>  	    (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) != PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
>  		return 0;
>  
> +	/* If we are, use the distinguished irq functions */
> +	pv_irq_ops.irq_disable = vsmp_irq_disable;
> +	pv_irq_ops.irq_enable  = vsmp_irq_enable;
> +	pv_irq_ops.save_fl  = vsmp_save_fl;
> +	pv_irq_ops.restore_fl  = vsmp_restore_fl;
> +	pv_init_ops.patch = vsmp_patch;
> +
>  	/* set vSMP magic bits to indicate vSMP capable kernel */
> -	address = ioremap(read_pci_config(0, 0x1f, 0, PCI_BASE_ADDRESS_0), 8);
> +	cfg = read_pci_config(0, 0x1f, 0, PCI_BASE_ADDRESS_0);
> +	address = early_ioremap(cfg, 8);
>  	cap = readl(address);
>  	ctl = readl(address + 4);
>  	printk("vSMP CTL: capabilities:0x%08x  control:0x%08x\n", cap, ctl);
> @@ -42,8 +102,6 @@ static int __init vsmp_init(void)
>  		printk("vSMP CTL: control set to:0x%08x\n", ctl);
>  	}
>  
> -	iounmap(address);
> +	early_iounmap(address, 8);
>  	return 0;
>  }
> -
> -core_initcall(vsmp_init);
> diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
> index 071e054..dd7996c 100644
> --- a/include/asm-x86/setup.h
> +++ b/include/asm-x86/setup.h
> @@ -58,7 +58,8 @@ void __init add_memory_region(unsigned long long start,
>  
>  extern unsigned long init_pg_tables_end;
>  
> -
> +/* For EM64T-based VSMP machines */
> +int vsmp_init(void);
>  
>  #endif /* __i386__ */
>  #endif /* _SETUP */
>   

