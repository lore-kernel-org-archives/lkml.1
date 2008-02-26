Return-Path: <linux-kernel-owner+w=401wt.eu-S1761686AbYBZQz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761686AbYBZQz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 11:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbYBZQzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 11:55:16 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:64926 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbYBZQzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 11:55:14 -0500
Date: Tue, 26 Feb 2008 08:54:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [linux-pm] [demo patch/RFC] sleepy linux
Message-Id: <20080226085422.6408fc4a.randy.dunlap@oracle.com>
In-Reply-To: <20080226102652.GA1830@elf.ucw.cz>
References: <20080226102652.GA1830@elf.ucw.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

On Tue, 26 Feb 2008 11:26:53 +0100 Pavel Machek wrote:


Hi Pavel,

Is this limited to UP and only one disk?

[comments below]


> Sleepy linux support, demo version, but it works on my thinkpad x60 ;-).
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/Documentation/power/sleepy.txt b/Documentation/power/sleepy.txt
> new file mode 100644
> index 0000000..a9caf05
> --- /dev/null
> +++ b/Documentation/power/sleepy.txt
> @@ -0,0 +1,55 @@
> +		Sleepy Linux
> +		~~~~~~~~~~~~
> +
> +Copyright 2007 Pavel Machek <pavel@suse.cz>
> +	  GPLv2
> +
> +Current Linux versions can enter suspend-to-RAM just fine, but only
> +can do it on explicit request. But suspend-to-RAM is important, eating

  Usually "can only do it" AFAIK.

> +something like 10% of power needed for idle system. Starting suspend
> +manually is not too convinient; it is not an option on multiuser

                       convenient;

> +machine, and even on single user machine, some things are not easy:
> +
> +1) Download this big chunk in mozilla, then go to sleep
> +
> +2) Compile this, then go to sleep
> +
> +3) You can sleep now, but wake me up in 8:30 with mp3 player
> +
> +Todays hardware is mostly capable of doing better: with correctly set

   Today's

> +up wakeups, machine can sleep and successfully pretend it is not
> +sleeping -- by waking up whenever something interesting happens. Of
> +course, it is easier on machines not connected to the network, and on
> +notebook computers.
> +
> +Requirements:
> +
> +0) Working suspend-to-RAM, with kernel being able to bring video back.
> +
> +1) RTC clock that can wake up system
> +
> +2) Lid that can wake up a system,
> +   or keyboard that can wake up system and does not loose keypress

                                                       lose

> +   or special screensaver setup
> +
> +3) Network card that is either down
> +   or can wake up system on any packet (and not loose too many packets)

                                                   lose

> +
> +How to use it
> +~~~~~~~~~~~~~
> +
> +First, make sure your config is tiny enough that cpu sleeps at least

                                                    CPU (please)

> +five or so seconds between wakeups. You'll probably need to disable
> +USB, make some kernel timers way longer than default and boot with
> +init=/bin/bash.
> +
> +Then, enable SCSI powersave by something like:
> +
> +mount /sys

Isn't /sys auto-mounted by kernel?

> +echo auto > /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/power/level
> +echo 3 > /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/power/autosuspend
> +echo adisk > /sys/power/state
> +mount / -oremount,commit=900
> +
> +Then, echo auto > /sys/power/state should enable sleepy support. Do it
> +twice, and it will ignore open lid and sleep anyway.

> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 29e71bd..0197b1f 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -268,6 +269,41 @@ static struct class_device_attribute *ah
>  	NULL
>  };
>  
> +struct pci_dev *my_pdev;
> +int autosuspend_enabled;
> +
> +struct sleep_disabled_reason ahci_active = {
> +        "ahci"
> +};
> +
> +/* The host and its devices are all idle so we can autosuspend */
> +static int autosuspend(struct Scsi_Host *host)
> +{
> +	if (my_pdev && autosuspend_enabled) {
> +		printk("ahci: should autosuspend\n");

Use printk() KERN_* levels (multiple places).


> +		ahci_pci_device_suspend(my_pdev, PMSG_SUSPEND);
> +		enable_auto_sleep(&ahci_active);
> +		return 0;
> +	} 
> +	printk("ahci: autosuspend disabled\n");
> +	return -EINVAL;
> +}
> +
...
> +}
> +
> +
> +
>  static struct scsi_host_template ahci_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
> @@ -1820,6 +1858,10 @@ static void ahci_thaw(struct ata_port *a
>  
>  static void ahci_error_handler(struct ata_port *ap)
>  {
> +	struct ata_host *host = ap->host;
> +	int rc;
> +	extern int slept;

Eh?

> +
>  	if (!(ap->pflags & ATA_PFLAG_FROZEN)) {
>  		/* restart engine */
>  		ahci_stop_engine(ap);

General comment:  Lots of the comment fixes in libata should be part
of a standalone patch, not part of this patch.


> diff --git a/include/linux/ata.h b/include/linux/ata.h
> index 78bbaca..df2dd4f 100644
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -298,6 +298,13 @@ enum {
>  	SCR_ACTIVE		= 3,
>  	SCR_NOTIFICATION	= 4,
>  
> +	/* SControl subfields, each field is 4 bit wide */

                                               bits

> +	ATA_SCTL_DET		= 0, /* lsb */
> +	ATA_SCTL_SPD		= 1,
> +	ATA_SCTL_IPM		= 2,
> +	ATA_SCTL_SPM		= 3,
> +	ATA_SCTL_PMP		= 4,
> +
>  	/* SError bits */
>  	SERR_DATA_RECOVERED	= (1 << 0), /* recovered data error */
>  	SERR_COMM_RECOVERED	= (1 << 1), /* recovered comm failure */

> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index a29da58..2470e94 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -3,6 +3,7 @@
>   *
>   * Copyright (c) 2003 Patrick Mochel
>   * Copyright (c) 2003 Open Source Development Lab
> + * Copyright (c) 2007 Pavel Machek <pavel@suse.cz>

It's 2008 now.

>   * 
>   * This file is released under the GPLv2
>   *
> @@ -22,7 +23,10 @@ #include <linux/freezer.h>
>  #include <linux/vmstat.h>
>  #include <linux/syscalls.h>
>  
> +#include <asm/percpu.h>
> +
>  #include "power.h"
> +#include "../../drivers/scsi/scsi_priv.h"

ugh.

>  DEFINE_MUTEX(pm_mutex);
>  
> @@ -426,6 +437,76 @@ static int enter_state(suspend_state_t s
>  	return error;
>  }
>  
> +/* Returns how long it waited in ms */
> +//extern long (*panic_blink)(long time);
> +
> +int slept;
> +
> +
> +struct sleep_disabled_reason wakeup_tasks = {
> +	"wakeup_tasks"
> +};
> +
> +int device_suspend_fake(pm_message_t state);
> +
> +int
> +do_auto_sleep(void)

All on one line.

> +{
> +	int error,i;

space after comma.

> +	int state = PM_SUSPEND_MEM;
> +
> +	/* add baby "morning tasks" to the lists. BUG if it is not
> +	   the only baby */
> +
> +	if (slept)
> +		return;
> +	slept++;
> +	disable_auto_sleep(&wakeup_tasks);
> +//	device_suspend_fake(PMSG_SUSPEND);
> +	suspend_enter(state);
> +
> +	/* FIXME: run "morning tasks" in process context; drivers need to check why
> +	   machine was woken, and perhaps put themselves back to crying babies list
> +	   if lid was opened or something. */
> +
> +	enable_auto_sleep(&wakeup_tasks);
> +
> +#if 0
> +	printk("finishing\n");
> +	if (suspend_ops->finish)
> +		suspend_ops->finish();
> +#endif
> +
> +	return 0;
> +}
> +
> +extern int set_alarm(int length);
> +
> +void
> +enter_auto_sleep(int length)

All on one line.

> +{
> +	int error;
> +
> +	if (atomic_read(&cpu_needed))
> +		return;
> +
> +	printk("Auto sleeping\n");
> +	set_alarm(length);
> +
> +	error = do_auto_sleep();
> +	if (error)
> +		printk("enter auto sleep failed: %d\n", error);
> +}
>  
>  /**
>   *	pm_suspend - Externally visible function for suspending system.
> @@ -481,6 +562,12 @@ #endif
>  	return (s - buf);
>  }
>  
> +extern struct pci_dev *my_pdev;
> +extern int autosuspend_enabled;
> +extern struct device *my_scsi_disk;
> +extern int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
> +extern int ahci_pci_device_resume(struct pci_dev *pdev);
> +

Externs in header files, please.

>  static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
>  			   const char *buf, size_t n)
>  {
...


---
~Randy
