Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0BGDoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 22:44:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:16528 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab0BGDns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 22:43:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,420,1262592000"; 
   d="scan'208";a="770770378"
Message-Id: <20100207034223.893741884@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 07 Feb 2010 11:28:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Al Viro <viro@ZenIV.linux.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Roland Dreier <rdreier@cisco.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@amd64.org>
CC: Jamie Lokier <jamie@shareable.org>
CC: Eric Paris <eparis@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] devmem: dont allow seek to last page
References: <20100207032805.769788305@intel.com>
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

--- linux.orig/drivers/char/mem.c	2010-01-15 09:11:25.000000000 +0800
+++ linux/drivers/char/mem.c	2010-01-20 09:45:55.000000000 +0800
@@ -700,16 +700,23 @@ static loff_t memory_lseek(struct file *
 
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


