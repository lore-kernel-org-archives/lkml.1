Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbZCHPwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbZCHPwd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 11:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZCHPwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 11:52:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:34111 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbZCHPwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 11:52:13 -0400
Date: Sun, 8 Mar 2009 15:51:33 GMT
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       mathieu.desnoyers@polymtl.ca, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       ananth@in.ibm.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <49B14306.2080202@redhat.com>
References: <49B14306.2080202@redhat.com>
Subject: [tip:tracing/core] tracing, Text Edit Lock - kprobes architecture independent support
Message-ID: <tip-4460fdad85becd569f11501ad5b91814814335ff@git.kernel.org>
Git-Commit-ID: 4460fdad85becd569f11501ad5b91814814335ff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 08 Mar 2009 15:51:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4460fdad85becd569f11501ad5b91814814335ff
Gitweb:     http://git.kernel.org/tip/4460fdad85becd569f11501ad5b91814814335ff
Author:     "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
AuthorDate: Fri, 6 Mar 2009 10:36:38 -0500
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 16:49:00 +0100

tracing, Text Edit Lock - kprobes architecture independent support

Use the mutual exclusion provided by the text edit lock in the kprobes code. It
allows coherent manipulation of the kernel code by other subsystems.

Changelog:

Move the kernel_text_lock/unlock out of the for loops.
Use text_mutex directly instead of a function.
Remove whitespace modifications.

(note : kprobes_mutex is always taken outside of text_mutex)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <49B14306.2080202@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/kprobes.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 7ba8cd9..479d4d5 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -43,6 +43,7 @@
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/kdebug.h>
+#include <linux/memory.h>
 
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
@@ -699,9 +700,10 @@ int __kprobes register_kprobe(struct kprobe *p)
 		goto out;
 	}
 
+	mutex_lock(&text_mutex);
 	ret = arch_prepare_kprobe(p);
 	if (ret)
-		goto out;
+		goto out_unlock_text;
 
 	INIT_HLIST_NODE(&p->hlist);
 	hlist_add_head_rcu(&p->hlist,
@@ -710,6 +712,8 @@ int __kprobes register_kprobe(struct kprobe *p)
 	if (kprobe_enabled)
 		arch_arm_kprobe(p);
 
+out_unlock_text:
+	mutex_unlock(&text_mutex);
 out:
 	mutex_unlock(&kprobe_mutex);
 
@@ -746,8 +750,11 @@ valid_p:
 		 * enabled and not gone - otherwise, the breakpoint would
 		 * already have been removed. We save on flushing icache.
 		 */
-		if (kprobe_enabled && !kprobe_gone(old_p))
+		if (kprobe_enabled && !kprobe_gone(old_p)) {
+			mutex_lock(&text_mutex);
 			arch_disarm_kprobe(p);
+			mutex_unlock(&text_mutex);
+		}
 		hlist_del_rcu(&old_p->hlist);
 	} else {
 		if (p->break_handler && !kprobe_gone(p))
@@ -1280,12 +1287,14 @@ static void __kprobes enable_all_kprobes(void)
 	if (kprobe_enabled)
 		goto already_enabled;
 
+	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist)
 			if (!kprobe_gone(p))
 				arch_arm_kprobe(p);
 	}
+	mutex_unlock(&text_mutex);
 
 	kprobe_enabled = true;
 	printk(KERN_INFO "Kprobes globally enabled\n");
@@ -1310,6 +1319,7 @@ static void __kprobes disable_all_kprobes(void)
 
 	kprobe_enabled = false;
 	printk(KERN_INFO "Kprobes globally disabled\n");
+	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
@@ -1318,6 +1328,7 @@ static void __kprobes disable_all_kprobes(void)
 		}
 	}
 
+	mutex_unlock(&text_mutex);
 	mutex_unlock(&kprobe_mutex);
 	/* Allow all currently running kprobes to complete */
 	synchronize_sched();
