Return-Path: <linux-kernel-owner+w=401wt.eu-S1765804AbYETKBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765804AbYETKBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765637AbYETKAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:00:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765629AbYETKAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:00:18 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Andrew Price <andy@andrewprice.me.uk>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/3] [GFS2] Fix cast from unsigned int to s64
Date: Tue, 20 May 2008 10:12:43 +0100
Message-Id: <12112747742961-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12112747723560-git-send-email-swhiteho@redhat.com>
References: <1211274764371-git-send-email-swhiteho@redhat.com>
 <12112747723560-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Price <andy@andrewprice.me.uk>

This fixes bz 444829 where allocating a new block caused gfs2 file systems to
report 0 bytes used in df. It was caused by a broken cast from an unsigned int
in gfs2_block_alloc() to a negative s64 in gfs2_statfs_change(). This patch
casts the unsigned int to an s64 before the unary minus is applied.

Signed-off-by: Andrew Price <andy@andrewprice.me.uk>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 7e8f0b1..6387523 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1495,7 +1495,7 @@ u64 gfs2_alloc_block(struct gfs2_inode *ip, unsigned int *n)
 
 	al->al_alloced += *n;
 
-	gfs2_statfs_change(sdp, 0, -*n, 0);
+	gfs2_statfs_change(sdp, 0, -(s64)*n, 0);
 	gfs2_quota_change(ip, *n, ip->i_inode.i_uid, ip->i_inode.i_gid);
 
 	spin_lock(&sdp->sd_rindex_spin);
-- 
1.5.1.2

