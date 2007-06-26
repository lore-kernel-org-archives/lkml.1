Return-Path: <linux-kernel-owner+w=401wt.eu-S1762588AbXFZXaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762588AbXFZXaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760862AbXFZXQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:16:49 -0400
Received: from ns2.suse.de ([195.135.220.15]:54363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760481AbXFZXQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:16:35 -0400
Message-Id: <20070626231552.962599112@suse.de>
References: <20070626231510.883881222@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:15:14 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [RFD 4/4] Pass nameidata2 to permission() from nfsd_permission()
Content-Disposition: inline; filename=nfsd_permission-nameidata.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Construct a nameidata object and pass it down to permission(), so
that we can do the proper mount flag checks there.

Note that confining nfsd with AppArmor makes no sense, and so this
patch is not necessary for AppArmor alone.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/nfsd/vfs.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1804,6 +1804,7 @@ nfsd_statfs(struct svc_rqst *rqstp, stru
 __be32
 nfsd_permission(struct svc_export *exp, struct dentry *dentry, int acc)
 {
+	struct nameidata2 nd;
 	struct inode	*inode = dentry->d_inode;
 	int		err;
 
@@ -1869,12 +1870,16 @@ nfsd_permission(struct svc_export *exp, 
 	    inode->i_uid == current->fsuid)
 		return 0;
 
-	err = permission(inode, acc & (MAY_READ|MAY_WRITE|MAY_EXEC), NULL);
+	nd.dentry = dentry;
+	nd.mnt = exp->ex_mnt;
+	nd.flags = LOOKUP_ACCESS;
+
+	err = permission(inode, acc & (MAY_READ|MAY_WRITE|MAY_EXEC), &nd);
 
 	/* Allow read access to binaries even when mode 111 */
 	if (err == -EACCES && S_ISREG(inode->i_mode) &&
 	    acc == (MAY_READ | MAY_OWNER_OVERRIDE))
-		err = permission(inode, MAY_EXEC, NULL);
+		err = permission(inode, MAY_EXEC, &nd);
 
 	return err? nfserrno(err) : 0;
 }

-- 
