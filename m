Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbZBQSMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbZBQSMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZBQSMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:12:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:41703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbZBQSMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:12:33 -0500
Message-ID: <499AFDAF.2060705@kernel.org>
Date: Tue, 17 Feb 2009 10:10:55 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] x86, apic: move APIC drivers to arch/x86/kernel/apic/*
References: <tip-f62bae5009c1ba596cd475cafbc83e0570a36e26@kernel.org>
In-Reply-To: <tip-f62bae5009c1ba596cd475cafbc83e0570a36e26@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

could move probe_32.c es7000_32.c numaq_32.c summit_32.c to apic/ too

YH

Ingo Molnar wrote:
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Tue, 17 Feb 2009 18:09:24 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 17 Feb 2009 18:17:36 +0100
> 
> x86, apic: move APIC drivers to arch/x86/kernel/apic/*
> 
> arch/x86/kernel/ is getting a bit crowded, and the APIC
> drivers are scattered into various different files.
> 
> Move them to arch/x86/kernel/apic/*, and also remove
> the 'gen' prefix from those which had it.
> 
> Also move APIC related functionality: the IO-APIC driver,
> the NMI and the IPI code.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/kernel/Makefile                           |   27 ++++++++-----------
>  arch/x86/kernel/apic/Makefile                      |   15 +++++++++++
>  arch/x86/kernel/{ => apic}/apic.c                  |    0
>  arch/x86/kernel/{genapic_64.c => apic/apic_64.c}   |    0
>  .../{genapic_flat_64.c => apic/apic_flat_64.c}     |    0
>  arch/x86/kernel/{ => apic}/io_apic.c               |    0
>  arch/x86/kernel/{ => apic}/ipi.c                   |    0
>  arch/x86/kernel/{ => apic}/nmi.c                   |    0
>  .../{genx2apic_cluster.c => apic/x2apic_cluster.c} |    0
>  .../{genx2apic_phys.c => apic/x2apic_phys.c}       |    0
>  .../{genx2apic_uv_x.c => apic/x2apic_uv_x.c}       |    0
>  11 files changed, 26 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 1cefd21..9139ff6 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -58,13 +58,12 @@ obj-$(CONFIG_PCI)		+= early-quirks.o
>  apm-y				:= apm_32.o
>  obj-$(CONFIG_APM)		+= apm.o
>  obj-$(CONFIG_SMP)		+= smp.o
> -obj-$(CONFIG_SMP)		+= smpboot.o tsc_sync.o ipi.o
> +obj-$(CONFIG_SMP)		+= smpboot.o tsc_sync.o
>  obj-$(CONFIG_SMP)		+= setup_percpu.o
>  obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o
>  obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
>  obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
> -obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o ipi.o
> -obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
> +obj-$(CONFIG_X86_LOCAL_APIC)	+= apic/
>  obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
>  obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
>  obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
> @@ -116,17 +115,13 @@ obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb_64.o # NB rename without _64
>  ###
>  # 64 bit specific files
>  ifeq ($(CONFIG_X86_64),y)
> -        obj-y				+= genapic_64.o genapic_flat_64.o
> -        obj-$(CONFIG_X86_X2APIC)	+= genx2apic_cluster.o
> -        obj-$(CONFIG_X86_X2APIC)	+= genx2apic_phys.o
> -	obj-$(CONFIG_X86_UV)		+= genx2apic_uv_x.o tlb_uv.o
> -	obj-$(CONFIG_X86_UV)		+= bios_uv.o uv_irq.o uv_sysfs.o
> -        obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
> -        obj-$(CONFIG_AUDIT)		+= audit_64.o
> -
> -        obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
> -        obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
> -        obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o amd_iommu.o
> -
> -        obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
> +	obj-$(CONFIG_X86_UV)		+= tlb_uv.o bios_uv.o uv_irq.o uv_sysfs.o
> +	obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
> +	obj-$(CONFIG_AUDIT)		+= audit_64.o
> +
> +	obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
> +	obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
> +	obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o amd_iommu.o
> +
> +	obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
>  endif
> diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
> new file mode 100644
> index 0000000..da20b70
> --- /dev/null
> +++ b/arch/x86/kernel/apic/Makefile
> @@ -0,0 +1,15 @@
> +#
> +# Makefile for local APIC drivers and for the IO-APIC code
> +#
> +
> +obj-y				:= apic.o ipi.o nmi.o
> +obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
> +obj-$(CONFIG_SMP)		+= ipi.o
> +
> +ifeq ($(CONFIG_X86_64),y)
> +obj-y				+= apic_64.o apic_flat_64.o
> +obj-$(CONFIG_X86_X2APIC)	+= x2apic_cluster.o
> +obj-$(CONFIG_X86_X2APIC)	+= x2apic_phys.o
> +obj-$(CONFIG_X86_UV)		+= x2apic_uv_x.o
> +endif
> +
> diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic/apic.c
> similarity index 100%
> rename from arch/x86/kernel/apic.c
> rename to arch/x86/kernel/apic/apic.c
> diff --git a/arch/x86/kernel/genapic_64.c b/arch/x86/kernel/apic/apic_64.c
> similarity index 100%
> rename from arch/x86/kernel/genapic_64.c
> rename to arch/x86/kernel/apic/apic_64.c
> diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
> similarity index 100%
> rename from arch/x86/kernel/genapic_flat_64.c
> rename to arch/x86/kernel/apic/apic_flat_64.c
> diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> similarity index 100%
> rename from arch/x86/kernel/io_apic.c
> rename to arch/x86/kernel/apic/io_apic.c
> diff --git a/arch/x86/kernel/ipi.c b/arch/x86/kernel/apic/ipi.c
> similarity index 100%
> rename from arch/x86/kernel/ipi.c
> rename to arch/x86/kernel/apic/ipi.c
> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/apic/nmi.c
> similarity index 100%
> rename from arch/x86/kernel/nmi.c
> rename to arch/x86/kernel/apic/nmi.c
> diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
> similarity index 100%
> rename from arch/x86/kernel/genx2apic_cluster.c
> rename to arch/x86/kernel/apic/x2apic_cluster.c
> diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
> similarity index 100%
> rename from arch/x86/kernel/genx2apic_phys.c
> rename to arch/x86/kernel/apic/x2apic_phys.c
> diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
> similarity index 100%
> rename from arch/x86/kernel/genx2apic_uv_x.c
> rename to arch/x86/kernel/apic/x2apic_uv_x.c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tip-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

