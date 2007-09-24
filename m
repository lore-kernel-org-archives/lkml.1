Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbXIXNAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbXIXNAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbXIXM7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:59:53 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35551 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380AbXIXM7w (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:59:52 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Christoph Hellwig <hch@infradead.org>, Dave Hansen <haveblue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1 - 'touch' command causes Oops.
In-Reply-To: Your message of "Mon, 24 Sep 2007 13:05:08 BST."
             <20070924120508.GA15648@infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <3339.1190630150@turing-police.cc.vt.edu>
            <20070924120508.GA15648@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190638701_3721P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Sep 2007 08:58:21 -0400
Message-ID: <3982.1190638701@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190638701_3721P
Content-Type: text/plain; charset=us-ascii

On Mon, 24 Sep 2007 13:05:08 BST, Christoph Hellwig said:
> On Mon, Sep 24, 2007 at 06:35:50AM -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Mon, 24 Sep 2007 02:17:16 PDT, Andrew Morton said:
> > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
> > 
> > It lived fast, it died young, it didn't leave a pretty corpse...

(adding Dave Hansen to the cc: list, his patch added the mnt_want_write stuff)

> do_times passes an unitialized vfsmount into mnt_want_write.  Here's
> the quick fix (untested), but the right fix is to restructure the complete
> mess do_utimes is (never let a libc developer write your kernel code.. :)):

Close - it still blew up, as one reference to nd.mnt remained.  Fixed patch
is appended - system boots all the way with this applied.

--- linux-2.6.23-rc7-mm1/fs/utimes.c.dist	2007-09-24 05:57:38.000000000 -0400
+++ linux-2.6.23-rc7-mm1/fs/utimes.c	2007-09-24 08:48:34.000000000 -0400
@@ -59,6 +59,7 @@ long do_utimes(int dfd, char __user *fil
 	struct inode *inode;
 	struct iattr newattrs;
 	struct file *f = NULL;
+	struct vfsmount *mnt;
 
 	error = -EINVAL;
 	if (times && (!nsec_valid(times[0].tv_nsec) ||
@@ -79,17 +80,19 @@ long do_utimes(int dfd, char __user *fil
 		if (!f)
 			goto out;
 		dentry = f->f_path.dentry;
+		mnt = f->f_path.mnt;
 	} else {
 		error = __user_walk_fd(dfd, filename, (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW, &nd);
 		if (error)
 			goto out;
 
 		dentry = nd.dentry;
+		mnt = nd.mnt;
 	}
 
 	inode = dentry->d_inode;
 
-	error = mnt_want_write(nd.mnt);
+	error = mnt_want_write(mnt);
 	if (error)
 		goto dput_and_out;
 
@@ -135,7 +138,7 @@ long do_utimes(int dfd, char __user *fil
 	error = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 mnt_drop_write_and_out:
-	mnt_drop_write(nd.mnt);
+	mnt_drop_write(mnt);
 dput_and_out:
 	if (f)
 		fput(f);



--==_Exmh_1190638701_3721P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG97RtcC3lWbTT17ARAkiaAKDcgMiZHR1vjytRBcefkuWDP/QRxwCfS8sw
295MyySISFaN2wtHVsucdvI=
=iGug
-----END PGP SIGNATURE-----

--==_Exmh_1190638701_3721P--
