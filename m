Return-Path: <linux-kernel-owner+w=401wt.eu-S1161505AbXDLCvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161505AbXDLCvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161506AbXDLCvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:51:35 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:54681 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161505AbXDLCvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=oRrf4BIYvjXnsjvGo1HZ3s00LwsyNIZ5/M6V9R36esMWxkdjrSI+mRsvvV5F4MQpE78iwceqlrdy+ElmIDUSxYw2uxTzZrAX/m5PAgTl67QEO4a2VQmw/R0zrICz0q3+vKhO148lnnOZc4yzHPhEAoPsRvrJB4Uf4zfq2rVqAFU=
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
Message-Id: <20070412024938.27380.87060.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 1/17] cramfs: use read_mapping_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

read_mapping_page_async() is going away, so convert its only user to
read_mapping_page().  This change has not been benchmarked, however, in
order to get real parallelism this wants something completely different,
like __do_page_cache_readahead(), which is not currently exported.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/cramfs/inode.c linux-2.6.21-rc6-mm1-test/fs/cramfs/inode.c
--- linux-2.6.21-rc6-mm1/fs/cramfs/inode.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/cramfs/inode.c	2007-04-09 21:37:09.000000000 -0700
@@ -180,8 +180,7 @@ static void *cramfs_read(struct super_bl
 		struct page *page = NULL;
 
 		if (blocknr + i < devsize) {
-			page = read_mapping_page_async(mapping, blocknr + i,
-									NULL);
+			page = read_mapping_page(mapping, blocknr + i, NULL);
 			/* synchronous error? */
 			if (IS_ERR(page))
 				page = NULL;
