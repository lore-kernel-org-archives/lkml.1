Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0BLLWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:22:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037Ab0BLLWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:22:32 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/2] GFS2: Fix bmap allocation corner-case bug
Date: Fri, 12 Feb 2010 11:13:21 +0000
Message-Id: <1265973201-3142-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1265973201-3142-2-git-send-email-swhiteho@redhat.com>
References: <1265973201-3142-1-git-send-email-swhiteho@redhat.com>
 <1265973201-3142-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch solves a corner case during allocation which occurs if both
metadata (indirect) and data blocks are required but there is an
obstacle in the filesystem (e.g. a resource group header or another
allocated block) such that when the allocation is requested only
enough blocks for the metadata are returned.

By changing the exit condition of this loop, we ensure that a
minimum of one data block will always be returned.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/bmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 6d47379..583e823 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -541,7 +541,7 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 				*ptr++ = cpu_to_be64(bn++);
 			break;
 		}
-	} while (state != ALLOC_DATA);
+	} while ((state != ALLOC_DATA) || !dblock);
 
 	ip->i_height = height;
 	gfs2_add_inode_blocks(&ip->i_inode, alloced);
-- 
1.6.2.5

