Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbZCSSGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbZCSSGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZCSSGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:06:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45977 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbZCSSGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:06:35 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 01/13] mutex: add atomic_dec_and_mutex_lock
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Date: Thu, 19 Mar 2009 14:04:56 -0400
Message-ID: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Much like the atomic_dec_and_lock() function in which we take an hold a
spin_lock if we drop the atomic to 0 this function takes and holds the
mutex if we dec the atomic to 0.

Signed-off-by: Eric Paris <eparis@redhat.com>
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

