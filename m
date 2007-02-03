Return-Path: <linux-kernel-owner+w=401wt.eu-S1946280AbXBCCsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946280AbXBCCsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946259AbXBCCi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:38:58 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53049 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946267AbXBCCiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:38:55 -0500
Message-Id: <20070203024320.526548000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:40 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>, Gabriel Paubert <paubert@iram.es>
Subject: [patch 36/59] knfsd: fix type mismatch with filldir_t used by nfsd.
Content-Disposition: inline; filename=knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: NeilBrown <neilb@suse.de>

nfsd defines a type 'encode_dent_fn' which is much like 'filldir_t'
except that the first pointer is 'struct readdir_cd *' rather than
'void *'.  It then casts encode_dent_fn points to 'filldir_t' as
needed.  This hides any other type mismatches between the two such as
the fact that the 'ino' arg recently changed from ino_t to u64.

So: get rid of 'encode_dent_fn', get rid of the cast of the function
type, change the first arg of various functions from 'struct readdir_cd *'
to 'void *', and live with the fact that we have a little less type
checking on the calling of these functions now.  
Less internal (to nfsd) checking offset by more external checking, which
is more important.

Thanks to Gabriel Paubert <paubert@iram.es> for discovering this and
providing an initial patch.

Signed-off-by: Gabriel Paubert <paubert@iram.es>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/nfsd/nfs3xdr.c         |    9 +++++----
 fs/nfsd/nfs4xdr.c         |    5 +++--
 fs/nfsd/nfsxdr.c          |    5 +++--
 fs/nfsd/vfs.c             |    4 ++--
 include/linux/nfsd/nfsd.h |    4 +---
 include/linux/nfsd/xdr.h  |    4 ++--
 include/linux/nfsd/xdr3.h |    8 ++++----
 7 files changed, 20 insertions(+), 19 deletions(-)

--- linux-2.6.19.2.orig/fs/nfsd/nfs3xdr.c
+++ linux-2.6.19.2/fs/nfsd/nfs3xdr.c
@@ -994,15 +994,16 @@ encode_entry(struct readdir_cd *ccd, con
 }
 
 int
-nfs3svc_encode_entry(struct readdir_cd *cd, const char *name,
-		     int namlen, loff_t offset, ino_t ino, unsigned int d_type)
+nfs3svc_encode_entry(void *cd, const char *name,
+		     int namlen, loff_t offset, u64 ino, unsigned int d_type)
 {
 	return encode_entry(cd, name, namlen, offset, ino, d_type, 0);
 }
 
 int
-nfs3svc_encode_entry_plus(struct readdir_cd *cd, const char *name,
-			  int namlen, loff_t offset, ino_t ino, unsigned int d_type)
+nfs3svc_encode_entry_plus(void *cd, const char *name,
+			  int namlen, loff_t offset, u64 ino,
+			  unsigned int d_type)
 {
 	return encode_entry(cd, name, namlen, offset, ino, d_type, 1);
 }
--- linux-2.6.19.2.orig/fs/nfsd/nfs4xdr.c
+++ linux-2.6.19.2/fs/nfsd/nfs4xdr.c
@@ -1884,9 +1884,10 @@ nfsd4_encode_rdattr_error(__be32 *p, int
 }
 
 static int
