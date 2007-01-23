Return-Path: <linux-kernel-owner+w=401wt.eu-S965032AbXAWNRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965032AbXAWNRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 08:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965024AbXAWNRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 08:17:54 -0500
Received: from allen.werkleitz.de ([80.190.251.108]:38761 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965032AbXAWNRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 08:17:53 -0500
Date: Tue, 23 Jan 2007 14:17:30 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: user-mode-linux-devel@lists.sourceforge.net, Jeff Dike <jdike@karaya.com>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Message-ID: <20070123131730.GA9286@linuxtv.org>
References: <20070122201317.GA8594@linuxtv.org> <200701230902.30715.blaisorblade@yahoo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701230902.30715.blaisorblade@yahoo.it>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 84.190.152.70
Subject: Re: [uml-devel] [PATCH] [UML] fix mknod
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 09:02:30AM +0100, Blaisorblade wrote:
> On Monday 22 January 2007 21:13, Johannes Stezenbach wrote:
> >
> > I was playing with user-mode Linux and found that mknod creates
> > devices node in hostfs with wrong major/minor numbers.
> > The patch below fixes it for me.
> 
> Hmpf. Still having this bug on hostfs is quite bad. Thanks for reporting.
> 
> It should be hostfs_user.c to take major and minor and to combine them 
> correctly - it can use libc's macros.

Right, below is a better patch.


Thanks,
Johannes

---
Fix UML hostfs mknod(): userspace has differernt
dev_t size and encoding than kernel, so extract major/minor
and reencode using glibc makedev() macro.

Signed-off-by: Johannes Stezenbach <js@linuxtv.org>

diff -rup linux-2.6.19.orig/fs/hostfs/hostfs.h linux-2.6.19/fs/hostfs/hostfs.h
--- linux-2.6.19.orig/fs/hostfs/hostfs.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.19/fs/hostfs/hostfs.h	2007-01-23 14:11:03.000000000 +0100
@@ -76,7 +76,7 @@ extern int make_symlink(const char *from
 extern int unlink_file(const char *file);
 extern int do_mkdir(const char *file, int mode);
 extern int do_rmdir(const char *file);
-extern int do_mknod(const char *file, int mode, int dev);
+extern int do_mknod(const char *file, int mode, unsigned int major, unsigned int minor);
 extern int link_file(const char *from, const char *to);
 extern int do_readlink(char *file, char *buf, int size);
 extern int rename_file(char *from, char *to);
diff -rup linux-2.6.19.orig/fs/hostfs/hostfs_kern.c linux-2.6.19/fs/hostfs/hostfs_kern.c
--- linux-2.6.19.orig/fs/hostfs/hostfs_kern.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.19/fs/hostfs/hostfs_kern.c	2007-01-23 14:11:20.000000000 +0100
@@ -755,7 +755,7 @@ int hostfs_mknod(struct inode *dir, stru
 		goto out_put;
 
 	init_special_inode(inode, mode, dev);
-	err = do_mknod(name, mode, dev);
+	err = do_mknod(name, mode, MAJOR(dev), MINOR(dev));
 	if(err)
 		goto out_free;
 
diff -rup linux-2.6.19.orig/fs/hostfs/hostfs_user.c linux-2.6.19/fs/hostfs/hostfs_user.c
--- linux-2.6.19.orig/fs/hostfs/hostfs_user.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.19/fs/hostfs/hostfs_user.c	2007-01-23 14:11:39.000000000 +0100
@@ -295,11 +295,11 @@ int do_rmdir(const char *file)
 	return(0);
 }
 
-int do_mknod(const char *file, int mode, int dev)
+int do_mknod(const char *file, int mode, unsigned int major, unsigned int minor)
 {
 	int err;
 
-	err = mknod(file, mode, dev);
+	err = mknod(file, mode, makedev(major, minor));
 	if(err) return(-errno);
 	return(0);
 }
