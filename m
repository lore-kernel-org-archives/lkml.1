Return-Path: <linux-kernel-owner+w=401wt.eu-S1761690AbXLMG5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761690AbXLMG5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760600AbXLMGzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:55:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54993 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760285AbXLMGzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:55:36 -0500
Date: Wed, 12 Dec 2007 22:51:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christian Borntraeger <borntraeger@de.ibm.com>, Jan Kara <jack@suse.cz>,
       Nick Piggin <npiggin@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 04/60] rd: fix data corruption on memory pressure Future of
	Linux 2.6.22.y series
Message-ID: <20071213065112.GE6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rd-fix-data-corruption-on-memory-pressure.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 5d0360ee96a5ef953dbea45873c2a8c87e77d59b upstream.

We have seen ramdisk based install systems, where some pages of mapped
libraries and programs were suddendly zeroed under memory pressure. This
should not happen, as the ramdisk avoids freeing its pages by keeping
them dirty all the time.

It turns out that there is a case, where the VM makes a ramdisk page
clean, without telling the ramdisk driver.  On memory pressure
shrink_zone runs and it starts to run shrink_active_list.  There is a
check for buffer_heads_over_limit, and if true, pagevec_strip is called.
pagevec_strip calls try_to_release_page. If the mapping has no
releasepage callback, try_to_free_buffers is called. try_to_free_buffers
has now a special logic for some file systems to make a dirty page
clean, if all buffers are clean. Thats what happened in our test case.

The simplest solution is to provide a noop-releasepage callback for the
ramdisk driver. This avoids try_to_free_buffers for ramdisk pages.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/block/rd.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/block/rd.c
+++ b/drivers/block/rd.c
@@ -189,6 +189,18 @@ static int ramdisk_set_page_dirty(struct
 	return 0;
 }
 
+/*
+ * releasepage is called by pagevec_strip/try_to_release_page if
+ * buffers_heads_over_limit is true. Without a releasepage function
+ * try_to_free_buffers is called instead. That can unset the dirty
+ * bit of our ram disk pages, which will be eventually freed, even
+ * if the page is still in use.
+ */
+static int ramdisk_releasepage(struct page *page, gfp_t dummy)
+{
+	return 0;
+}
+
 static const struct address_space_operations ramdisk_aops = {
 	.readpage	= ramdisk_readpage,
 	.prepare_write	= ramdisk_prepare_write,
@@ -196,6 +208,7 @@ static const struct address_space_operat
 	.writepage	= ramdisk_writepage,
 	.set_page_dirty	= ramdisk_set_page_dirty,
 	.writepages	= ramdisk_writepages,
+	.releasepage	= ramdisk_releasepage,
 };
 
 static int rd_blkdev_pagecache_IO(int rw, struct bio_vec *vec, sector_t sector,

-- 
