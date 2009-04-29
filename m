Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbZD2LGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbZD2LGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbZD2LFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:05:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:49845 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195AbZD2LFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:05:38 -0400
Date: Wed, 29 Apr 2009 11:05:02 GMT
From: tip-bot for Stuart Bennett <stuart@freedesktop.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, pq@iki.fi, stuart@freedesktop.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, pq@iki.fi, stuart@freedesktop.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240946271-7083-5-git-send-email-stuart@freedesktop.org>
References: <1240946271-7083-5-git-send-email-stuart@freedesktop.org>
Subject: [tip:tracing/core] tracing: x86, mmiotrace: only register for die notifier when tracer active
Message-ID: <tip-0f9a623dd6c9b5b4dd00c232f29525bfc7a8ecf2@git.kernel.org>
Git-Commit-ID: 0f9a623dd6c9b5b4dd00c232f29525bfc7a8ecf2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 11:05:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f9a623dd6c9b5b4dd00c232f29525bfc7a8ecf2
Gitweb:     http://git.kernel.org/tip/0f9a623dd6c9b5b4dd00c232f29525bfc7a8ecf2
Author:     Stuart Bennett <stuart@freedesktop.org>
AuthorDate: Tue, 28 Apr 2009 20:17:51 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 11:33:34 +0200

tracing: x86, mmiotrace: only register for die notifier when tracer active

Follow up to afcfe024aebd74b0984a41af9a34e009cf5badaf in Linus' tree
("x86: mmiotrace: quieten spurious warning message")

Signed-off-by: Stuart Bennett <stuart@freedesktop.org>
Acked-by: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1240946271-7083-5-git-send-email-stuart@freedesktop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/kmmio.c       |   27 ++++++++++++++++++++++-----
 arch/x86/mm/mmio-mod.c    |    2 ++
 include/linux/mmiotrace.h |    2 ++
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index a769d1a..256ce64 100644
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
@@ -529,8 +534,8 @@ void unregister_kmmio_probe(struct kmmio_probe *p)
 }
 EXPORT_SYMBOL(unregister_kmmio_probe);
 
-static int kmmio_die_notifier(struct notifier_block *nb, unsigned long val,
-								void *args)
+static int
+kmmio_die_notifier(struct notifier_block *nb, unsigned long val, void *args)
 {
 	struct die_args *arg = args;
 
@@ -545,11 +550,23 @@ static struct notifier_block nb_die = {
 	.notifier_call = kmmio_die_notifier
 };
 
-static int __init init_kmmio(void)
+int kmmio_init(void)
 {
 	int i;
+
 	for (i = 0; i < KMMIO_PAGE_TABLE_SIZE; i++)
 		INIT_LIST_HEAD(&kmmio_page_table[i]);
+
 	return register_die_notifier(&nb_die);
 }
-fs_initcall(init_kmmio); /* should be before device_initcall() */
+
+void kmmio_cleanup(void)
+{
+	int i;
+
+	unregister_die_notifier(&nb_die);
+	for (i = 0; i < KMMIO_PAGE_TABLE_SIZE; i++) {
+		WARN_ONCE(!list_empty(&kmmio_page_table[i]),
+			KERN_ERR "kmmio_page_table not empty at cleanup, any further tracing will leak memory.\n");
+	}
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
