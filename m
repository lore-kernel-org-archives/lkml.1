Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbYFPQX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbYFPQX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 12:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYFPQXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 12:23:52 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:55770 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbYFPQXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 12:23:51 -0400
Date: Mon, 16 Jun 2008 20:26:03 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] coredump: elf_core_dump: skip kernel threads
Message-ID: <20080616162603.GA21028@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux_binfmt->core_dump() runs before the process does exit_aio(), this means
that we can hit the kernel thread which shares the same ->mm. Afaics, nothing
really bad can happen, but perhaps it makes sense to fix this minor bug.

It is sad we have to iterate over all threads in system and use GFP_ATOMIC.
Hopefully we can kill theses ugly do_each_thread()s, but this needs some
nontrivial changes in mm_struct and do_coredump.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 binfmt_elf.c       |    6 ++++++
 binfmt_elf_fdpic.c |    3 +++
 2 files changed, 9 insertions(+)

--- 26-rc2/fs/binfmt_elf.c~CD_SKIP_KTHREAD	2008-06-02 20:46:54.000000000 +0400
+++ 26-rc2/fs/binfmt_elf.c	2008-06-16 20:00:00.000000000 +0400
@@ -1522,6 +1522,9 @@ static int fill_note_info(struct elfhdr 
 	rcu_read_lock();
 	do_each_thread(g, p)
 		if (p->mm == dump_task->mm) {
+			if (p->flags & PF_KTHREAD)
+				continue;
+
 			t = kzalloc(offsetof(struct elf_thread_core_info,
 					     notes[info->thread_notes]),
 				    GFP_ATOMIC);
@@ -1726,6 +1729,9 @@ static int fill_note_info(struct elfhdr 
 		rcu_read_lock();
 		do_each_thread(g, p)
 			if (current->mm == p->mm && current != p) {
+				if (p->flags & PF_KTHREAD)
+					continue;
+
 				ets = kzalloc(sizeof(*ets), GFP_ATOMIC);
 				if (!ets) {
 					rcu_read_unlock();
--- 26-rc2/fs/binfmt_elf_fdpic.c~CD_SKIP_KTHREAD	2008-06-02 20:46:54.000000000 +0400
+++ 26-rc2/fs/binfmt_elf_fdpic.c	2008-06-16 18:57:46.000000000 +0400
@@ -1626,6 +1626,9 @@ static int elf_fdpic_core_dump(long sign
 		rcu_read_lock();
 		do_each_thread(g,p)
 			if (current->mm == p->mm && current != p) {
+				if (p->flags & PF_KTHREAD)
+					continue;
+
 				tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);
 				if (!tmp) {
 					rcu_read_unlock();

