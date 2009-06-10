Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbZFJJn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbZFJJn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757637AbZFJJij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40351 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758816AbZFJJiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:25 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 24/24] GFS2: Fix cache coherency between truncate and O_DIRECT read
Date: Wed, 10 Jun 2009 09:31:05 +0100
Message-Id: <1244622665-7470-25-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-24-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-10-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-12-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-13-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-14-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-15-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-16-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-17-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-18-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-19-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-20-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-21-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-22-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-23-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-24-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a page was partially zeroed as the result of a truncate, then it was
not being correctly marked dirty. This resulted in the deleted data
reappearing if the file was read back via direct I/O.

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 1153a07..3297635 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1012,7 +1012,7 @@ static int gfs2_block_truncate_page(struct address_space *mapping)
 		gfs2_trans_add_bh(ip->i_gl, bh, 0);
 
 	zero_user(page, offset, length);
-
+	mark_buffer_dirty(bh);
 unlock:
 	unlock_page(page);
 	page_cache_release(page);
-- 
1.6.0.6

