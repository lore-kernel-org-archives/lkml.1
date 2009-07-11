Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbZGKKlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbZGKKlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 06:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZGKKll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 06:41:41 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:46969 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZGKKll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 06:41:41 -0400
Date: Sat, 11 Jul 2009 06:39:23 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] KERNEL:  Conditionally include ramdisk-related code.
Message-ID: <alpine.LFD.2.00.0907110636290.2814@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Given that BLK_DEV_INITRD defines whether the kernel has any ramdisk
functionality whatsoever, conditionally include ramdisk-related code
in init/main.c.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  Not a big deal, but there seems to be some precedent in other files
in conditionally whacking out any chunks related to ramdisks if
BLK_DEV_INITRD has not been selected.

  Compile tested on x86 with "defconfig", followed by deselecting
BLK_DEV_INITRD.

diff --git a/init/main.c b/init/main.c
index 2c5ade7..d88c7b4 100644
--- a/init/main.c
+++ b/init/main.c
@@ -119,7 +119,9 @@ char *saved_command_line;
 static char *static_command_line;

 static char *execute_command;
+#ifdef CONFIG_BLK_DEV_INITRD
 static char *ramdisk_execute_command;
+#endif

 #ifdef CONFIG_SMP
 /* Setup configured maximum number of CPUs to activate */
@@ -330,6 +332,8 @@ static int __init init_setup(char *str)
 }
 __setup("init=", init_setup);

+#ifdef CONFIG_BLK_DEV_INITRD
+
 static int __init rdinit_setup(char *str)
 {
 	unsigned int i;
@@ -342,6 +346,9 @@ static int __init rdinit_setup(char *str)
 }
 __setup("rdinit=", rdinit_setup);

+
+#endif
+
 #ifndef CONFIG_SMP

 #ifdef CONFIG_X86_LOCAL_APIC
@@ -850,12 +857,16 @@ static noinline int init_post(void)

 	current->signal->flags |= SIGNAL_UNKILLABLE;

+#ifdef CONFIG_BLK_DEV_INITRD
+
 	if (ramdisk_execute_command) {
 		run_init_process(ramdisk_execute_command);
 		printk(KERN_WARNING "Failed to execute %s\n",
 				ramdisk_execute_command);
 	}

+#endif
+
 	/*
 	 * We try each of these until one succeeds.
 	 *
@@ -909,6 +920,8 @@ static int __init kernel_init(void * unused)

 	do_basic_setup();

+#ifdef CONFIG_BLK_DEV_INITRD
+
 	/*
 	 * check if there is an early userspace init.  If yes, let it do all
 	 * the work
@@ -922,6 +935,8 @@ static int __init kernel_init(void * unused)
 		prepare_namespace();
 	}

+#endif
+
 	/*
 	 * Ok, we have completed the initial bootup, and
 	 * we're essentially up and running. Get rid of the

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
"Kernel Newbie Corner" column @ linux.com:          http://cli.gs/WG6WYX
========================================================================
