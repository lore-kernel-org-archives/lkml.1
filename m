Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbZC3Pzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbZC3Pzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbZC3PzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:55:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:32971 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbZC3PzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:55:11 -0400
To: torvalds@linux-foundation.org
CC: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org
Subject: [git pull] fuse fix for 2.6.30 and -stable
Message-Id: <E1LoJpI-0007JN-Mc@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 30 Mar 2009 17:55:04 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

to get the following fix.

Thanks,
Miklos

---
commit 5291658d87ac1ae60418e79e7b6bad7d5f595e0c
Author: Dan Carpenter <error27@gmail.com>
Date:   Fri Mar 27 13:36:10 2009 +0300

    fuse: fix fuse_file_lseek returning with lock held
    
    This bug was found with smatch (http://repo.or.cz/w/smatch.git/).  If
    we return directly the inode->i_mutex lock doesn't get released.
    
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
    CC: stable@kernel.org
---
 fs/fuse/file.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index d9fdb7c..821d10f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1465,7 +1465,7 @@ static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
 	case SEEK_END:
 		retval = fuse_update_attributes(inode, NULL, file, NULL);
 		if (retval)
-			return retval;
+			goto exit;
 		offset += i_size_read(inode);
 		break;
 	case SEEK_CUR:
@@ -1479,6 +1479,7 @@ static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
 		}
 		retval = offset;
 	}
+exit:
 	mutex_unlock(&inode->i_mutex);
 	return retval;
 }
