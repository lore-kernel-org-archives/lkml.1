Return-Path: <linux-kernel-owner+w=401wt.eu-S1751543AbZI1EJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbZI1EJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 00:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbZI1EJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 00:09:43 -0400
Received: from mail.crca.org.au ([67.207.131.56]:39222 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbZI1EJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 00:09:43 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4AC0372E.8090706@crca.org.au>
Date: Mon, 28 Sep 2009 14:10:22 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Rafael Wysocki <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] Shift remaining code from swsusp.c to hibernate.c
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shift the remaining declaration of the variable in_suspend and the
function swsusp_show_speed from swsusp.c to hibernate.c, and delete
swsusp.c.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/Makefile    |    2 +-
 kernel/power/hibernate.c |   30 ++++++++++++++++
 kernel/power/swsusp.c    |   87 ----------------------------------------------
 3 files changed, 31 insertions(+), 88 deletions(-)
 delete mode 100644 kernel/power/swsusp.c

diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index c3b81c3..4319181 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_PM_SLEEP)		+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
-obj-$(CONFIG_HIBERNATION)	+= swsusp.o hibernate.o snapshot.o swap.o user.o
+obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o
 obj-$(CONFIG_HIBERNATION_NVS)	+= hibernate_nvs.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 04b3a83..a5b2538 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -32,6 +32,7 @@ static int noresume = 0;
 static char resume_file[256] = CONFIG_PM_STD_PARTITION;
 dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
+int in_suspend __nosavedata = 0;
 
 enum {
 	HIBERNATION_INVALID,
@@ -202,6 +203,35 @@ static void platform_recover(int platform_mode)
 }
 
 /**
+ *	swsusp_show_speed - print the time elapsed between two events represented by
+ *	@start and @stop
+ *
+ *	@nr_pages -	number of pages processed between @start and @stop
+ *	@msg -		introductory message to print
+ */
+
+void swsusp_show_speed(struct timeval *start, struct timeval *stop,
+			unsigned nr_pages, char *msg)
+{
+	s64 elapsed_centisecs64;
+	int centisecs;
+	int k;
+	int kps;
+
+	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
+	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
+	centisecs = elapsed_centisecs64;
+	if (centisecs == 0)
+		centisecs = 1;	/* avoid div-by-zero */
+	k = nr_pages * (PAGE_SIZE / 1024);
+	kps = (k * 100) / centisecs;
+	printk(KERN_INFO "PM: %s %d kbytes in %d.%02d seconds (%d.%02d MB/s)\n",
+			msg, k,
+			centisecs / 100, centisecs % 100,
+			kps / 1000, (kps % 1000) / 10);
+}
+
+/**
  *	create_image - freeze devices that need to be frozen with interrupts
  *	off, create the hibernation image and thaw those devices.  Control
  *	reappears in this routine after a restore.
diff --git a/kernel/power/swsusp.c b/kernel/power/swsusp.c
deleted file mode 100644
index 57222d2..0000000
--- a/kernel/power/swsusp.c
+++ /dev/null
@@ -1,87 +0,0 @@
-/*
- * linux/kernel/power/swsusp.c
- *
- * This file provides code to write suspend image to swap and read it back.
- *
- * Copyright (C) 1998-2001 Gabor Kuti <seasons@fornax.hu>
- * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@suse.cz>
- *
- * This file is released under the GPLv2.
- *
- * I'd like to thank the following people for their work:
- *
- * Pavel Machek <pavel@ucw.cz>:
- * Modifications, defectiveness pointing, being with me at the very beginning,
- * suspend to swap space, stop all tasks. Port to 2.4.18-ac and 2.5.17.
- *
- * Steve Doddi <dirk@loth.demon.co.uk>:
- * Support the possibility of hardware state restoring.
- *
- * Raph <grey.havens@earthling.net>:
- * Support for preserving states of network devices and virtual console
- * (including X and svgatextmode)
- *
- * Kurt Garloff <garloff@suse.de>:
- * Straightened the critical function in order to prevent compilers from
- * playing tricks with local variables.
- *
- * Andreas Mohr <a.mohr@mailto.de>
- *
- * Alex Badea <vampire@go.ro>:
- * Fixed runaway init
- *
- * Rafael J. Wysocki <rjw@sisk.pl>
- * Reworked the freeing of memory and the handling of swap
- *
- * More state savers are welcome. Especially for the scsi layer...
- *
- * For TODOs,FIXMEs also look in Documentation/power/swsusp.txt
- */
-
-#include <linux/mm.h>
-#include <linux/suspend.h>
-#include <linux/spinlock.h>
-#include <linux/kernel.h>
-#include <linux/major.h>
-#include <linux/swap.h>
-#include <linux/pm.h>
-#include <linux/swapops.h>
-#include <linux/bootmem.h>
-#include <linux/syscalls.h>
-#include <linux/highmem.h>
-#include <linux/time.h>
-#include <linux/rbtree.h>
-#include <linux/io.h>
-
-#include "power.h"
-
-int in_suspend __nosavedata = 0;
-
-/**
- *	swsusp_show_speed - print the time elapsed between two events represented by
- *	@start and @stop
- *
- *	@nr_pages -	number of pages processed between @start and @stop
- *	@msg -		introductory message to print
- */
-
-void swsusp_show_speed(struct timeval *start, struct timeval *stop,
-			unsigned nr_pages, char *msg)
-{
-	s64 elapsed_centisecs64;
-	int centisecs;
-	int k;
-	int kps;
-
-	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
-	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
-	centisecs = elapsed_centisecs64;
-	if (centisecs == 0)
-		centisecs = 1;	/* avoid div-by-zero */
-	k = nr_pages * (PAGE_SIZE / 1024);
-	kps = (k * 100) / centisecs;
-	printk(KERN_INFO "PM: %s %d kbytes in %d.%02d seconds (%d.%02d MB/s)\n",
-			msg, k,
-			centisecs / 100, centisecs % 100,
-			kps / 1000, (kps % 1000) / 10);
-}
-- 
1.6.3.3

