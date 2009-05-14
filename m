Return-Path: <linux-kernel-owner+w=401wt.eu-S1761210AbZENW5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761210AbZENW5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbZENWm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:56 -0400
Received: from kroah.org ([198.145.64.141]:52594 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783AbZENWm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:26 2009
Message-Id: <20090514223526.591104158@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:33:13 -0700
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
Subject: [patch 38/51] nfsd4: check for negative dentry before use in nfsv4 readdir
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=nfsd4-check-for-negative-dentry-before-use-in-nfsv4-readdir.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. Bruce Fields <bfields@citi.umich.edu>

commit b2c0cea6b1cb210e962f07047df602875564069e upstream.

After 2f9092e1020246168b1309b35e085ecd7ff9ff72 "Fix i_mutex vs.  readdir
handling in nfsd" (and 14f7dd63 "Copy XFS readdir hack into nfsd code"),
an entry may be removed between the first mutex_unlock and the second
mutex_lock. In this case, lookup_one_len() will return a negative
dentry.  Check for this case to avoid a NULL dereference.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Reviewed-by: J. R. Okajima <hooanon05@yahoo.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4xdr.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1843,6 +1843,15 @@ nfsd4_encode_dirent_fattr(struct nfsd4_r
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
@@ -1905,6 +1914,7 @@ nfsd4_encode_dirent(void *ccdv, const ch
 	struct nfsd4_readdir *cd = container_of(ccd, struct nfsd4_readdir, common);
 	int buflen;
 	__be32 *p = cd->buffer;
+	__be32 *cookiep;
 	__be32 nfserr = nfserr_toosmall;
 
 	/* In nfsv4, "." and ".." never make it onto the wire.. */
@@ -1921,7 +1931,7 @@ nfsd4_encode_dirent(void *ccdv, const ch
 		goto fail;
 
 	*p++ = xdr_one;                             /* mark entry present */
-	cd->offset = p;                             /* remember pointer */
+	cookiep = p;
 	p = xdr_encode_hyper(p, NFS_OFFSET_MAX);    /* offset of next entry */
 	p = xdr_encode_array(p, name, namlen);      /* name length & name */
 
@@ -1935,6 +1945,8 @@ nfsd4_encode_dirent(void *ccdv, const ch
 		goto fail;
 	case nfserr_dropit:
 		goto fail;
+	case nfserr_noent:
+		goto skip_entry;
 	default:
 		/*
 		 * If the client requested the RDATTR_ERROR attribute,
@@ -1953,6 +1965,8 @@ nfsd4_encode_dirent(void *ccdv, const ch
 	}
 	cd->buflen -= (p - cd->buffer);
 	cd->buffer = p;
+	cd->offset = cookiep;
+skip_entry:
 	cd->common.err = nfs_ok;
 	return 0;
 fail:


