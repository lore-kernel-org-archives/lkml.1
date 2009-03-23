Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbZCWU6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbZCWU6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759107AbZCWU5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:57:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:49081 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758830AbZCWU5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:57:20 -0400
Date: Mon, 23 Mar 2009 20:56:49 GMT
From: Eric Paris <eparis@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, eparis@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, eparis@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090323172417.410913479@chello.nl>
References: <20090323172417.410913479@chello.nl>
Subject: [tip:perfcounters/core] mutex: add atomic_dec_and_mutex_lock()
Message-ID: <tip-3a2d367d9aabac486ac4444c6c7ec7a1dab16267@git.kernel.org>
Git-Commit-ID: 3a2d367d9aabac486ac4444c6c7ec7a1dab16267
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 20:56:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a2d367d9aabac486ac4444c6c7ec7a1dab16267
Gitweb:     http://git.kernel.org/tip/3a2d367d9aabac486ac4444c6c7ec7a1dab16267
Author:     Eric Paris <eparis@redhat.com>
AuthorDate: Mon, 23 Mar 2009 18:22:09 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 21:45:10 +0100

mutex: add atomic_dec_and_mutex_lock()

Much like the atomic_dec_and_lock() function in which we take an hold a
spin_lock if we drop the atomic to 0 this function takes and holds the
mutex if we dec the atomic to 0.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090323172417.410913479@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/mutex.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 3069ec7..93054fc 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -151,4 +151,27 @@ extern int __must_check mutex_lock_killable(struct mutex *lock);
 extern int mutex_trylock(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
 
+/**
+ * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
+ * @cnt: the atomic which we are to dec
+ * @lock: the mutex to return holding if we dec to 0
+ *
+ * return true and hold lock if we dec to 0, return false otherwise
+ */
+static inline int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock)
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
+
 #endif
