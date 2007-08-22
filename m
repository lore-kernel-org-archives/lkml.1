Return-Path: <linux-kernel-owner+w=401wt.eu-S1762188AbXHVJBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762188AbXHVJBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758578AbXHVIxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:23 -0400
Received: from 1wt.eu ([62.212.114.60]:2049 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758389AbXHVIxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:22 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084021.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:14 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Greg Banks <gnb@melbourne.sgi.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>, NeilBrown <neilb@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 30/58] nfsd: fix possible read-ahead cache and export table corruption
Content-Disposition: inline; filename=0030-nfsd-fix-possible-read-ahead-cache-and-export-table.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The value of nperbucket calculated here is too small--we should be rounding up
instead of down--with the result that the index j in the following loop can
overflow the raparm_hash array.  At least in my case, the next thing in memory
turns out to be export_table, so the symptoms I see are crashes caused by the
appearance of four zeroed-out export entries in the first bucket of the hash
table of exports (which were actually entries in the readahead cache, a
pointer to which had been written to the export table in this initialization
code).

It looks like the bug was probably introduced with commit
fce1456a19f5c08b688c29f00ef90fdfa074c79b ("knfsd: make the readahead params
cache SMP-friendly").

Cc: Greg Banks <gnb@melbourne.sgi.com>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/nfsd/vfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 8283236..d8b773a 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1887,7 +1887,7 @@ nfsd_racache_init(int cache_size)
 		raparm_hash[i].pb_head = NULL;
 		spin_lock_init(&raparm_hash[i].pb_lock);
 	}
-	nperbucket = cache_size >> RAPARM_HASH_BITS;
+	nperbucket = DIV_ROUND_UP(cache_size, RAPARM_HASH_SIZE);
 	for (i = 0; i < cache_size - 1; i++) {
 		if (i % nperbucket == 0)
 			raparm_hash[j++].pb_head = raparml + i;
-- 
1.5.2.5

-- 
