Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbYH0Nx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbYH0Nx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbYH0NtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:49:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233AbYH0NtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:49:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 36/59] CRED: Wrap task credential accesses in the NCPFS
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Petr Vandrovec <vandrove@vc.cvut.cz>,
       linware@sh.cvut.cz
Date: Wed, 27 Aug 2008 14:48:48 +0100
Message-ID: <20080827134847.19980.68770.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: linware@sh.cvut.cz
---

 fs/ncpfs/ioctl.c |   91 ++++++++++++++++++++++++++----------------------------
 1 files changed, 44 insertions(+), 47 deletions(-)


diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index 3a97c95..6d04e05 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -40,10 +40,10 @@ ncp_get_fs_info(struct ncp_server * server, struct file *file,
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct ncp_fs_info info;
 
-	if ((file_permission(file, MAY_WRITE) != 0)
-	    && (current->uid != server->m.mounted_uid)) {
+	if (file_permission(file, MAY_WRITE) != 0
+	    && current_uid() != server->m.mounted_uid)
 		return -EACCES;
-	}
+
 	if (copy_from_user(&info, arg, sizeof(info)))
 		return -EFAULT;
 
@@ -70,10 +70,10 @@ ncp_get_fs_info_v2(struct ncp_server * server, struct file *file,
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct ncp_fs_info_v2 info2;
 
-	if ((file_permission(file, MAY_WRITE) != 0)
-	    && (current->uid != server->m.mounted_uid)) {
+	if (file_permission(file, MAY_WRITE) != 0
+	    && current_uid() != server->m.mounted_uid)
 		return -EACCES;
-	}
+
 	if (copy_from_user(&info2, arg, sizeof(info2)))
 		return -EFAULT;
 
@@ -141,10 +141,10 @@ ncp_get_compat_fs_info_v2(struct ncp_server * server, struct file *file,
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct compat_ncp_fs_info_v2 info2;
 
-	if ((file_permission(file, MAY_WRITE) != 0)
-	    && (current->uid != server->m.mounted_uid)) {
+	if (file_permission(file, MAY_WRITE) != 0
+	    && current_uid() != server->m.mounted_uid)
 		return -EACCES;
-	}
+
 	if (copy_from_user(&info2, arg, sizeof(info2)))
 		return -EFAULT;
 
@@ -270,16 +270,17 @@ static int __ncp_ioctl(struct inode *inode, struct file *filp,
 	struct ncp_ioctl_request request;
 	char* bouncebuffer;
 	void __user *argp = (void __user *)arg;
+	uid_t uid = current_uid();
 
 	switch (cmd) {
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_NCPREQUEST_32:
 #endif
 	case NCP_IOC_NCPREQUEST:
-		if ((file_permission(filp, MAY_WRITE) != 0)
-		    && (current->uid != server->m.mounted_uid)) {
+		if (file_permission(filp, MAY_WRITE) != 0
+		    && uid != server->m.mounted_uid)
 			return -EACCES;
-		}
+
 #ifdef CONFIG_COMPAT
 		if (cmd == NCP_IOC_NCPREQUEST_32) {
 			struct compat_ncp_ioctl_request request32;
@@ -356,10 +357,10 @@ static int __ncp_ioctl(struct inode *inode, struct file *filp,
 	case NCP_IOC_GETMOUNTUID16:
 	case NCP_IOC_GETMOUNTUID32:
 	case NCP_IOC_GETMOUNTUID64:
-		if ((file_permission(filp, MAY_READ) != 0)
-			&& (current->uid != server->m.mounted_uid)) {
+		if (file_permission(filp, MAY_READ) != 0
+			&& uid != server->m.mounted_uid)
 			return -EACCES;
-		}
+
 		if (cmd == NCP_IOC_GETMOUNTUID16) {
 			u16 uid;
 			SET_UID(uid, server->m.mounted_uid);
@@ -380,11 +381,10 @@ static int __ncp_ioctl(struct inode *inode, struct file *filp,
 		{
 			struct ncp_setroot_ioctl sr;
 
-			if ((file_permission(filp, MAY_READ) != 0)
-			    && (current->uid != server->m.mounted_uid))
-			{
+			if (file_permission(filp, MAY_READ) != 0
+			    && uid != server->m.mounted_uid)
 				return -EACCES;
-			}
+
 			if (server->m.mounted_vol[0]) {
 				struct dentry* dentry = inode->i_sb->s_root;
 
@@ -408,6 +408,7 @@ static int __ncp_ioctl(struct inode *inode, struct file *filp,
 				return -EFAULT;
 			return 0;
 		}
+
 	case NCP_IOC_SETROOT:
 		{
 			struct ncp_setroot_ioctl sr;
@@ -455,11 +456,10 @@ static int __ncp_ioctl(struct inode *inode, struct file *filp,
 
 #ifdef CONFIG_NCPFS_PACKET_SIGNING	
 	case NCP_IOC_SIGN_INIT:
-		if ((file_permission(filp, MAY_WRITE) != 0)
-		    && (current->uid != server->m.mounted_uid))
-		{
+		if (file_permission(filp, MAY_WRITE) != 0
+		    && uid != server->m.mounted_uid)
 			return -EACCES;
-		}
+
 		if (argp) {
 			if (server->sign_wanted)
 			{
@@ -478,24 +478,22 @@ static int __ncp_ioctl(struct inode *inode, struct file *filp,
 		return 0;		
 		
         case NCP_IOC_SIGN_WANTED:
-		if ((file_permission(filp, MAY_READ) != 0)
-		    && (current->uid != server->m.mounted_uid))
-		{
+		if (file_permission(filp, MAY_READ) != 0
+		    && uid != server->m.mounted_uid)
 			return -EACCES;
-		}
 		
                 if (put_user(server->sign_wanted, (int __user *)argp))
 			return -EFAULT;
                 return 0;
+
 	case NCP_IOC_SET_SIGN_WANTED:
 		{
 			int newstate;
 
-			if ((file_permission(filp, MAY_WRITE) != 0)
-			    && (current->uid != server->m.mounted_uid))
-			{
+			if (file_permission(filp, MAY_WRITE) != 0
+			    && uid != server->m.mounted_uid)
 				return -EACCES;
-			}
+
 			/* get only low 8 bits... */
 			if (get_user(newstate, (unsigned char __user *)argp))
 				return -EFAULT;
@@ -512,11 +510,10 @@ static int __ncp_ioctl(struct inode *inode, struct file *filp,
 
 #ifdef CONFIG_NCPFS_IOCTL_LOCKING
 	case NCP_IOC_LOCKUNLOCK:
-		if ((file_permission(filp, MAY_WRITE) != 0)
-		    && (current->uid != server->m.mounted_uid))
-		{
+		if (file_permission(filp, MAY_WRITE) != 0
+		    && uid != server->m.mounted_uid)
 			return -EACCES;
-		}
+
 		{
 			struct ncp_lock_ioctl	 rqdata;
 
@@ -585,9 +582,8 @@ outrel:
 
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_GETOBJECTNAME_32:
-		if (current->uid != server->m.mounted_uid) {
+		if (uid != server->m.mounted_uid)
 			return -EACCES;
-		}
 		{
 			struct compat_ncp_objectname_ioctl user;
 			size_t outl;
@@ -609,10 +605,10 @@ outrel:
 			return 0;
 		}
 #endif
+
 	case NCP_IOC_GETOBJECTNAME:
-		if (current->uid != server->m.mounted_uid) {
+		if (uid != server->m.mounted_uid)
 			return -EACCES;
-		}
 		{
 			struct ncp_objectname_ioctl user;
 			size_t outl;
@@ -633,13 +629,13 @@ outrel:
 				return -EFAULT;
 			return 0;
 		}
+
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_SETOBJECTNAME_32:
 #endif
 	case NCP_IOC_SETOBJECTNAME:
-		if (current->uid != server->m.mounted_uid) {
+		if (uid != server->m.mounted_uid)
 			return -EACCES;
-		}
 		{
 			struct ncp_objectname_ioctl user;
 			void* newname;
@@ -691,13 +687,13 @@ outrel:
 			kfree(oldname);
 			return 0;
 		}
+
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_GETPRIVATEDATA_32:
 #endif
 	case NCP_IOC_GETPRIVATEDATA:
-		if (current->uid != server->m.mounted_uid) {
+		if (uid != server->m.mounted_uid)
 			return -EACCES;
-		}
 		{
 			struct ncp_privatedata_ioctl user;
 			size_t outl;
@@ -736,13 +732,13 @@ outrel:
 
 			return 0;
 		}
+
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_SETPRIVATEDATA_32:
 #endif
 	case NCP_IOC_SETPRIVATEDATA:
-		if (current->uid != server->m.mounted_uid) {
+		if (uid != server->m.mounted_uid)
 			return -EACCES;
-		}
 		{
 			struct ncp_privatedata_ioctl user;
 			void* new;
@@ -794,9 +790,10 @@ outrel:
 #endif /* CONFIG_NCPFS_NLS */
 
 	case NCP_IOC_SETDENTRYTTL:
-		if ((file_permission(filp, MAY_WRITE) != 0) &&
-				 (current->uid != server->m.mounted_uid))
+		if (file_permission(filp, MAY_WRITE) != 0 &&
+		    uid != server->m.mounted_uid)
 			return -EACCES;
+
 		{
 			u_int32_t user;
 

