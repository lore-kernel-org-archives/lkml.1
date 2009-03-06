Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbZCFPhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbZCFPhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbZCFPgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:36:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60611 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924AbZCFPgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:36:48 -0500
Message-ID: <49B14306.2080202@redhat.com>
Date: Fri, 06 Mar 2009 10:36:38 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH -tip 2/4]Text Edit Lock - kprobes architecture independent
 support (v3)
References: <49B1428A.9050500@redhat.com>
In-Reply-To: <49B1428A.9050500@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

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
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
CC: Roel Kluin <12o3l@tiscali.nl>
---
 kernel/kprobes.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: 2.6.29-rc7/kernel/kprobes.c
===================================================================
--- 2.6.29-rc7.orig/kernel/kprobes.c
+++ 2.6.29-rc7/kernel/kprobes.c
@@ -43,6 +43,7 @@
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/kdebug.h>
+#include <linux/memory.h>

 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
@@ -699,9 +700,10 @@ int __kprobes register_kprobe(struct kpr
 		goto out;
 	}

+	mutex_lock(&text_mutex);
 	ret = arch_prepare_kprobe(p);
 	if (ret)
-		goto out;
+		goto out_unlock_text;

 	INIT_HLIST_NODE(&p->hlist);
 	hlist_add_head_rcu(&p->hlist,
@@ -710,6 +712,8 @@ int __kprobes register_kprobe(struct kpr
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
@@ -1280,12 +1287,14 @@ static void __kprobes enable_all_kprobes
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
@@ -1310,6 +1319,7 @@ static void __kprobes disable_all_kprobe

 	kprobe_enabled = false;
 	printk(KERN_INFO "Kprobes globally disabled\n");
+	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
@@ -1318,6 +1328,7 @@ static void __kprobes disable_all_kprobe
 		}
 	}

+	mutex_unlock(&text_mutex);
 	mutex_unlock(&kprobe_mutex);
 	/* Allow all currently running kprobes to complete */
 	synchronize_sched();
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


