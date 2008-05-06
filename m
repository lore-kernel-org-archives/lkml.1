Return-Path: <linux-kernel-owner+w=401wt.eu-S1764257AbYEFAez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764257AbYEFAez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764069AbYEFAeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:34:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761633AbYEFAeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:34:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 3/4] do_wait: return security_task_wait() error code in place of -ECHILD
In-Reply-To: Roland McGrath's message of  Monday, 5 May 2008 17:32:39 -0700 <20080506003239.43FF026FA20@magilla.localdomain>
References: <20080506003239.43FF026FA20@magilla.localdomain>
Emacs: don't try this at home, kids!
Message-Id: <20080506003358.664BB26FA20@magilla.localdomain>
Date: Mon,  5 May 2008 17:33:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts the effect of commit f2cc3eb133baa2e9dc8efd40f417106b2ee520f3
"do_wait: fix security checks".  That change reverted the effect of commit
73243284463a761e04d69d22c7516b2be7de096c.  The rationale for the original
commit still stands.  The inconsistent treatment of children hidden by
ptrace was an unintended omission in the original change and in no way
invalidates its purpose.

This makes do_wait return the error returned by security_task_wait()
(usually -EACCES) in place of -ECHILD when there are some children the
caller would be able to wait for if not for the permission failure.  A
permission error will give the user a clue to look for security policy
problems, rather than for mysterious wait bugs.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/exit.c |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index c95765f..42980e2 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1193,14 +1193,10 @@ static int eligible_child(enum pid_type type, struct pid *pid, int options,
 		return 0;
 
 	err = security_task_wait(p);
-	if (likely(!err))
-		return 1;
+	if (err)
+		return err;
 
-	if (type != PIDTYPE_PID)
-		return 0;
-	/* This child was explicitly requested, abort */
-	read_unlock(&tasklist_lock);
-	return err;
+	return 1;
 }
 
 static int wait_noreap_copyout(struct task_struct *p, pid_t pid, uid_t uid,
@@ -1530,7 +1526,8 @@ static int wait_task_continued(struct task_struct *p, int options,
  * -ECHILD should be in *@retval before the first call.
  * Returns nonzero for a final return, when we have unlocked tasklist_lock.
  * Returns zero if the search for a child should continue; then *@retval is
- * 0 if @p is an eligible child, or still -ECHILD.
+ * 0 if @p is an eligible child, or another error from security_task_wait(),
+ * or still -ECHILD.
  */
 static int wait_consider_task(struct task_struct *parent, int ptrace,
 			      struct task_struct *p, int *retval,
@@ -1539,9 +1536,21 @@ static int wait_consider_task(struct task_struct *parent, int ptrace,
 			      int __user *stat_addr, struct rusage __user *ru)
 {
 	int ret = eligible_child(type, pid, options, p);
-	if (ret <= 0)
+	if (!ret)
 		return ret;
 
+	if (unlikely(ret < 0)) {
+		/*
+		 * If we have not yet seen any eligible child,
+		 * then let this error code replace -ECHILD.
+		 * A permission error will give the user a clue
+		 * to look for security policy problems, rather
+		 * than for mysterious wait bugs.
+		 */
+		if (*retval)
+			*retval = ret;
+	}
+
 	if (likely(!ptrace) && unlikely(p->ptrace)) {
 		/*
 		 * This child is hidden by ptrace.
@@ -1579,7 +1588,8 @@ static int wait_consider_task(struct task_struct *parent, int ptrace,
  * -ECHILD should be in *@retval before the first call.
  * Returns nonzero for a final return, when we have unlocked tasklist_lock.
  * Returns zero if the search for a child should continue; then *@retval is
- * 0 if there were any eligible children, or still -ECHILD.
+ * 0 if there were any eligible children, or another error from
+ * security_task_wait(), or still -ECHILD.
  */
 static int do_wait_thread(struct task_struct *tsk, int *retval,
 			  enum pid_type type, struct pid *pid, int options,
