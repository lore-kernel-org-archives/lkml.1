Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbZBDS4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbZBDS4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:56:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761216AbZBDStT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:19 -0500
Received: from kroah.org ([198.145.64.141]:34387 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755007AbZBDStL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:11 -0500
Date: Wed, 4 Feb 2009 10:46:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [patch 12/41] nfsd: Ensure nfsv4 calls the underlying filesystem
	on LOCKT
Message-ID: <20090204184612.GM25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfsd-ensure-nfsv4-calls-the-underlying-filesystem-on-lockt.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. Bruce Fields <bfields@citi.umich.edu>

commit 55ef1274dddd4de387c54d110e354ffbb6cdc706 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4state.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2767,6 +2767,25 @@ out:
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
@@ -2774,7 +2793,6 @@ nfsd4_lockt(struct svc_rqst *rqstp, stru
 	    struct nfsd4_lockt *lockt)
 {
 	struct inode *inode;
-	struct file file;
 	struct file_lock file_lock;
 	int error;
 	__be32 status;
@@ -2832,16 +2850,8 @@ nfsd4_lockt(struct svc_rqst *rqstp, stru
 
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

