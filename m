Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbZG1PzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbZG1PzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbZG1PzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:55:09 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:55435 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613AbZG1PzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:55:07 -0400
Date: Tue, 28 Jul 2009 17:54:58 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/9] fs/romfs: correct error-handling code
Message-ID: <Pine.LNX.4.64.0907281754250.28189@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

romfs_iget returns an ERR_PTR value in an error case instead of NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@match exists@
expression x, E;
statement S1, S2;
@@

x = romfs_iget(...)
... when != x = E
(
*  if (x == NULL || ...) S1 else S2
|
*  if (x == NULL && ...) S1 else S2
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/romfs/super.c                    |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index 4ab3c03..7f733fb 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -528,7 +528,7 @@ static int romfs_fill_super(struct super_block *sb, void *data, int silent)
 	pos = (ROMFH_SIZE + len + 1 + ROMFH_PAD) & ROMFH_MASK;
 
 	root = romfs_iget(sb, pos);
-	if (!root)
+	if (IS_ERR(root))
 		goto error;
 
 	sb->s_root = d_alloc_root(root);
