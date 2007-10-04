Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbXJDJU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbXJDJU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759451AbXJDJRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759445AbXJDJRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:32 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/51] [GFS2] Detach buf data during in-place writeback
Date: Thu,  4 Oct 2007 09:49:03 +0100
Message-Id: <11914878081562-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878063121-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This is patch 5 of 5 for bug #248176

Metadata corruption was occurring because page references weren't
being removed in all cases.  I previously added a function called
detach_bufdata, but I discovered there already WAS a function out
there to do the job.  It's called gfs2_meta_cache_flush.  So I added
a call to that to remove the page references.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index f7c0608..00ab6c0 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -219,6 +219,7 @@ static void gfs2_ail2_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 {
 	struct list_head *head = &ai->ai_ail2_list;
 	struct gfs2_bufdata *bd;
+	struct gfs2_inode *bh_ip;
 
 	while (!list_empty(head)) {
 		bd = list_entry(head->prev, struct gfs2_bufdata,
@@ -228,6 +229,8 @@ static void gfs2_ail2_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 		list_del(&bd->bd_ail_st_list);
 		list_del(&bd->bd_ail_gl_list);
 		atomic_dec(&bd->bd_gl->gl_ail_count);
+		bh_ip = GFS2_I(bd->bd_bh->b_page->mapping->host);
+		gfs2_meta_cache_flush(bh_ip);
 		brelse(bd->bd_bh);
 	}
 }
-- 
1.5.1.2

