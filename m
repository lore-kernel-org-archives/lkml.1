Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbXKLDOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbXKLDOE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 22:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbXKLDNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 22:13:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbXKLDNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 22:13:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH] core dump: remain dumpable
In-Reply-To: Roland McGrath's message of  Wednesday, 10 October 2007 23:27:30 -0700 <20071011062730.19F774D026B@magilla.localdomain>
X-Fcc: ~/Mail/linus
References: <20071011062730.19F774D026B@magilla.localdomain>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20071112031343.77C834D04C8@magilla.localdomain>
Date: Sun, 11 Nov 2007 19:13:43 -0800 (PST)
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

set_dumpable was only used in do_coredump for synchronization and not
intended for any security purpose.  (It doesn't secure anything that wasn't
already unsecured when a process dies by SIGTERM instead of SIGQUIT.)

This changes do_coredump to check the core_waiters count as the means of
synchronization, which is sufficient.  Now we leave the "dumpable" bits alone.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/exec.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 2c942e2..3f70c3e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1692,7 +1692,10 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	if (!binfmt || !binfmt->core_dump)
 		goto fail;
 	down_write(&mm->mmap_sem);
-	if (!get_dumpable(mm)) {
+	/*
+	 * If another thread got here first, or we are not dumpable, bail out.
+	 */
+	if (mm->core_waiters || !get_dumpable(mm)) {
 		up_write(&mm->mmap_sem);
 		goto fail;
 	}
@@ -1706,7 +1709,6 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		current->fsuid = 0;	/* Dump root private */
 	}
-	set_dumpable(mm, 0);
 
 	retval = coredump_wait(exit_code);
 	if (retval < 0)
