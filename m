Return-Path: <linux-kernel-owner+w=401wt.eu-S1030476AbXBLXQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030476AbXBLXQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030478AbXBLXQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:16:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030476AbXBLXQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:16:40 -0500
Message-ID: <45D0F55E.9040101@redhat.com>
Date: Mon, 12 Feb 2007 18:16:46 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Andi Kleen <andi@firstfloor.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [patch] compat_ioctl should return -ENOTTY for some failures
Content-Type: multipart/mixed;
 boundary="------------030703040102040605090502"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030703040102040605090502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

In many cases compat_ioctl() should return -ENOTTY.

Recent changes in this area seem to be breaking some
Wine apps.  I'm not proposing this for inclusion (yet,)
I just want to know if I've hit the right places.


--------------030703040102040605090502
Content-Type: text/plain;
 name="compat_ioctl_proper_error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="compat_ioctl_proper_error.patch"

Index: 2.6.20-d390/fs/compat.c
===================================================================
--- 2.6.20-d390.orig/fs/compat.c	2007-02-12 13:24:20.000000000 -0500
+++ 2.6.20-d390/fs/compat.c	2007-02-12 16:16:08.000000000 -0500
@@ -439,15 +439,10 @@
 	}
 
 	if (S_ISSOCK(filp->f_path.dentry->d_inode->i_mode) &&
-	    cmd >= SIOCDEVPRIVATE && cmd <= (SIOCDEVPRIVATE + 15)) {
+	    cmd >= SIOCDEVPRIVATE && cmd <= (SIOCDEVPRIVATE + 15))
 		error = siocdevprivate_ioctl(fd, cmd, arg);
-	} else {
-		static int count;
-
-		if (++count <= 50)
-			compat_ioctl_error(filp, fd, cmd, arg);
-		error = -EINVAL;
-	}
+	else
+		error = -ENOTTY;
 
 	goto out_fput;
 
Index: 2.6.20-d390/fs/ioctl.c
===================================================================
--- 2.6.20-d390.orig/fs/ioctl.c	2007-02-12 13:24:20.000000000 -0500
+++ 2.6.20-d390/fs/ioctl.c	2007-02-12 16:14:29.000000000 -0500
@@ -27,7 +27,7 @@
 	if (filp->f_op->unlocked_ioctl) {
 		error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
 		if (error == -ENOIOCTLCMD)
-			error = -EINVAL;
+			error = -ENOTTY;
 		goto out;
 	} else if (filp->f_op->ioctl) {
 		lock_kernel();

--------------030703040102040605090502--
