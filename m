Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbYIXFyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbYIXFyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 01:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbYIXFyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 01:54:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbYIXFyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 01:54:03 -0400
Date: Tue, 23 Sep 2008 22:53:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/3] corruption check: move the corruption checks into
 their own file
Message-Id: <20080923225306.09fc27b4.akpm@linux-foundation.org>
In-Reply-To: <20080923215335.05678239@infradead.org>
References: <20080923215335.05678239@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008 21:53:35 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> 
> >From 19058f850aaf82d8185f06b54582a3d8e1ca8d97 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Mon, 22 Sep 2008 09:35:06 -0700
> Subject: [PATCH] corruption check: move the corruption checks into their own file
> 
> There'll be more checks over time (based on kerneloops data I have
> several ideas already) and making the checks their own file rather
> than setup.c makes sense in that light.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  arch/x86/kernel/Makefile |    1 +
>  arch/x86/kernel/check.c  |  156 ++++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/setup.c  |  151 --------------------------------------------

So this is long-standing code.  Let's pretend otherwise ;)

>  include/asm-x86/setup.h  |    4 +
>  4 files changed, 161 insertions(+), 151 deletions(-)
>  create mode 100644 arch/x86/kernel/check.c
> 
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index c71722d..5d788ea 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -36,6 +36,7 @@ obj-y			+= bootflag.o e820.o
>  obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
>  obj-y			+= alternative.o i8253.o pci-nommu.o
>  obj-y			+= tsc.o io_delay.o rtc.o
> +obj-y			+= check.o
>  
>  obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
>  obj-y				+= process.o
> diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
> new file mode 100644
> index 0000000..a7e80ed
> --- /dev/null
> +++ b/arch/x86/kernel/check.c
> @@ -0,0 +1,156 @@
> +#include <linux/module.h>
> +#include <linux/sched.h>
> +
> +#include <asm/e820.h>
> +#include <asm/proto.h>
> +
> +/*
> + * Some BIOSes seem to corrupt the low 64k of memory during events
> + * like suspend/resume and unplugging an HDMI cable.  Reserve all
> + * remaining free memory in that area and fill it with a distinct
> + * pattern.
> + */
> +#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
> +#define MAX_SCAN_AREAS	8
> +
> +static int __read_mostly memory_corruption_check = -1;
> +
> +static unsigned __read_mostly corruption_check_size = 64*1024;
> +static unsigned __read_mostly corruption_check_period = 60; /* seconds */
> +
> +static struct e820entry scan_areas[MAX_SCAN_AREAS];
> +static int num_scan_areas;
> +
> +
> +static int set_corruption_check(char *arg)
> +{
> +	char *end;
> +
> +	memory_corruption_check = simple_strtol(arg, &end, 10);
> +
> +	return (*end == 0) ? 0 : -EINVAL;
> +}
> +early_param("memory_corruption_check", set_corruption_check);

__init?

> +static int set_corruption_check_period(char *arg)
> +{
> +	char *end;
> +
> +	corruption_check_period = simple_strtoul(arg, &end, 10);
> +
> +	return (*end == 0) ? 0 : -EINVAL;
> +}
> +early_param("memory_corruption_check_period", set_corruption_check_period);

__init?

> +static int set_corruption_check_size(char *arg)
> +{
> +	char *end;
> +	unsigned size;
> +
> +	size = memparse(arg, &end);
> +
> +	if (*end == '\0')
> +		corruption_check_size = size;
> +
> +	return (size == corruption_check_size) ? 0 : -EINVAL;
> +}
> +early_param("memory_corruption_check_size", set_corruption_check_size);

__init?

> +
> +void __init setup_bios_corruption_check(void)
> +{
> +	u64 addr = PAGE_SIZE;	/* assume first page is reserved anyway */
> +
> +	if (memory_corruption_check == -1) {
> +		memory_corruption_check =
> +#ifdef CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
> +			1
> +#else
> +			0
> +#endif
> +			;
> +	}
> +
> +	if (corruption_check_size == 0)
> +		memory_corruption_check = 0;
> +
> +	if (!memory_corruption_check)
> +		return;
> +
> +	corruption_check_size = round_up(corruption_check_size, PAGE_SIZE);
> +
> +	while(addr < corruption_check_size && num_scan_areas < MAX_SCAN_AREAS) {
> +		u64 size;
> +		addr = find_e820_area_size(addr, &size, PAGE_SIZE);
> +
> +		if (addr == 0)
> +			break;
> +
> +		if ((addr + size) > corruption_check_size)
> +			size = corruption_check_size - addr;
> +
> +		if (size == 0)
> +			break;
> +
> +		e820_update_range(addr, size, E820_RAM, E820_RESERVED);
> +		scan_areas[num_scan_areas].addr = addr;
> +		scan_areas[num_scan_areas].size = size;
> +		num_scan_areas++;
> +
> +		/* Assume we've already mapped this early memory */
> +		memset(__va(addr), 0, size);
> +
> +		addr += size;
> +	}
> +
> +	printk(KERN_INFO "Scanning %d areas for low memory corruption\n",
> +	       num_scan_areas);
> +	update_e820();
> +}
> +
> +static struct timer_list periodic_check_timer;

Could use DEFINE_TIMER() here.

> +void check_for_bios_corruption(void)
> +{
> +	int i;
> +	int corruption = 0;
> +
> +	if (!memory_corruption_check)
> +		return;
> +
> +	for(i = 0; i < num_scan_areas; i++) {
> +		unsigned long *addr = __va(scan_areas[i].addr);
> +		unsigned long size = scan_areas[i].size;
> +
> +		for(; size; addr++, size -= sizeof(unsigned long)) {
> +			if (!*addr)
> +				continue;
> +			printk(KERN_ERR "Corrupted low memory at %p (%lx phys) = %08lx\n",
> +			       addr, __pa(addr), *addr);
> +			corruption = 1;
> +			*addr = 0;
> +		}
> +	}
> +
> +	WARN(corruption, KERN_ERR "Memory corruption detected in low memory\n");
> +}
> +
> +static void periodic_check_for_corruption(unsigned long data)
> +{
> +	check_for_bios_corruption();
> +	mod_timer(&periodic_check_timer, round_jiffies(jiffies + corruption_check_period*HZ));
> +}
> +
> +void start_periodic_check_for_corruption(void)
> +{
> +	if (!memory_corruption_check || corruption_check_period == 0)
> +		return;
> +
> +	printk(KERN_INFO "Scanning for low memory corruption every %d seconds\n",
> +	       corruption_check_period);
> +
> +	init_timer(&periodic_check_timer);
> +	periodic_check_timer.function = &periodic_check_for_corruption;

and zap those.

> +	periodic_check_for_corruption(0);
> +}
> +#endif

