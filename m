Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbZFBJzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbZFBJzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 05:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbZFBJyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 05:54:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:9163 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186AbZFBJyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 05:54:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=EP3arMMyj7Pxf6E2zPEeOvr/R7GNPvjmzPzFcOmd4RDBJcWc5QV+oKwfQ5M+9BqRm1
         yQLnAf+BxRWBqOZkJNHR/51romDuYyw5XZBwUEsGgCFrPhtjTFCF9SumcABmJoPFuW32
         npWoxWdJCHomIduYRTV+AW1iUKCKM9RVyctYM=
MIME-Version: 1.0
Date: Tue, 2 Jun 2009 17:54:52 +0800
Message-ID: <a8e1da0906020254s34dd0cd9id1b88655cab6d72d@mail.gmail.com>
Subject: [PATCH] printk: add halt_delay parameter for printk delay in halt 
	phase
From: Dave Young <hidave.darkstar@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a halt_delay module parameter in printk.c used to read the printk
messages in halt/poweroff/restart phase, delay each printk messages
by halt_delay milliseconds. It is useful for debugging if there's no
other way to dump kernel messages that time.

halt_delay default value is 0, change it by:

echo xxx > /sys/module/printk/parameters/halt_delay

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
kernel/printk.c   |   21 +++++++++++++++++++++
lib/Kconfig.debug |   10 ++++++++++
2 files changed, 31 insertions(+)

--- linux-2.6.orig/kernel/printk.c	2009-04-09 16:23:03.000000000 +0800
+++ linux-2.6/kernel/printk.c	2009-06-02 17:45:54.000000000 +0800
@@ -250,6 +250,26 @@ static inline void boot_delay_msec(void)
 }
 #endif

+#ifdef CONFIG_HALT_PRINTK_DELAY
+/* msecs delay after each halt/poweroff/restart phase printk */
+static unsigned int halt_delay;
+
+static inline void halt_delay_msec(void)
+{
+	if (halt_delay == 0 || !(system_state == SYSTEM_HALT
+				|| system_state == SYSTEM_POWER_OFF
+				|| system_state == SYSTEM_RESTART))
+		return;
+
+	mdelay(halt_delay);
+}
+
+module_param(halt_delay, int, S_IRUGO | S_IWUSR);
+#else
+static inline void halt_delay_msec(void)
+{
+}
+#endif
 /*
  * Commands to do_syslog:
  *
@@ -649,6 +669,7 @@ asmlinkage int vprintk(const char *fmt,
 	char *p;

 	boot_delay_msec();
+	halt_delay_msec();

 	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
--- linux-2.6.orig/lib/Kconfig.debug	2009-05-12 11:27:22.000000000 +0800
+++ linux-2.6/lib/Kconfig.debug	2009-06-02 17:50:15.000000000 +0800
@@ -647,6 +647,16 @@ config BOOT_PRINTK_DELAY
 	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
 	  what it believes to be lockup conditions.

+config HALT_PRINTK_DELAY
+	bool "Delay halt/poweroff/restart printk message by N milliseconds"
+	depends on DEBUG_KERNEL && PRINTK && SYSFS
+	default n
+	help
+	  This build option allows you to read kernel messages in
+	  halt/poweroff/restart phase by inserting a short delay after
+	  each one.  The delay is specified in milliseconds on the
+	  module parameter: /sys/module/printk/halt_delay.
+
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
