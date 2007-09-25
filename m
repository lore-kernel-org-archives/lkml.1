Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbXIYUFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbXIYUFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbXIYUF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:05:29 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:3844 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbXIYUF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:05:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=h3MNYMTMiooN7Q8c4M3XoW+sY1TJVrmUSExWTR9HTdg6OsKaQlr2XUnqLhMfwHOAIPIMdJfAmbz8J2Z0+bYO629v7CybRr9I9x9fIfsyYpWkYY4Az+w7I/mrTimp4AuburqCzowqchd3tMIUcJ5j02BJonpgqlC5FwEwOz5FHPI=
From: Denis Cheng <crquan@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, cr_quan@163.com
Subject: [PATCH] fs/dcache.c: revamped to use a more straightforward and efficient way to operate
Date: Wed, 26 Sep 2007 04:04:30 +0800
Message-Id: <1190750670-8264-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.2
In-Reply-To: <1190546051-15590-1-git-send-email-crquan@gmail.com>
References: <1190546051-15590-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/dcache.c |   39 ++++++++++++++++++---------------------
 1 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 678d39d..05ed44a 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1138,29 +1138,26 @@ struct dentry * d_alloc_anon(struct inode *inode)
 	
 	spin_lock(&dcache_lock);
 	res = __d_find_alias(inode, 0);
-	if (!res) {
-		/* attach a disconnected dentry */
-		res = tmp;
-		tmp = NULL;
-		spin_lock(&res->d_lock);
-		res->d_sb = inode->i_sb;
-		res->d_parent = res;
-		res->d_inode = inode;
-		res->d_flags |= DCACHE_DISCONNECTED;
-		res->d_flags &= ~DCACHE_UNHASHED;
-		list_add(&res->d_alias, &inode->i_dentry);
-		hlist_add_head(&res->d_hash, &inode->i_sb->s_anon);
-		spin_unlock(&res->d_lock);
-
-		inode = NULL; /* don't drop reference */
-	}
-	spin_unlock(&dcache_lock);
-
-	if (inode)
+	if (unlikely(res)) {
+		spin_unlock(&dcache_lock);
 		iput(inode);
-	if (tmp)
 		dput(tmp);
-	return res;
+		return res;
+	} else {
+		/* attach a disconnected dentry */
+		spin_lock(&tmp->d_lock);
+		tmp->d_sb = inode->i_sb;
+		tmp->d_parent = tmp;
+		tmp->d_inode = inode;
+		tmp->d_flags |= DCACHE_DISCONNECTED;
+		tmp->d_flags &= ~DCACHE_UNHASHED;
+		list_add(&tmp->d_alias, &inode->i_dentry);
+		hlist_add_head(&tmp->d_hash, &inode->i_sb->s_anon);
+		spin_unlock(&tmp->d_lock);
+
+		spin_unlock(&dcache_lock);
+		return tmp;
+	}
 }
 
 
-- 
1.5.3.2

