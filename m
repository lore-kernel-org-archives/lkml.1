Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbZKTReq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbZKTReq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbZKTReq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:34:46 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:47624 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbZKTRep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:34:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=scHEEhLPWbIl6w8lipt8d39DGRBL785+ATU2pK6dqIeqyQ9wmtGJ9eFYGIY4EfgvqS
         xgemwPDNGzAbje2SIuD5E6sreUklT/zHaI8sj68UqhboexnJ3KNjMYqcxN4NjJmX//ib
         golTxj3q8te4B2RY/pgeHl00wcwG7L1B/1icM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] kill-the-bkl/reiserfs: turn GFP_ATOMIC flag to GFP_NOFS in reiserfs_get_block()
Date: Fri, 20 Nov 2009 18:34:50 +0100
Message-Id: <1258738490-5856-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFP_ATOMIC was used in reiserfs_get_block to not lose the Bkl so that
nobody can modify the tree in the middle of its work. Now that we
kicked out the bkl, we can use a more friendly flag. We use GFP_NOFS
here because we already hold the reiserfs lock.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 fs/reiserfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 0d493a3..3a28e77 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -932,7 +932,7 @@ int reiserfs_get_block(struct inode *inode, sector_t block,
 			if (blocks_needed == 1) {
 				un = &unf_single;
 			} else {
-				un = kzalloc(min(blocks_needed, max_to_insert) * UNFM_P_SIZE, GFP_ATOMIC);	// We need to avoid scheduling.
+				un = kzalloc(min(blocks_needed, max_to_insert) * UNFM_P_SIZE, GFP_NOFS);
 				if (!un) {
 					un = &unf_single;
 					blocks_needed = 1;
-- 
1.6.2.3

