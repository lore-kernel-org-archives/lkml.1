Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323AbXJYQgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbXJYQgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbXJYQes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:34:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291AbXJYQeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:34:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/31] IGET: Introduce a function to register iget failure
	[try #5]
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 25 Oct 2007 17:34:07 +0100
Message-ID: <20071025163407.5057.26345.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
References: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a function to register failure in an inode construction path.  This
includes marking the inode under construction as bad, unlocking it and
releasing it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/porting |   18 +++++++++++++-----
 fs/bad_inode.c                    |   14 ++++++++++++++
 include/linux/fs.h                |    1 +
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index dac45c9..3b0fb22 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -184,11 +184,19 @@ just takes the superblock and inode number as arguments and does the
 test and set for you.
 
 e.g.
-       inode = iget_locked(sb, ino);
-       if (inode->i_state & I_NEW) {
-               read_inode_from_disk(inode);
-               unlock_new_inode(inode);
-       }
+	inode = iget_locked(sb, ino);
+	if (inode->i_state & I_NEW) {
+		err = read_inode_from_disk(inode);
+		if (err < 0) {
+			iget_failed(inode);
+			return err;
+		}
+		unlock_new_inode(inode);
+	}
+
+Note that if the process of setting up a new inode fails, then iget_failed()
+should be called on the inode to render it dead, and an appropriate error
+should be passed back to the caller.
 
 ---
 [recommended]
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 521ff7c..f1c2ea8 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -359,3 +359,17 @@ int is_bad_inode(struct inode *inode)
 }
 
 EXPORT_SYMBOL(is_bad_inode);
+
+/**
+ * iget_failed - Mark an under-construction inode as dead and release it
+ * @inode: The inode to discard
+ *
+ * Mark an under-construction inode as dead and release it.
+ */
+void iget_failed(struct inode *inode)
+{
+	make_bad_inode(inode);
+	unlock_new_inode(inode);
+	iput(inode);
+}
+EXPORT_SYMBOL(iget_failed);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ec4a4..bc2671f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1763,6 +1763,7 @@ static inline struct inode *iget(struct super_block *sb, unsigned long ino)
 }
 
 extern void __iget(struct inode * inode);
+extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);
 extern void destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);

