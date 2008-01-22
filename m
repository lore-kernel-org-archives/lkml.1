Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbYAVDEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbYAVDEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbYAVDC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:02:59 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64690 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755150AbYAVDC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:02:56 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, Mingming Cao <cmm@us.ibm.com>,
       "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH 44/49] ext4: fix uniniatilized extent splitting error
Date: Mon, 21 Jan 2008 22:02:23 -0500
Message-Id: <1200970948-17903-45-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-44-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
 <1200970948-17903-22-git-send-email-tytso@mit.edu>
 <1200970948-17903-23-git-send-email-tytso@mit.edu>
 <1200970948-17903-24-git-send-email-tytso@mit.edu>
 <1200970948-17903-25-git-send-email-tytso@mit.edu>
 <1200970948-17903-26-git-send-email-tytso@mit.edu>
 <1200970948-17903-27-git-send-email-tytso@mit.edu>
 <1200970948-17903-28-git-send-email-tytso@mit.edu>
 <1200970948-17903-29-git-send-email-tytso@mit.edu>
 <1200970948-17903-30-git-send-email-tytso@mit.edu>
 <1200970948-17903-31-git-send-email-tytso@mit.edu>
 <1200970948-17903-32-git-send-email-tytso@mit.edu>
 <1200970948-17903-33-git-send-email-tytso@mit.edu>
 <1200970948-17903-34-git-send-email-tytso@mit.edu>
 <1200970948-17903-35-git-send-email-tytso@mit.edu>
 <1200970948-17903-36-git-send-email-tytso@mit.edu>
 <1200970948-17903-37-git-send-email-tytso@mit.edu>
 <1200970948-17903-38-git-send-email-tytso@mit.edu>
 <1200970948-17903-39-git-send-email-tytso@mit.edu>
 <1200970948-17903-40-git-send-email-tytso@mit.edu>
 <1200970948-17903-41-git-send-email-tytso@mit.edu>
 <1200970948-17903-42-git-send-email-tytso@mit.edu>
 <1200970948-17903-43-git-send-email-tytso@mit.edu>
 <1200970948-17903-44-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

Fix bug reported by Dmitry Monakhov caused by lost error code

    Testcase:

    blksize = 0x1000;
    fd = open(argv[1], O_RDWR|O_CREAT, 0700);
    unsigned long long sz = 0x10000000UL;
    /* allocating big blocks chunk */
    syscall(__NR_fallocate, fd, 0, 0UL, sz)

    /* grab all other available filesystem space */
    tfd = open("tmp", O_RDWR|O_CREAT|O_DIRECT, 0700);
    while( write(tfd, buf, 4096) > 0); /* loop untill ENOSPC */
    fsync(fd); /* just in case */
    while (pos < sz) {
    	/* each seek+ write operation result in splits uninitialized extent
    	in three extents. Splitting may result in new extent allocation
    	which probably will fail because of ENOSPC*/

    	lseek(fd, blksize*2 -1, SEEK_CUR);
    	if ((ret = write(fd, 'a', 1)) != 1)
    		exit(1);
    	pos += blksize * 2;
    }

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8cf5545..13e3e8c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2373,9 +2373,10 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ret = ext4_ext_convert_to_initialized(handle, inode,
 								path, iblock,
 								max_blocks);
-			if (ret <= 0)
+			if (ret <= 0) {
+				err = ret;
 				goto out2;
-			else
+			} else
 				allocated = ret;
 			goto outnew;
 		}
-- 
1.5.4.rc3.31.g1271-dirty

