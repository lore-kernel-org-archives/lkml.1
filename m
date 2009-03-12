Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZCLMa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZCLMa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZCLMaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:30:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbZCLMaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:30:12 -0400
Date: Thu, 12 Mar 2009 08:30:05 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: linux-kernel@vger.kernel.org
cc: hirofumi@mail.parknet.co.jp
Subject: [PATCH] deadlock when swapping to FAT
Message-ID: <Pine.LNX.4.64.0903120819010.26206@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

swapon will deadlock when an attempt to swap to a file on FAT filesystem 
is made. swapon holds i_mutex and FAT bmap is attempting to take it again.

This bug was introduced somewhere between 2.6.27 and 2.6.28.

No other filesystem is taking i_mutex in bmap, so I removed it as well.

Note that there are many other cases where bmap can race with truncate in 
almost all the filesystems. They don't impose an immediate threat because 
bmap can be only called by root. These problems should be solved in a 
generic way, not in individual filesystems.

Mikulas

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com
Cc: <stable@kernel.org>

---
 fs/fat/inode.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.29-rc7-devel/fs/fat/inode.c
===================================================================
--- linux-2.6.29-rc7-devel.orig/fs/fat/inode.c	2009-03-10 21:17:22.000000000 +0100
+++ linux-2.6.29-rc7-devel/fs/fat/inode.c	2009-03-11 22:52:38.000000000 +0100
@@ -202,9 +202,7 @@ static sector_t _fat_bmap(struct address
 	sector_t blocknr;
 
 	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
-	mutex_lock(&mapping->host->i_mutex);
 	blocknr = generic_block_bmap(mapping, block, fat_get_block);
-	mutex_unlock(&mapping->host->i_mutex);
 
 	return blocknr;
 }
