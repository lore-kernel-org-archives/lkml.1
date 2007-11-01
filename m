Return-Path: <linux-kernel-owner+w=401wt.eu-S1761655AbXKAXNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761655AbXKAXNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759186AbXKAXIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:08:51 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49898 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768AbXKAXIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:08:49 -0400
Subject: [PATCH 11/27] r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:08:40 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230840.25D680E0@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


fs/ncpfs/ioctl.c: In function 'ncp_ioctl_need_write':
fs/ncpfs/ioctl.c:852: error: label at end of compound statement

Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/ncpfs/ioctl.c |   57 ++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff -puN fs/ncpfs/ioctl.c~r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl fs/ncpfs/ioctl.c
--- linux-2.6.git/fs/ncpfs/ioctl.c~r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl	2007-11-01 14:46:11.000000000 -0700
+++ linux-2.6.git-dave/fs/ncpfs/ioctl.c	2007-11-01 14:46:11.000000000 -0700
@@ -14,6 +14,7 @@
 #include <linux/ioctl.h>
 #include <linux/time.h>
 #include <linux/mm.h>
+#include <linux/mount.h>
 #include <linux/highuid.h>
 #include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
@@ -261,7 +262,7 @@ ncp_get_charsets(struct ncp_server* serv
 }
 #endif /* CONFIG_NCPFS_NLS */
 
-int ncp_ioctl(struct inode *inode, struct file *filp,
+static int __ncp_ioctl(struct inode *inode, struct file *filp,
 	      unsigned int cmd, unsigned long arg)
 {
 	struct ncp_server *server = NCP_SERVER(inode);
@@ -817,11 +818,63 @@ outrel:			
 				return -EFAULT;
 			return 0;
 		}
-
+	default: /* unkown IOCTL command, assume write */
+		;
 	}
 	return -EINVAL;
 }
 
+static int ncp_ioctl_need_write(unsigned int cmd)
+{
+	switch (cmd) {
+	case NCP_IOC_GET_FS_INFO:
+	case NCP_IOC_GET_FS_INFO_V2:
+	case NCP_IOC_NCPREQUEST:
+	case NCP_IOC_SETDENTRYTTL:
+	case NCP_IOC_SIGN_INIT:
+	case NCP_IOC_LOCKUNLOCK:
+	case NCP_IOC_SET_SIGN_WANTED:
+		return 1;
+	case NCP_IOC_GETOBJECTNAME:
+	case NCP_IOC_SETOBJECTNAME:
+	case NCP_IOC_GETPRIVATEDATA:
+	case NCP_IOC_SETPRIVATEDATA:
+	case NCP_IOC_SETCHARSETS:
+	case NCP_IOC_GETCHARSETS:
+	case NCP_IOC_CONN_LOGGED_IN:
+	case NCP_IOC_GETDENTRYTTL:
+	case NCP_IOC_GETMOUNTUID2:
+	case NCP_IOC_SIGN_WANTED:
+	case NCP_IOC_GETROOT:
+	case NCP_IOC_SETROOT:
+		return 0;
+	default:
+		/* unkown IOCTL command, assume write */
+	}
+	return 1;
+}
+
+int ncp_ioctl(struct inode *inode, struct file *filp,
+	      unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	if (ncp_ioctl_need_write(cmd)) {
+		/*
+		 * inside the ioctl(), any failures which
+		 * are because of file_permission() are
+		 * -EACCESS, so it seems consistent to keep
+		 *  that here.
+		 */
+		if (mnt_want_write(filp->f_vfsmnt))
+			return -EACCES;
+	}
+	ret = __ncp_ioctl(inode, filp, cmd, arg);
+	if (ncp_ioctl_need_write(cmd))
+		mnt_drop_write(filp->f_vfsmnt);
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
 long ncp_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
_
