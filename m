Return-Path: <linux-kernel-owner+w=401wt.eu-S932617AbXA3PqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbXA3PqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965038AbXA3PqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:46:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623AbXA3PqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:46:12 -0500
Date: Tue, 30 Jan 2007 10:45:54 -0500
From: Jeffrey Layton <jlayton@redhat.com>
Message-Id: <200701301545.l0UFjsCw027749@dantu.rdu.redhat.com>
Subject: [PATCH] make iunique use a do/while loop rather than its obscure goto loop
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While working on a case, Christoph mentioned that he thought that iunique
ought to be cleaned up to use a more conventional loop construct. This patch
does that, turning the strange goto loop into a do/while.

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
