Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309Ab0ARCLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab0ARCLf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968Ab0ARCLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:11:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38166 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab0ARCLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:11:33 -0500
Date: Mon, 18 Jan 2010 13:11:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       =?UTF-8?B?IkrDtnJuIEVuZ2VsIg==?= <joern@logfs.org>
Subject: linux-next: vfs tree build warning
Message-Id: <20100118131128.a09d1021.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Today's linux-next build (x86_64_allmodconfig) produced this warning:

fs/logfs/inode.c:399: warning: initialization from incompatible pointer type

Introduced by commit bc39e28236344af617473df80abb7de43176511e ("pass
writeback_control to ->write_inode") from the vfs tree interacting with
commit 5db53f3e80dee2d9dff5e534f9e9fe1db17c9936 ("[LogFS] add new flash
file system") from the logfs tree.

This will need a fixup patch (see below) which I can carry in the
linux-next tree.  There may, of course, be a better fix (which I can
carry if someone sends it to me).
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 18 Jan 2010 12:14:59 +1100
Subject: [PATCH] logfs: fixup for write_inode API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/logfs/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/logfs/inode.c b/fs/logfs/inode.c
index 6d08b37..36308af 100644
--- a/fs/logfs/inode.c
+++ b/fs/logfs/inode.c
@@ -8,6 +8,7 @@
 #include "logfs.h"
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
+#include <linux/writeback.h>
 
 /*
  * How soon to reuse old inode numbers?  LogFS doesn't store deleted inodes
@@ -282,7 +283,7 @@ struct inode *logfs_read_meta_inode(struct super_block *sb, u64 ino)
 	return inode;
 }
 
-static int logfs_write_inode(struct inode *inode, int do_sync)
+static int logfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int ret;
 	long flags = WF_LOCK;
-- 
1.6.6

