Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbZJFPFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbZJFPFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbZJFPFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:05:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:57446 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbZJFPFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:05:03 -0400
Date: Tue, 6 Oct 2009 15:03:57 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, ani@anirban.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, ani@anirban.org
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Move exit_pi_state() call to release_mm()
Message-ID: <tip-322a2c100a8998158445599ea437fb556aa95b11@git.kernel.org>
Git-Commit-ID: 322a2c100a8998158445599ea437fb556aa95b11
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 15:04:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  322a2c100a8998158445599ea437fb556aa95b11
Gitweb:     http://git.kernel.org/tip/322a2c100a8998158445599ea437fb556aa95b11
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 5 Oct 2009 18:18:03 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 6 Oct 2009 17:00:01 +0200

futex: Move exit_pi_state() call to release_mm()

exit_pi_state() is called from do_exit() but not from do_execve().
Move it to release_mm() so it gets called from do_execve() as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Cc: stable@kernel.org
Cc: Anirban Sinha <ani@anirban.org>
Cc: Peter Zijlstra <peterz@infradead.org>

---
 kernel/exit.c |    2 --
 kernel/fork.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index ae5d866..bc2b1fd 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -989,8 +989,6 @@ NORET_TYPE void do_exit(long code)
 	tsk->mempolicy = NULL;
 #endif
 #ifdef CONFIG_FUTEX
-	if (unlikely(!list_empty(&tsk->pi_state_list)))
-		exit_pi_state_list(tsk);
 	if (unlikely(current->pi_state_cache))
 		kfree(current->pi_state_cache);
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index 88ef51c..341965b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -553,6 +553,8 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 		tsk->compat_robust_list = NULL;
 	}
 #endif
+	if (unlikely(!list_empty(&tsk->pi_state_list)))
+		exit_pi_state_list(tsk);
 #endif
 
 	/* Get rid of any cached register state */
