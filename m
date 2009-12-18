Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbZLRTgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbZLRTgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbZLRTgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:36:20 -0500
Received: from kroah.org ([198.145.64.141]:47410 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbZLRTgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:36:18 -0500
Subject: patch staging-ramzswap-remove-arm-specific-d-cache-hack.patch added to gregkh-2.6 tree
To: ngupta@vflare.org, akpm@linux-foundation.org, gregkh@suse.de,
       greg@kroah.com, linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi
From: <gregkh@suse.de>
Date: Fri, 18 Dec 2009 11:33:47 -0800
In-Reply-To: <1260598486-12623-1-git-send-email-ngupta@vflare.org>
Message-ID: <1261164827658@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: ramzswap: remove ARM specific d-cache hack

to my gregkh-2.6 tree.  Its filename is

    staging-ramzswap-remove-arm-specific-d-cache-hack.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From ngupta@vflare.org  Fri Dec 18 10:22:00 2009
From: Nitin Gupta <ngupta@vflare.org>
Date: Sat, 12 Dec 2009 11:44:46 +0530
Subject: Staging: ramzswap: remove ARM specific d-cache hack
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1260598486-12623-1-git-send-email-ngupta@vflare.org>


Remove d-cache hack in ramzswap driver that was needed
to workaround a bug in ARM version of update_mmu_cache()
which caused stale data in d-cache to be transferred to
userspace. This bug was fixed by git commit:
	787b2faadc4356b6c2c71feb42fb944fece9a12f
This also brings down one entry in TODO file.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/ramzswap/TODO           |    1 -
 drivers/staging/ramzswap/ramzswap_drv.c |   28 +++-------------------------
 2 files changed, 3 insertions(+), 26 deletions(-)

--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -222,28 +222,6 @@ out:
 	return ret;
 }
 
-static void ramzswap_flush_dcache_page(struct page *page)
-{
-#ifdef CONFIG_ARM
-	int flag = 0;
-	/*
-	 * Ugly hack to get flush_dcache_page() work on ARM.
-	 * page_mapping(page) == NULL after clearing this swap cache flag.
-	 * Without clearing this flag, flush_dcache_page() will simply set
-	 * "PG_dcache_dirty" bit and return.
-	 */
-	if (PageSwapCache(page)) {
-		flag = 1;
-		ClearPageSwapCache(page);
-	}
-#endif
-	flush_dcache_page(page);
-#ifdef CONFIG_ARM
-	if (flag)
-		SetPageSwapCache(page);
-#endif
-}
-
 void ramzswap_ioctl_get_stats(struct ramzswap *rzs,
 			struct ramzswap_ioctl_stats *s)
 {
@@ -655,7 +633,7 @@ static int handle_zero_page(struct bio *
 	memset(user_mem, 0, PAGE_SIZE);
 	kunmap_atomic(user_mem, KM_USER0);
 
-	ramzswap_flush_dcache_page(page);
+	flush_dcache_page(page);
 
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
 	bio_endio(bio, 0);
@@ -679,7 +657,7 @@ static int handle_uncompressed_page(stru
 	kunmap_atomic(user_mem, KM_USER0);
 	kunmap_atomic(cmem, KM_USER1);
 
-	ramzswap_flush_dcache_page(page);
+	flush_dcache_page(page);
 
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
 	bio_endio(bio, 0);
@@ -779,7 +757,7 @@ static int ramzswap_read(struct ramzswap
 		goto out;
 	}
 
-	ramzswap_flush_dcache_page(page);
+	flush_dcache_page(page);
 
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
 	bio_endio(bio, 0);
--- a/drivers/staging/ramzswap/TODO
+++ b/drivers/staging/ramzswap/TODO
@@ -1,6 +1,5 @@
 TODO:
 	- Add support for swap notifiers
-	- Remove CONFIG_ARM hack
 
 Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
 Nitin Gupta <ngupta@vflare.org>

