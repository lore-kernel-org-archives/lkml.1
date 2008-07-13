Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYGMRUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYGMRUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 13:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYGMRTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 13:19:48 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51481 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbYGMRTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 13:19:47 -0400
Date: Sun, 13 Jul 2008 21:22:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] coredump: elf_fdpic_core_dump: use core_state->dumper list
Message-ID: <20080713172258.GA28773@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UNTESTED.

Kill the nasty rcu_read_lock() + do_each_thread() loop, use the list encoded
in mm->core_state instead, s/GFP_ATOMIC/GFP_KERNEL/.

This patch allows futher cleanups in binfmt_elf_fdpic.c.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 binfmt_elf_fdpic.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

--- 26-rc2/fs/binfmt_elf_fdpic.c~4_FDPIC	2008-06-16 18:57:46.000000000 +0400
+++ 26-rc2/fs/binfmt_elf_fdpic.c	2008-07-13 21:18:31.000000000 +0400
@@ -1573,7 +1573,6 @@ static int elf_fdpic_core_dump(long sign
 	struct memelfnote *notes = NULL;
 	struct elf_prstatus *prstatus = NULL;	/* NT_PRSTATUS */
 	struct elf_prpsinfo *psinfo = NULL;	/* NT_PRPSINFO */
- 	struct task_struct *g, *p;
  	LIST_HEAD(thread_list);
  	struct list_head *t;
 	elf_fpregset_t *fpu = NULL;
@@ -1622,23 +1621,19 @@ static int elf_fdpic_core_dump(long sign
 #endif
 
 	if (signr) {
+		struct core_thread *ct;
 		struct elf_thread_status *tmp;
-		rcu_read_lock();
-		do_each_thread(g,p)
-			if (current->mm == p->mm && current != p) {
-				if (p->flags & PF_KTHREAD)
-					continue;
 
-				tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);
-				if (!tmp) {
-					rcu_read_unlock();
-					goto cleanup;
-				}
-				tmp->thread = p;
-				list_add(&tmp->list, &thread_list);
-			}
-		while_each_thread(g,p);
-		rcu_read_unlock();
+		for (ct = current->mm->core_state->dumper.next;
+						ct; ct = ct->next) {
+			tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+			if (!tmp)
+				goto cleanup;
+
+			tmp->thread = ct->task;
+			list_add(&tmp->list, &thread_list);
+		}
+
 		list_for_each(t, &thread_list) {
 			struct elf_thread_status *tmp;
 			int sz;

