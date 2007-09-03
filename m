Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbXICWT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbXICWT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 18:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXICWTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 18:19:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36694 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXICWTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 18:19:20 -0400
Date: Tue, 4 Sep 2007 04:02:21 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Wim Van Sebroeck <wim@iguana.be>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc4-mm1
In-Reply-To: <20070903192519.GA2758@infomag.infomag.iguana.be>
Message-ID: <alpine.LFD.0.999.0709040356220.8504@enigma.security.iitk.ac.in>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
 <20070902213049.45804afd.randy.dunlap@oracle.com>
 <20070903192519.GA2758@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Mon, 3 Sep 2007, Wim Van Sebroeck wrote:
> 
> > 
> > on x86_64:
> > drivers/watchdog/core/watchdog_dev.c:84:
> > warning: format '%i' expects type 'int', but argument 5 has type 'size_t'

Hmm, a warning I missed during my Sunday evening pastime.

> I'll have a look at it.

How about ... (unrelated cleanup thrown in, but SCNR)



* Fix this warning:

  drivers/watchdog/core/watchdog_dev.c:84:
  warning: format '%i' expects type 'int', but argument 5 has type 'size_t'

* CONFIG_xxx options are directly usable by preprocessor directives.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 drivers/watchdog/core/Makefile       |    5 -----
 drivers/watchdog/core/watchdog_dev.c |    6 +++---
 2 files changed, 3 insertions(+), 8 deletions(-)

--- linux-2.6.23-rc4-mm1/drivers/watchdog/core/Makefile~fix	2007-09-04 03:12:27.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/watchdog/core/Makefile	2007-09-04 03:12:45.000000000 +0530
@@ -4,8 +4,3 @@
 
 # The Generic Watchdog Driver
 obj-$(CONFIG_WATCHDOG_CORE)		+= watchdog_core.o watchdog_dev.o
-
-ifeq ($(CONFIG_WATCHDOG_DEBUG_CORE), y)
-EXTRA_CFLAGS += -DDEBUG
-endif
-
--- linux-2.6.23-rc4-mm1/drivers/watchdog/core/watchdog_dev.c~fix	2007-09-04 02:37:12.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/watchdog/core/watchdog_dev.c	2007-09-04 03:10:58.000000000 +0530
@@ -36,7 +36,7 @@
 #include <linux/init.h>		/* For __init/__exit/... */
 #include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
 
-#ifdef DEBUG
+#ifdef CONFIG_WATCHDOG_DEBUG_CORE
 #define trace(format, args...) \
 	printk(KERN_INFO "%s(" format ")\n", __FUNCTION__ , ## args)
 #define dbg(format, arg...) \
@@ -81,7 +81,7 @@ static DEFINE_MUTEX(watchdog_register_mt
 static ssize_t watchdog_write(struct file *file, const char __user *data,
 				size_t len, loff_t *ppos)
 {
-	trace("%p, %p, %i, %p", file, data, len, ppos);
+	trace("%p, %p, %zu, %p", file, data, len, ppos);
 
 	if (!watchdogdev ||
 	    !watchdogdev->watchdog_ops ||
@@ -144,7 +144,7 @@ static int watchdog_ioctl(struct inode *
 		.identity =		"Watchdog Device",
 	};
 
-	trace("%p, %p, %i, %li", inode, file, cmd, arg);
+	trace("%p, %p, %u, %li", inode, file, cmd, arg);
 
 	if (!watchdogdev || !watchdogdev->watchdog_ops)
 		return -ENODEV;
