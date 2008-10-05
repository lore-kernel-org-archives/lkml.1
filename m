Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbYJEQUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbYJEQUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757845AbYJEQQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:16:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49642 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757964AbYJEQQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:16:38 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 44/76] tty: Fix abusers of current->sighand->tty
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:16:38 +0100
Message-ID: <20081005161542.1997.70677.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various people outside the tty layer still stick their noses in behind the
scenes. We need to make sure they also obey the locking and referencing rules.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 kernel/acct.c    |    2 +-
 kernel/auditsc.c |    9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index dd68b90..f6006a6 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -548,7 +548,7 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 #endif
 
 	spin_lock_irq(&current->sighand->siglock);
-	tty = current->signal->tty;
+	tty = current->signal->tty;	/* Safe as we hold the siglock */
 	ac.ac_tty = tty ? old_encode_dev(tty_devnum(tty)) : 0;
 	ac.ac_utime = encode_comp_t(jiffies_to_AHZ(cputime_to_jiffies(pacct->ac_utime)));
 	ac.ac_stime = encode_comp_t(jiffies_to_AHZ(cputime_to_jiffies(pacct->ac_stime)));
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 59cedfb..cf5bc2f 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -246,8 +246,8 @@ static int audit_match_perm(struct audit_context *ctx, int mask)
 	unsigned n;
 	if (unlikely(!ctx))
 		return 0;
-
 	n = ctx->major;
+
 	switch (audit_classify_syscall(ctx->arch, n)) {
 	case 0:	/* native */
 		if ((mask & AUDIT_PERM_WRITE) &&
@@ -1204,13 +1204,13 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 				 (context->return_valid==AUDITSC_SUCCESS)?"yes":"no",
 				 context->return_code);
 
-	mutex_lock(&tty_mutex);
-	read_lock(&tasklist_lock);
+	spin_lock_irq(&tsk->sighand->siglock);
 	if (tsk->signal && tsk->signal->tty && tsk->signal->tty->name)
 		tty = tsk->signal->tty->name;
 	else
 		tty = "(none)";
-	read_unlock(&tasklist_lock);
+	spin_unlock_irq(&tsk->sighand->siglock);
+
 	audit_log_format(ab,
 		  " a0=%lx a1=%lx a2=%lx a3=%lx items=%d"
 		  " ppid=%d pid=%d auid=%u uid=%u gid=%u"
@@ -1230,7 +1230,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 		  context->egid, context->sgid, context->fsgid, tty,
 		  tsk->sessionid);
 
-	mutex_unlock(&tty_mutex);
 
 	audit_log_task_info(ab, tsk);
 	if (context->filterkey) {

