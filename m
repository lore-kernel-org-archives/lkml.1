Return-Path: <linux-kernel-owner+w=401wt.eu-S1764963AbYBPDpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764963AbYBPDpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 22:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759173AbYBPDpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 22:45:19 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:24858 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469AbYBPDpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 22:45:17 -0500
Subject: [PATCH 2/2] Preempt realtime printk syslog
From: Min Zhang <mzhang@mvista.com>
Reply-To: mzhang@mvista.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Monta Vista
Date: Fri, 15 Feb 2008 19:45:14 -0800
Message-Id: <1203133514.10893.28.camel@dhcp140.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 50s timeout in do_syslog to poll printk from non-preemptible
section. printk is missing from syslog if from non-preemptible
section, because on PREEMPT_RT kernels, printk doesn't wake up syslogd
from non-preemptible section; see release_console_sem in
kernel/printk.c.

Tested by printk in module_init and insmod that kernel module. The
printk is in non-preemptive context because modules are loaded from
inside a realtime priority thread in a preemptive realtime kernel.

Signed-off-by: Min Zhang <mzhang@mvista.com>

Index: rt-2.6/kernel/printk.c
===================================================================
--- rt-2.6.orig/kernel/printk.c
+++ rt-2.6/kernel/printk.c
@@ -116,6 +116,12 @@ static int preferred_console = -1;
 /* Flag: console code may call schedule() */
 static int console_may_schedule;
 
+/* minimum time in jiffies between messages */
+int printk_ratelimit_jiffies = 5 * HZ;
+
+/* number of messages we send before ratelimiting */
+int printk_ratelimit_burst = 10;
+
 #ifdef CONFIG_PRINTK
 
 static char __log_buf[__LOG_BUF_LEN];
@@ -313,10 +319,26 @@ int do_syslog(int type, char __user *buf
 			error = -EFAULT;
 			goto out;
 		}
+#ifdef CONFIG_PREEMPT_RT
+ 		/*
+ 		 * On PREEMPT_RT kernels release_console_sem wakes us only if
+ 		 * in preemptible section, so timeout to poll for printk from
+ 		 * non-preemptible sections.
+ 		 */
+ 		i = printk_ratelimit_burst * printk_ratelimit_jiffies;
+ 		error = wait_event_interruptible_timeout(log_wait,
+ 							 (log_start - log_end),
+ 							 i);
+ 		if (error < 0)
+ 			goto out;
+ 		else
+ 			error = 0;
+#else
 		error = wait_event_interruptible(log_wait,
 							(log_start - log_end));
 		if (error)
 			goto out;
+#endif
 		i = 0;
 		spin_lock_irq(&logbuf_lock);
 		while (!error && (log_start != log_end) && i < len) {
@@ -1272,12 +1294,6 @@ int __printk_ratelimit(int ratelimit_jif
 }
 EXPORT_SYMBOL(__printk_ratelimit);
 
-/* minimum time in jiffies between messages */
-int printk_ratelimit_jiffies = 5 * HZ;
-
-/* number of messages we send before ratelimiting */
-int printk_ratelimit_burst = 10;
-
 int printk_ratelimit(void)
 {
 	return __printk_ratelimit(printk_ratelimit_jiffies,


