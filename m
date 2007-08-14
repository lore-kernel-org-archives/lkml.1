Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbXHNKR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbXHNKR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757229AbXHNKK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:10:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbXHNKKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:10:54 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Fix incorrect error path in prepare_write()
Date: Tue, 14 Aug 2007 10:47:14 +0100
Message-Id: <11870848591530-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11870848365-git-send-email-swhiteho@redhat.com>
References: <11870848365-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The error path in prepare_write() was incorrect in the (very rare) event
that the transaction fails to start. The following prevents a NULL
pointer dereference,

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index ce90032..42a5f58 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -416,7 +416,7 @@ static int gfs2_prepare_write(struct file *file, struct page *page,
 
 	error = gfs2_trans_begin(sdp, rblocks, 0);
 	if (error)
-		goto out;
+		goto out_trans_fail;
 
 	if (gfs2_is_stuffed(ip)) {
 		if (end > sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode)) {
@@ -434,6 +434,7 @@ prepare_write:
 out:
 	if (error) {
 		gfs2_trans_end(sdp);
+out_trans_fail:
 		if (alloc_required) {
 			gfs2_inplace_release(ip);
 out_qunlock:
-- 
1.5.1.2

