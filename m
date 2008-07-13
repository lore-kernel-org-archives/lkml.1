Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYGMRUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYGMRUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 13:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYGMRTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 13:19:49 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51479 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYGMRTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 13:19:47 -0400
Date: Sun, 13 Jul 2008 21:22:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] coredump: elf_core_dump: use core_state->dumper list
Message-ID: <20080713172258.GA28770@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill the nasty rcu_read_lock() + do_each_thread() loop, use the list encoded
in mm->core_state instead, s/GFP_ATOMIC/GFP_KERNEL/.

This patch allows futher cleanups in binfmt_elf.c, in particular we can kill
the parallel info->threads list.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 binfmt_elf.c |   73 ++++++++++++++++++++++++-----------------------------------
 1 files changed, 30 insertions(+), 43 deletions(-)

--- 26-rc2/fs/binfmt_elf.c~3_ELF	2008-06-18 20:04:09.000000000 +0400
+++ 26-rc2/fs/binfmt_elf.c	2008-07-13 20:52:25.000000000 +0400
@@ -1480,7 +1480,7 @@ static int fill_note_info(struct elfhdr 
 	const struct user_regset_view *view = task_user_regset_view(dump_task);
 	struct elf_thread_core_info *t;
 	struct elf_prpsinfo *psinfo;
-	struct task_struct *g, *p;
+	struct core_thread *ct;
 	unsigned int i;
 
 	info->size = 0;
@@ -1519,34 +1519,26 @@ static int fill_note_info(struct elfhdr 
 	/*
 	 * Allocate a structure for each thread.
 	 */
-	rcu_read_lock();
-	do_each_thread(g, p)
-		if (p->mm == dump_task->mm) {
-			if (p->flags & PF_KTHREAD)
-				continue;
+	for (ct = &dump_task->mm->core_state->dumper; ct; ct = ct->next) {
+		t = kzalloc(offsetof(struct elf_thread_core_info,
+				     notes[info->thread_notes]),
+			    GFP_KERNEL);
+		if (unlikely(!t))
+			return 0;
 
-			t = kzalloc(offsetof(struct elf_thread_core_info,
-					     notes[info->thread_notes]),
-				    GFP_ATOMIC);
-			if (unlikely(!t)) {
-				rcu_read_unlock();
-				return 0;
-			}
-			t->task = p;
-			if (p == dump_task || !info->thread) {
-				t->next = info->thread;
-				info->thread = t;
-			} else {
-				/*
-				 * Make sure to keep the original task at
-				 * the head of the list.
-				 */
-				t->next = info->thread->next;
-				info->thread->next = t;
-			}
+		t->task = ct->task;
+		if (ct->task == dump_task || !info->thread) {
+			t->next = info->thread;
+			info->thread = t;
+		} else {
+			/*
+			 * Make sure to keep the original task at
+			 * the head of the list.
+			 */
+			t->next = info->thread->next;
+			info->thread->next = t;
 		}
-	while_each_thread(g, p);
-	rcu_read_unlock();
+	}
 
 	/*
 	 * Now fill in each thread's information.
@@ -1693,7 +1685,6 @@ static int fill_note_info(struct elfhdr 
 {
 #define	NUM_NOTES	6
 	struct list_head *t;
-	struct task_struct *g, *p;
 
 	info->notes = NULL;
 	info->prstatus = NULL;
@@ -1725,23 +1716,19 @@ static int fill_note_info(struct elfhdr 
 
 	info->thread_status_size = 0;
 	if (signr) {
+		struct core_thread *ct;
 		struct elf_thread_status *ets;
-		rcu_read_lock();
-		do_each_thread(g, p)
-			if (current->mm == p->mm && current != p) {
-				if (p->flags & PF_KTHREAD)
-					continue;
 
-				ets = kzalloc(sizeof(*ets), GFP_ATOMIC);
-				if (!ets) {
-					rcu_read_unlock();
-					return 0;
-				}
-				ets->thread = p;
-				list_add(&ets->list, &info->thread_list);
-			}
-		while_each_thread(g, p);
-		rcu_read_unlock();
+		for (ct = current->mm->core_state->dumper.next;
+						ct; ct = ct->next) {
+			ets = kzalloc(sizeof(*ets), GFP_KERNEL);
+			if (!ets)
+				return 0;
+
+			ets->thread = ct->task;
+			list_add(&ets->list, &info->thread_list);
+		}
+
 		list_for_each(t, &info->thread_list) {
 			int sz;
 

