Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbZA0XZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbZA0XZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZA0XZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:25:37 -0500
Received: from mail.fieldses.org ([141.211.133.115]:49139 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZA0XZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:25:36 -0500
Date: Tue, 27 Jan 2009 18:25:36 -0500
To: stable@kernel.org
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>, Marc Eshel <eshel@almaden.ibm.com>
Subject: [PATCH] nfsd: Ensure nfsv4 calls the underlying filesystem on LOCKT
Message-ID: <20090127232536.GA15170@fieldses.org>
References: <20090127232058.GC13854@fieldses.org> <20090127232304.GD13854@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127232304.GD13854@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

Since nfsv4 allows LOCKT without an open, but the ->lock() method is a
file method, we fake up a struct file in the nfsv4 code with just the
fields we need initialized.  But we forgot to initialize the file
operations, with the result that LOCKT never results in a call to the
filesystem's ->lock() method (if it exists).

We could just add that one more initialization.  But this hack of faking
up a struct file with only some fields initialized seems the kind of
thing that might cause more problems in the future.  We should either do
an open and get a real struct file, or make lock-testing an inode (not a
file) method.

This patch does the former.

Reported-by: Marc Eshel <eshel@almaden.ibm.com>
Tested-by: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 fs/nfsd/nfs4state.c |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 06b89df..e62d0e3 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2782,6 +2782,25 @@ out:
 }
 
 /*
+ * The NFSv4 spec allows a client to do a LOCKT without holding an OPEN,
+ * so we do a temporary open here just to get an open file to pass to
+ * vfs_test_lock.  (Arguably perhaps test_lock should be done with an
+ * inode operation.)
+ */
+static int nfsd_test_lock(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file_lock *lock)
+{
+	struct file *file;
+	int err;
+
+	err = nfsd_open(rqstp, fhp, S_IFREG, NFSD_MAY_READ, &file);
+	if (err)
+		return err;
+	err = vfs_test_lock(file, lock);
+	nfsd_close(file);
+	return err;
+}
+
+/*
  * LOCKT operation
  */
 __be32
@@ -2789,7 +2808,6 @@ nfsd4_lockt(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	    struct nfsd4_lockt *lockt)
 {
 	struct inode *inode;
-	struct file file;
 	struct file_lock file_lock;
 	int error;
 	__be32 status;
@@ -2847,16 +2865,8 @@ nfsd4_lockt(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
 	nfs4_transform_lock_offset(&file_lock);
 
-	/* vfs_test_lock uses the struct file _only_ to resolve the inode.
-	 * since LOCKT doesn't require an OPEN, and therefore a struct
-	 * file may not exist, pass vfs_test_lock a struct file with
-	 * only the dentry:inode set.
-	 */
-	memset(&file, 0, sizeof (struct file));
-	file.f_path.dentry = cstate->current_fh.fh_dentry;
-
 	status = nfs_ok;
-	error = vfs_test_lock(&file, &file_lock);
+	error = nfsd_test_lock(rqstp, &cstate->current_fh, &file_lock);
 	if (error) {
 		status = nfserrno(error);
 		goto out;
-- 
1.5.6.3

