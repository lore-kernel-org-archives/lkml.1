Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138Ab0ANXKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab0ANXKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896Ab0ANXKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:10:16 -0500
Received: from kroah.org ([198.145.64.141]:41919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554Ab0ANXKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:10:10 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Jan 14 15:06:21 2010
Message-Id: <20100114230621.214106296@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 15:04:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [4/6] fix more leaks in audit_tree.c tag_chunk()
In-Reply-To: <20100114230640.GA7259@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit b4c30aad39805902cf5b855aa8a8b22d728ad057 upstream.

Several leaks in audit_tree didn't get caught by commit
318b6d3d7ddbcad3d6867e630711b8a705d873d7, including the leak on normal
exit in case of multiple rules refering to the same chunk.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/audit_tree.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -372,15 +372,17 @@ static int tag_chunk(struct inode *inode
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
@@ -422,7 +424,8 @@ static int tag_chunk(struct inode *inode
 	spin_unlock(&hash_lock);
 	inotify_evict_watch(&old->watch);
 	mutex_unlock(&inode->inotify_mutex);
-	put_inotify_watch(&old->watch);
+	put_inotify_watch(&old->watch); /* pair to inotify_find_watch */
+	put_inotify_watch(&old->watch); /* and kill it */
 	return 0;
 }
 


