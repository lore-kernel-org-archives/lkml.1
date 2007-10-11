Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbXJKG1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbXJKG1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 02:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbXJKG1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 02:27:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbXJKG1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 02:27:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH] core dump: remain dumpable
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20071011062730.19F774D026B@magilla.localdomain>
Date: Wed, 10 Oct 2007 23:27:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The coredump code always calls set_dumpable(0) when it starts (even
if RLIMIT_CORE prevents any core from being dumped).  The effect of
this (via task_dumpable) is to make /proc/pid/* files owned by root
instead of the user, so the user can no longer examine his own
process--in a case where there was never any privileged data to
protect.  This affects e.g. auxv, environ, fd; in Fedora (execshield)
kernels, also maps.  In practice, you can only notice this when a
debugger has requested PTRACE_EVENT_EXIT tracing.

As far as I know, set_dumpable was only used in do_coredump for
synchronization and not intended for any security purpose.
(It doesn't secure anything that wasn't already unsecured when a
process dies by SIGTERM instead of SIGQUIT.)

This changes do_coredump to use a separate bit for its
synchronization, so the "dumpable" bits remain the same.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/exec.c             |    4 ++--
 include/linux/sched.h |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 073b0b8..7f1e355 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1727,7 +1727,8 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	if (!binfmt || !binfmt->core_dump)
 		goto fail;
 	down_write(&mm->mmap_sem);
-	if (!get_dumpable(mm)) {
+	if (!get_dumpable(mm) ||
+	    test_and_set_bit(MMF_DUMP_STARTED, &mm->flags)) {
 		up_write(&mm->mmap_sem);
 		goto fail;
 	}
@@ -1741,7 +1742,6 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		current->fsuid = 0;	/* Dump root private */
 	}
-	set_dumpable(mm, 0);
 
 	retval = coredump_wait(exit_code);
 	if (retval < 0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1f274c2..33676ad 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -367,6 +367,8 @@ extern int get_dumpable(struct mm_struct *mm);
 #define MMF_DUMP_FILTER_DEFAULT \
 	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED))
 
+#define MMF_DUMP_STARTED	16 /* some thread entered do_coredump already */
+
 struct mm_struct {
 	struct vm_area_struct * mmap;		/* list of VMAs */
 	struct rb_root mm_rb;
