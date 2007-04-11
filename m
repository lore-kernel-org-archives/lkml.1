Return-Path: <linux-kernel-owner+w=401wt.eu-S1161282AbXDKV7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161282AbXDKV7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 17:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161280AbXDKV7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 17:59:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161263AbXDKV7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 17:59:14 -0400
Date: Wed, 11 Apr 2007 17:58:56 -0400
From: Jeffrey Layton <jlayton@redhat.com>
Message-Id: <200704112158.l3BLwunk023090@dantu.rdu.redhat.com>
Subject: [PATCH] make iunique use a do/while loop rather than its obscure goto loop
To: akpm@linux-foundation.org
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A while back, Christoph mentioned that he thought that iunique ought to be
cleaned up to use a more conventional loop construct. This patch does that,
turning the strange goto loop into a do/while.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/inode.c b/fs/inode.c
index 23fc1fd..90e7587 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -689,21 +689,18 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 	struct inode *inode;
 	struct hlist_head * head;
 	ino_t res;
+
 	spin_lock(&inode_lock);
-retry:
-	if (counter > max_reserved) {
-		head = inode_hashtable + hash(sb,counter);
+	do {
+		if (counter <= max_reserved)
+			counter = max_reserved + 1;
 		res = counter++;
+		head = inode_hashtable + hash(sb, res);
 		inode = find_inode_fast(sb, head, res);
-		if (!inode) {
-			spin_unlock(&inode_lock);
-			return res;
-		}
-	} else {
-		counter = max_reserved + 1;
-	}
-	goto retry;
-	
+	} while (inode != NULL);
+	spin_unlock(&inode_lock);
+
+	return res;
 }
 
 EXPORT_SYMBOL(iunique);
