Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739Ab0A1PwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab0A1PwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 10:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576Ab0A1PwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 10:52:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:51718 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab0A1PwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 10:52:15 -0500
Message-ID: <4B61B227.3050703@vflare.org>
Date: Thu, 28 Jan 2010 21:19:59 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] Handle case for invalid backing swap
References: <1264693423-2694-1-git-send-email-ngupta@vflare.org>
In-Reply-To: <1264693423-2694-1-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we crash (issue BUG_ON) if backing swap
disk size is zero. This can happen is user specified
an extended partition or simply a bad disk as backing
swap. A crash is really an unpleasant surprise to user
for such trivial problems.

Now, we check for this condition and simply fail device
initialization if this is the case.

Additional cleanups:
 * use static for all functions
 * remove extra newline between functions
 * memset backing_swap_name to NULL on device reset

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/ramzswap/ramzswap_drv.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
index 7e0a3fa..1bca069 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -220,7 +220,7 @@ out:
 	return ret;
 }

-void ramzswap_ioctl_get_stats(struct ramzswap *rzs,
+static void ramzswap_ioctl_get_stats(struct ramzswap *rzs,
 			struct ramzswap_ioctl_stats *s)
 {
 	strncpy(s->backing_swap_name, rzs->backing_swap_name,
@@ -502,6 +502,14 @@ static int setup_backing_swap(struct ramzswap *rzs)
 			goto bad_param;
 		}
 		disksize = i_size_read(inode);
+		/*
+		 * Can happen if user gives an extended partition as
+		 * backing swap or simply a bad disk.
+		 */
+		if (!disksize) {
+			pr_err("Error reading backing swap size.\n");
+			goto bad_param;
+		}
 	} else if (S_ISREG(inode->i_mode)) {
 		bdev = inode->i_sb->s_bdev;
 		if (IS_SWAPFILE(inode)) {
@@ -519,7 +527,6 @@ static int setup_backing_swap(struct ramzswap *rzs)
 	rzs->swap_file = swap_file;
 	rzs->backing_swap = bdev;
 	rzs->disksize = disksize;
-	BUG_ON(!rzs->disksize);

 	return 0;

@@ -537,7 +544,7 @@ out:
  * Map logical page number 'pagenum' to physical page number
  * on backing swap device. For block device, this is a nop.
  */
-u32 map_backing_swap_page(struct ramzswap *rzs, u32 pagenum)
+static u32 map_backing_swap_page(struct ramzswap *rzs, u32 pagenum)
 {
 	u32 skip_pages, entries_per_page;
 	size_t delta, se_offset, skipped;
@@ -668,7 +675,6 @@ static int handle_uncompressed_page(struct ramzswap *rzs, struct bio *bio)
 	return 0;
 }

-
 /*
  * Called when request page is not present in ramzswap.
  * Its either in backing swap device (if present) or
@@ -936,7 +942,6 @@ out:
 	return 0;
 }

-
 /*
  * Check if request is within bounds and page aligned.
  */
@@ -1064,6 +1069,7 @@ static void reset_device(struct ramzswap *rzs)
 			bd_release(rzs->backing_swap);
 		filp_close(rzs->swap_file, NULL);
 		rzs->backing_swap = NULL;
+		memset(rzs->backing_swap_name, 0, MAX_SWAP_NAME_LEN);
 	}

 	/* Reset stats */
--
1.6.2.5


