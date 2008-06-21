Return-Path: <linux-kernel-owner+w=401wt.eu-S1751636AbYFUOLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbYFUOLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 10:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYFUOLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 10:11:23 -0400
Received: from [194.117.236.238] ([194.117.236.238]:54440 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYFUOLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 10:11:22 -0400
Date: Sat, 21 Jun 2008 17:10:51 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: tzanussi@gmail.com
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Better interface for hooking early initcalls.
Message-ID: <20080621171051.5ed3b522@linux360.ro>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added early initcall (pre-SMP) support, using an identical interface to
that of regular initcalls. Functions called from do_pre_smp_initcalls()
could be converted to use this cleaner interface.

This is required by CPU hotplug, because early users have to register
notifiers before going SMP. One such CPU hotplug user is the relay
interface with buffer-only channels, which needs to register such a
notifier, to be usable in early code. This in turn is used by kmemtrace.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 include/asm-generic/vmlinux.lds.h |    2 ++
 include/linux/init.h              |    7 +++++++
 init/main.c                       |   13 +++++++++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f054778..4a318e5 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -326,6 +326,8 @@
 	}
 
 #define INITCALLS							\
+	*(.initcallearly.init)						\
+	__early_initcall_end = .;					\
   	*(.initcall0.init)						\
   	*(.initcall0s.init)						\
   	*(.initcall1.init)						\
diff --git a/include/linux/init.h b/include/linux/init.h
index 21d658c..bd12a4c 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -170,6 +170,13 @@ extern void (*late_time_init)(void);
 	__attribute__((__section__(".initcall" level ".init"))) = fn
 
 /*
+ * Early initcalls run before initializing SMP.
+ *
+ * Only for built-in code, not modules.
+ */
+#define early_initcall(fn)		__define_initcall("early",fn,early)
+
+/*
  * A "pure" initcall has no dependencies on anything else, and purely
  * initializes variables that couldn't be statically initialized.
  *
diff --git a/init/main.c b/init/main.c
index f7fb200..bd5df3e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -736,13 +736,13 @@ static void __init do_one_initcall(initcall_t fn)
 }
 
 
-extern initcall_t __initcall_start[], __initcall_end[];
+extern initcall_t __initcall_start[], __initcall_end[], __early_initcall_end[];
 
 static void __init do_initcalls(void)
 {
 	initcall_t *call;
 
-	for (call = __initcall_start; call < __initcall_end; call++)
+	for (call = __early_initcall_end; call < __initcall_end; call++)
 		do_one_initcall(*call);
 
 	/* Make sure there is no pending stuff from the initcall sequence */
@@ -775,6 +775,14 @@ static int __init nosoftlockup_setup(char *str)
 }
 __setup("nosoftlockup", nosoftlockup_setup);
 
+static void __init __do_pre_smp_initcalls(void)
+{
+	initcall_t *call;
+
+	for (call = __initcall_start; call < __early_initcall_end; call++)
+		(*call)();
+}
+
 static void __init do_pre_smp_initcalls(void)
 {
 	extern int spawn_ksoftirqd(void);
@@ -856,6 +864,7 @@ static int __init kernel_init(void * unused)
 
 	smp_prepare_cpus(setup_max_cpus);
 
+	__do_pre_smp_initcalls();
 	do_pre_smp_initcalls();
 
 	smp_init();
-- 
1.5.5.4

