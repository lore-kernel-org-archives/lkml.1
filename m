Return-Path: <linux-kernel-owner+w=401wt.eu-S1763648AbZFPUl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763648AbZFPUl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762792AbZFPUkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:40:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59586 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761888AbZFPUkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:40:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/17] AFS: Implement the PWhereIs pioctl
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, Wang Lei <wang840925@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:39:37 +0100
Message-ID: <20090616203937.4526.53619.stgit@warthog.procyon.org.uk>
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

Implement the PWhereIs pioctl for AFS.  This will find out on which servers the
volume containing the specified file is located and return the IPv4 addresses
to userspace.

This can be tested with the OpenAFS userspace tools by doing:

	fs whereis /afs

on a mounted AFS filesystem, which should return something like:

	File /afs is on host altair.cambridge.redhat.com

Signed-off-by: Wang Lei <wang840925@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/pioctl.c         |   51 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/afscall.h |    3 +++
 include/linux/venus.h   |    1 +
 3 files changed, 55 insertions(+), 0 deletions(-)


diff --git a/fs/afs/pioctl.c b/fs/afs/pioctl.c
index 4efd825..5f6beeb 100644
--- a/fs/afs/pioctl.c
+++ b/fs/afs/pioctl.c
@@ -97,6 +97,53 @@ long afs_PGetVolStat(struct dentry *dentry, struct vice_ioctl *arg,
 }
 
 /*
+ * Find out where a volume is located
+ */
+long afs_PWhereIs(struct dentry *dentry, struct vice_ioctl *arg,
+		  struct key *key)
+{
+	int i;
+	char *cp = arg->out;
+	const size_t addr_size = sizeof(struct in_addr);
+	struct afs_volume *volume = AFS_FS_I(dentry->d_inode)->volume;
+	long ret;
+
+	_enter("");
+
+	if (arg->out_size < AFS_MAXHOSTS * addr_size) {
+		_leave(" = -EINVAL [%d < %zu]", arg->out_size,
+		       AFS_MAXHOSTS * addr_size);
+		return -EINVAL;
+	}
+
+	down_read(&volume->server_sem);
+
+	/* handle the no-server case */
+	if (volume->nservers == 0) {
+		ret = volume->rjservers ? -ENOMEDIUM : -ESTALE;
+		up_read(&volume->server_sem);
+		_leave(" = %ld [no servers]", ret);
+		return ret;
+	}
+
+	for (i = 0; i < volume->nservers; i++, cp += addr_size)
+		memcpy(cp, &volume->servers[i]->addr.s_addr, addr_size);
+
+	up_read(&volume->server_sem);
+
+	if (i < AFS_MAXHOSTS) {
+		/* still room for terminating NULL, add it on the end */
+		memset(cp, 0, addr_size);
+		cp += addr_size;
+	}
+
+	arg->out_size = cp - arg->out;
+
+	_leave(" = 0 [%d]", arg->out_size);
+	return 0;
+}
+
+/*
  * The AFS path-based I/O control operation
  */
 long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
@@ -130,6 +177,10 @@ long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
 		ret = afs_PGetVolStat(dentry, arg, key);
 		break;
 
+	case VIOC_COMMAND(PWhereIs):
+		ret = afs_PWhereIs(dentry, arg, key);
+		break;
+
 	default:
 		_debug("fallback to pathless: %x", cmd);
 		ret = afs_pathless_pioctl(cmd, arg);
diff --git a/include/linux/afscall.h b/include/linux/afscall.h
index 6772712..0a60cd1 100644
--- a/include/linux/afscall.h
+++ b/include/linux/afscall.h
@@ -15,9 +15,12 @@
 
 /* pioctl commands */
 #define PGetVolStat	4		/* get volume status */
+#define PWhereIs	14		/* find out where a volume is located */
 #define PGetFID		22		/* get file ID */
 #define PGetFileCell	30		/* get the cell a file inhabits */
 
+#define AFS_MAXHOSTS	8		/* the maximum of hosts number */
+
 /*
  * AFS volume status record
  */
diff --git a/include/linux/venus.h b/include/linux/venus.h
index 437e7f3..78cbf47 100644
--- a/include/linux/venus.h
+++ b/include/linux/venus.h
@@ -18,6 +18,7 @@
  * pioctl commands (not usable as ioctls)
  */
 #define VIOCGETVOLSTAT		_VICEIOCTL(PGetVolStat)
+#define VIOCWHEREIS		_VICEIOCTL(PWhereIs)
 #define VIOCGETFID		_VICEIOCTL(PGetFID)
 #define VIOC_FILE_CELL_NAME	_VICEIOCTL(PGetFileCell)
 

