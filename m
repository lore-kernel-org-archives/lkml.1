Return-Path: <linux-kernel-owner+w=401wt.eu-S1762352AbZLKElM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762352AbZLKElM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762326AbZLKEhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:37:07 -0500
Received: from kroah.org ([198.145.64.141]:36934 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760802AbZLKEgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:16 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:00 2009
Message-Id: <20091211042759.784398525@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [49/90] ext4: Fix time encoding with extra epoch bits
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0049-ext4-Fix-time-encoding-with-extra-epoch-bits.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit c1fccc0696bcaff6008c11865091f5ec4b0937ab)

"Looking at ext4.h, I think the setting of extra time fields forgets to
mask the epoch bits so the epoch part overwrites nsec part. The second
change is only for coherency (2 -> EXT4_EPOCH_BITS)."

Thanks to Damien Guibouret for pointing out this problem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ext4.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -522,8 +522,8 @@ struct move_extent {
 static inline __le32 ext4_encode_extra_time(struct timespec *time)
 {
        return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
-			   time->tv_sec >> 32 : 0) |
-			   ((time->tv_nsec << 2) & EXT4_NSEC_MASK));
+			   (time->tv_sec >> 32) & EXT4_EPOCH_MASK : 0) |
+                          ((time->tv_nsec << EXT4_EPOCH_BITS) & EXT4_NSEC_MASK));
 }
 
 static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
@@ -531,7 +531,7 @@ static inline void ext4_decode_extra_tim
        if (sizeof(time->tv_sec) > 4)
 	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
 			       << 32;
-       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> 2;
+       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
 }
 
 #define EXT4_INODE_SET_XTIME(xtime, inode, raw_inode)			       \


