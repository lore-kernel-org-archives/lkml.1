Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbZCCOdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbZCCOdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 09:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbZCCOdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 09:33:40 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:64063 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755154AbZCCOdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 09:33:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALvJrElMQW1W/2dsb2JhbACBTtZQhAYG
Date: Tue, 3 Mar 2009 09:33:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH] Text Edit Lock - kprobes architecture independent support
	(v3)
Message-ID: <20090303143333.GB27043@Krystal>
References: <20090302222254.GA31962@elte.hu> <49AC63FA.70801@redhat.com> <20090302230915.GA11626@elte.hu> <49AC6DEA.2050304@redhat.com> <20090302234910.GA17956@elte.hu> <20090303000054.GC3906@Krystal> <20090303003237.GA30221@elte.hu> <20090303013124.GB7783@Krystal> <20090303092750.GG11484@elte.hu> <20090303120659.GA3480@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090303120659.GA3480@in.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:31:17 up 3 days, 10:57,  1 user,  load average: 0.03, 0.24,
	0.31
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Index: linux-2.6-lttng/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/kernel/kprobes.c	2009-03-02 19:22:51.000000000 -0500
+++ linux-2.6-lttng/kernel/kprobes.c	2009-03-03 09:11:17.000000000 -0500
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
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
