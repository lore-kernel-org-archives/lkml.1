Return-Path: <linux-kernel-owner+w=401wt.eu-S1762323AbXH3PHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762323AbXH3PHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbXH3PHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:07:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbXH3PHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:07:01 -0400
Date: Thu, 30 Aug 2007 11:06:48 -0400
Message-Id: <200708301506.l7UF6mRM002138@dantu.rdu.redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 2/3] NFS: ignore mode change if it's just for clearing setuid/setgid bits
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the ATTR_KILL_S*ID bits are set then any mode change is only for
clearing the setuid/setgid bits. For NFS skip the mode change and
let the server handle it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/nfs/inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 45633f9..441bd8b 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -327,6 +327,10 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	nfs_inc_stats(inode, NFSIOS_VFSSETATTR);
 
+	/* skip mode change if it's just for clearing setuid/setgid */
+	if (attr->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
+		attr->ia_valid &= ~ATTR_MODE;
+
 	if (attr->ia_valid & ATTR_SIZE) {
 		if (!S_ISREG(inode->i_mode) || attr->ia_size == i_size_read(inode))
 			attr->ia_valid &= ~ATTR_SIZE;
-- 
1.5.2.1

