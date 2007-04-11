Return-Path: <linux-kernel-owner+w=401wt.eu-S1030352AbXDKDiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030352AbXDKDiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbXDKDik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:38:40 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:15843 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbXDKDif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:38:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=aGZ+6HJW3WnZJwl7CC5q64geeFPw891YhX/LDpSr2hp12IC4P4i4Uypwql5fnFQZ/VAt6I9as0zlvwe6tfBu0W7R6qs7OxTN1B/sePgMCru0qKWWzWYsnHAxll46LXAciU2ctJHXCv1OAHAymYRv1bedTzuqDCB6T53rmIlHMJc=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 10 Apr 2007 20:36:00 -0700
Message-Id: <20070411033600.11000.71629.patchbomb.py@localhost>
In-Reply-To: <20070411033600.11000.38285.patchbomb.py@localhost>
Subject: [PATCH 6/13] gfs2: use zero_user_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use zero_user_page() instead of open-coding it. 

Signed-off-by: Nate Diller <nate.diller@gmail.com>

--- 

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/gfs2/bmap.c linux-2.6.21-rc6-mm1-test/fs/gfs2/bmap.c
--- linux-2.6.21-rc6-mm1/fs/gfs2/bmap.c	2007-04-09 17:23:48.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/gfs2/bmap.c	2007-04-09 18:18:23.000000000 -0700
@@ -885,7 +885,6 @@ static int gfs2_block_truncate_page(stru
 	unsigned blocksize, iblock, length, pos;
 	struct buffer_head *bh;
 	struct page *page;
-	void *kaddr;
 	int err;
 
 	page = grab_cache_page(mapping, index);
@@ -933,10 +932,7 @@ static int gfs2_block_truncate_page(stru
 	if (sdp->sd_args.ar_data == GFS2_DATA_ORDERED || gfs2_is_jdata(ip))
 		gfs2_trans_add_bh(ip->i_gl, bh, 0);
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, length);
 
 unlock:
 	unlock_page(page);
