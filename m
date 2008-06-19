Return-Path: <linux-kernel-owner+w=401wt.eu-S1763106AbYF0UwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763106AbYF0UwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760756AbYF0Uum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:50:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760089AbYF0Uuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:50:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: elf_core_dump: skip kernel threads
In-Reply-To: Oleg Nesterov's message of  Monday, 16 June 2008 20:26:03 +0400 <20080616162603.GA21028@tv-sign.ru>
References: <20080616162603.GA21028@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080627204953.C2A49154224@magilla.localdomain>
Date: Thu, 19 Jun 2008 00:19:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps a little prettier like this:

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1469,6 +1469,12 @@ static int fill_thread_core_info(struct 
 	return 1;
 }
 
+static bool is_dump_thread(struct task_struct *dump_task,
+			   struct task_struct *thread)
+{
+	return !(thread->flags & PF_KTHREAD) && thread->mm == dump_task->mm;
+}
+
 static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  struct elf_note_info *info,
 			  long signr, struct pt_regs *regs)
@@ -1518,7 +1524,7 @@ static int fill_note_info(struct elfhdr 
 	 */
 	rcu_read_lock();
 	do_each_thread(g, p)
-		if (p->mm == dump_task->mm) {
+		if (is_dump_thread(dump_task, p)) {
 			t = kzalloc(offsetof(struct elf_thread_core_info,
 					     notes[info->thread_notes]),
 				    GFP_ATOMIC);
@@ -1722,7 +1728,7 @@ static int fill_note_info(struct elfhdr 
 		struct elf_thread_status *ets;
 		rcu_read_lock();
 		do_each_thread(g, p)
-			if (current->mm == p->mm && current != p) {
+			if (p != current && is_dump_thread(current, p)) {
 				ets = kzalloc(sizeof(*ets), GFP_ATOMIC);
 				if (!ets) {
 					rcu_read_unlock();

Or maybe you'll have other reasons to add a task_user_mm() that returns
NULL for kthreads, and then just use task_user_mm(p) == dump_task->mm here.

> It is sad we have to iterate over all threads in system and use GFP_ATOMIC.
> Hopefully we can kill theses ugly do_each_thread()s, but this needs some
> nontrivial changes in mm_struct and do_coredump.

Agreed, and twice at that (coredump_wait).  But this is something more to
consider for the future, and I wouldn't worry about it right now.


Thanks,
Roland
