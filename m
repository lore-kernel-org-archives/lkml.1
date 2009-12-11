Return-Path: <linux-kernel-owner+w=401wt.eu-S1762490AbZLKEkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762490AbZLKEkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762344AbZLKEhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:37:13 -0500
Received: from kroah.org ([198.145.64.141]:36958 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759453AbZLKEgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:19 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:02 2009
Message-Id: <20091211042802.010530397@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mingming Cao <cmm@us.ibm.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [53/90] ext4: fix ext4_ext_direct_IO()s return value after converting uninit extents
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0053-ext4-fix-ext4_ext_direct_IO-s-return-value-after-con.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 109f55651954def97fa41ee71c464d268c512ab0)

After a direct I/O request covering an uninitalized extent (i.e.,
created using the fallocate system call) or a hole in a file, ext4
will convert the uninitialized extent so it is marked as initialized
by calling ext4_convert_unwritten_extents().  This function returns
zero on success.

This return value was getting returned by ext4_direct_IO(); however
the file system's direct_IO function is supposed to return the number
of bytes read or written on a success.  By returning zero, it confused
the direct I/O code into falling back to buffered I/O unnecessarily.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/extents.c |    1 +
 fs/ext4/inode.c   |   10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3496,6 +3496,7 @@ retry:
  *
  * This function is called from the direct IO end io call back
  * function, to convert the fallocated extents after IO is completed.
+ * Returns 0 on success.
  */
 int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 				    loff_t len)
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3766,13 +3766,17 @@ static ssize_t ext4_ext_direct_IO(int rw
 		if (ret != -EIOCBQUEUED && ret <= 0 && iocb->private) {
 			ext4_free_io_end(iocb->private);
 			iocb->private = NULL;
-		} else if (ret > 0)
+		} else if (ret > 0) {
+			int err;
 			/*
 			 * for non AIO case, since the IO is already
 			 * completed, we could do the convertion right here
 			 */
-			ret = ext4_convert_unwritten_extents(inode,
-								offset, ret);
+			err = ext4_convert_unwritten_extents(inode,
+							     offset, ret);
+			if (err < 0)
+				ret = err;
+		}
 		return ret;
 	}
 


