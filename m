Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbZCWR1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbZCWR1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 13:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758722AbZCWRZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 13:25:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759601AbZCWRZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 13:25:24 -0400
Message-Id: <20090323172417.410913479@chello.nl>
References: <20090323172205.389341032@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 23 Mar 2009 18:22:09 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Paris <eparis@redhat.com>
Subject: [PATCH 4/7] mutex: add atomic_dec_and_mutex_lock]
Content-Disposition: inline; filename=eparis-mutex-add_atomic_dec_and_mutex_lock.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

Much like the atomic_dec_and_lock() function in which we take an hold a
spin_lock if we drop the atomic to 0 this function takes and holds the
mutex if we dec the atomic to 0.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>
---
 include/linux/mutex.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

Index: linux-2.6/include/linux/mutex.h
===================================================================
--- linux-2.6.orig/include/linux/mutex.h
+++ linux-2.6/include/linux/mutex.h
@@ -151,4 +151,27 @@ extern int __must_check mutex_lock_killa
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

-- 

