Return-Path: <linux-kernel-owner+w=401wt.eu-S1763105AbZFPUnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763105AbZFPUnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763117AbZFPUkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:40:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59627 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763020AbZFPUk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:40:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/17] AFS: Implement the PGetFid pioctl
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org,
       Jacob Thebault-Spieker <summatusmentis@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:39:21 +0100
Message-ID: <20090616203921.4526.8438.stgit@warthog.procyon.org.uk>
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

Implement the PGetFID pioctl for AFS.  This will get the FID of a specified
file and return it to userspace.

This can be tested with the OpenAFS userspace tools by doing:

	fs getfid /afs

on a mounted AFS filesystem, which should return something like:

	File /afs (1.1.0) contained in volume 1

Signed-off-by: Jacob Thebault-Spieker <summatusmentis@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/pioctl.c         |   30 ++++++++++++++++++++++++++++++
 include/linux/afscall.h |    3 +++
 include/linux/venus.h   |    1 +
 3 files changed, 34 insertions(+), 0 deletions(-)


diff --git a/fs/afs/pioctl.c b/fs/afs/pioctl.c
index 6cac006..2e4f741 100644
--- a/fs/afs/pioctl.c
+++ b/fs/afs/pioctl.c
@@ -10,9 +10,35 @@
 #include <linux/fs.h>
 #include <linux/afscall.h>
 #include <linux/pioctl.h>
+#include <linux/venus.h>
 #include "internal.h"
 
 /*
+ * Get the AFS file identifier of a file
+ */
+static long afs_PGetFID(struct dentry *dentry, struct vice_ioctl *arg,
+			struct key *key)
+{
+	struct afs_vnode *vnode;
+
+	_enter("");
+
+	vnode = AFS_FS_I(dentry->d_inode);
+
+	if (arg->out_size < sizeof(vnode->fid)) {
+		_leave(" = -EINVAL [%d < %zu]",
+		       arg->out_size, sizeof(vnode->fid));
+		return -EINVAL;
+	}
+
+	memcpy(arg->out, &vnode->fid, sizeof(vnode->fid));
+	arg->out_size = sizeof(vnode->fid);
+
+	_leave(" = 0 [%d]", arg->out_size);
+	return 0;
+}
+
+/*
  * The AFS path-based I/O control operation
  */
 long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
@@ -34,6 +60,10 @@ long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
 #define VIOC_COMMAND(nr) (_VICEIOCTL(nr) & ~IOCSIZE_MASK)
 
 	switch (cmd & ~IOCSIZE_MASK) {
+	case VIOC_COMMAND(PGetFID):
+		ret = afs_PGetFID(dentry, arg, key);
+		break;
+
 	default:
 		_debug("fallback to pathless: %x", cmd);
 		ret = afs_pathless_pioctl(cmd, arg);
diff --git a/include/linux/afscall.h b/include/linux/afscall.h
index 40cbfa5..cb006a2 100644
--- a/include/linux/afscall.h
+++ b/include/linux/afscall.h
@@ -13,4 +13,7 @@
 
 #define AFSCALL_PIOCTL 0x14
 
+/* pioctl commands */
+#define PGetFID		22		/* get file ID */
+
 #endif /* _LINUX_AFSCALL_H */
diff --git a/include/linux/venus.h b/include/linux/venus.h
index 19fe13e..ea896e4 100644
--- a/include/linux/venus.h
+++ b/include/linux/venus.h
@@ -17,5 +17,6 @@
 /*
  * pioctl commands (not usable as ioctls)
  */
+#define VIOCGETFID		_VICEIOCTL(PGetFID)
 
 #endif /* _LINUX_VENUS_H */

