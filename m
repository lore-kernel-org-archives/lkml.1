Return-Path: <linux-kernel-owner+w=401wt.eu-S1759138AbYLLOH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbYLLOH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 09:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbYLLOHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 09:07:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34875 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758225AbYLLOHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 09:07:10 -0500
Date: Fri, 12 Dec 2008 15:05:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Hugh Dickins <hugh@veritas.com>,
       Jay Lan <jlan@sgi.com>, Jiri Pirko <jpirko@redhat.com>,
       Jonathan Lim <jlim@sgi.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH, RESEND] introduce get_mm_hiwater_xxx(), fix
	taskstats->hiwater_xxx accounting
Message-ID: <20081212140524.GA29488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(changes: update the changelog/comments)

xacct_add_tsk() relies on do_exit()->update_hiwater_xxx() and uses
mm->hiwater_xxx directly, this leads to 2 problems:

	- taskstats_user_cmd() can call fill_pid()->xacct_add_tsk()
	  at any moment before the task exits, so we should check the
	  current values of rss/vm anyway.

	- do_exit()->update_hiwater_xxx() calls are racy. An exiting
	  thread can be preempted right before mm->hiwater_xxx = new_val,
	  and another thread can use A_LOT of memory and exit in between.
	  When the first thread resumes it can be the last thread in the
	  thread group, in that case we report the wrong hiwater_xxx
	  values which do not take A_LOT into account.

Introduce get_mm_hiwater_rss() and get_mm_hiwater_vm() helpers and
change xacct_add_tsk() to use them. The first helper will also be
used by rusage->ru_maxrss accounting.

Kill do_exit()->update_hiwater_xxx() calls. Unless we are going to
decrease rss/vm there is no point to update mm->hiwater_xxx, and
nobody can look at this mm_struct when exit_mmap() actually unmaps
the memory.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- K-28/include/linux/sched.h~HIWATER	2008-12-02 17:12:40.000000000 +0100
+++ K-28/include/linux/sched.h	2008-12-03 18:17:18.000000000 +0100
@@ -388,6 +388,9 @@ extern void arch_unmap_area_topdown(stru
 		(mm)->hiwater_vm = (mm)->total_vm;	\
 } while (0)
 
+#define get_mm_hiwater_rss(mm)	max((mm)->hiwater_rss, get_mm_rss(mm))
+#define get_mm_hiwater_vm(mm)	max((mm)->hiwater_vm, (mm)->total_vm)
+
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
 
--- K-28/kernel/tsacct.c~HIWATER	2008-10-10 00:13:53.000000000 +0200
+++ K-28/kernel/tsacct.c	2008-12-03 18:24:28.000000000 +0100
@@ -90,8 +90,8 @@ void xacct_add_tsk(struct taskstats *sta
 	mm = get_task_mm(p);
 	if (mm) {
 		/* adjust to KB unit */
-		stats->hiwater_rss   = mm->hiwater_rss * PAGE_SIZE / KB;
-		stats->hiwater_vm    = mm->hiwater_vm * PAGE_SIZE / KB;
+		stats->hiwater_rss   = get_mm_hiwater_rss(mm) * PAGE_SIZE / KB;
+		stats->hiwater_vm    = get_mm_hiwater_vm(mm)  * PAGE_SIZE / KB;
 		mmput(mm);
 	}
 	stats->read_char	= p->ioac.rchar;
--- K-28/kernel/exit.c~HIWATER	2008-12-02 17:12:40.000000000 +0100
+++ K-28/kernel/exit.c	2008-12-03 18:21:06.000000000 +0100
@@ -1048,10 +1048,7 @@ NORET_TYPE void do_exit(long code)
 				preempt_count());
 
 	acct_update_integrals(tsk);
-	if (tsk->mm) {
-		update_hiwater_rss(tsk->mm);
-		update_hiwater_vm(tsk->mm);
-	}
+
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
 		hrtimer_cancel(&tsk->signal->real_timer);
--- K-28/mm/mmap.c~HIWATER	2008-12-02 17:12:40.000000000 +0100
+++ K-28/mm/mmap.c	2008-12-11 09:13:07.000000000 +0100
@@ -2103,7 +2103,7 @@ void exit_mmap(struct mm_struct *mm)
 	lru_add_drain();
 	flush_cache_mm(mm);
 	tlb = tlb_gather_mmu(mm, 1);
-	/* Don't update_hiwater_rss(mm) here, do_exit already did */
+	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	end = unmap_vmas(&tlb, vma, 0, -1, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);

