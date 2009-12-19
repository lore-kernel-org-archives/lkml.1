Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZLSQDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZLSQDe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 11:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZLSQDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 11:03:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55216 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZLSQDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 11:03:31 -0500
Date: Sat, 19 Dec 2009 16:03:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, eparis@redhat.com
Subject: [PATCH] fix more leaks in audit_tree.c tag_chunk()
Message-ID: <20091219160330.GM18217@ZenIV.linux.org.uk>
References: <20091219155945.GL18217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091219155945.GL18217@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Several leaks in audit_tree didn't get caught by commit
318b6d3d7ddbcad3d6867e630711b8a705d873d7, including the leak on
normal exit in case of multiple rules refering to the same chunk.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -373,15 +373,17 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	for (n = 0; n < old->count; n++) {
 		if (old->owners[n].owner == tree) {
 			spin_unlock(&hash_lock);
-			put_inotify_watch(watch);
+			put_inotify_watch(&old->watch);
 			return 0;
 		}
 	}
 	spin_unlock(&hash_lock);
 
 	chunk = alloc_chunk(old->count + 1);
-	if (!chunk)
+	if (!chunk) {
+		put_inotify_watch(&old->watch);
 		return -ENOMEM;
+	}
 
 	mutex_lock(&inode->inotify_mutex);
 	if (inotify_clone_watch(&old->watch, &chunk->watch) < 0) {
@@ -425,7 +427,8 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	spin_unlock(&hash_lock);
 	inotify_evict_watch(&old->watch);
 	mutex_unlock(&inode->inotify_mutex);
-	put_inotify_watch(&old->watch);
+	put_inotify_watch(&old->watch); /* pair to inotify_find_watch */
+	put_inotify_watch(&old->watch); /* and kill it */
 	return 0;
 }
 
