Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbZJFPEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbZJFPEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbZJFPEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:04:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:57438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392AbZJFPEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:04:43 -0400
Date: Tue, 6 Oct 2009 15:03:42 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, ani@anirban.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, ani@anirban.org
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Nullify robust lists after cleanup
Message-ID: <tip-fc6b177dee33365ccb29fe6d2092223cf8d679f9@git.kernel.org>
Git-Commit-ID: fc6b177dee33365ccb29fe6d2092223cf8d679f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 15:03:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc6b177dee33365ccb29fe6d2092223cf8d679f9
Gitweb:     http://git.kernel.org/tip/fc6b177dee33365ccb29fe6d2092223cf8d679f9
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 5 Oct 2009 18:17:32 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 6 Oct 2009 17:00:01 +0200

futex: Nullify robust lists after cleanup

The robust list pointers of user space held futexes are kept intact
over an exec() call. When the exec'ed task exits exit_robust_list() is
called with the stale pointer. The risk of corruption is minimal, but
still it is incorrect to keep the pointers valid. Actually glibc
should uninstall the robust list before calling exec() but we have to
deal with it anyway.

Nullify the pointers after [compat_]exit_robust_list() has been
called.

Reported-by: Anirban Sinha <ani@anirban.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Cc: stable@kernel.org
---
 kernel/fork.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index bfee931..88ef51c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -543,11 +543,15 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 
 	/* Get rid of any futexes when releasing the mm */
 #ifdef CONFIG_FUTEX
-	if (unlikely(tsk->robust_list))
+	if (unlikely(tsk->robust_list)) {
 		exit_robust_list(tsk);
+		tsk->robust_list = NULL;
+	}
 #ifdef CONFIG_COMPAT
-	if (unlikely(tsk->compat_robust_list))
+	if (unlikely(tsk->compat_robust_list)) {
 		compat_exit_robust_list(tsk);
+		tsk->compat_robust_list = NULL;
+	}
 #endif
 #endif
 
