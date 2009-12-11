Return-Path: <linux-kernel-owner+w=401wt.eu-S1762474AbZLKEkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762474AbZLKEkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762335AbZLKEhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:37:08 -0500
Received: from kroah.org ([198.145.64.141]:36945 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760847AbZLKEgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:18 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:01 2009
Message-Id: <20091211042800.901979632@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [51/90] ext4: retry failed direct IO allocations
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0051-ext4-retry-failed-direct-IO-allocations.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit fbbf69456619de5d251cb9f1df609069178c62d5)

On a 256M filesystem, doing this in a loop:

        xfs_io -F -f -d -c 'pwrite 0 64m' test
        rm -f test

eventually leads to ENOSPC.  (the xfs_io command does a
64m direct IO write to the file "test")

As with other block allocation callers, it looks like we need to
potentially retry the allocations on the initial ENOSPC.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3372,6 +3372,7 @@ static ssize_t ext4_ind_direct_IO(int rw
 	ssize_t ret;
 	int orphan = 0;
 	size_t count = iov_length(iov, nr_segs);
+	int retries = 0;
 
 	if (rw == WRITE) {
 		loff_t final_size = offset + count;
@@ -3394,9 +3395,12 @@ static ssize_t ext4_ind_direct_IO(int rw
 		}
 	}
 
+retry:
 	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
 				 ext4_get_block, NULL);
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+		goto retry;
 
 	if (orphan) {
 		int err;


