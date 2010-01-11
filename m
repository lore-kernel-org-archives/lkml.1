Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954Ab0AKJPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab0AKJPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 04:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920Ab0AKJPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 04:15:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab0AKJPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 04:15:40 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/4] GFS2: Fix locking bug in rename
Date: Mon, 11 Jan 2010 09:11:38 +0000
Message-Id: <1263201100-6904-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1263201100-6904-2-git-send-email-swhiteho@redhat.com>
References: <1263201100-6904-1-git-send-email-swhiteho@redhat.com>
 <1263201100-6904-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rename code was taking a resource group lock in cases where
it wasn't actually needed, this caused problems if the rename
was resulting in an inode being unlinked. The patch ensures that
we only take the rgrp lock early if it is really needed.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/ops_inode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 247436c..78f73ca 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -748,7 +748,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	struct gfs2_rgrpd *nrgd;
 	unsigned int num_gh;
 	int dir_rename = 0;
-	int alloc_required;
+	int alloc_required = 0;
 	unsigned int x;
 	int error;
 
@@ -867,7 +867,9 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			goto out_gunlock;
 	}
 
-	alloc_required = error = gfs2_diradd_alloc_required(ndir, &ndentry->d_name);
+	if (nip == NULL)
+		alloc_required = gfs2_diradd_alloc_required(ndir, &ndentry->d_name);
+	error = alloc_required;
 	if (error < 0)
 		goto out_gunlock;
 	error = 0;
-- 
1.6.2.5

