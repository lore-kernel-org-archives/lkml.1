Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbYCRAoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbYCRAoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 20:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYCRAo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 20:44:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:42863 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYCRAoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 20:44:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=aW46kTRl+/7aWksQDUeFpaaWxW4WIjZ4OFFlgtsjqfVd11BDThXzP6JOz/Lo+29rKIgDpAdg/gOGsHc4Acpe2MIHjKoT5ydvBIc7Aa2PRXxCcJ7AElPLlbQbjDNCYetLu8V9CuUAYRI96DZiCv+cQNaWtvDpWNwRFNUHYsKPBQs=
Date: Tue, 18 Mar 2008 08:50:16 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jack@suse.cz, chris@linuxinfotag.de
Subject: [PATCH] ZISOFS : readpage over i_size fix
Message-ID: <20080318005016.GA2776@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read request over i_size will be dealed in do_generic_file_read.
So we just return 0 to avoid getting -EIO as normal reading,
let do_generic_file_read do the rest.

At the same time we need unlock the page to avoid system stuck.

For the bug report please see
http://bugzilla.kernel.org/show_bug.cgi?id=10227

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>

---
fs/isofs/compress.c |   10 ++++++++++
1 file changed, 10 insertions(+)

diff -upr linux/fs/isofs/compress.c linux.new/fs/isofs/compress.c
--- linux/fs/isofs/compress.c	2008-03-17 18:07:44.000000000 +0800
+++ linux.new/fs/isofs/compress.c	2008-03-17 18:13:14.000000000 +0800
@@ -72,6 +72,16 @@ static int zisofs_readpage(struct file *
 	offset = index & ~zisofs_block_page_mask;
 	blockindex = offset >> zisofs_block_page_shift;
 	maxpage = (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+
+	/* Here the outsize request we just return 0 because
+	do_generic_file_read will handle this for us */
+
+	if (page->index >= maxpage) {
+		SetPageUptodate(page);
+		unlock_page(page);
+		return 0;
+	}
+
 	maxpage = min(zisofs_block_pages, maxpage-offset);
 
 	for ( i = 0 ; i < maxpage ; i++, offset++ ) {