-nfsd4_encode_dirent(struct readdir_cd *ccd, const char *name, int namlen,
-		    loff_t offset, ino_t ino, unsigned int d_type)
+nfsd4_encode_dirent(void *ccdv, const char *name, int namlen,
+		    loff_t offset, u64 ino, unsigned int d_type)
 {
+	struct readdir_cd *ccd = ccdv;
 	struct nfsd4_readdir *cd = container_of(ccd, struct nfsd4_readdir, common);
 	int buflen;
 	__be32 *p = cd->buffer;
--- linux-2.6.19.2.orig/fs/nfsd/nfsxdr.c
+++ linux-2.6.19.2/fs/nfsd/nfsxdr.c
@@ -467,9 +467,10 @@ nfssvc_encode_statfsres(struct svc_rqst 
 }
 
 int
-nfssvc_encode_entry(struct readdir_cd *ccd, const char *name,
-		    int namlen, loff_t offset, ino_t ino, unsigned int d_type)
+nfssvc_encode_entry(void *ccdv, const char *name,
+		    int namlen, loff_t offset, u64 ino, unsigned int d_type)
 {
+	struct readdir_cd *ccd = ccdv;
 	struct nfsd_readdirres *cd = container_of(ccd, struct nfsd_readdirres, common);
 	__be32	*p = cd->buffer;
 	int	buflen, slen;
--- linux-2.6.19.2.orig/fs/nfsd/vfs.c
+++ linux-2.6.19.2/fs/nfsd/vfs.c
@@ -1727,7 +1727,7 @@ out:
  */
 __be32
 nfsd_readdir(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t *offsetp, 
-	     struct readdir_cd *cdp, encode_dent_fn func)
+	     struct readdir_cd *cdp, filldir_t func)
 {
 	__be32		err;
 	int 		host_err;
@@ -1752,7 +1752,7 @@ nfsd_readdir(struct svc_rqst *rqstp, str
 
 	do {
 		cdp->err = nfserr_eof; /* will be cleared on successful read */
-		host_err = vfs_readdir(file, (filldir_t) func, cdp);
+		host_err = vfs_readdir(file, func, cdp);
 	} while (host_err >=0 && cdp->err == nfs_ok);
 	if (host_err)
 		err = nfserrno(host_err);
--- linux-2.6.19.2.orig/include/linux/nfsd/nfsd.h
+++ linux-2.6.19.2/include/linux/nfsd/nfsd.h
@@ -52,8 +52,6 @@
 struct readdir_cd {
 	__be32			err;	/* 0, nfserr, or nfserr_eof */
 };
-typedef int		(*encode_dent_fn)(struct readdir_cd *, const char *,
-						int, loff_t, ino_t, unsigned int);
 typedef int (*nfsd_dirop_t)(struct inode *, struct dentry *, int, int);
 
 extern struct svc_program	nfsd_program;
@@ -117,7 +115,7 @@ __be32		nfsd_unlink(struct svc_rqst *, s
 int		nfsd_truncate(struct svc_rqst *, struct svc_fh *,
 				unsigned long size);
 __be32		nfsd_readdir(struct svc_rqst *, struct svc_fh *,
-			     loff_t *, struct readdir_cd *, encode_dent_fn);
+			     loff_t *, struct readdir_cd *, filldir_t);
 __be32		nfsd_statfs(struct svc_rqst *, struct svc_fh *,
 				struct kstatfs *);
 
--- linux-2.6.19.2.orig/include/linux/nfsd/xdr3.h
+++ linux-2.6.19.2/include/linux/nfsd/xdr3.h
@@ -331,11 +331,11 @@ int nfs3svc_release_fhandle(struct svc_r
 				struct nfsd3_attrstat *);
 int nfs3svc_release_fhandle2(struct svc_rqst *, __be32 *,
 				struct nfsd3_fhandle_pair *);
-int nfs3svc_encode_entry(struct readdir_cd *, const char *name,
-				int namlen, loff_t offset, ino_t ino,
+int nfs3svc_encode_entry(void *, const char *name,
+				int namlen, loff_t offset, u64 ino,
 				unsigned int);
-int nfs3svc_encode_entry_plus(struct readdir_cd *, const char *name,
-				int namlen, loff_t offset, ino_t ino,
+int nfs3svc_encode_entry_plus(void *, const char *name,
+				int namlen, loff_t offset, u64 ino,
 				unsigned int);
 /* Helper functions for NFSv3 ACL code */
 __be32 *nfs3svc_encode_post_op_attr(struct svc_rqst *rqstp, __be32 *p,
--- linux-2.6.19.2.orig/include/linux/nfsd/xdr.h
+++ linux-2.6.19.2/include/linux/nfsd/xdr.h
@@ -165,8 +165,8 @@ int nfssvc_encode_readres(struct svc_rqs
 int nfssvc_encode_statfsres(struct svc_rqst *, __be32 *, struct nfsd_statfsres *);
 int nfssvc_encode_readdirres(struct svc_rqst *, __be32 *, struct nfsd_readdirres *);
 
-int nfssvc_encode_entry(struct readdir_cd *, const char *name,
-				int namlen, loff_t offset, ino_t ino, unsigned int);
+int nfssvc_encode_entry(void *, const char *name,
+			int namlen, loff_t offset, u64 ino, unsigned int);
 
 int nfssvc_release_fhandle(struct svc_rqst *, __be32 *, struct nfsd_fhandle *);
 

--
