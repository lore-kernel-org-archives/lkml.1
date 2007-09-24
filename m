Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbXIXMF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbXIXMF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755358AbXIXMFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:05:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58139 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbXIXMFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:05:13 -0400
Date: Mon, 24 Sep 2007 13:05:08 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1 - 'touch' command causes Oops.
Message-ID: <20070924120508.GA15648@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <3339.1190630150@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3339.1190630150@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 06:35:50AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 24 Sep 2007 02:17:16 PDT, Andrew Morton said:
> 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
> 
> It lived fast, it died young, it didn't leave a pretty corpse...
> 
> Something in the startup scripts did a 'touch', and ker-blam.
> [   15.668000] Call Trace:
> [   15.668000]  [<ffffffff802a4d20>] mnt_want_write+0x49/0xb5
> [   15.668000]  [<ffffffff802ad288>] do_utimes+0xd0/0x220
> [   15.668000]  [<ffffffff8035437b>] __up_read+0x7a/0x83
> [   15.668000]  [<ffffffff8024b1af>] up_read+0x9/0xb
> [   15.668000]  [<ffffffff8051977c>] do_page_fault+0x421/0x7d0
> [   15.668000]  [<ffffffff8028b370>] do_filp_open+0x36/0x46
> [   15.668000]  [<ffffffff802ad519>] sys_utimensat+0x8b/0xa5
> [   15.668000]  [<ffffffff80517a4d>] error_exit+0x0/0x84
> [   15.668000]  [<ffffffff8020c10e>] system_call+0x7e/0x83

do_times passes an unitialized vfsmount into mnt_want_write.  Here's
the quick fix (untested), but the right fix is to restructure the complete
mess do_utimes is (never let a libc developer write your kernel code.. :)):


Index: linux-2.6.23-rc6/fs/utimes.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/utimes.c	2007-09-24 14:02:24.000000000 +0200
+++ linux-2.6.23-rc6/fs/utimes.c	2007-09-24 14:03:57.000000000 +0200
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
 


