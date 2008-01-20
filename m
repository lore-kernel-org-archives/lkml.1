Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbYATJsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbYATJsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 04:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYATJsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 04:48:13 -0500
Received: from ozlabs.org ([203.10.76.45]:52090 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbYATJsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 04:48:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/6] typesafe: Convert stop_machine and callers
Date: Sun, 20 Jan 2008 20:47:22 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
References: <200801202046.14746.rusty@rustcorp.com.au>
In-Reply-To: <200801202046.14746.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801202047.22943.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple statement expression with a temporary variable does the
typechecking for us: that the stop_machine callback matches the data
type.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/hw_random/intel-rng.c |    3 +--
 include/linux/stop_machine.h       |   13 +++++++++----
 kernel/module.c                    |   10 +++-------
 kernel/stop_machine.c              |    4 ++--
 4 files changed, 15 insertions(+), 15 deletions(-)

diff -r fa243a61ba85 drivers/char/hw_random/intel-rng.c
--- a/drivers/char/hw_random/intel-rng.c	Thu Jan 17 13:06:16 2008 +1100
+++ b/drivers/char/hw_random/intel-rng.c	Thu Jan 17 14:47:11 2008 +1100
@@ -227,9 +227,8 @@ struct intel_rng_hw {
 	u8 fwh_dec_en1_val;
 };
 
-static int __init intel_rng_hw_init(void *_intel_rng_hw)
+static int __init intel_rng_hw_init(struct intel_rng_hw *intel_rng_hw)
 {
-	struct intel_rng_hw *intel_rng_hw = _intel_rng_hw;
 	u8 mfc, dvc;
 
 	/* interrupts disabled in stop_machine_run call */
diff -r fa243a61ba85 include/linux/stop_machine.h
--- a/include/linux/stop_machine.h	Thu Jan 17 13:06:16 2008 +1100
+++ b/include/linux/stop_machine.h	Thu Jan 17 14:47:11 2008 +1100
@@ -7,7 +7,6 @@
 #include <linux/cpu.h>
 #include <asm/system.h>
 
-#if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
 /**
  * stop_machine_run: freeze the machine on all CPUs and run this function
  * @fn: the function to run
@@ -21,7 +20,13 @@
  *
  * This can be thought of as a very heavy write lock, equivalent to
  * grabbing every spinlock in the kernel. */
-int stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu);
+#define stop_machine_run(fn, data, cpu) ({			\
+	int (*_fn)(typeof(data)) = (fn);			\
+	stop_machine_run_notype((void *)_fn, (data), (cpu));	\
+})
+
+#if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
+int stop_machine_run_notype(int (*fn)(void *), void *data, unsigned int cpu);
 
 /**
  * __stop_machine_run: freeze the machine on all CPUs and run this function
@@ -38,8 +43,8 @@ struct task_struct *__stop_machine_run(i
 
 #else
 
-static inline int stop_machine_run(int (*fn)(void *), void *data,
-				   unsigned int cpu)
+static inline int stop_machine_run_notype(int (*fn)(void *), void *data,
+					  unsigned int cpu)
 {
 	int ret;
 	local_irq_disable();
diff -r fa243a61ba85 kernel/module.c
--- a/kernel/module.c	Thu Jan 17 13:06:16 2008 +1100
+++ b/kernel/module.c	Thu Jan 17 14:47:11 2008 +1100
@@ -623,10 +623,8 @@ struct stopref
 };
 
 /* Whole machine is stopped with interrupts off when this runs. */
-static int __try_stop_module(void *_sref)
+static int __try_stop_module(struct stopref *sref)
 {
-	struct stopref *sref = _sref;
-
 	/* If it's not unused, quit unless we are told to block. */
 	if ((sref->flags & O_NONBLOCK) && module_refcount(sref->mod) != 0) {
 		if (!(*sref->forced = try_force_unload(sref->flags)))
@@ -1305,9 +1303,8 @@ static void mod_kobject_remove(struct mo
  * link the module with the whole machine is stopped with interrupts off
  * - this defends against kallsyms not taking locks
  */
-static int __link_module(void *_mod)
+static int __link_module(struct module *mod)
 {
-	struct module *mod = _mod;
 	list_add(&mod->list, &modules);
 	return 0;
 }
@@ -1316,9 +1313,8 @@ static int __link_module(void *_mod)
  * unlink the module with the whole machine is stopped with interrupts off
  * - this defends against kallsyms not taking locks
  */
-static int __unlink_module(void *_mod)
+static int __unlink_module(struct module *mod)
 {
-	struct module *mod = _mod;
 	list_del(&mod->list);
 	return 0;
 }
diff -r fa243a61ba85 kernel/stop_machine.c
--- a/kernel/stop_machine.c	Thu Jan 17 13:06:16 2008 +1100
+++ b/kernel/stop_machine.c	Thu Jan 17 14:47:11 2008 +1100
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
