Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZEEXfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZEEXfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZEEXfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:35:22 -0400
Received: from mail.fieldses.org ([141.211.133.115]:38062 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbZEEXfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:35:21 -0400
Date: Tue, 5 May 2009 19:35:09 -0400
To: hooanon05@yahoo.co.jp
Cc: David Woodhouse <dwmw2@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Fix i_mutex handling in nfsd readdir
Message-ID: <20090505233509.GG27790@fieldses.org>
References: <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org> <1240144069.3589.156.camel@macbook.infradead.org> <7321.1240375306@jrobl> <20090422191244.GD9541@fieldses.org> <9180.1240468823@jrobl> <20090423202705.GA31085@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423202705.GA31085@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 04:27:05PM -0400, bfields wrote:
> On Thu, Apr 23, 2009 at 03:40:23PM +0900, hooanon05@yahoo.co.jp wrote:
> > 
> > "J. Bruce Fields":
> > > > Isn't it better to test it BEFORE fh_compose()?
> > 	:::
> > > Yes, I think you're right.
> > 
> > Then here you are.
> 
> The nfsv4 readdir callback needs a similar fix.
> 
> Also, it looks to me like this results in us encoding an entry for this
> deleted file in the readdir reply, but with an empty filehandle.  From a
> quick glance at the rfc it's not clear to me whether this is really
> legal.  I suspect it may cause odd behavior on clients.  At the least it
> would seem cleaner to check for this condition early enough that we can
> just skip the entry entirely.

Err, no, I was confused, the v3 spec does clearly state that the
filehandle field here is just an optional optimization.

But now that I look fh_compose() seems perfectly capable of dealing with
negative dentries, so I don't think your patch is necessary after all.

In the v4 case it looks like we actually have to return an error (if
only in the special rdattr_error attribute defined for this case), and
it seems to me that a client might legimately be unhappy with a server
returning a readdir entry with the rdattr_error set to -ENOENT.  So I
think we need something like the following for v4.--b.

commit 97a452f918403493309357146af3d8d8360be970
Author: J. Bruce Fields <bfields@citi.umich.edu>
Date:   Tue May 5 19:04:29 2009 -0400

    nfsd4: check for negative dentry before use in nfsv4 readdir
    
    After 2f9092e1020246168b1309b35e085ecd7ff9ff72 "Fix i_mutex vs.  readdir
    handling in nfsd" (and 14f7dd63 "Copy XFS readdir hack into nfsd code"),
    an entry may be removed between the first mutex_unlock and the second
    mutex_lock. In this case, lookup_one_len() will return a negative
    dentry.  Check for this case to avoid a NULL dereference.
    
    Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
    Cc: stable@kernel.org

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index b820c31..fe91427 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2204,14 +2204,12 @@ static inline int attributes_need_mount(u32 *bmval)
 
 static __be32
 nfsd4_encode_dirent_fattr(struct nfsd4_readdir *cd,
-		const char *name, int namlen, __be32 *p, int *buflen)
+		struct dentry *dentry, __be32 *p, int *buflen)
 {
 	struct svc_export *exp = cd->rd_fhp->fh_export;
-	struct dentry *dentry;
 	__be32 nfserr;
 	int ignore_crossmnt = 0;
 
-	dentry = lookup_one_len(name, cd->rd_fhp->fh_dentry, namlen);
 	if (IS_ERR(dentry))
 		return nfserrno(PTR_ERR(dentry));
 
@@ -2274,6 +2272,7 @@ nfsd4_encode_dirent(void *ccdv, const char *name, int namlen,
 {
 	struct readdir_cd *ccd = ccdv;
 	struct nfsd4_readdir *cd = container_of(ccd, struct nfsd4_readdir, common);
+	struct dentry *dentry;
 	int buflen;
 	__be32 *p = cd->buffer;
 	__be32 nfserr = nfserr_toosmall;
@@ -2283,20 +2282,32 @@ nfsd4_encode_dirent(void *ccdv, const char *name, int namlen,
 		cd->common.err = nfs_ok;
 		return 0;
 	}
+	dentry = lookup_one_len(name, cd->rd_fhp->fh_dentry, namlen);
+	/* Whoops, it vanished after we dropped the i_sem: */
+	if (!IS_ERR(dentry) && !dentry->d_inode)
+		return 0;
+	/*
+	 * (Note that nfsd4_encode_dirent_fattr() checks for other
+	 * lookup errors below, allowing us to return them in the
+	 * RDATTR_ERROR attribute instead of failing the whole readdir.
+	 */
 
 	if (cd->offset)
 		xdr_encode_hyper(cd->offset, (u64) offset);
 
 	buflen = cd->buflen - 4 - XDR_QUADLEN(namlen);
-	if (buflen < 0)
+	if (buflen < 0) {
+		dput(dentry);
 		goto fail;
+	}
 
 	*p++ = xdr_one;                             /* mark entry present */
 	cd->offset = p;                             /* remember pointer */
 	p = xdr_encode_hyper(p, NFS_OFFSET_MAX);    /* offset of next entry */
 	p = xdr_encode_array(p, name, namlen);      /* name length & name */
 
-	nfserr = nfsd4_encode_dirent_fattr(cd, name, namlen, p, &buflen);
+	/* This consumes a reference to dentry: */
+	nfserr = nfsd4_encode_dirent_fattr(cd, dentry, p, &buflen);
 	switch (nfserr) {
 	case nfs_ok:
 		p += buflen;
