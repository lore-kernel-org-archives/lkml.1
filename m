Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbYFLTuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbYFLTuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbYFLTuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:50:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:16360 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbYFLTuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:50:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aVZkkEzCbzkyqr/4uI00owk9HmaB+e5pmdt0WXyyiJGXKEBnk3dal9z9/7nIOJnqPs
         RSaj7mvEgPJJo2lSD/XF4Nded/qZf/QkyQ4Dw2DYYg3eAp2Isvs7Oc3mN/KubQAaq7qw
         WO44fNcE59cmftzNI2HCz+mWaX2j1IzCdKQSY=
Message-ID: <86802c440806121250s1b04c553ld505f6c76c2e206@mail.gmail.com>
Date: Thu, 12 Jun 2008 12:50:10 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [PATCH 2/2] x86: Move PCI IO ECS code to x86/pci
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <1213294763-19566-2-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080603072550.GR23679@erda.amd.com>
	 <1213294763-19566-2-git-send-email-robert.richter@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 11:19 AM, Robert Richter <robert.richter@amd.com> wrote:
> "Form follows function". Code is now where it belongs to.
>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/amd.c    |    3 ---
>  arch/x86/kernel/cpu/amd_64.c |    4 ----
>  arch/x86/kernel/cpu/cpu.h    |    2 --
>  arch/x86/kernel/setup.c      |   13 -------------
>  arch/x86/pci/Makefile_32     |    1 +
>  arch/x86/pci/amd_bus.c       |   32 ++++++++++++++++++++++++++++++++
>  arch/x86/pci/direct.c        |   16 +++++++++-------
>  arch/x86/pci/pci.h           |    1 +
>  include/asm-x86/cpufeature.h |    2 --
>  9 files changed, 43 insertions(+), 31 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index acc891a..81a07ca 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -266,9 +266,6 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>
>        if (cpu_has_xmm2)
>                set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
> -
> -       if (c->x86 == 0x10)
> -               amd_enable_pci_ext_cfg(c);
>  }
>
>  static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
> diff --git a/arch/x86/kernel/cpu/amd_64.c b/arch/x86/kernel/cpu/amd_64.c
> index f8d2058..250bfe6 100644
> --- a/arch/x86/kernel/cpu/amd_64.c
> +++ b/arch/x86/kernel/cpu/amd_64.c
> @@ -6,7 +6,6 @@
>  #include <asm/cacheflush.h>
>
>  #include <mach_apic.h>
> -#include "cpu.h"
>
>  extern int __cpuinit get_model_name(struct cpuinfo_x86 *c);
>  extern void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c);
> @@ -187,9 +186,6 @@ void __cpuinit init_amd(struct cpuinfo_x86 *c)
>        if (c->x86 == 0x10)
>                fam10h_check_enable_mmcfg();
>
> -       if (c->x86 == 0x10)
> -               amd_enable_pci_ext_cfg(c);
> -
>        if (c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
>                unsigned long long tseg;
>
> diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
> index f5d5bb1..40ad189 100644
> --- a/arch/x86/kernel/cpu/cpu.h
> +++ b/arch/x86/kernel/cpu/cpu.h
> @@ -39,5 +39,3 @@ extern int get_model_name(struct cpuinfo_x86 *c);
>  extern void display_cacheinfo(struct cpuinfo_x86 *c);
>
>  #endif /* CONFIG_X86_32 */
> -
> -extern void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c);
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 20e14db..6f80b85 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -137,16 +137,3 @@ void __init setup_per_cpu_areas(void)
>  }
>
>  #endif
> -#define ENABLE_CF8_EXT_CFG      (1ULL << 46)
> -
> -void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c)
> -{
> -       u64 reg;
> -       rdmsrl(MSR_AMD64_NB_CFG, reg);
> -       if (!(reg & ENABLE_CF8_EXT_CFG)) {
> -               reg |= ENABLE_CF8_EXT_CFG;
> -               wrmsrl(MSR_AMD64_NB_CFG, reg);
> -       }
> -       set_cpu_cap(c, X86_FEATURE_PCI_EXT_CFG);
> -}
> -
> diff --git a/arch/x86/pci/Makefile_32 b/arch/x86/pci/Makefile_32
> index 89ec35d..f647e7e 100644
> --- a/arch/x86/pci/Makefile_32
> +++ b/arch/x86/pci/Makefile_32
> @@ -22,3 +22,4 @@ pci-$(CONFIG_X86_NUMAQ)               := numa.o irq.o
>  pci-$(CONFIG_NUMA)             += mp_bus_to_node.o
>
>  obj-y                          += $(pci-y) common.o early.o
> +obj-y                          += amd_bus.o
> diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
> index 5c2799c..15f505d 100644
> --- a/arch/x86/pci/amd_bus.c
> +++ b/arch/x86/pci/amd_bus.c
> @@ -1,5 +1,9 @@
>  #include <linux/init.h>
>  #include <linux/pci.h>
> +#include "pci.h"
> +
> +#ifdef CONFIG_X86_64
> +
>  #include <asm/pci-direct.h>
>  #include <asm/mpspec.h>
>  #include <linux/cpumask.h>
> @@ -526,3 +530,31 @@ static int __init early_fill_mp_bus_info(void)
>  }
>
>  postcore_initcall(early_fill_mp_bus_info);
> +
> +#endif
> +
> +/* common 32/64 bit code */
> +
> +#define ENABLE_CF8_EXT_CFG      (1ULL << 46)
> +
> +static void enable_pci_io_ecs_per_cpu(void *unused)
> +{
> +       u64 reg;
> +       rdmsrl(MSR_AMD64_NB_CFG, reg);
> +       if (!(reg & ENABLE_CF8_EXT_CFG)) {
> +               reg |= ENABLE_CF8_EXT_CFG;
> +               wrmsrl(MSR_AMD64_NB_CFG, reg);
> +       }
> +}
> +
> +static int __init enable_pci_io_ecs(void)
> +{
> +       /* assume all cpus from fam10h have IO ECS */
> +        if (boot_cpu_data.x86 < 0x10)
> +               return 0;
> +       on_each_cpu(enable_pci_io_ecs_per_cpu, NULL, 1, 1);

how about some cpu hotplug? i mean if you limit that when booting and
later use "echo 1 > /sys/.../online" etc to get it online.

YH
