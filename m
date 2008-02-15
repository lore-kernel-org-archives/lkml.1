Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbYBOUC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbYBOUC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762691AbYBOUCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:02:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:61522 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762664AbYBOUCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:02:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OkNADSFmFQnXzuawTbaw7vVLsheft2f1viektWDtLo/2+OCoPQKUQMvIk+atn9A1ubhzv3RaJzlBi6dx40w2qhOf9arHSzDiwgWQS10/FcccthSEnYJ3ZjvK70s0bveh0mCwGCyebnPSJRvzyidVL/MwMCQJ0kv4X1VcvtCm4Tk=
Subject: [PATCH 2/3] ncpfs: fix sparse warnings in ioctl.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Petr Vandrovec <vandrove@vc.cvut.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 12:02:28 -0800
Message-Id: <1203105748.15275.35.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In both cases, these inode variables arebeing used to test the
server's root inode against NULL.  Change them to s_inode.
fs/ncpfs/ioctl.c:391:18: warning: symbol 'inode' shadows an earlier one
fs/ncpfs/ioctl.c:264:28: originally declared here
fs/ncpfs/ioctl.c:441:17: warning: symbol 'inode' shadows an earlier one
fs/ncpfs/ioctl.c:264:28: originally declared here

In this case, we are about to return anyway, just reuse result.
fs/ncpfs/ioctl.c:521:8: warning: symbol 'result' shadows an earlier one
fs/ncpfs/ioctl.c:268:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ncpfs/ioctl.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index c67b4bd..58efbe1 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -388,11 +388,11 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 				struct dentry* dentry = inode->i_sb->s_root;
 
 				if (dentry) {
-					struct inode* inode = dentry->d_inode;
+					struct inode* s_inode = dentry->d_inode;
 				
-					if (inode) {
-						sr.volNumber = NCP_FINFO(inode)->volNumber;
-						sr.dirEntNum = NCP_FINFO(inode)->dirEntNum;
+					if (s_inode) {
+						sr.volNumber = NCP_FINFO(s_inode)->volNumber;
+						sr.dirEntNum = NCP_FINFO(s_inode)->dirEntNum;
 						sr.namespace = server->name_space[sr.volNumber];
 					} else
 						DPRINTK("ncpfs: s_root->d_inode==NULL\n");
@@ -438,12 +438,12 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 			dentry = inode->i_sb->s_root;
 			server->root_setuped = 1;
 			if (dentry) {
-				struct inode* inode = dentry->d_inode;
+				struct inode* s_inode = dentry->d_inode;
 				
 				if (inode) {
-					NCP_FINFO(inode)->volNumber = vnum;
-					NCP_FINFO(inode)->dirEntNum = de;
-					NCP_FINFO(inode)->DosDirNum = dosde;
+					NCP_FINFO(s_inode)->volNumber = vnum;
+					NCP_FINFO(s_inode)->dirEntNum = de;
+					NCP_FINFO(s_inode)->DosDirNum = dosde;
 				} else
 					DPRINTK("ncpfs: s_root->d_inode==NULL\n");
 			} else
@@ -518,7 +518,6 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 		}
 		{
 			struct ncp_lock_ioctl	 rqdata;
-			int result;
 
 			if (copy_from_user(&rqdata, argp, sizeof(rqdata)))
 				return -EFAULT;
-- 
1.5.4.1.1278.gc75be


