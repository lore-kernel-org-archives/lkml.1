Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbZENWnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbZENWnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbZENWmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:00 -0400
Received: from kroah.org ([198.145.64.141]:51454 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023AbZENWl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:41:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:21 2009
Message-Id: <20090514223520.984425367@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:32:40 -0700
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
       alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [patch 05/51] md: fix loading of out-of-date bitmap.
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=md-fix-loading-of-out-of-date-bitmap.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit b74fd2826c5acce20e6f691437b2d19372bc2057 upstream.

When md is loading a bitmap which it knows is out of date, it fills
each page with 1s and writes it back out again.  However the
write_page call makes used of bitmap->file_pages and
bitmap->last_page_size which haven't been set correctly yet.  So this
can sometimes fail.

Move the setting of file_pages and last_page_size to before the call
to write_page.

This bug can cause the assembly on an array to fail, thus making the
data inaccessible.  Hence I think it is a suitable candidate for
-stable.

Reported-by: Vojtech Pavlik <vojtech@suse.cz>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/bitmap.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -985,6 +985,9 @@ static int bitmap_init_from_disk(struct 
 			oldindex = index;
 			oldpage = page;
 
+			bitmap->filemap[bitmap->file_pages++] = page;
+			bitmap->last_page_size = count;
+
 			if (outofdate) {
 				/*
 				 * if bitmap is out of date, dirty the
@@ -997,15 +1000,9 @@ static int bitmap_init_from_disk(struct 
 				write_page(bitmap, page, 1);
 
 				ret = -EIO;
-				if (bitmap->flags & BITMAP_WRITE_ERROR) {
-					/* release, page not in filemap yet */
-					put_page(page);
+				if (bitmap->flags & BITMAP_WRITE_ERROR)
 					goto err;
-				}
 			}
-
-			bitmap->filemap[bitmap->file_pages++] = page;
-			bitmap->last_page_size = count;
 		}
 		paddr = kmap_atomic(page, KM_USER0);
 		if (bitmap->flags & BITMAP_HOSTENDIAN)


