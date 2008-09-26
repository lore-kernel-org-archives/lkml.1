Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbYIZJAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbYIZJAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbYIZI7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:59:21 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43252 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbYIZI7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:59:19 -0400
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/10] reiserfs: Fix error handling in write_super_lockfs/unlockfs
Message-Id: <20080926175854t-sato@mail.jp.nec.com>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:1K0086
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Fri, 26 Sep 2008 17:58:54 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've changed write_super_lockfs/unlockfs so that they always return
0 (success) to keep a current behavior.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 super.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-xfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs-xfs/fs/reiserfs/super.c linux-2
.6.27-rc7-lockfs-reiserfs/fs/reiserfs/super.c
--- linux-2.6.27-rc7-lockfs-xfs/fs/reiserfs/super.c	2008-09-26 12:19:24.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-reiserfs/fs/reiserfs/super.c	2008-09-26 17:00:18.000000000 +0900
@@ -83,7 +83,7 @@ static void reiserfs_write_super(struct 
 	reiserfs_sync_fs(s, 1);
 }
 
-static void reiserfs_write_super_lockfs(struct super_block *s)
+static int reiserfs_freeze(struct super_block *s)
 {
 	struct reiserfs_transaction_handle th;
 	reiserfs_write_lock(s);
@@ -101,11 +101,13 @@ static void reiserfs_write_super_lockfs(
 	}
 	s->s_dirt = 0;
 	reiserfs_write_unlock(s);
+	return 0;
 }
 
-static void reiserfs_unlockfs(struct super_block *s)
+static int reiserfs_unfreeze(struct super_block *s)
 {
 	reiserfs_allow_writes(s);
+	return 0;
 }
 
 extern const struct in_core_key MAX_IN_CORE_KEY;
@@ -613,8 +615,8 @@ static const struct super_operations rei
 	.put_super = reiserfs_put_super,
 	.write_super = reiserfs_write_super,
 	.sync_fs = reiserfs_sync_fs,
-	.write_super_lockfs = reiserfs_write_super_lockfs,
-	.unlockfs = reiserfs_unlockfs,
+	.freeze_fs = reiserfs_freeze,
+	.unfreeze_fs = reiserfs_unfreeze,
 	.statfs = reiserfs_statfs,
 	.remount_fs = reiserfs_remount,
 	.show_options = generic_show_options,
