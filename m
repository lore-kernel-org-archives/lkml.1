Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbXINJXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbXINJXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 05:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXINJXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 05:23:10 -0400
Received: from swsoft-mipt-nat.sw.ru ([195.214.233.10]:60020 "EHLO iris"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751926AbXINJXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 05:23:09 -0400
X-Greylist: delayed 1798 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Sep 2007 05:23:09 EDT
Date: Fri, 14 Sep 2007 12:37:12 +0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: devel@openvz.org, den@openvz.org, dev@openvz.org, amirkin@openvz.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: [PATCH] shrink_dcache_sb speedup
Message-ID: <20070914083712.GA9788@iris.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis V. Lunev <den@openvz.org>

This patch makes shrink_dcache_sb consistent with dentry pruning policy.

On the first pass we iterate over dentry unused list and prepare some
dentries for removal.
However, since the existing code moves evicted dentries
to the beginning of the LRU it can happen that fresh dentries from
other superblocks will be inserted *before* our dentries.

This can result in significant slowdown of shrink_dcache_sb().
Moreover, for virtual filesystems like unionfs which can call dput()
during dentries kill existing code results in O(n^2) complexity.

We observed 2 minutes shrink_dcache_sb() with only 35000 dentries.

To avoid this effects we propose to isolate sb dentries at the end
of LRU list.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Andrey Mirkin <amirkin@openvz.org>

-------

--- ./fs/dcache.c.shrink	2007-09-14 10:25:21.000000000 +0400
+++ ./fs/dcache.c	2007-09-14 10:26:08.000000000 +0400
@@ -553,18 +553,18 @@ void shrink_dcache_sb(struct super_block
 	 * superblock to the most recent end of the unused list.
 	 */
 	spin_lock(&dcache_lock);
-	list_for_each_safe(tmp, next, &dentry_unused) {
+	list_for_each_prev_safe(tmp, next, &dentry_unused) {
 		dentry = list_entry(tmp, struct dentry, d_lru);
 		if (dentry->d_sb != sb)
 			continue;
-		list_move(tmp, &dentry_unused);
+		list_move_tail(tmp, &dentry_unused);
 	}
 
 	/*
 	 * Pass two ... free the dentries for this superblock.
 	 */
 repeat:
-	list_for_each_safe(tmp, next, &dentry_unused) {
+	list_for_each_prev_safe(tmp, next, &dentry_unused) {
 		dentry = list_entry(tmp, struct dentry, d_lru);
 		if (dentry->d_sb != sb)
 			continue;
--- ./include/linux/list.h.shrink	2007-08-10 16:58:49.000000000 +0400
+++ ./include/linux/list.h	2007-09-14 10:26:08.000000000 +0400
@@ -478,6 +478,18 @@ static inline void list_splice_init_rcu(
 		pos = n, n = pos->next)
 
 /**
+ * list_for_each_prev_safe - iterate over a list backwards safe against removal
+			of list entry
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @n:		another &struct list_head to use as temporary storage
+ * @head:	the head for your list.
+ */
+#define list_for_each_prev_safe(pos, n, head) \
+	for (pos = (head)->prev, n = pos->prev; \
+	     prefetch(pos->prev), pos != (head); \
+	     pos = n, n = pos->prev)
+
+/**
  * list_for_each_entry	-	iterate over list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
