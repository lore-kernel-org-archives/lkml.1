Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbXDKDij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbXDKDij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbXDKDid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:38:33 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:15870 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbXDKDiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:38:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=srG9qBrcsgsas5FrbbDGduGfw5HUBnCwRBPFXOMluOoh8OJFh+WiJCDBQ9zhsocLnJ6f6qfCVmHsK7sEBcgy3hxJwH/0JMeDZUdxjuv40tVSiW6Nbtd8SUVsW3TlJHFDin/LQ2oL8ejOFBbEqZgAtNkh9ex4pSyV+1AYTjJoLZg=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 10 Apr 2007 20:36:00 -0700
Message-Id: <20070411033600.11000.20151.patchbomb.py@localhost>
In-Reply-To: <20070411033600.11000.38285.patchbomb.py@localhost>
Subject: [PATCH 4/13] ext3: use zero_user_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use zero_user_page() instead of open-coding it. 

Signed-off-by: Nate Diller <nate.diller@gmail.com>

--- 

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/ext3/inode.c linux-2.6.21-rc6-mm1-test/fs/ext3/inode.c
--- linux-2.6.21-rc6-mm1/fs/ext3/inode.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/ext3/inode.c	2007-04-09 18:18:23.000000000 -0700
@@ -1767,7 +1767,6 @@ static int ext3_block_truncate_page(hand
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
 	int err = 0;
-	void *kaddr;
 
 	blocksize = inode->i_sb->s_blocksize;
 	length = blocksize - (offset & (blocksize - 1));
@@ -1779,10 +1778,7 @@ static int ext3_block_truncate_page(hand
 	 */
 	if (!page_has_buffers(page) && test_opt(inode->i_sb, NOBH) &&
 	     ext3_should_writeback_data(inode) && PageUptodate(page)) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + offset, 0, length);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, offset, length);
 		set_page_dirty(page);
 		goto unlock;
 	}
@@ -1835,11 +1831,7 @@ static int ext3_block_truncate_page(hand
 			goto unlock;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-
+	zero_user_page(page, offset, length);
 	BUFFER_TRACE(bh, "zeroed end of block");
 
 	err = 0;
