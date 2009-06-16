Return-Path: <linux-kernel-owner+w=401wt.eu-S1762328AbZFPUlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762328AbZFPUlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762045AbZFPUj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:39:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59574 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762309AbZFPUjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:39:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/17] AFS: Handle pathless pioctls aimed at AFS
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, Wang Lei <wang840925@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:39:11 +0100
Message-ID: <20090616203911.4526.59826.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Lei <wang840925@gmail.com>

Handle pathless pioctls aimed at the AFS client in general, rather than at
specific files, volumes or cells.  We also check pathed ioctls for command
matches to pathless pioctls.

Signed-off-by: Wang Lei <wang840925@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/internal.h |    3 +++
 fs/afs/pioctl.c   |   28 ++++++++++++++++++++++++++--
 fs/afs/super.c    |   17 +++++++++++++++++
 3 files changed, 46 insertions(+), 2 deletions(-)


diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 0aaa324..9a8e8a2 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/pioctl.h>
 #include <linux/skbuff.h>
 #include <linux/rxrpc.h>
 #include <linux/key.h>
@@ -588,6 +589,8 @@ extern void afs_mntpt_kill_timer(void);
  */
 extern long afs_pioctl(struct dentry *, int, struct vice_ioctl *);
 
+extern long afs_pathless_pioctl(int, struct vice_ioctl *);
+
 /*
  * proc.c
  */
diff --git a/fs/afs/pioctl.c b/fs/afs/pioctl.c
index 63a6211..63d2fe1 100644
--- a/fs/afs/pioctl.c
+++ b/fs/afs/pioctl.c
@@ -33,8 +33,8 @@ long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
 
 	switch (cmd) {
 	default:
-		printk(KERN_DEBUG "AFS: Unsupported pioctl command %x\n", cmd);
-		ret = -EOPNOTSUPP;
+		_debug("fallback to pathless: %x", cmd);
+		ret = afs_pathless_pioctl(cmd, arg);
 		break;
 	}
 
@@ -42,3 +42,27 @@ long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
 	_leave(" = %ld", ret);
 	return ret;
 }
+
+/*
+ * The AFS pathless pioctl handler
+ */
+long afs_pathless_pioctl(int cmd, struct vice_ioctl *arg)
+{
+	long ret;
+
+	_enter(",%x(%d),{%d,%d}",
+	       cmd, _IOC_NR(cmd), arg->in_size, arg->out_size);
+
+#define VIOC_COMMAND(nr) (_VICEIOCTL(nr) & ~IOCSIZE_MASK)
+
+	switch (cmd & ~IOCSIZE_MASK) {
+	default:
+		printk(KERN_DEBUG
+			"AFS: Unsupported pioctl command %x\n", cmd);
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	_leave(" = %ld", ret);
+	return ret;
+}
diff --git a/fs/afs/super.c b/fs/afs/super.c
index ad0514d..62a43ea 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -71,6 +71,11 @@ static const match_table_t afs_options_list = {
 	{ afs_no_opt,		NULL		},
 };
 
+struct pathless_pioctl_handler afs_pathless_pioctl_handler = {
+	.owner		= THIS_MODULE,
+	.pioctl		= afs_pathless_pioctl,
+};
+
 /*
  * initialise the filesystem
  */
@@ -94,9 +99,20 @@ int __init afs_fs_init(void)
 		return ret;
 	}
 
+	/* register our pathless pioctl handler to pathless pioctl list */
+	ret = pathless_pioctl_register(&afs_pathless_pioctl_handler);
+	if (ret < 0) {
+		printk(KERN_NOTICE
+			"kAFS: Failed to register pathless pioctl handler\n");
+		kmem_cache_destroy(afs_inode_cachep);
+		_leave(" = %d", ret);
+		return ret;
+	}
+
 	/* now export our filesystem to lesser mortals */
 	ret = register_filesystem(&afs_fs_type);
 	if (ret < 0) {
+		pathless_pioctl_unregister(&afs_pathless_pioctl_handler);
 		kmem_cache_destroy(afs_inode_cachep);
 		_leave(" = %d", ret);
 		return ret;
@@ -114,6 +130,7 @@ void __exit afs_fs_exit(void)
 	_enter("");
 
 	afs_mntpt_kill_timer();
+	pathless_pioctl_unregister(&afs_pathless_pioctl_handler);
 	unregister_filesystem(&afs_fs_type);
 
 	if (atomic_read(&afs_count_active_inodes) != 0) {

