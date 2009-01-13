Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbZAMBda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbZAMBda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758167AbZAMB3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:29:07 -0500
Received: from kroah.org ([198.145.64.141]:35995 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758144AbZAMB3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:29:03 -0500
Date: Mon, 12 Jan 2009 17:27:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Neil Brown <neilb@suse.de>
Subject: [patch 10/21] md: Dont read past end of bitmap when reading bitmap.
Message-ID: <20090113012709.GK4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-don-t-read-past-end-of-bitmap-when-reading-bitmap.patch"
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit a2ed9615e3222645007fc19991aedf30eed3ecfd upstream.

When we read the write-intent-bitmap off the device, we currently
read a whole number of pages.
When PAGE_SIZE is 4K, this works due to the alignment we enforce
on the superblock and bitmap.
When PAGE_SIZE is 64K, this case read past the end-of-device
which causes an error.

When we write the superblock, we ensure to clip the last page
to just be the required size.  Copy that code into the read path
to just read the required number of sectors.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/bitmap.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -208,16 +208,19 @@ static void bitmap_checkfree(struct bitm
  */
 
 /* IO operations when bitmap is stored near all superblocks */
-static struct page *read_sb_page(mddev_t *mddev, long offset, unsigned long index)
+static struct page *read_sb_page(mddev_t *mddev, long offset,
+				 struct page *page,
+				 unsigned long index, int size)
 {
 	/* choose a good rdev and read the page from there */
 
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
-	struct page *page = alloc_page(GFP_KERNEL);
 	sector_t target;
 
 	if (!page)
+		page = alloc_page(GFP_KERNEL);
+	if (!page)
 		return ERR_PTR(-ENOMEM);
 
 	rdev_for_each(rdev, tmp, mddev) {
@@ -227,7 +230,9 @@ static struct page *read_sb_page(mddev_t
 
 		target = rdev->sb_start + offset + index * (PAGE_SIZE/512);
 
-		if (sync_page_io(rdev->bdev, target, PAGE_SIZE, page, READ)) {
+		if (sync_page_io(rdev->bdev, target,
+				 roundup(size, bdev_hardsect_size(rdev->bdev)),
+				 page, READ)) {
 			page->index = index;
 			attach_page_buffers(page, NULL); /* so that free_buffer will
 							  * quietly no-op */
@@ -544,7 +549,9 @@ static int bitmap_read_sb(struct bitmap 
 
 		bitmap->sb_page = read_page(bitmap->file, 0, bitmap, bytes);
 	} else {
-		bitmap->sb_page = read_sb_page(bitmap->mddev, bitmap->offset, 0);
+		bitmap->sb_page = read_sb_page(bitmap->mddev, bitmap->offset,
+					       NULL,
+					       0, sizeof(bitmap_super_t));
 	}
 	if (IS_ERR(bitmap->sb_page)) {
 		err = PTR_ERR(bitmap->sb_page);
@@ -957,11 +964,16 @@ static int bitmap_init_from_disk(struct 
 				 */
 				page = bitmap->sb_page;
 				offset = sizeof(bitmap_super_t);
+				read_sb_page(bitmap->mddev, bitmap->offset,
+					     page,
+					     index, count);
 			} else if (file) {
 				page = read_page(file, index, bitmap, count);
 				offset = 0;
 			} else {
-				page = read_sb_page(bitmap->mddev, bitmap->offset, index);
+				page = read_sb_page(bitmap->mddev, bitmap->offset,
+						    NULL,
+						    index, count);
 				offset = 0;
 			}
 			if (IS_ERR(page)) { /* read error */

