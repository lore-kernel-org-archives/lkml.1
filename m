Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0CKS2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:28:31 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:60838 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752331Ab0CKS20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:28:26 -0500
X-Greylist: delayed 2085 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2010 13:28:26 EST
Date: Thu, 11 Mar 2010 12:53:33 -0500 (EST)
From: Sachin Prabhu <sprabhu@redhat.com>
To: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
       Latchesar Ionkov <lucho@ionkov.net>
Cc: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <1691295304.288201268330013229.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <129079056.288181268330011583.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: [PATCH] v9fs: Skip check for mandatory locks when unlocking
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While investigating a bug, I came across a possible bug in v9fs. The problem is similar to the one reported for NFS by ASANO Masahiro in http://lkml.org/lkml/2005/12/21/334. 

v9fs_file_lock() will skip locks on file which has mode set to 02666. This is a problem in cases where the mode of the file is changed after a process has obtained a lock on the file. Such a lock will be skipped during unlock and the machine will end up with a BUG in locks_remove_flock().

v9fs_file_lock() should skip the check for mandatory locks when unlocking a file.

Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
diff -up linux-2.6/fs/9p/vfs_file.c.9p linux-2.6/fs/9p/vfs_file.c
--- linux-2.6/fs/9p/vfs_file.c.9p	2010-03-11 17:32:52.000000000 +0000
+++ linux-2.6/fs/9p/vfs_file.c	2010-03-11 17:33:11.000000000 +0000
@@ -114,7 +114,7 @@ static int v9fs_file_lock(struct file *f
 	P9_DPRINTK(P9_DEBUG_VFS, "filp: %p lock: %p\n", filp, fl);
 
 	/* No mandatory locks */
-	if (__mandatory_lock(inode))
+	if (__mandatory_lock(inode) && fl->fl_type != F_UNLCK)
 		return -ENOLCK;
 
 	if ((IS_SETLK(cmd) || IS_SETLKW(cmd)) && fl->fl_type != F_UNLCK) {
