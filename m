Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbXI0NXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbXI0NXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 09:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbXI0NXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 09:23:33 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41370 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752599AbXI0NXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 09:23:32 -0400
Date: Thu, 27 Sep 2007 14:29:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fs: Correct SuS compliance for open of large file without
 options
Message-ID: <20070927142919.10b62f9b@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The early LFS work that Linux uses favours EFBIG in various places. SuSv3
specifically uses EOVERFLOW for this as noted by Michael (Bug 7253)

--

[EOVERFLOW]
    The named file is a regular file and the size of the file cannot be
represented correctly in an object of type off_t. We should therefore
transition to the proper error return code

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.23rc8-mm1/fs/gfs2/ops_file.c linux-2.6.23rc8-mm1/fs/gfs2/ops_file.c
--- linux.vanilla-2.6.23rc8-mm1/fs/gfs2/ops_file.c	2007-09-26 16:46:54.000000000 +0100
+++ linux-2.6.23rc8-mm1/fs/gfs2/ops_file.c	2007-09-27 13:45:48.000000000 +0100
@@ -406,7 +406,7 @@
 
 		if (!(file->f_flags & O_LARGEFILE) &&
 		    ip->i_di.di_size > MAX_NON_LFS) {
-			error = -EFBIG;
+			error = -EOVERFLOW;
 			goto fail_gunlock;
 		}
 
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.23rc8-mm1/fs/ntfs/file.c linux-2.6.23rc8-mm1/fs/ntfs/file.c
--- linux.vanilla-2.6.23rc8-mm1/fs/ntfs/file.c	2007-09-26 16:46:55.000000000 +0100
+++ linux-2.6.23rc8-mm1/fs/ntfs/file.c	2007-09-27 13:47:35.000000000 +0100
@@ -61,7 +61,7 @@
 {
 	if (sizeof(unsigned long) < 8) {
 		if (i_size_read(vi) > MAX_LFS_FILESIZE)
-			return -EFBIG;
+			return -EOVERFLOW;
 	}
 	return generic_file_open(vi, filp);
 }
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.23rc8-mm1/fs/open.c linux-2.6.23rc8-mm1/fs/open.c
--- linux.vanilla-2.6.23rc8-mm1/fs/open.c	2007-09-26 16:46:55.000000000 +0100
+++ linux-2.6.23rc8-mm1/fs/open.c	2007-09-27 13:45:10.000000000 +0100
@@ -1210,7 +1210,7 @@
 int generic_file_open(struct inode * inode, struct file * filp)
 {
 	if (!(filp->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
-		return -EFBIG;
+		return -EOVERFLOW;
 	return 0;
 }
 

