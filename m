Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYDTXFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYDTXFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 19:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYDTXFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 19:05:35 -0400
Received: from ozlabs.org ([203.10.76.45]:59317 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbYDTXFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 19:05:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] typesafe: Convert stop_machine
Date: Mon, 21 Apr 2008 09:05:32 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200804210859.00080.rusty@rustcorp.com.au> <200804210900.16242.rusty@rustcorp.com.au> <200804210901.20229.rusty@rustcorp.com.au>
In-Reply-To: <200804210901.20229.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804210905.33090.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Straightforward conversion of stop_machine_run.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/stop_machine.h |   12 +++--
 kernel/stop_machine.c        |   89 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 95 insertions(+), 6 deletions(-)

diff -r 103cfcb193b5 include/linux/stop_machine.h
--- a/include/linux/stop_machine.h	Mon Apr 07 15:39:49 2008 +1000
+++ b/include/linux/stop_machine.h	Mon Apr 07 15:44:29 2008 +1000
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
@@ -21,7 +21,11 @@
  *
  * This can be thought of as a very heavy write lock, equivalent to
  * grabbing every spinlock in the kernel. */
-int stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu);
+#define stop_machine_run(fn, data, cpu)					\
+	stop_machine_run_notype(typesafe_cb(int, (fn), (data)), (data), (cpu))
+
+#if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
+int stop_machine_run_notype(int (*fn)(void *), void *data, unsigned int cpu);
 
 /**
  * __stop_machine_run: freeze the machine on all CPUs and run this function
@@ -38,8 +42,8 @@ struct task_struct *__stop_machine_run(i
 
 #else
 
-static inline int stop_machine_run(int (*fn)(void *), void *data,
-				   unsigned int cpu)
+static inline int stop_machine_run_notype(int (*fn)(void *), void *data,
+					  unsigned int cpu)
 {
 	int ret;
 	local_irq_disable();
diff -r 103cfcb193b5 kernel/stop_machine.c
--- a/kernel/stop_machine.c	Mon Apr 07 15:39:49 2008 +1000
+++ b/kernel/stop_machine.c	Mon Apr 07 15:44:29 2008 +1000
@@ -197,7 +197,7 @@ struct task_struct *__stop_machine_run(i
 	return p;
 }
 
-int stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu)
+int stop_machine_run_notype(int (*fn)(void *), void *data, unsigned int cpu)
 {
 	struct task_struct *p;
 	int ret;
@@ -213,4 +213,4 @@ int stop_machine_run(int (*fn)(void *), 
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(stop_machine_run);
+EXPORT_SYMBOL_GPL(stop_machine_run_notype);

