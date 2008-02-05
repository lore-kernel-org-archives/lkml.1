Return-Path: <linux-kernel-owner+w=401wt.eu-S1757666AbYBEKJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666AbYBEKJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbYBEKJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:09:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbYBEKJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:09:30 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20420.1201625624@turing-police.cc.vt.edu>
References: <20420.1201625624@turing-police.cc.vt.edu>
To: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1 - iget-stop-isofs-from-using-read_inode-fix-2.patch
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 05 Feb 2008 10:09:21 +0000
Message-ID: <30832.1202206161@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


How about this patch?

David
---
IGET: Fix isofs_get_block() to only return 0 on success.

From: David Howells <dhowells@redhat.com>

Fix isofs_get_block() to return only 0 on success.  It shouldn't return a +ve
block count for example.

Also make sure that isofs_get_blocks() doesn't accidentally return an error if
rv is 0 come the return statement.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/isofs/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 0f5ed8c..875d37f 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1022,6 +1022,7 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 		rv++;
 	}
 
+	error = 0;
 abort:
 	unlock_kernel();
 	return rv != 0 ? rv : error;
@@ -1033,12 +1034,15 @@ abort:
 static int isofs_get_block(struct inode *inode, sector_t iblock,
 		    struct buffer_head *bh_result, int create)
 {
+	int ret;
+
 	if (create) {
 		printk(KERN_DEBUG "%s: Kernel tries to allocate a block\n", __func__);
 		return -EROFS;
 	}
 
-	return isofs_get_blocks(inode, iblock, &bh_result, 1);
+	ret = isofs_get_blocks(inode, iblock, &bh_result, 1);
+	return ret < 0 ? ret : 0;
 }
 
 static int isofs_bmap(struct inode *inode, sector_t block)
