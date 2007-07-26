Return-Path: <linux-kernel-owner+w=401wt.eu-S933989AbXGZOVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989AbXGZOVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757210AbXGZOVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:21:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36488 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219AbXGZOVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:21:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: YOSHIFUJI Hideaki /
	 =?iso-2022-jp?q?=1B=24B5HF=231QL=40=1B=28B?= 
	<yoshfuji@linux-ipv6.org>
Subject: Re: [2.6.23-rc1 REGRESSION] ThinkPad T42 poweroff failure by "PM: Introduce pm_power_off_prepare"
Date: Thu, 26 Jul 2007 16:29:55 +0200
User-Agent: KMail/1.9.5
Cc: pavel@ucw.cz, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, michal.k.k.piotrowski@gmail.com
References: <200707251446.56809.rjw@sisk.pl> <200707261412.33839.rjw@sisk.pl> <20070726.080624.94043434.yoshfuji@linux-ipv6.org>
In-Reply-To: <20070726.080624.94043434.yoshfuji@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707261629.55741.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 July 2007 15:06, YOSHIFUJI Hideaki / 吉藤英明 wrote:
> Hello.
> 
> In article <200707261412.33839.rjw@sisk.pl> (at Thu, 26 Jul 2007 14:12:33 +0200), "Rafael J. Wysocki" <rjw@sisk.pl> says:
> 
> > On Wednesday, 25 July 2007 17:28, YOSHIFUJI Hideaki / 吉藤英明 wrote:
> > > Hello.
> > > 
> > > In article <200707251446.56809.rjw@sisk.pl> (at Wed, 25 Jul 2007 14:46:55 +0200), "Rafael J. Wysocki" <rjw@sisk.pl> says:
> > > 
> > > > On Wednesday, 25 July 2007 00:19, YOSHIFUJI Hideaki / 吉藤英明 wrote:
> > > :
> > > > > Linux 2.6.23-rc1 fails to power off my ThinkPad T42.
> > > > > Git-bisect told me that the following commit is to blame,
> > > > > and by reverting that commit, it works appropriately.
> > > > 
> > > > (1) Can you please apply the appended patch and see if the message gets
> > > >     printed when you try to power off the system?
> > > 
> > > Yup, I got it.  Last lines are:
> :
> > Can you please check if the appended patch helps?
> 
> Yes, it definitely does.  Thank you.

OK, so here it goes again with a changelog:

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Generally, sysdev_shutdown() should be called after the ACPI preparation for
powering the system off.  To make it happen, we can separate sysdev_shutdown()
from device_shutdown() and call it directly wherever necessary.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/shutdown.c |    2 --
 include/linux/device.h        |    3 +++
 kernel/power/disk.c           |    1 +
 kernel/sys.c                  |    3 +++
 4 files changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6.23-rc1/drivers/base/power/shutdown.c
===================================================================
--- linux-2.6.23-rc1.orig/drivers/base/power/shutdown.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.23-rc1/drivers/base/power/shutdown.c	2007-07-26 12:24:37.000000000 +0200
@@ -44,7 +44,5 @@ void device_shutdown(void)
 			dev->driver->shutdown(dev);
 		}
 	}
-
-	sysdev_shutdown();
 }
 
Index: linux-2.6.23-rc1/kernel/sys.c
===================================================================
--- linux-2.6.23-rc1.orig/kernel/sys.c	2007-07-23 22:07:02.000000000 +0200
+++ linux-2.6.23-rc1/kernel/sys.c	2007-07-26 12:08:07.000000000 +0200
@@ -804,6 +804,7 @@ static void kernel_restart_prepare(char 
 	blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, cmd);
 	system_state = SYSTEM_RESTART;
 	device_shutdown();
+	sysdev_shutdown();
 }
 
 /**
@@ -860,6 +861,7 @@ void kernel_shutdown_prepare(enum system
 void kernel_halt(void)
 {
 	kernel_shutdown_prepare(SYSTEM_HALT);
+	sysdev_shutdown();
 	printk(KERN_EMERG "System halted.\n");
 	machine_halt();
 }
@@ -876,6 +878,7 @@ void kernel_power_off(void)
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
+	sysdev_shutdown();
 	printk(KERN_EMERG "Power down.\n");
 	machine_power_off();
 }
Index: linux-2.6.23-rc1/kernel/power/disk.c
===================================================================
--- linux-2.6.23-rc1.orig/kernel/power/disk.c	2007-07-26 12:13:58.000000000 +0200
+++ linux-2.6.23-rc1/kernel/power/disk.c	2007-07-26 12:14:23.000000000 +0200
@@ -216,6 +216,7 @@ int hibernation_platform_enter(void)
 		 * sleep state after all
 		 */
 		error = hibernation_ops->prepare();
+		sysdev_shutdown();
 		if (!error)
 			error = hibernation_ops->enter();
 	} else {
Index: linux-2.6.23-rc1/include/linux/device.h
===================================================================
--- linux-2.6.23-rc1.orig/include/linux/device.h	2007-07-23 22:06:59.000000000 +0200
+++ linux-2.6.23-rc1/include/linux/device.h	2007-07-26 12:48:05.000000000 +0200
@@ -551,6 +551,9 @@ extern void put_device(struct device * d
 /* drivers/base/power/shutdown.c */
 extern void device_shutdown(void);
 
+/* drivers/base/sys.c */
+extern void sysdev_shutdown(void);
+
 
 /* drivers/base/firmware.c */
 extern int __must_check firmware_register(struct kset *);
