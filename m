Return-Path: <linux-kernel-owner+w=401wt.eu-S1760906AbZFPUo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906AbZFPUo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763314AbZFPUlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:41:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35498 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763279AbZFPUlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:41:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/17] AFS: Implement the PFlushCB pioctl
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, Wang Lei <wang840925@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:39:42 +0100
Message-ID: <20090616203942.4526.93942.stgit@warthog.procyon.org.uk>
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

Implement the PFlushCB pioctl for AFS.  This flushes the callback of the
specified file, indicating to the server we're no longer interested in
notifications of changes to that file.

Signed-off-by: Wang Lei <wang840925@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/pioctl.c         |   26 ++++++++++++++++++++++++++
 include/linux/afscall.h |    1 +
 include/linux/venus.h   |    1 +
 3 files changed, 28 insertions(+), 0 deletions(-)


diff --git a/fs/afs/pioctl.c b/fs/afs/pioctl.c
index 5f6beeb..ffbec0c 100644
--- a/fs/afs/pioctl.c
+++ b/fs/afs/pioctl.c
@@ -144,6 +144,28 @@ long afs_PWhereIs(struct dentry *dentry, struct vice_ioctl *arg,
 }
 
 /*
+ * Flush callback only
+ */
+long afs_PFlushCB(struct dentry *dentry, struct vice_ioctl *arg,
+		  struct key *key)
+{
+	struct afs_vnode *vnode = AFS_FS_I(dentry->d_inode);
+	struct afs_volume *volume = vnode->volume;
+
+	_enter("");
+
+	/* file servers do not grant callbacks on files from read-only
+	 * volumes */
+	if (volume->type != AFSVL_ROVOL && vnode->cb_promised) {
+		afs_give_up_callback(vnode);
+		afs_flush_callback_breaks(vnode->server);
+	}
+
+	_leave(" = 0");
+	return 0;
+}
+
+/*
  * The AFS path-based I/O control operation
  */
 long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
@@ -181,6 +203,10 @@ long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
 		ret = afs_PWhereIs(dentry, arg, key);
 		break;
 
+	case VIOC_COMMAND(PFlushCB):
+		ret = afs_PFlushCB(dentry, arg, key);
+		break;
+
 	default:
 		_debug("fallback to pathless: %x", cmd);
 		ret = afs_pathless_pioctl(cmd, arg);
diff --git a/include/linux/afscall.h b/include/linux/afscall.h
index 0a60cd1..00054f0 100644
--- a/include/linux/afscall.h
+++ b/include/linux/afscall.h
@@ -17,6 +17,7 @@
 #define PGetVolStat	4		/* get volume status */
 #define PWhereIs	14		/* find out where a volume is located */
 #define PGetFID		22		/* get file ID */
+#define PFlushCB	25		/* flush callback only */
 #define PGetFileCell	30		/* get the cell a file inhabits */
 
 #define AFS_MAXHOSTS	8		/* the maximum of hosts number */
diff --git a/include/linux/venus.h b/include/linux/venus.h
index 78cbf47..ea8e468 100644
--- a/include/linux/venus.h
+++ b/include/linux/venus.h
@@ -20,6 +20,7 @@
 #define VIOCGETVOLSTAT		_VICEIOCTL(PGetVolStat)
 #define VIOCWHEREIS		_VICEIOCTL(PWhereIs)
 #define VIOCGETFID		_VICEIOCTL(PGetFID)
+#define VIOCFLUSHCB		_VICEIOCTL(PFlushCB)
 #define VIOC_FILE_CELL_NAME	_VICEIOCTL(PGetFileCell)
 
 #endif /* _LINUX_VENUS_H */

