Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbZFVTVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbZFVTVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbZFVTVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:21:05 -0400
Received: from mx2.netapp.com ([216.240.18.37]:6263 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZFVTU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:20:58 -0400
X-IronPort-AV: E=Sophos;i="4.42,270,1243839600"; 
   d="scan'208";a="194527923"
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 1/5] VFS: Uninline the function put_mnt_ns()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 15:09:13 -0400
Message-ID: <20090622190913.27923.64996.stgit@heimdal.trondhjem.org>
In-Reply-To: <20090622190913.27923.31665.stgit@heimdal.trondhjem.org>
References: <20090622190913.27923.31665.stgit@heimdal.trondhjem.org>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 22 Jun 2009 19:20:59.0953 (UTC) FILETIME=[93458A10:01C9F36E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow modules to use it without having to export vfsmount_lock.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/namespace.c                |    8 ++++++--
 include/linux/mnt_namespace.h |    9 +--------
 2 files changed, 7 insertions(+), 10 deletions(-)


diff --git a/fs/namespace.c b/fs/namespace.c
index 2dd333b..2465c05 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2246,10 +2246,14 @@ void __init mnt_init(void)
 	init_mount_tree();
 }
 
-void __put_mnt_ns(struct mnt_namespace *ns)
+void put_mnt_ns(struct mnt_namespace *ns)
 {
-	struct vfsmount *root = ns->root;
+	struct vfsmount *root;
 	LIST_HEAD(umount_list);
+	
+	if (!atomic_dec_and_lock(&ns->count, &vfsmount_lock))
+		return;
+	root = ns->root;
 	ns->root = NULL;
 	spin_unlock(&vfsmount_lock);
 	down_write(&namespace_sem);
diff --git a/include/linux/mnt_namespace.h b/include/linux/mnt_namespace.h
index 3a05929..299d11a 100644
--- a/include/linux/mnt_namespace.h
+++ b/include/linux/mnt_namespace.h
@@ -26,14 +26,7 @@ struct fs_struct;
 
 extern struct mnt_namespace *copy_mnt_ns(unsigned long, struct mnt_namespace *,
 		struct fs_struct *);
-extern void __put_mnt_ns(struct mnt_namespace *ns);
-
-static inline void put_mnt_ns(struct mnt_namespace *ns)
-{
-	if (atomic_dec_and_lock(&ns->count, &vfsmount_lock))
-		/* releases vfsmount_lock */
-		__put_mnt_ns(ns);
-}
+extern void put_mnt_ns(struct mnt_namespace *ns);
 
 static inline void exit_mnt_ns(struct task_struct *p)
 {

