Return-Path: <linux-kernel-owner+w=401wt.eu-S2992557AbXCBP4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992557AbXCBP4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992546AbXCBPz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:55:59 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:49711 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992549AbXCBPzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:55:25 -0500
Subject: [PATCH 6/9] mtd: Add a 'block unused' ioctl call to provide hints
	to block drivers
From: Richard Purdie <rpurdie@openedhand.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, dwmw2@infradead.org
Content-Type: text/plain
Date: Fri, 02 Mar 2007 15:54:54 +0000
Message-Id: <1172850894.11149.126.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Knowing that the data in a given block is now unused is a useful
feature that some block drivers can take advantage of, especially 
when dealing with devices like flash.

This adds an ioctl which allows such hints to be passed to the
block driver. Its shouldn't provide false positives but doesn't
have to provide the signal in all cases - its intended as a hint.

Support for the ioctl is added to the swap subsystem when the swap
header indicates such notification would be useful though an added
flags bitfield. The swaponflash driver takes advantage of this
functionality.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

---
 block/ioctl.c        |    4 ++++
 include/linux/fs.h   |    1 +
 include/linux/swap.h |    5 ++++-
 mm/swapfile.c        |    7 ++++++-
 4 files changed, 15 insertions(+), 2 deletions(-)

Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-02-28 18:16:52.000000000 +0000
+++ linux/include/linux/fs.h	2007-03-02 14:46:34.000000000 +0000
@@ -214,6 +214,7 @@ extern int dir_notify_enable;
 #define BLKTRACESTART _IO(0x12,116)
 #define BLKTRACESTOP _IO(0x12,117)
 #define BLKTRACETEARDOWN _IO(0x12,118)
+#define BLKSWAPMARKUNUSED _IOW(0x12, 1197, int)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
Index: linux/include/linux/swap.h
===================================================================
--- linux.orig/include/linux/swap.h	2007-03-02 14:35:02.000000000 +0000
+++ linux/include/linux/swap.h	2007-03-02 14:46:34.000000000 +0000
@@ -65,7 +65,9 @@ union swap_header {
 		__u32		nr_badpages;
 		unsigned char	sws_uuid[16];
 		unsigned char	sws_volume[16];
-		__u32		padding[117];
+		__u32		flags;
+#define SWAPFLAG_UNUSED_IOCTL (1 << 0)
+		__u32		padding[113];
 		__u32		badpages[1];
 	} info;
 };
@@ -119,6 +121,7 @@ enum {
 	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
 	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
 	SWP_ACTIVE	= (SWP_USED | SWP_WRITEOK),
+	SWP_UNUSED_IOCTL = (1 << 2),
 					/* add others here before... */
 	SWP_SCANNING	= (1 << 8),	/* refcount in scan_swap_map */
 };
Index: linux/mm/swapfile.c
===================================================================
--- linux.orig/mm/swapfile.c	2007-03-02 14:35:04.000000000 +0000
+++ linux/mm/swapfile.c	2007-03-02 14:46:34.000000000 +0000
@@ -284,6 +284,8 @@ static int swap_entry_free(struct swap_i
 				swap_list.next = p - swap_info;
 			nr_swap_pages++;
 			p->inuse_pages--;
+			if (p->flags & SWP_UNUSED_IOCTL)
+				blkdev_ioctl(p->swap_file->f_mapping->host, p->swap_file, BLKSWAPMARKUNUSED, offset);
 		}
 	}
 	return count;
@@ -1649,6 +1651,9 @@ asmlinkage long sys_swapon(const char __
 			goto bad_swap;
 		}
 
+		if (swap_header->info.flags & SWAPFLAG_UNUSED_IOCTL)
+			p->flags |= SWP_UNUSED_IOCTL;
+
 		error = 0;
 		memset(p->swap_map, 0, maxpages * sizeof(short));
 		for (i = 0; i < swap_header->info.nr_badpages; i++) {
@@ -1684,7 +1689,7 @@ asmlinkage long sys_swapon(const char __
 
 	mutex_lock(&swapon_mutex);
 	spin_lock(&swap_lock);
-	p->flags = SWP_ACTIVE;
+	p->flags |= SWP_ACTIVE;
 	nr_swap_pages += nr_good_pages;
 	total_swap_pages += nr_good_pages;
 
Index: linux/block/ioctl.c
===================================================================
--- linux.orig/block/ioctl.c	2007-02-28 18:16:52.000000000 +0000
+++ linux/block/ioctl.c	2007-03-02 14:46:34.000000000 +0000
@@ -274,6 +274,10 @@ int blkdev_ioctl(struct inode *inode, st
 			return -EFAULT;
 		return 0;
 	}
+	case BLKSWAPMARKUNUSED:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		return blkdev_driver_ioctl(inode, file, disk, cmd, arg);
 	}
 
 	lock_kernel();


