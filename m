Return-Path: <linux-kernel-owner+w=401wt.eu-S933193AbYEAVwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbYEAVwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762377AbYEAVwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:52:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762247AbYEAVw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:52:28 -0400
Date: Thu, 1 May 2008 14:51:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chen Gong <g.chen@freescale.com>
Cc: linuxppc-dev@ozlabs.org, wim@iguana.be, linux-kernel@vger.kernel.org,
       g.chen@freescale.com
Subject: Re: [PATCH] Watchdog on MPC85xx SMP system
Message-Id: <20080501145137.a5af389c.akpm@linux-foundation.org>
In-Reply-To: <1209458525-8041-2-git-send-email-g.chen@freescale.com>
References: <1209458525-8041-1-git-send-email-g.chen@freescale.com>
	<1209458525-8041-2-git-send-email-g.chen@freescale.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 16:42:05 +0800
Chen Gong <g.chen@freescale.com> wrote:

> On Book-E SMP systems each core has its own private watchdog.
> If only one watchdog is enabled, when the core that doesn't
> enable the watchdog is hung, system can't reset because no
> watchdog is running on it. That's bad. It means we must
> enable watchdogs on both cores.
> 
> We can use smp_call_function() to send appropriate messages to
> all the other cores to enable and update the watchdog.
> 
> Signed-off-by: Chen Gong <g.chen@freescale.com>
> ---
> Now Tested on MPC8572DS platform.
> 
>  drivers/watchdog/booke_wdt.c |   31 +++++++++++++++++++++++--------
>  1 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
> index d362f5b..8a4e7f0 100644
> --- a/drivers/watchdog/booke_wdt.c
> +++ b/drivers/watchdog/booke_wdt.c
> @@ -1,12 +1,12 @@
>  /*
> - * drivers/char/watchdog/booke_wdt.c
> + * drivers/watchdog/booke_wdt.c
>   *
>   * Watchdog timer for PowerPC Book-E systems
>   *
>   * Author: Matthew McClintock
>   * Maintainer: Kumar Gala <galak@kernel.crashing.org>
>   *
> - * Copyright 2005 Freescale Semiconductor Inc.
> + * Copyright 2005, 2008 Freescale Semiconductor Inc.
>   *
>   * This program is free software; you can redistribute  it and/or modify it
>   * under  the terms of  the GNU General  Public License as published by the
> @@ -16,6 +16,7 @@
>  
>  #include <linux/module.h>
>  #include <linux/fs.h>
> +#include <linux/smp.h>
>  #include <linux/miscdevice.h>
>  #include <linux/notifier.h>
>  #include <linux/watchdog.h>
> @@ -47,23 +48,31 @@ u32 booke_wdt_period = WDT_PERIOD_DEFAULT;
>  #define WDTP(x)		(TCR_WP(x))
>  #endif
>  
> +static DEFINE_SPINLOCK(booke_wdt_lock);
> +
> +static void __booke_wdt_ping(void *data)
> +{
> +	mtspr(SPRN_TSR, TSR_ENW|TSR_WIS);
> +}
> +
>  /*
>   * booke_wdt_ping:
>   */
>  static __inline__ void booke_wdt_ping(void)
>  {
> -	mtspr(SPRN_TSR, TSR_ENW|TSR_WIS);
> +	smp_call_function(__booke_wdt_ping, NULL, 0, 0);
> +	__booke_wdt_ping(NULL);
>  }
>  
>  /*
> - * booke_wdt_enable:
> + * __booke_wdt_enable:
>   */
> -static __inline__ void booke_wdt_enable(void)
> +static inline void __booke_wdt_enable(void *data)
>  {
>  	u32 val;
>  
>  	/* clear status before enabling watchdog */
> -	booke_wdt_ping();
> +	__booke_wdt_ping(NULL);
>  	val = mfspr(SPRN_TCR);
>  	val |= (TCR_WIE|TCR_WRC(WRC_CHIP)|WDTP(booke_wdt_period));
>  
> @@ -137,12 +146,15 @@ static int booke_wdt_ioctl (struct inode *inode, struct file *file,
>   */
>  static int booke_wdt_open (struct inode *inode, struct file *file)
>  {
> +	spin_lock(&booke_wdt_lock);
>  	if (booke_wdt_enabled == 0) {
>  		booke_wdt_enabled = 1;
> -		booke_wdt_enable();
> +		__booke_wdt_enable(NULL);
> +		smp_call_function(__booke_wdt_enable, NULL, 0, 0);

It's nonsensical to call an inlined function via smp_call_function().  What
we're asking the compiler to do here is to generate both an out-of-line
copy and an inlined copy.

Also, the above is an open-coded version of on_each_cpu().

so...  something like the below should tidy that up, along with numerous
other things.  Can you please check it over?



diff -puN drivers/watchdog/booke_wdt.c~watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix drivers/watchdog/booke_wdt.c
--- a/drivers/watchdog/booke_wdt.c~watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix
+++ a/drivers/watchdog/booke_wdt.c
@@ -1,6 +1,4 @@
 /*
- * drivers/watchdog/booke_wdt.c
- *
  * Watchdog timer for PowerPC Book-E systems
  *
  * Author: Matthew McClintock
@@ -39,7 +37,7 @@
 #define WDT_PERIOD_DEFAULT 3	/* Refer to the PPC40x and PPC4xx manuals */
 #endif				/* for timing information */
 
-u32 booke_wdt_enabled = 0;
+u32 booke_wdt_enabled;
 u32 booke_wdt_period = WDT_PERIOD_DEFAULT;
 
 #ifdef	CONFIG_FSL_BOOKE
@@ -55,19 +53,12 @@ static void __booke_wdt_ping(void *data)
 	mtspr(SPRN_TSR, TSR_ENW|TSR_WIS);
 }
 
-/*
- * booke_wdt_ping:
- */
-static __inline__ void booke_wdt_ping(void)
+static void booke_wdt_ping(void)
 {
-	smp_call_function(__booke_wdt_ping, NULL, 0, 0);
-	__booke_wdt_ping(NULL);
+	on_each_cpu(__booke_wdt_ping, NULL, 0, 0);
 }
 
-/*
- * __booke_wdt_enable:
- */
-static inline void __booke_wdt_enable(void *data)
+static void __booke_wdt_enable(void *data)
 {
 	u32 val;
 
@@ -79,10 +70,7 @@ static inline void __booke_wdt_enable(vo
 	mtspr(SPRN_TCR, val);
 }
 
-/*
- * booke_wdt_write:
- */
-static ssize_t booke_wdt_write (struct file *file, const char __user *buf,
+static ssize_t booke_wdt_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
 	booke_wdt_ping();
@@ -90,15 +78,11 @@ static ssize_t booke_wdt_write (struct f
 }
 
 static struct watchdog_info ident = {
-  .options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
-  .firmware_version = 0,
-  .identity = "PowerPC Book-E Watchdog",
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = "PowerPC Book-E Watchdog",
 };
 
-/*
- * booke_wdt_ioctl:
- */
-static int booke_wdt_ioctl (struct inode *inode, struct file *file,
+static int booke_wdt_ioctl(struct inode *inode, struct file *file,
 			    unsigned int cmd, unsigned long arg)
 {
 	u32 tmp = 0;
@@ -106,7 +90,7 @@ static int booke_wdt_ioctl (struct inode
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user ((struct watchdog_info __user *) arg, &ident,
+		if (copy_to_user((struct watchdog_info __user *)arg, &ident,
 				sizeof(struct watchdog_info)))
 			return -EFAULT;
 	case WDIOC_GETSTATUS:
@@ -141,18 +125,15 @@ static int booke_wdt_ioctl (struct inode
 
 	return 0;
 }
-/*
- * booke_wdt_open:
- */
-static int booke_wdt_open (struct inode *inode, struct file *file)
+
+static int booke_wdt_open(struct inode *inode, struct file *file)
 {
 	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
-		__booke_wdt_enable(NULL);
-		smp_call_function(__booke_wdt_enable, NULL, 0, 0);
-		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
-				booke_wdt_period);
+		on_each_cpu(__booke_wdt_enable, NULL, 0, 0);
+		printk(KERN_INFO "PowerPC Book-E Watchdog Timer Enabled "
+				"(wdt_period=%d)\n", booke_wdt_period);
 	}
 	spin_unlock(&booke_wdt_lock);
 
@@ -160,17 +141,17 @@ static int booke_wdt_open (struct inode 
 }
 
 static const struct file_operations booke_wdt_fops = {
-  .owner = THIS_MODULE,
-  .llseek = no_llseek,
-  .write = booke_wdt_write,
-  .ioctl = booke_wdt_ioctl,
-  .open = booke_wdt_open,
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = booke_wdt_write,
+	.ioctl = booke_wdt_ioctl,
+	.open = booke_wdt_open,
 };
 
 static struct miscdevice booke_wdt_miscdev = {
-  .minor = WATCHDOG_MINOR,
-  .name = "watchdog",
-  .fops = &booke_wdt_fops,
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &booke_wdt_fops,
 };
 
 static void __exit booke_wdt_exit(void)
@@ -178,29 +159,25 @@ static void __exit booke_wdt_exit(void)
 	misc_deregister(&booke_wdt_miscdev);
 }
 
-/*
- * booke_wdt_init:
- */
 static int __init booke_wdt_init(void)
 {
 	int ret = 0;
 
-	printk (KERN_INFO "PowerPC Book-E Watchdog Timer Loaded\n");
+	printk(KERN_INFO "PowerPC Book-E Watchdog Timer Loaded\n");
 	ident.firmware_version = cur_cpu_spec->pvr_value;
 
 	ret = misc_register(&booke_wdt_miscdev);
 	if (ret) {
-		printk (KERN_CRIT "Cannot register miscdev on minor=%d (err=%d)\n",
+		printk(KERN_CRIT "Cannot register miscdev on minor=%d: %d\n",
 				WATCHDOG_MINOR, ret);
 		return ret;
 	}
 
 	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 1) {
-		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
-				booke_wdt_period);
-		__booke_wdt_enable(NULL);
-		smp_call_function(__booke_wdt_enable, NULL, 0, 0);
+		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled "
+				"(wdt_period=%d)\n", booke_wdt_period);
+		on_each_cpu(__booke_wdt_enable, NULL, 0, 0);
 	}
 	spin_unlock(&booke_wdt_lock);
 
_

