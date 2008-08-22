Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbYHVS4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbYHVS4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYHVS4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:56:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:59818 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbYHVS4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ofhot60jiHmsKHAxJSR3mNuh+z/XwcGmjz2ZISBKIXUhVmTn8g5OI6scWI8vTkgDWf
         S5NjZ7osJtCJtHSzoxfWaNmZ1oFEYeBG8kHClwGKxlt9vH8Pt7fa5L47RB2iEdORI5kT
         Sf7P/NsyNGjdioRGe2/gNv0g4JoGRpH6c5gns=
Message-ID: <86802c440808221156h7ef48973hb5db8cf2b01ac27b@mail.gmail.com>
Date: Fri, 22 Aug 2008 11:56:08 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [PATCH] x86: fix: make PCI ECS for AMD CPUs hotplug capable
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Jan Beulich" <jbeulich@novell.com>
In-Reply-To: <1219429418-29023-2-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD82D5.76E4.0078.0@novell.com>
	 <1219429418-29023-2-git-send-email-robert.richter@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 11:23 AM, Robert Richter <robert.richter@amd.com> wrote:
> Until now, PCI ECS setup was performed at boot time only and for cpus
> that are enabled then. This patch fixes this and adds cpu hotplug.
>
> Tests sequence (check if ECS bit is set when bringing cpu online again):
>
>  # ( perl -e 'sysseek(STDIN, 0xC001001F, 0)'; hexdump -n 8 -e '2/4 "%08x " "\n"' )   < /dev/cpu/1/msr
>  00000008 00404010
>  # ( perl -e 'sysseek(STDOUT, 0xC001001F, 0); print pack "l*", 8, 0x00400010' ) > /dev/cpu/1/msr
>  # ( perl -e 'sysseek(STDIN, 0xC001001F, 0)'; hexdump -n 8 -e '2/4 "%08x " "\n"' )   < /dev/cpu/1/msr
>  00000008 00400010
>  # echo 0 > /sys/devices/system/cpu/cpu1/online
>  # echo 1 > /sys/devices/system/cpu/cpu1/online
>  # ( perl -e 'sysseek(STDIN, 0xC001001F, 0)'; hexdump -n 8 -e '2/4 "%08x " "\n"' )   < /dev/cpu/1/msr
>  00000008 00404010
>
> Cc: Jan Beulich <jbeulich@novell.com>
> Cc: Yinghai Lu <yhlu.kernel@gmail.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/pci/amd_bus.c |   35 +++++++++++++++++++++++++++++++----
>  1 files changed, 31 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
> index 4a6f1a6..6a0fca7 100644
> --- a/arch/x86/pci/amd_bus.c
> +++ b/arch/x86/pci/amd_bus.c
> @@ -1,6 +1,7 @@
>  #include <linux/init.h>
>  #include <linux/pci.h>
>  #include <linux/topology.h>
> +#include <linux/cpu.h>
>  #include "pci.h"
>
>  #ifdef CONFIG_X86_64
> @@ -565,7 +566,7 @@ static int __init early_fill_mp_bus_info(void) { return 0; }
>
>  #define ENABLE_CF8_EXT_CFG      (1ULL << 46)
>
> -static void enable_pci_io_ecs_per_cpu(void *unused)
> +static void enable_pci_io_ecs(void *unused)
>  {
>        u64 reg;
>        rdmsrl(MSR_AMD64_NB_CFG, reg);
> @@ -575,13 +576,39 @@ static void enable_pci_io_ecs_per_cpu(void *unused)
>        }
>  }
>
> -static int __init enable_pci_io_ecs(void)
> +static int __cpuinit amd_cpu_notify(struct notifier_block *self,
> +                                   unsigned long action, void *hcpu)
>  {
> +       int cpu = (long)hcpu;
> +       switch(action) {
> +       case CPU_ONLINE:
> +       case CPU_ONLINE_FROZEN:
> +               smp_call_function_single(cpu, enable_pci_io_ecs, NULL, 0);
> +               break;
> +       default:
> +               break;
> +       }
> +       return NOTIFY_OK;
> +}
> +
> +static struct notifier_block __cpuinitdata amd_cpu_notifier = {
> +       .notifier_call  = amd_cpu_notify,
> +};
> +
> +static int __init pci_io_ecs_init(void)
> +{
> +       int cpu;
> +
>        /* assume all cpus from fam10h have IO ECS */
>         if (boot_cpu_data.x86 < 0x10)
>                return 0;
> -       on_each_cpu(enable_pci_io_ecs_per_cpu, NULL, 1);
> +
> +       register_cpu_notifier(&amd_cpu_notifier);
> +       for_each_online_cpu(cpu)
> +               amd_cpu_notify(&amd_cpu_notifier, (unsigned long)CPU_ONLINE,
> +                              (void *)(long)cpu);

wonder if those two lines should be reversed.

>        pci_probe |= PCI_HAS_IO_ECS;
> +
>        return 0;
>  }
>
> @@ -591,7 +618,7 @@ static int __init amd_postcore_init(void)
>                return 0;
>
>        early_fill_mp_bus_info();
> -       enable_pci_io_ecs();
> +       pci_io_ecs_init();
>
>        return 0;
>  }
> --
> 1.5.6.4
>
>
>
