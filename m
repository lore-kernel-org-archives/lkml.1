Return-Path: <linux-kernel-owner+w=401wt.eu-S1764197AbYCUXHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764197AbYCUXHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757845AbYCUWv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:51:26 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59421 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763827AbYCUWvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:51:23 -0400
Message-Id: <20080321224450.534958863@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:59 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Young <hidave.darkstar@gmail.com>, Jan Kara <jack@suse.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 69/76] zisofs: fix readpage() outside i_size
Content-Disposition: inline; filename=zisofs-fix-readpage-outside-i_size.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dave Young <hidave.darkstar@gmail.com>

A read request outside i_size will be handled in do_generic_file_read().  So
we just return 0 to avoid getting -EIO as normal reading, let
do_generic_file_read do the rest.

At the same time we need unlock the page to avoid system stuck.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=10227

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Report-by: Christian Perle <chris@linuxinfotag.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/isofs/compress.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -72,6 +72,17 @@ static int zisofs_readpage(struct file *
 	offset = index & ~zisofs_block_page_mask;
 	blockindex = offset >> zisofs_block_page_shift;
 	maxpage = (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+
+	/*
+	 * If this page is wholly outside i_size we just return zero;
+	 * do_generic_file_read() will handle this for us
+	 */
+	if (page->index >= maxpage) {
+		SetPageUptodate(page);
+		unlock_page(page);
+		return 0;
+	}
+
 	maxpage = min(zisofs_block_pages, maxpage-offset);
 
 	for ( i = 0 ; i < maxpage ; i++, offset++ ) {

-- 
