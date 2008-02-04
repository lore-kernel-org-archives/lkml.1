Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYBDMQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYBDMQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYBDMQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:16:18 -0500
Received: from ozlabs.org ([203.10.76.45]:45955 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbYBDMQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:16:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/5] typesafe: Convert stop_machine
Date: Mon, 4 Feb 2008 23:16:02 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200802042311.18762.rusty@rustcorp.com.au> <200802042314.18738.rusty@rustcorp.com.au>
In-Reply-To: <200802042314.18738.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802042316.02963.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using cast_if_type() we can have a callback funciton either of the
exactly correct type to take "data", or to take a void *.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r e279190b7b43 include/linux/stop_machine.h
--- a/include/linux/stop_machine.h	Mon Jan 21 14:42:54 2008 +1100
+++ b/include/linux/stop_machine.h	Mon Jan 21 15:04:00 2008 +1100
@@ -5,9 +5,9 @@
    (and more).  So the "read" side to such a lock is anything which
    diables preeempt. */
 #include <linux/cpu.h>
+#include <linux/compiler.h>
 #include <asm/system.h>
 
-#if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
 /**
  * stop_machine_run: freeze the machine on all CPUs and run this function
  * @fn: the function to run
@@ -21,7 +21,12 @@
  *
  * This can be thought of as a very heavy write lock, equivalent to
  * grabbing every spinlock in the kernel. */
-int stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu);
+#define stop_machine_run(fn, data, cpu)					\
+	stop_machine_run_notype(cast_if_type((fn), int(*)(typeof(data)), \
+					     int(*)(void *)), (data), (cpu))
+
+#if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
+int stop_machine_run_notype(int (*fn)(void *), void *data, unsigned int cpu);
 
 /**
  * __stop_machine_run: freeze the machine on all CPUs and run this function
@@ -38,8 +46,8 @@ struct task_struct *__stop_machine_run(i
 
 #else
 
-static inline int stop_machine_run(int (*fn)(void *), void *data,
-				   unsigned int cpu)
+static inline int stop_machine_run_notype(int (*fn)(void *), void *data,
+					  unsigned int cpu)
 {
 	int ret;
 	local_irq_disable();
diff -r e279190b7b43 kernel/stop_machine.c
--- a/kernel/stop_machine.c	Mon Jan 21 14:42:54 2008 +1100
+++ b/kernel/stop_machine.c	Mon Jan 21 15:04:00 2008 +1100
@@ -197,7 +197,7 @@ struct task_struct *__stop_machine_run(i
 	return p;
 }
 
-int stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu)
+int stop_machine_run_notype(int (*fn)(void *), void *data, unsigned int cpu)
 {
 	struct task_struct *p;
 	int ret;
