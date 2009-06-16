Return-Path: <linux-kernel-owner+w=401wt.eu-S1762328AbZFPUjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762328AbZFPUjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZFPUjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:39:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59551 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbZFPUjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:39:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/17] AFS: Implement the PGetFileCell pioctl
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org,
       Jacob Thebault-Spieker <summatusmentis@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:39:27 +0100
Message-ID: <20090616203926.4526.37772.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Thebault-Spieker <summatusmentis@gmail.com>

Implement the PGetFileCell pioctl for AFS.  This will get the name of the cell
to which a file belongs and return to userspace.

This can be tested with the OpenAFS userspace tools by doing:

	fs whichcell /afs

on a mounted AFS filesystem, which should return something like:

	File /afs lives in cell 'cambridge.redhat.com'

Signed-off-by: Jacob Thebault-Spieker <summatusmentis@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/pioctl.c         |   31 +++++++++++++++++++++++++++++++
 include/linux/afscall.h |    1 +
 include/linux/venus.h   |    1 +
 3 files changed, 33 insertions(+), 0 deletions(-)


diff --git a/fs/afs/pioctl.c b/fs/afs/pioctl.c
index 2e4f741..3d95a0d 100644
--- a/fs/afs/pioctl.c
+++ b/fs/afs/pioctl.c
@@ -11,6 +11,7 @@
 #include <linux/afscall.h>
 #include <linux/pioctl.h>
 #include <linux/venus.h>
+#include <linux/string.h>
 #include "internal.h"
 
 /*
@@ -39,6 +40,32 @@ static long afs_PGetFID(struct dentry *dentry, struct vice_ioctl *arg,
 }
 
 /*
+ * Get the cell that the file belongs to
+ */
+long afs_PGetFileCell(struct dentry *dentry, struct vice_ioctl *arg,
+		      struct key *key)
+{
+	struct afs_vnode *vnode;
+	size_t name_len;
+
+	_enter("");
+
+	vnode = AFS_FS_I(dentry->d_inode);
+	name_len = strlen(vnode->volume->vlocation->cell->name);
+
+	if (arg->out_size < name_len + 1) {
+		_leave(" = -EINVAL [%d < %zu]", arg->out_size, name_len + 1);
+		return -EINVAL;
+	}
+
+	memcpy(arg->out, &vnode->volume->vlocation->cell->name, name_len + 1);
+	arg->out_size = name_len + 1;
+
+	_leave(" = 0 [%d]", arg->out_size);
+	return 0;
+}
+
+/*
  * The AFS path-based I/O control operation
  */
 long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
@@ -64,6 +91,10 @@ long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
 		ret = afs_PGetFID(dentry, arg, key);
 		break;
 
+	case VIOC_COMMAND(PGetFileCell):
+		ret = afs_PGetFileCell(dentry, arg, key);
+		break;
+
 	default:
 		_debug("fallback to pathless: %x", cmd);
 		ret = afs_pathless_pioctl(cmd, arg);
diff --git a/include/linux/afscall.h b/include/linux/afscall.h
index cb006a2..0976469 100644
--- a/include/linux/afscall.h
+++ b/include/linux/afscall.h
@@ -15,5 +15,6 @@
 
 /* pioctl commands */
 #define PGetFID		22		/* get file ID */
+#define PGetFileCell	30		/* get the cell a file inhabits */
 
 #endif /* _LINUX_AFSCALL_H */
diff --git a/include/linux/venus.h b/include/linux/venus.h
index ea896e4..9cc115c 100644
--- a/include/linux/venus.h
+++ b/include/linux/venus.h
@@ -18,5 +18,6 @@
  * pioctl commands (not usable as ioctls)
  */
 #define VIOCGETFID		_VICEIOCTL(PGetFID)
+#define VIOC_FILE_CELL_NAME	_VICEIOCTL(PGetFileCell)
 
 #endif /* _LINUX_VENUS_H */

