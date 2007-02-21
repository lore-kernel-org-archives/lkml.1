Return-Path: <linux-kernel-owner+w=401wt.eu-S964852AbXBUB5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852AbXBUB5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964843AbXBUBvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:51:46 -0500
Received: from cantor.suse.de ([195.135.220.2]:42872 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964841AbXBUBvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:51:42 -0500
Date: Tue, 20 Feb 2007 17:50:21 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, sandeen@redhat.com,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 07/18] grow_buffers() infinite loop fix (CVE-2006-5757, CVE-2006-6060)
Message-ID: <20070221015021.GH3684@kroah.com>
References: <20070221014413.282048309@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="grow_buffers-infinite-loop-fix.patch"
In-Reply-To: <20070221014927.GA3684@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andrew Morton <akpm@osdl.org>

If grow_buffers() is for some reason passed a block number which wants to lie
outside the maximum-addressable pagecache range (PAGE_SIZE * 4G bytes) then it
will accidentally truncate `index' and will then instnatiate a page at the
wrong pagecache offset.  This causes __getblk_slow() to go into an infinite
loop.

This can happen with corrupted disks, or with software errors elsewhere.

Detect that, and handle it.

Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/buffer.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- linux-2.6.18.7.orig/fs/buffer.c
+++ linux-2.6.18.7/fs/buffer.c
@@ -1179,8 +1179,21 @@ grow_buffers(struct block_device *bdev, 
 	} while ((size << sizebits) < PAGE_SIZE);
 
 	index = block >> sizebits;
-	block = index << sizebits;
 
+	/*
+	 * Check for a block which wants to lie outside our maximum possible
+	 * pagecache index.  (this comparison is done using sector_t types).
+	 */
+	if (unlikely(index != block >> sizebits)) {
+		char b[BDEVNAME_SIZE];
+
+		printk(KERN_ERR "%s: requested out-of-range block %llu for "
+			"device %s\n",
+			__FUNCTION__, (unsigned long long)block,
+			bdevname(bdev, b));
+		return -EIO;
+	}
+	block = index << sizebits;
 	/* Create a page with the proper size buffers.. */
 	page = grow_dev_page(bdev, block, index, size);
 	if (!page)
@@ -1207,12 +1220,16 @@ __getblk_slow(struct block_device *bdev,
 
 	for (;;) {
 		struct buffer_head * bh;
+		int ret;
 
 		bh = __find_get_block(bdev, block, size);
 		if (bh)
 			return bh;
 
-		if (!grow_buffers(bdev, block, size))
+		ret = grow_buffers(bdev, block, size);
+		if (ret < 0)
+			return NULL;
+		if (ret == 0)
 			free_more_memory();
 	}
 }

--
