Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbXBIXBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbXBIXBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbXBIXAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:00:23 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:44257 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423351AbXBIWxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:53:36 -0500
Subject: [PATCH 06/22] elevate write count during entire ncp_ioctl()
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, hch@infradead.org, Dave Hansen <hansendc@us.ibm.com>
From: Dave Hansen <hansendc@us.ibm.com>
Date: Fri, 09 Feb 2007 14:53:33 -0800
References: <20070209225329.27619A62@localhost.localdomain>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
Message-Id: <20070209225333.CFB0FE05@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Some ioctls need write access, but others don't.  Make a helper
function to decide when write access is needed, and take it.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/ncpfs/ioctl.c |   55 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff -puN fs/ncpfs/ioctl.c~08-24-elevate-write-count-during-entire-ncp-ioctl fs/ncpfs/ioctl.c
--- lxc/fs/ncpfs/ioctl.c~08-24-elevate-write-count-during-entire-ncp-ioctl	2007-02-09 14:26:50.000000000 -0800
+++ lxc-dave/fs/ncpfs/ioctl.c	2007-02-09 14:26:50.000000000 -0800
@@ -14,6 +14,7 @@
 #include <linux/ioctl.h>
 #include <linux/time.h>
 #include <linux/mm.h>
+#include <linux/mount.h>
 #include <linux/highuid.h>
 #include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
@@ -260,7 +261,7 @@ ncp_get_charsets(struct ncp_server* serv
 }
 #endif /* CONFIG_NCPFS_NLS */
 
-int ncp_ioctl(struct inode *inode, struct file *filp,
+static int __ncp_ioctl(struct inode *inode, struct file *filp,
 	      unsigned int cmd, unsigned long arg)
 {
 	struct ncp_server *server = NCP_SERVER(inode);
@@ -821,6 +822,58 @@ outrel:			
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
+		WARN_ON(1);
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
