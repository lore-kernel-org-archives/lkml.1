Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbZD3HEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbZD3HEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 03:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZD3HEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 03:04:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:50418 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbZD3HEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 03:04:36 -0400
Date: Thu, 30 Apr 2009 07:03:29 GMT
From: tip-bot for Andrew Morton <akpm@linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, eparis@redhat.com,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org, hch@lst.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, eparis@redhat.com, a.p.zijlstra@chello.nl,
       viro@zeniv.linux.org.uk, hch@lst.de, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200904292318.n3TNIsi6028340@imap1.linux-foundation.org>
References: <200904292318.n3TNIsi6028340@imap1.linux-foundation.org>
Subject: [tip:core/locking] mutex: add atomic_dec_and_mutex_lock(), fix
Message-ID: <tip-a511e3f968c462a55ef58697257f5347c73d306e@git.kernel.org>
Git-Commit-ID: a511e3f968c462a55ef58697257f5347c73d306e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 07:03:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a511e3f968c462a55ef58697257f5347c73d306e
Gitweb:     http://git.kernel.org/tip/a511e3f968c462a55ef58697257f5347c73d306e
Author:     Andrew Morton <akpm@linux-foundation.org>
AuthorDate: Wed, 29 Apr 2009 15:59:58 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 30 Apr 2009 09:01:34 +0200

mutex: add atomic_dec_and_mutex_lock(), fix

include/linux/mutex.h:136: warning: 'mutex_lock' declared inline after being called
 include/linux/mutex.h:136: warning: previous declaration of 'mutex_lock' was here

uninline it.

[ Impact: clean up and uninline, address compiler warning ]

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Paris <eparis@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <200904292318.n3TNIsi6028340@imap1.linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/mutex.h |   24 +-----------------------
 kernel/mutex.c        |   25 ++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 93054fc..878cab4 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -150,28 +150,6 @@ extern int __must_check mutex_lock_killable(struct mutex *lock);
  */
 extern int mutex_trylock(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
-
-/**
- * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
- * @cnt: the atomic which we are to dec
- * @lock: the mutex to return holding if we dec to 0
- *
- * return true and hold lock if we dec to 0, return false otherwise
- */
-static inline int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock)
-{
-	/* dec if we can't possibly hit 0 */
-	if (atomic_add_unless(cnt, -1, 1))
-		return 0;
-	/* we might hit 0, so take the lock */
-	mutex_lock(lock);
-	if (!atomic_dec_and_test(cnt)) {
-		/* when we actually did the dec, we didn't hit 0 */
-		mutex_unlock(lock);
-		return 0;
-	}
-	/* we hit 0, and we hold the lock */
-	return 1;
-}
+extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
 #endif
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 507cf2b..e2d25e9 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -471,5 +471,28 @@ int __sched mutex_trylock(struct mutex *lock)
 
 	return ret;
 }
-
 EXPORT_SYMBOL(mutex_trylock);
+
+/**
+ * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
+ * @cnt: the atomic which we are to dec
+ * @lock: the mutex to return holding if we dec to 0
+ *
+ * return true and hold lock if we dec to 0, return false otherwise
+ */
+int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock)
+{
+	/* dec if we can't possibly hit 0 */
+	if (atomic_add_unless(cnt, -1, 1))
+		return 0;
+	/* we might hit 0, so take the lock */
+	mutex_lock(lock);
+	if (!atomic_dec_and_test(cnt)) {
+		/* when we actually did the dec, we didn't hit 0 */
+		mutex_unlock(lock);
+		return 0;
+	}
+	/* we hit 0, and we hold the lock */
+	return 1;
+}
+EXPORT_SYMBOL(atomic_dec_and_mutex_lock);
