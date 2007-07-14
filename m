Return-Path: <linux-kernel-owner+w=401wt.eu-S1764088AbXGNBAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764088AbXGNBAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759264AbXGNBAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:00:32 -0400
Received: from c-69-242-210-120.hsd1.mi.comcast.net ([69.242.210.120]:46793
	"EHLO heimdal.trondhjem.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759086AbXGNBAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:00:31 -0400
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH] SUNRPC: Convert rpc_pipefs to use the generic filesystem notification hooks
Date: Fri, 13 Jul 2007 21:00:30 -0400
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       nfs@lists.sourceforge.net
Message-Id: <20070714010030.27468.48291.stgit@heimdal.trondhjem.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

This will allow rpc.gssd to use inotify instead of dnotify in order to
locate new rpc upcall pipes.

This also requires the exporting of __audit_inode_child(), which is used by
fsnotify_create() and fsnotify_mkdir(). Ccing David Woodhouse.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 kernel/auditsc.c      |    1 +
 net/sunrpc/rpc_pipe.c |    7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index e36481e..64f229b 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1500,6 +1500,7 @@ add_names:
 			context->names[idx].ino = (unsigned long)-1;
 	}
 }
+EXPORT_SYMBOL_GPL(__audit_inode_child);
 
 /**
  * auditsc_get_stamp - get local copies of audit_context values
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index e787b6a..22e25b5 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -14,7 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
-#include <linux/dnotify.h>
+#include <linux/fsnotify.h>
 #include <linux/kernel.h>
 
 #include <asm/ioctls.h>
@@ -588,6 +588,7 @@ rpc_populate(struct dentry *parent,
 		if (S_ISDIR(mode))
 			inc_nlink(dir);
 		d_add(dentry, inode);
+		fsnotify_create(dir, dentry);
 	}
 	mutex_unlock(&dir->i_mutex);
 	return 0;
@@ -609,7 +610,7 @@ __rpc_mkdir(struct inode *dir, struct dentry *dentry)
 	inode->i_ino = iunique(dir->i_sb, 100);
 	d_instantiate(dentry, inode);
 	inc_nlink(dir);
-	inode_dir_notify(dir, DN_CREATE);
+	fsnotify_mkdir(dir, dentry);
 	return 0;
 out_err:
 	printk(KERN_WARNING "%s: %s failed to allocate inode for dentry %s\n",
@@ -751,7 +752,7 @@ rpc_mkpipe(struct dentry *parent, const char *name, void *private, struct rpc_pi
 	rpci->flags = flags;
 	rpci->ops = ops;
 	rpci->nkern_readwriters = 1;
-	inode_dir_notify(dir, DN_CREATE);
+	fsnotify_create(dir, dentry);
 	dget(dentry);
 out:
 	mutex_unlock(&dir->i_mutex);
