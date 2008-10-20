Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbYJTReF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbYJTReF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYJTRdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:33:49 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27007 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbYJTRdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:33:47 -0400
Date: Mon, 20 Oct 2008 10:32:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Andy Henroid <andrew.d.henroid@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] i7300_idle driver v1.55
Message-Id: <20081020103214.072e3b5f.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.1.10.0810161805360.3026@localhost.localdomain>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
	<e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com>
	<20081011083347.GA31918@elte.hu>
	<alpine.LFD.1.10.0810161805360.3026@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 18:08:01 -0400 (EDT) Len Brown wrote:

> From: Andy Henroid <andrew.d.henroid@intel.com>
> 
> The Intel 7300 Memory Controller supports dynamic throttling of memory which can
> be used to save power when system is idle. This driver does the memory
> throttling when all CPUs are idle on such a system.
> 
> Refer to "Intel 7300 Memory Controller Hub (MCH)" datasheet
> for the config space description.
> 
> Signed-off-by: Andy Henroid <andrew.d.henroid@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> ---
>  MAINTAINERS               |    6 +
>  arch/x86/Kconfig          |    2 +
>  drivers/Makefile          |    1 +
>  drivers/dma/ioat_dma.c    |    3 +
>  drivers/idle/Kconfig      |   16 +
>  drivers/idle/Makefile     |    2 +
>  drivers/idle/i7300_idle.c |  674 +++++++++++++++++++++++++++++++++++++++++++++

Why not just use drivers/power/ instead of a new sub-directory?


>  include/asm-x86/idle.h    |    1 +
>  include/linux/pci_ids.h   |    1 +
>  9 files changed, 706 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/idle/Kconfig
>  create mode 100644 drivers/idle/Makefile
>  create mode 100644 drivers/idle/i7300_idle.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8dae455..43f71b0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2078,6 +2078,12 @@ L:	linux-ide@vger.kernel.org
>  L:	linux-scsi@vger.kernel.org
>  S:	Orphan
>  
> +IDLE-I7300
> +P:	Andy Henroid
> +M:	andrew.d.henroid@intel.com

welcome back.

> +L:	linux-pm@lists.linux-foundation.org
> +S:	Supported
> +
>  IEEE 1394 SUBSYSTEM (drivers/ieee1394)
>  P:	Ben Collins
>  M:	ben.collins@ubuntu.com

> diff --git a/drivers/idle/i7300_idle.c b/drivers/idle/i7300_idle.c
> new file mode 100644
> index 0000000..59d1bbc
> --- /dev/null
> +++ b/drivers/idle/i7300_idle.c
> @@ -0,0 +1,674 @@
> +/*
> + * (C) Copyright 2008 Intel Corporation
> + * Authors:
> + * Andy Henroid <andrew.d.henroid@intel.com>
> + * Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> + */
> +
> +
> +/*
> + * Value to set THRTLOW to when initiating throttling
> + *  0 = No throttling
> + *  1 = Throttle when > 4 activations per eval window (Maximum throttling)
> + *  2 = Throttle when > 8 activations
> + *  168 = Throttle when > 168 activations (Minimum throttling)

Why do some numbers mean > their value (i.e., 168) but others don't?
Is it a linear value or logarithmic or what?


> + */
> +#define MAX_THRTLWLIMIT		168
> +static uint i7300_idle_thrtlowlm = 1;
> +module_param_named(thrtlwlimit, i7300_idle_thrtlowlm, uint, 0644);
> +MODULE_PARM_DESC(thrtlwlimit,
> +		"Value for THRTLOWLM activation field "
> +		"(0 = disable throttle, 1 = Max throttle, 168 = Min throttle)");
> +

> +/* Stop I/O AT memory copy */
> +static void i7300_idle_ioat_stop(void)
> +{
> +	int i;
> +	u8 sts;
> +
> +	for (i = 0; i < 5; i++) {
> +		writeb(IOAT_CHANCMD_RESET,
> +			ioat_chanbase + IOAT1_CHANCMD_OFFSET);
> +
> +		udelay(10);
> +
> +		sts = readq(ioat_chanbase + IOAT1_CHANSTS_OFFSET) &
> +			IOAT_CHANSTS_DMA_TRANSFER_STATUS;

readq() returns 64 bits.  You only want to LS-byte of it here?

> +		if (sts != IOAT_CHANSTS_DMA_TRANSFER_STATUS_ACTIVE)
> +			break;
> +
> +	}
> +
> +	if (i == 5)
> +		dprintk("failed to suspend+reset I/O AT after 5 retries\n");
> +
> +}


> +struct debugfs_file_info {
> +	void *ptr;
> +	char name[32];
> +	struct dentry *file;
> +} debugfs_file_list[] = {
> +				{&total_starts, "total_starts", NULL},
> +				{&total_us, "total_us", NULL},
> +#ifdef DEBUG
> +				{&past_skip, "past_skip", NULL},
> +#endif
> +				{NULL, "", NULL}
> +			};

What is debugfs used for?  any docs for it?

Does this build/work if CONFIG_DEBUG_FS=n?


> +static int __init i7300_idle_init(void)
> +{
> +	spin_lock_init(&i7300_idle_lock);
> +	cpus_clear(idle_cpumask);
> +	total_us = 0;
> +
> +	if (i7300_idle_platform_probe())
> +		return -ENODEV;
> +
> +	if (i7300_idle_thrt_save())
> +		return -ENODEV;
> +
> +	if (i7300_idle_ioat_init())
> +		return -ENODEV;
> +
> +	debugfs_dir = debugfs_create_dir("i7300_idle", NULL);
> +	if (debugfs_dir) {
> +		int i = 0;
> +
> +		while (debugfs_file_list[i].ptr != NULL) {
> +			debugfs_file_list[i].file = debugfs_create_file(
> +					debugfs_file_list[i].name,
> +					S_IRUSR,
> +					debugfs_dir,
> +					debugfs_file_list[i].ptr,
> +					&idle_fops);
> +			i++;
> +		}
> +	}
> +
> +	idle_notifier_register(&i7300_idle_nb);
> +
> +	printk(KERN_INFO "i7300_idle: loaded v%s\n", I7300_IDLE_DRIVER_VERSION);
> +	return 0;
> +}


---
~Randy
