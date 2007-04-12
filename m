Return-Path: <linux-kernel-owner+w=401wt.eu-S1161511AbXDLCwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161511AbXDLCwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161523AbXDLCwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:52:40 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:54681 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161511AbXDLCwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:52:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=BbSnJuMZMVTmHat0pky4aeXD//sjHPn64lX+AbqCwaIxyGUXetXELUwyqFzMo2R72PbJhm/7fhksLQa9bdQoQmAGGzkCNeEnbLBe49b+Ku05IIMKZgVG3copFYyIrQSFj8KROQvRVcmKcqCMyezVpm1gp0brzcMCmhfFZSRzZnM=
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
Message-Id: <20070412024938.27380.3762.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 8/17] jfs: use locking read_mapping_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new locking variant of read_mapping_page to avoid doing extra work.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/jfs/jfs_metapage.c linux-2.6.21-rc6-mm1-test/fs/jfs/jfs_metapage.c
--- linux-2.6.21-rc6-mm1/fs/jfs/jfs_metapage.c	2007-04-09 17:23:48.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/jfs/jfs_metapage.c	2007-04-09 21:37:09.000000000 -0700
@@ -632,12 +632,11 @@ struct metapage *__get_metapage(struct i
 		}
 		SetPageUptodate(page);
 	} else {
-		page = read_mapping_page(mapping, page_index, NULL);
-		if (IS_ERR(page) || !PageUptodate(page)) {
+		page = __read_mapping_page(mapping, page_index, NULL);
+		if (IS_ERR(page)) {
 			jfs_err("read_mapping_page failed!");
 			return NULL;
 		}
-		lock_page(page);
 	}
 
 	mp = page_to_mp(page, page_offset);
