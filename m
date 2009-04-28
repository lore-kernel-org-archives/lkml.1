Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbZD1T20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbZD1T20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZD1T1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:27:48 -0400
Received: from relay.pcl-ipout01.plus.net ([212.159.7.99]:22001 "EHLO
	relay.pcl-ipout01.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754989AbZD1T1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:27:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAL/z9knUnw4R/2dsb2JhbAC/J5Agg3MF
From: Stuart Bennett <stuart@freedesktop.org>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Stuart Bennett <stuart@freedesktop.org>
Subject: [PATCH] x86 mmiotrace: only register for die notifier when tracer active
Date: Tue, 28 Apr 2009 20:17:51 +0100
Message-Id: <1240946271-7083-5-git-send-email-stuart@freedesktop.org>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1240946271-7083-4-git-send-email-stuart@freedesktop.org>
References: <1240946271-7083-1-git-send-email-stuart@freedesktop.org>
 <1240946271-7083-2-git-send-email-stuart@freedesktop.org>
 <1240946271-7083-3-git-send-email-stuart@freedesktop.org>
 <1240946271-7083-4-git-send-email-stuart@freedesktop.org>
X-Plusnet-Relay: 998feba60ec0d1eb7d78f088a84f5440
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow up to afcfe024aebd74b0984a41af9a34e009cf5badaf in Linus' tree
("x86: mmiotrace: quieten spurious warning message")

Signed-off-by: Stuart Bennett <stuart@freedesktop.org>
Acked-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/kmmio.c       |   21 ++++++++++++++++++---
 arch/x86/mm/mmio-mod.c    |    2 ++
 include/linux/mmiotrace.h |    2 ++
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 422f49e..bdbbf0d 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -311,7 +311,12 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
 
 	if (!ctx->active) {
-		pr_debug("kmmio: spurious debug trap on CPU %d.\n",
+		/*
+		 * debug traps without an active context are due to either
+		 * something external causing them (f.e. using a debugger while
+		 * mmio tracing enabled), or erroneous behaviour
+		 */
+		pr_warning("kmmio: unexpected debug trap on CPU %d.\n",
 							smp_processor_id());
 		goto out;
 	}
@@ -545,11 +550,21 @@ static struct notifier_block nb_die = {
 	.notifier_call = kmmio_die_notifier
 };
 
-static int __init init_kmmio(void)
+int kmmio_init(void)
 {
 	int i;
 	for (i = 0; i < KMMIO_PAGE_TABLE_SIZE; i++)
 		INIT_LIST_HEAD(&kmmio_page_table[i]);
 	return register_die_notifier(&nb_die);
 }
-fs_initcall(init_kmmio); /* should be before device_initcall() */
+
+void kmmio_cleanup(void)
+{
+	int i;
+
+	unregister_die_notifier(&nb_die);
+	for (i = 0; i < KMMIO_PAGE_TABLE_SIZE; i++)
+		WARN_ONCE(!list_empty(&kmmio_page_table[i]),
+			  KERN_ERR "kmmio_page_table not empty at cleanup, "
+				   "any further tracing will leak memory\n");
+}
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index c9342ed..132772a 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -451,6 +451,7 @@ void enable_mmiotrace(void)
 
 	if (nommiotrace)
 		pr_info(NAME "MMIO tracing disabled.\n");
+	kmmio_init();
 	enter_uniprocessor();
 	spin_lock_irq(&trace_lock);
 	atomic_inc(&mmiotrace_enabled);
@@ -473,6 +474,7 @@ void disable_mmiotrace(void)
 
 	clear_trace_list(); /* guarantees: no more kmmio callbacks */
 	leave_uniprocessor();
+	kmmio_cleanup();
 	pr_info(NAME "disabled.\n");
 out:
 	mutex_unlock(&mmiotrace_mutex);
diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
index 3d1b7bd..97491f7 100644
--- a/include/linux/mmiotrace.h
+++ b/include/linux/mmiotrace.h
@@ -30,6 +30,8 @@ extern unsigned int kmmio_count;
 
 extern int register_kmmio_probe(struct kmmio_probe *p);
 extern void unregister_kmmio_probe(struct kmmio_probe *p);
+extern int kmmio_init(void);
+extern void kmmio_cleanup(void);
 
 #ifdef CONFIG_MMIOTRACE
 /* kmmio is active by some kmmio_probes? */
-- 
1.5.4.4

