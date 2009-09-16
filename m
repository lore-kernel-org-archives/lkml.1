Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbZIPWTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbZIPWTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbZIPWTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:19:30 -0400
Received: from kroah.org ([198.145.64.141]:49814 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251AbZIPWSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:18:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:15:07 2009
Message-Id: <20090916221506.929363993@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:13:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       David Shaw <dshaw@jabberwocky.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [patch 09/10] Short write in nfsd becomes a full write to the client
References: <20090916221320.283781925@mini.kroah.org>
Content-Disposition: inline; filename=short-write-in-nfsd-becomes-a-full-write-to-the-client.patch
In-Reply-To: <20090916221529.GA28162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Shaw <dshaw@jabberwocky.com>

commit 31dec2538e45e9fff2007ea1f4c6bae9f78db724 upstream.

Short write in nfsd becomes a full write to the client

If a filesystem being written to via NFS returns a short write count
(as opposed to an error) to nfsd, nfsd treats that as a success for
the entire write, rather than the short count that actually succeeded.

For example, given a 8192 byte write, if the underlying filesystem
only writes 4096 bytes, nfsd will ack back to the nfs client that all
8192 bytes were written.  The nfs client does have retry logic for
short writes, but this is never called as the client is told the
complete write succeeded.

There are probably other ways it could happen, but in my case it
happened with a fuse (filesystem in userspace) filesystem which can
rather easily have a partial write.

Here is a patch to properly return the short write count to the
client.

Signed-off-by: David Shaw <dshaw@jabberwocky.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs3proc.c        |    5 +++--
 fs/nfsd/nfs4proc.c        |    7 +++++--
 fs/nfsd/nfsproc.c         |    3 ++-
 fs/nfsd/vfs.c             |   13 +++++++------
 include/linux/nfsd/nfsd.h |    2 +-
 5 files changed, 18 insertions(+), 12 deletions(-)

--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -201,6 +201,7 @@ nfsd3_proc_write(struct svc_rqst *rqstp,
 					 struct nfsd3_writeres  *resp)
 {
 	__be32	nfserr;
+	unsigned long cnt = argp->len;
 
 	dprintk("nfsd: WRITE(3)    %s %d bytes at %ld%s\n",
 				SVCFH_fmt(&argp->fh),
@@ -213,9 +214,9 @@ nfsd3_proc_write(struct svc_rqst *rqstp,
 	nfserr = nfsd_write(rqstp, &resp->fh, NULL,
 				   argp->offset,
 				   rqstp->rq_vec, argp->vlen,
-				   argp->len,
+				   &cnt,
 				   &resp->committed);
-	resp->count = argp->count;
+	resp->count = cnt;
 	RETURN_STATUS(nfserr);
 }
 
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -685,6 +685,7 @@ nfsd4_write(struct svc_rqst *rqstp, stru
 	struct file *filp = NULL;
 	u32 *p;
 	__be32 status = nfs_ok;
+	unsigned long cnt;
 
 	/* no need to check permission - this will be done in nfsd_write() */
 
@@ -703,7 +704,7 @@ nfsd4_write(struct svc_rqst *rqstp, stru
 		return status;
 	}
 
-	write->wr_bytes_written = write->wr_buflen;
+	cnt = write->wr_buflen;
 	write->wr_how_written = write->wr_stable_how;
 	p = (u32 *)write->wr_verifier.data;
 	*p++ = nfssvc_boot.tv_sec;
@@ -711,10 +712,12 @@ nfsd4_write(struct svc_rqst *rqstp, stru
 
 	status =  nfsd_write(rqstp, &cstate->current_fh, filp,
 			     write->wr_offset, rqstp->rq_vec, write->wr_vlen,
-			     write->wr_buflen, &write->wr_how_written);
+			     &cnt, &write->wr_how_written);
 	if (filp)
 		fput(filp);
 
+	write->wr_bytes_written = cnt;
+
 	if (status == nfserr_symlink)
 		status = nfserr_inval;
 	return status;
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -179,6 +179,7 @@ nfsd_proc_write(struct svc_rqst *rqstp, 
 {
 	__be32	nfserr;
 	int	stable = 1;
+	unsigned long cnt = argp->len;
 
 	dprintk("nfsd: WRITE    %s %d bytes at %d\n",
 		SVCFH_fmt(&argp->fh),
@@ -187,7 +188,7 @@ nfsd_proc_write(struct svc_rqst *rqstp, 
 	nfserr = nfsd_write(rqstp, fh_copy(&resp->fh, &argp->fh), NULL,
 				   argp->offset,
 				   rqstp->rq_vec, argp->vlen,
-				   argp->len,
+			           &cnt,
 				   &stable);
 	return nfsd_return_attrs(nfserr, resp);
 }
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -957,7 +957,7 @@ static void kill_suid(struct dentry *den
 static __be32
 nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 				loff_t offset, struct kvec *vec, int vlen,
-	   			unsigned long cnt, int *stablep)
+				unsigned long *cnt, int *stablep)
 {
 	struct svc_export	*exp;
 	struct dentry		*dentry;
@@ -971,7 +971,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	err = nfserr_perm;
 
 	if ((fhp->fh_export->ex_flags & NFSEXP_MSNFS) &&
-		(!lock_may_write(file->f_path.dentry->d_inode, offset, cnt)))
+		(!lock_may_write(file->f_path.dentry->d_inode, offset, *cnt)))
 		goto out;
 #endif
 
@@ -1003,7 +1003,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	host_err = vfs_writev(file, (struct iovec __user *)vec, vlen, &offset);
 	set_fs(oldfs);
 	if (host_err >= 0) {
-		nfsdstats.io_write += cnt;
+		nfsdstats.io_write += host_err;
 		fsnotify_modify(file->f_path.dentry);
 	}
 
@@ -1048,9 +1048,10 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	}
 
 	dprintk("nfsd: write complete host_err=%d\n", host_err);
-	if (host_err >= 0)
+	if (host_err >= 0) {
 		err = 0;
-	else 
+		*cnt = host_err;
+	} else
 		err = nfserrno(host_err);
 out:
 	return err;
@@ -1092,7 +1093,7 @@ out:
  */
 __be32
 nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
-		loff_t offset, struct kvec *vec, int vlen, unsigned long cnt,
+		loff_t offset, struct kvec *vec, int vlen, unsigned long *cnt,
 		int *stablep)
 {
 	__be32			err = 0;
--- a/include/linux/nfsd/nfsd.h
+++ b/include/linux/nfsd/nfsd.h
@@ -105,7 +105,7 @@ void		nfsd_close(struct file *);
 __be32 		nfsd_read(struct svc_rqst *, struct svc_fh *, struct file *,
 				loff_t, struct kvec *, int, unsigned long *);
 __be32 		nfsd_write(struct svc_rqst *, struct svc_fh *,struct file *,
-				loff_t, struct kvec *,int, unsigned long, int *);
+				loff_t, struct kvec *,int, unsigned long *, int *);
 __be32		nfsd_readlink(struct svc_rqst *, struct svc_fh *,
 				char *, int *);
 __be32		nfsd_symlink(struct svc_rqst *, struct svc_fh *,


