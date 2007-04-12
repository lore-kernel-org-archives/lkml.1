Return-Path: <linux-kernel-owner+w=401wt.eu-S1161542AbXDLCxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161542AbXDLCxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161527AbXDLCxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:53:52 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:4941 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161537AbXDLCxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:53:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=OD19gjOjkk47pBwpJxU8pnYd391TdFPIYGkIE46d3r+pzC3vrXaPEgTabrxo12ZZ0SKsbbvaUSONA0JDLPGSOJDW3iQD4IcpsNtSimS8ekymVuMGXVRg4wKAhNZB1mulSkxBLEvFv6Hn5h97zmlo7US0BA36RZYo6daDoRdxOc4=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       David Woodhouse <dwmw2@infradead.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Anton Altaparmakov <aia21@cantab.net>,
       Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-dev@namesys.com
Date: Wed, 11 Apr 2007 19:49:38 -0700
Message-Id: <20070412024938.27380.89491.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 13/17] reiser4: remove redundant read_mapping_page error checks
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

read_mapping_page() is now fully synchronous, so there's no need wait for
the page lock or check for I/O errors.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiser4/plugin/file/tail_conversion.c linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/file/tail_conversion.c
--- linux-2.6.21-rc6-mm1/fs/reiser4/plugin/file/tail_conversion.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/file/tail_conversion.c	2007-04-10 21:33:47.000000000 -0700
@@ -608,14 +608,6 @@ int extent2tail(unix_file_info_t *uf_inf
 			break;
 		}
 
-		wait_on_page_locked(page);
-
-		if (!PageUptodate(page)) {
-			page_cache_release(page);
-			result = RETERR(-EIO);
-			break;
-		}
-
 		/* cut part of file we have read */
 		start_byte = (__u64) (i << PAGE_CACHE_SHIFT);
 		set_key_offset(&from, start_byte);
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/extent_file_ops.c linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/extent_file_ops.c
--- linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/extent_file_ops.c	2007-04-10 19:41:14.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/extent_file_ops.c	2007-04-10 21:38:41.000000000 -0700
@@ -1220,15 +1220,8 @@ int reiser4_read_extent(struct file *fil
 		page = read_mapping_page(mapping, cur_page, file);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
-		lock_page(page);
-		if (!PageUptodate(page)) {
-			unlock_page(page);
-			page_cache_release(page);
-			warning("jmacd-97178", "extent_read: page is not up to date");
-			return RETERR(-EIO);
-		}
+
 		mark_page_accessed(page);
-		unlock_page(page);
 
 		/* If users can be writing to this page using arbitrary virtual
 		   addresses, take care about potential aliasing before reading
