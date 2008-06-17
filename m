Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbYFQQFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbYFQQFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 12:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYFQQFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 12:05:46 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45840 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbYFQQFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 12:05:45 -0400
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, ywang221@hotmail.com, szaka@ntfs-3g.org
Subject: [2.6.26 patch] fuse: fix thinko in max I/O size calucation
Message-Id: <E1K8dgi-0005sl-El@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 17 Jun 2008 18:05:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Use max not min to enforce a lower limit on the max I/O size.

This bug was introduced by

   commit e5d9a0df07484d6d191756878c974e4307fb24ce
   Author: Miklos Szeredi <mszeredi@suse.cz>
   Date:   Wed Apr 30 00:54:44 2008 -0700
   
       fuse: fix max i/o size calculation

Thanks to Brian Wang for noticing.

Reported-by: Brian Wang <ywang221@hotmail.com>
CC: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/fuse/inode.c
===================================================================
--- linux-2.6.orig/fs/fuse/inode.c	2008-06-17 17:55:38.000000000 +0200
+++ linux-2.6/fs/fuse/inode.c	2008-06-17 17:55:48.000000000 +0200
@@ -591,7 +591,7 @@ static void process_init_reply(struct fu
 		fc->bdi.ra_pages = min(fc->bdi.ra_pages, ra_pages);
 		fc->minor = arg->minor;
 		fc->max_write = arg->minor < 5 ? 4096 : arg->max_write;
-		fc->max_write = min_t(unsigned, 4096, fc->max_write);
+		fc->max_write = max_t(unsigned, 4096, fc->max_write);
 		fc->conn_init = 1;
 	}
 	fuse_put_request(fc, req);
@@ -667,7 +667,7 @@ static int fuse_fill_super(struct super_
 	fc->flags = d.flags;
 	fc->user_id = d.user_id;
 	fc->group_id = d.group_id;
-	fc->max_read = min_t(unsigned, 4096, d.max_read);
+	fc->max_read = max_t(unsigned, 4096, d.max_read);
 
 	/* Used by get_root_inode() */
 	sb->s_fs_info = fc;
