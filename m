Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbZEFUVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbZEFUVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757638AbZEFUVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:21:00 -0400
Received: from mail.fieldses.org ([141.211.133.115]:42891 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbZEFUU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:20:59 -0400
Date: Wed, 6 May 2009 16:20:50 -0400
To: hooanon05@yahoo.co.jp
Cc: David Woodhouse <dwmw2@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Fix i_mutex handling in nfsd readdir
Message-ID: <20090506202050.GK9861@fieldses.org>
References: <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org> <1240144069.3589.156.camel@macbook.infradead.org> <7321.1240375306@jrobl> <20090422191244.GD9541@fieldses.org> <9180.1240468823@jrobl> <20090423202705.GA31085@fieldses.org> <20090505233509.GG27790@fieldses.org> <7475.1241586545@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7475.1241586545@jrobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 02:09:05PM +0900, hooanon05@yahoo.co.jp wrote:
> 
> "J. Bruce Fields":
> > On Thu, Apr 23, 2009 at 04:27:05PM -0400, bfields wrote:
> > > On Thu, Apr 23, 2009 at 03:40:23PM +0900, hooanon05@yahoo.co.jp wrote:
> > > > 
> > > > "J. Bruce Fields":
> > > > > > Isn't it better to test it BEFORE fh_compose()?
> > > > 	:::
> > > > > Yes, I think you're right.
> 	:::
> > Err, no, I was confused, the v3 spec does clearly state that the
> > filehandle field here is just an optional optimization.
> > 
> > But now that I look fh_compose() seems perfectly capable of dealing with
> > negative dentries, so I don't think your patch is necessary after all.
> 
> I agree with you.
> I just thought it is _better_ to test it BEFORE fh_compose(). I don't
> think fh_compose() would crash.

OK, got it.  The nfsd code routinely calls fh_compose() before handling
negative dentries, so I think it can be left as is.

> If you move lookup_one_len() from nfsd4_encode_dirent_fattr() to
> nfsd4_encode_dirent(), then I'd suggest you to move dput() too.

Yes, that'd be cleaner, but there's an nfsd_cross_mount() in
nfsd_cross_mnt that overwrites its local dentry variable, and that makes
this a little ugly.

> Applying your patch,
> - when we get a negative dentry, nfsd4_encode_dirent() will return
>   without dput(). Is it OK?

Whoops, no, you're right.

> - when lookup_one_len() returns an error, nfsd4_encode_dirent() may
>   crash later.

Yes, it can crash in the "goto fail" case immediately below, because we
pass the error pointer to dput().  Oops.

I wonder if it'd be simpler just to keep the loookup_one_len() in
nfsd4_encode_dirent() and just be prepared to roll back the encoding
we've already done if we find out at that point the dentry has gone
negative.  Actually, that doesn't look hard.

Thanks for looking at this!

--b.

commit b2c0cea6b1cb210e962f07047df602875564069e
Author: J. Bruce Fields <bfields@citi.umich.edu>
Date:   Tue May 5 19:04:29 2009 -0400

    nfsd4: check for negative dentry before use in nfsv4 readdir
    
    After 2f9092e1020246168b1309b35e085ecd7ff9ff72 "Fix i_mutex vs.  readdir
    handling in nfsd" (and 14f7dd63 "Copy XFS readdir hack into nfsd code"),
    an entry may be removed between the first mutex_unlock and the second
    mutex_lock. In this case, lookup_one_len() will return a negative
    dentry.  Check for this case to avoid a NULL dereference.
    
    Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
    Reviewed-by: J. R. Okajima <hooanon05@yahoo.co.jp>
    Cc: stable@kernel.org

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index b820c31..b73549d 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2214,6 +2214,15 @@ nfsd4_encode_dirent_fattr(struct nfsd4_readdir *cd,
 	dentry = lookup_one_len(name, cd->rd_fhp->fh_dentry, namlen);
 	if (IS_ERR(dentry))
 		return nfserrno(PTR_ERR(dentry));
+	if (!dentry->d_inode) {
+		/*
+		 * nfsd_buffered_readdir drops the i_mutex between
+		 * readdir and calling this callback, leaving a window
+		 * where this directory entry could have gone away.
+		 */
+		dput(dentry);
+		return nfserr_noent;
+	}
 
 	exp_get(exp);
 	/*
@@ -2276,6 +2285,7 @@ nfsd4_encode_dirent(void *ccdv, const char *name, int namlen,
 	struct nfsd4_readdir *cd = container_of(ccd, struct nfsd4_readdir, common);
 	int buflen;
 	__be32 *p = cd->buffer;
+	__be32 *cookiep;
 	__be32 nfserr = nfserr_toosmall;
 
 	/* In nfsv4, "." and ".." never make it onto the wire.. */
@@ -2292,7 +2302,7 @@ nfsd4_encode_dirent(void *ccdv, const char *name, int namlen,
 		goto fail;
 
 	*p++ = xdr_one;                             /* mark entry present */
-	cd->offset = p;                             /* remember pointer */
+	cookiep = p;
 	p = xdr_encode_hyper(p, NFS_OFFSET_MAX);    /* offset of next entry */
 	p = xdr_encode_array(p, name, namlen);      /* name length & name */
 
@@ -2306,6 +2316,8 @@ nfsd4_encode_dirent(void *ccdv, const char *name, int namlen,
 		goto fail;
 	case nfserr_dropit:
 		goto fail;
+	case nfserr_noent:
+		goto skip_entry;
 	default:
 		/*
 		 * If the client requested the RDATTR_ERROR attribute,
@@ -2324,6 +2336,8 @@ nfsd4_encode_dirent(void *ccdv, const char *name, int namlen,
 	}
 	cd->buflen -= (p - cd->buffer);
 	cd->buffer = p;
+	cd->offset = cookiep;
+skip_entry:
 	cd->common.err = nfs_ok;
 	return 0;
 fail:
