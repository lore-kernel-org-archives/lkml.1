Return-Path: <linux-kernel-owner+w=401wt.eu-S1163158AbYCTAWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163158AbYCTAWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938462AbYCSXgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:36:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50604 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938512AbYCSXfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:35:48 -0400
Message-Id: <20080318185721.611032284@szeredi.hu>
References: <20080318185626.300130296@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 18 Mar 2008 19:56:30 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 4/4] fuse: support writable mmap fix
Content-Disposition: inline; filename=fuse_mmap_write_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Set the BDI_CAP_NO_ACCT_WB capability, so that fuse can do it's own
accounting of writeback pages.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/file.c  |    3 ++-
 fs/fuse/inode.c |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2008-03-18 19:27:43.000000000 +0100
+++ linux/fs/fuse/file.c	2008-03-18 19:43:40.000000000 +0100
@@ -1145,8 +1145,9 @@ static int fuse_writepage_locked(struct 
 	req->end = fuse_writepage_end;
 	req->inode = inode;
 
+	inc_bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK);
 	inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
-	__end_page_writeback(page, false);
+	end_page_writeback(page);
 
 	spin_lock(&fc->lock);
 	list_add(&req->writepages_entry, &fi->writepages);
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2008-03-18 19:27:43.000000000 +0100
+++ linux/fs/fuse/inode.c	2008-03-18 19:43:40.000000000 +0100
@@ -483,6 +483,8 @@ static struct fuse_conn *new_conn(struct
 		atomic_set(&fc->num_waiting, 0);
 		fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;
+		/* fuse does it's own writeback accounting */
+		fc->bdi.capabilities = BDI_CAP_NO_ACCT_WB;
 		fc->dev = sb->s_dev;
 		err = bdi_init(&fc->bdi);
 		if (err)

--
