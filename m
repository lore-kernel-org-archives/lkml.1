Return-Path: <linux-kernel-owner+w=401wt.eu-S1760666AbXHVI5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666AbXHVI5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXHVIwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:53 -0400
Received: from 1wt.eu ([62.212.114.60]:1951 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbXHVIwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:51 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822083958.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:02 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 18/58] splice: fix double page unlock
Content-Disposition: inline; filename=0018-splice-fix-double-page-unlock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If add_to_page_cache_lru() fails, the page will not be locked. But
splice jumps to an error path that does a page release and unlock,
causing a BUG() in unlock_page().

Fix this by adding one more label that just releases the page. This bug
was actually triggered on EL5 by gurudas pai <gurudas.pai@oracle.com>
using fio.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/splice.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 2fca6eb..b657217 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -614,7 +614,7 @@ find_page:
 			ret = add_to_page_cache_lru(page, mapping, index,
 						    GFP_KERNEL);
 			if (unlikely(ret))
-				goto out;
+				goto out_release;
 		}
 
 		/*
@@ -695,8 +695,9 @@ find_page:
 		goto find_page;
 	}
 out:
-	page_cache_release(page);
 	unlock_page(page);
+out_release:
+	page_cache_release(page);
 out_ret:
 	return ret;
 }
-- 
1.5.2.5

-- 
