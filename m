Return-Path: <linux-kernel-owner+w=401wt.eu-S1765032AbXFER5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765032AbXFER5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757160AbXFER5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:57:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314AbXFER5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:57:03 -0400
Date: Tue, 5 Jun 2007 13:56:59 -0400
From: Jeff Layton <jlayton@redhat.com>
To: nfsv4@linux-nfs.org, nfs@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] nfs4: on a O_EXCL OPEN make sure the SETATTR sets the
 fields holding the verifier
Message-Id: <20070605135659.8f9c2715.jlayton@redhat.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux NFS4 client simply skips over the bitmask in an O_EXCL open
call and so it doesn't bother to reset any fields that may be holding
the verifier. This patch has us save the first two words of the bitmask
(which is all the current client has #defines for). The client then
later checks this bitmask and turns on the appropriate flags in the
sattr->ia_verify field for the following SETATTR call.

This patch only currently checks to see if the server used the atime
and mtime slots for the verifier (which is what the Linux server uses
for this). I'm not sure of what other fields the server could
reasonably use, but adding checks for others should be trivial.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 8e46e3e..34ddd66 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -955,6 +955,22 @@ static struct nfs4_state *nfs4_open_delegated(struct inode *inode, int flags, st
 }
 
 /*
+ * on an EXCLUSIVE create, the server should send back a bitmask with FATTR4-*
+ * fields corresponding to attributes that were used to store the verifier.
+ * Make sure we clobber those fields in the later setattr call
+ */
+static inline void nfs4_exclusive_attrset (struct nfs4_opendata *opendata, struct iattr *sattr)
+{
+	if ((opendata->o_res.attrset[1] & FATTR4_WORD1_TIME_ACCESS) &&
+	    !(sattr->ia_valid & ATTR_ATIME_SET))
+		sattr->ia_valid |= ATTR_ATIME;
+
+	if ((opendata->o_res.attrset[1] & FATTR4_WORD1_TIME_MODIFY) &&
+	    !(sattr->ia_valid & ATTR_MTIME_SET))
+		sattr->ia_valid |= ATTR_MTIME;
+}
+
+/*
  * Returns a referenced nfs4_state
  */
 static int _nfs4_do_open(struct inode *dir, struct dentry *dentry, int flags, struct iattr *sattr, struct rpc_cred *cred, struct nfs4_state **res)
@@ -985,6 +1001,9 @@ static int _nfs4_do_open(struct inode *dir, struct dentry *dentry, int flags, st
 	if (status != 0)
 		goto err_opendata_free;
 
+	if (opendata->o_arg.open_flags & O_EXCL)
+		nfs4_exclusive_attrset(opendata, sattr);
+
 	status = -ENOMEM;
 	state = nfs4_opendata_to_nfs4_state(opendata);
 	if (state == NULL)
@@ -1787,6 +1806,7 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 		status = nfs4_do_setattr(state->inode, &fattr, sattr, state);
 		if (status == 0)
 			nfs_setattr_update_inode(state->inode, sattr);
+		nfs_refresh_inode(state->inode, &fattr);
 	}
 	if (status == 0 && nd != NULL && (nd->flags & LOOKUP_OPEN))
 		status = nfs4_intent_set_file(nd, dentry, state);
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 4eb8a59..b281c83 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3313,7 +3313,7 @@ static int decode_delegation(struct xdr_stream *xdr, struct nfs_openres *res)
 static int decode_open(struct xdr_stream *xdr, struct nfs_openres *res)
 {
         __be32 *p;
-        uint32_t bmlen;
+        uint32_t savewords, bmlen, i;
         int status;
 
         status = decode_op_hdr(xdr, OP_OPEN);
@@ -3331,7 +3331,15 @@ static int decode_open(struct xdr_stream *xdr, struct nfs_openres *res)
                 goto xdr_error;
 
         READ_BUF(bmlen << 2);
-        p += bmlen;
+
+	savewords = bmlen > NFS_OPENRES_ATTRSET_WORDS ?
+			NFS_OPENRES_ATTRSET_WORDS : bmlen;
+
+	for (i = 0; i < savewords; ++i) 
+		READ32(res->attrset[i]);
+
+	p += (bmlen - savewords);
+
 	return decode_delegation(xdr, res);
 xdr_error:
 	dprintk("%s: Bitmap too large! Length = %u\n", __FUNCTION__, bmlen);
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index f8c55e5..f050a27 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -133,6 +133,7 @@ struct nfs_openargs {
 	__u32			claim;
 };
 
+#define NFS_OPENRES_ATTRSET_WORDS	2
 struct nfs_openres {
 	nfs4_stateid            stateid;
 	struct nfs_fh           fh;
@@ -145,6 +146,7 @@ struct nfs_openres {
 	nfs4_stateid		delegation;
 	__u32			do_recall;
 	__u64			maxsize;
+	__u32			attrset[NFS_OPENRES_ATTRSET_WORDS];
 };
 
 /*
