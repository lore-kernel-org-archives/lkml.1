Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472Ab0A3JyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0A3JyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 04:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315Ab0A3Jx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 04:53:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:46174 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab0A3Jx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 04:53:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,373,1262592000"; 
   d="scan'208";a="768609414"
Message-Id: <20100130094958.141191239@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 30 Jan 2010 17:45:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Al Viro <viro@ZenIV.linux.org.uk>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 5/5] devmem: dont allow seek to last page
References: <20100130094515.475881280@intel.com>
Content-Disposition: inline; filename=mem-seek-fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So as to return a uniform error -EOVERFLOW instead of a random one:

# kmem-seek 0xfffffffffffffff0
seek /dev/kmem: Device or resource busy
# kmem-seek 0xfffffffffffffff1
seek /dev/kmem: Block device required

Suggested by OGAWA Hirofumi.

CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- linux-mm.orig/drivers/char/mem.c	2010-01-30 17:41:51.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2010-01-30 17:42:29.000000000 +0800
@@ -721,16 +721,23 @@ static loff_t memory_lseek(struct file *
 
 	mutex_lock(&file->f_path.dentry->d_inode->i_mutex);
 	switch (orig) {
-		case 0:
+		case SEEK_CUR:
+			offset += file->f_pos;
+			if ((unsigned long long)offset <
+			    (unsigned long long)file->f_pos) {
+				ret = -EOVERFLOW;
+				break;
+			}
+		case SEEK_SET:
+			/* to avoid userland mistaking f_pos=-9 as -EBADF=-9 */
+			if ((unsigned long long)offset >= ~0xFFFULL) {
+				ret = -EOVERFLOW;
+				break;
+			}
 			file->f_pos = offset;
 			ret = file->f_pos;
 			force_successful_syscall_return();
 			break;
-		case 1:
-			file->f_pos += offset;
-			ret = file->f_pos;
-			force_successful_syscall_return();
-			break;
 		default:
 			ret = -EINVAL;
 	}


