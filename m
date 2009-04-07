Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbZDGGRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbZDGGRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZDGGRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:17:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:36507 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZDGGRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:17:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,336,1235980800"; 
   d="scan'208";a="128646587"
Date: Tue, 7 Apr 2009 14:16:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avan Anishchuk <matimatik@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [PATCH] ramfs: fix double freeing s_fs_info on failed mount
Message-ID: <20090407061650.GA31745@localhost>
References: <20090405193944.GA12691@elte.hu> <alpine.LFD.2.00.0904061842490.4010@localhost.localdomain> <alpine.LFD.2.00.0904062045530.4010@localhost.localdomain> <alpine.LFD.2.00.0904062108550.4010@localhost.localdomain> <alpine.LFD.2.00.0904062142110.4010@localhost.localdomain> <20090407052801.GA4235@elte.hu> <20090407055502.GA22881@localhost> <20090407060309.GA21788@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407060309.GA21788@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

If ramfs mount fails, s_fs_info will be freed twice in ramfs_fill_super()
and ramfs_kill_sb(), leading to kernel oops.

Consolidate and beautify the code.
Make sure s_fs_info and s_root are in known good states.

Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/ramfs/inode.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- mm.orig/fs/ramfs/inode.c
+++ mm/fs/ramfs/inode.c
@@ -221,22 +221,23 @@ static int ramfs_fill_super(struct super
 	save_mount_options(sb, data);
 
 	fsi = kzalloc(sizeof(struct ramfs_fs_info), GFP_KERNEL);
+	sb->s_fs_info = fsi;
 	if (!fsi) {
 		err = -ENOMEM;
 		goto fail;
 	}
-	sb->s_fs_info = fsi;
 
 	err = ramfs_parse_options(data, &fsi->mount_opts);
 	if (err)
 		goto fail;
 
-	sb->s_maxbytes = MAX_LFS_FILESIZE;
-	sb->s_blocksize = PAGE_CACHE_SIZE;
-	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
-	sb->s_magic = RAMFS_MAGIC;
-	sb->s_op = &ramfs_ops;
-	sb->s_time_gran = 1;
+	sb->s_maxbytes		= MAX_LFS_FILESIZE;
+	sb->s_blocksize		= PAGE_CACHE_SIZE;
+	sb->s_blocksize_bits	= PAGE_CACHE_SHIFT;
+	sb->s_magic		= RAMFS_MAGIC;
+	sb->s_op		= &ramfs_ops;
+	sb->s_time_gran		= 1;
+
 	inode = ramfs_get_inode(sb, S_IFDIR | fsi->mount_opts.mode, 0);
 	if (!inode) {
 		err = -ENOMEM;
@@ -244,14 +245,16 @@ static int ramfs_fill_super(struct super
 	}
 
 	root = d_alloc_root(inode);
+	sb->s_root = root;
 	if (!root) {
 		err = -ENOMEM;
 		goto fail;
 	}
-	sb->s_root = root;
+
 	return 0;
 fail:
 	kfree(fsi);
+	sb->s_fs_info = NULL;
 	iput(inode);
 	return err;
 }
