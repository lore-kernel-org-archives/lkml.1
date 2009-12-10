Return-Path: <linux-kernel-owner+w=401wt.eu-S1761903AbZLJWKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761903AbZLJWKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:10:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761922AbZLJWKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:10:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:41310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761895AbZLJWKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:10:02 -0500
Date: Thu, 10 Dec 2009 22:09:45 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <20091210004703.269843657@linutronix.de>
References: <20091210004703.269843657@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] signals: Fix more rcu assumptions
Message-ID: <tip-7cf7db8df0b78076eafa4ead47559344ca7b7a43@git.kernel.org>
Git-Commit-ID: 7cf7db8df0b78076eafa4ead47559344ca7b7a43
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7cf7db8df0b78076eafa4ead47559344ca7b7a43
Gitweb:     http://git.kernel.org/tip/7cf7db8df0b78076eafa4ead47559344ca7b7a43
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 10 Dec 2009 00:53:21 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 10 Dec 2009 23:04:11 +0100

signals: Fix more rcu assumptions

1) Remove the misleading comment in __sigqueue_alloc() which claims
   that holding a spinlock is equivalent to rcu_read_lock().

2) Add a rcu_read_lock/unlock around the __task_cred() access
   in __sigqueue_alloc()

This needs to be revisited to remove the remaining users of
read_lock(&tasklist_lock) but that's outside the scope of this patch.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091210004703.269843657@linutronix.de>
---
 kernel/signal.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 7331656..f67545f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -218,13 +218,13 @@ __sigqueue_alloc(int sig, struct task_struct *t, gfp_t flags, int override_rlimi
 	struct user_struct *user;
 
 	/*
-	 * We won't get problems with the target's UID changing under us
-	 * because changing it requires RCU be used, and if t != current, the
-	 * caller must be holding the RCU readlock (by way of a spinlock) and
-	 * we use RCU protection here
+	 * Protect access to @t credentials. This can go away when all
+	 * callers hold rcu read lock.
 	 */
+	rcu_read_lock();
 	user = get_uid(__task_cred(t)->user);
 	atomic_inc(&user->sigpending);
+	rcu_read_unlock();
 
 	if (override_rlimit ||
 	    atomic_read(&user->sigpending) <=
