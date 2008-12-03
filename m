Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbYLCSOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbYLCSOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYLCSO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:14:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33183 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbYLCSOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:14:25 -0500
Date: Wed, 3 Dec 2008 19:12:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Hugh Dickins <hugh@veritas.com>,
       Jay Lan <jlan@sgi.com>, Jiri Pirko <jpirko@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] introduce get_mm_hiwater_xxx(), fix taskstats->hiwater_xxx
	accounting
Message-ID: <20081203181220.GA22918@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unless we are going to decrease rss/vm there is no point to call the
(racy) update_hiwater_xxx() helpers. Still do_exit() does this, and
the accounting code uses mm->hiwater_xxx directly.

This is not right. fill_pid()->xacct_add_tsk() can be called by
taskstats_user_cmd() at any time, not only when the task exits.
in that case taskstats->hiwater_xxx can be very wrong.

Introduce get_mm_hiwater_rss() and get_mm_hiwater_vm() to use instead,
and kill the "if (tsk->mm) {}" code in do_exit(). The first helper will
be also used to actually fill/report rusage->ru_maxrss.

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

