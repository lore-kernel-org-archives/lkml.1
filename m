Return-Path: <linux-kernel-owner+w=401wt.eu-S1762878AbZFPUkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762878AbZFPUkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762322AbZFPUjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:39:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59563 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762241AbZFPUjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:39:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/17] AFS: Implement the PGetVolStat pioctl
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, Wang Lei <wang840925@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:39:32 +0100
Message-ID: <20090616203932.4526.83219.stgit@warthog.procyon.org.uk>
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

Implement the PGetVolStat pioctl for AFS.  This will get the status information
for the volume in which a specified file is located.

This can be tested with the OpenAFS userspace tools by doing:

	fs examine /afs

on a mounted AFS filesystem, which should return something like:

	fs: You don't have the required access rights on '/afs'

or:

	[root@andromeda ~]# fs examine /afs
	File /afs (1.1.32576) contained in volume 1
	Volume status for vid = 536870912 named
	Current disk quota is 5000
	Current blocks used are 2
	The partition has 39007484 blocks available out of 39187776

if authenticated.

Signed-off-by: Wang Lei <wang840925@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/pioctl.c         |   35 +++++++++++++++++++++++++++++++++++
 include/linux/afscall.h |   19 +++++++++++++++++++
 include/linux/venus.h   |    1 +
 3 files changed, 55 insertions(+), 0 deletions(-)


diff --git a/fs/afs/pioctl.c b/fs/afs/pioctl.c
index 3d95a0d..4efd825 100644
--- a/fs/afs/pioctl.c
+++ b/fs/afs/pioctl.c
@@ -66,6 +66,37 @@ long afs_PGetFileCell(struct dentry *dentry, struct vice_ioctl *arg,
 }
 
 /*
+ * Get volume status for pathname
+ */
+long afs_PGetVolStat(struct dentry *dentry, struct vice_ioctl *arg,
+		     struct key *key)
+{
+	struct afs_volume_status vs;
+	struct afs_vnode *vnode = AFS_FS_I(dentry->d_inode);
+	long ret;
+
+	_enter("");
+
+	if (arg->out_size < sizeof(struct VolumeStatus)) {
+		_leave(" = -EINVAL [%d < %zu]", arg->out_size,
+		       sizeof(struct VolumeStatus));
+		return -EINVAL;
+	}
+
+	ret = afs_vnode_get_volume_status(vnode, key, &vs);
+	if (ret < 0) {
+		_leave(" = %ld", ret);
+		return ret;
+	}
+
+	memcpy(arg->out, &vs, sizeof(struct VolumeStatus));
+	arg->out_size = sizeof(struct VolumeStatus);
+
+	_leave(" = 0 [%d]", arg->out_size);
+	return 0;
+}
+
+/*
  * The AFS path-based I/O control operation
  */
 long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
@@ -95,6 +126,10 @@ long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
 		ret = afs_PGetFileCell(dentry, arg, key);
 		break;
 
+	case VIOC_COMMAND(PGetVolStat):
+		ret = afs_PGetVolStat(dentry, arg, key);
+		break;
+
 	default:
 		_debug("fallback to pathless: %x", cmd);
 		ret = afs_pathless_pioctl(cmd, arg);
diff --git a/include/linux/afscall.h b/include/linux/afscall.h
index 0976469..6772712 100644
--- a/include/linux/afscall.h
+++ b/include/linux/afscall.h
@@ -14,7 +14,26 @@
 #define AFSCALL_PIOCTL 0x14
 
 /* pioctl commands */
+#define PGetVolStat	4		/* get volume status */
 #define PGetFID		22		/* get file ID */
 #define PGetFileCell	30		/* get the cell a file inhabits */
 
+/*
+ * AFS volume status record
+ */
+struct VolumeStatus {
+	int	Vid;		/* volume ID */
+	int	ParentId;	/* parent volume ID */
+	char	Online;		/* 1 if volume currently online and available */
+	char	InService;	/* 1 if volume currently in service */
+	char	Blessed;	/* same as in_service */
+	char	NeedsSalvage;	/* 1 if consistency checking required */
+	int	Type;		/* volume type (afs_voltype_t) */
+	int	MinQuota;	/* minimum blocks set aside */
+	int	MaxQuota;	/* maximum blocks this volume may occupy */
+	int	BlocksInUse;	/* blocks this volume currently occupies */
+	int	PartBlocksAvail;/* space available in volume's partition */
+	int	PartMaxBlocks;	/* size of volume's partition */
+};
+
 #endif /* _LINUX_AFSCALL_H */
diff --git a/include/linux/venus.h b/include/linux/venus.h
index 9cc115c..437e7f3 100644
--- a/include/linux/venus.h
+++ b/include/linux/venus.h
@@ -17,6 +17,7 @@
 /*
  * pioctl commands (not usable as ioctls)
  */
+#define VIOCGETVOLSTAT		_VICEIOCTL(PGetVolStat)
 #define VIOCGETFID		_VICEIOCTL(PGetFID)
 #define VIOC_FILE_CELL_NAME	_VICEIOCTL(PGetFileCell)
 

