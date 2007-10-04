Return-Path: <linux-kernel-owner+w=401wt.eu-S1759142AbXJDJgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142AbXJDJgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759751AbXJDJSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759668AbXJDJSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:43 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Wendy Cheng <wcheng@redhat.com>
Subject: [PATCH 49/51] [GFS2] Get superblock a different way
Date: Thu,  4 Oct 2007 09:49:42 +0100
Message-Id: <11914878792099-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1191487877383-git-send-email-swhiteho@redhat.com>
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
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
 <11914878304004-git-send-email-swhiteho@redhat.com>
 <11914878323899-git-send-email-swhiteho@redhat.com>
 <11914878342921-git-send-email-swhiteho@redhat.com>
 <11914878361239-git-send-email-swhiteho@redhat.com>
 <11914878383633-git-send-email-swhiteho@redhat.com>
 <11914878401428-git-send-email-swhiteho@redhat.com>
 <11914878422398-git-send-email-swhiteho@redhat.com>
 <1191487844772-git-send-email-swhiteho@redhat.com>
 <1191487846406-git-send-email-swhiteho@redhat.com>
 <11914878472056-git-send-email-swhiteho@redhat.com>
 <11914878492645-git-send-email-swhiteho@redhat.com>
 <11914878513555-git-send-email-swhiteho@redhat.com>
 <11914878521254-git-send-email-swhiteho@redhat.com>
 <119148785427-git-send-email-swhiteho@redhat.com>
 <11914878551328-git-send-email-swhiteho@redhat.com>
 <11914878571888-git-send-email-swhiteho@redhat.com>
 <11914878592314-git-send-email-swhiteho@redhat.com>
 <1191487861683-git-send-email-swhiteho@redhat.com>
 <11914878632211-git-send-email-swhiteho@redhat.com>
 <1191487864951-git-send-email-swhiteho@redhat.com>
 <11914878661743-git-send-email-swhiteho@redhat.com>
 <11914878683674-git-send-email-swhiteho@redhat.com>
 <1191487870444-git-send-email-swhiteho@redhat.com>
 <1191487872941-git-send-email-swhiteho@redhat.com>
 <119148787317-git-send-email-swhiteho@redhat.com>
 <11914878753861-git-send-email-swhiteho@redhat.com>
 <1191487877383-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The mapping may be NULL by the time the I/O has completed, so
we now get the superblock by a different route (via the bd and glock)
to avoid this problem.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Wendy Cheng <wcheng@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index ee70467..7df7024 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -513,7 +513,8 @@ struct buffer_head *gfs2_log_get_buf(struct gfs2_sbd *sdp)
 static void gfs2_fake_write_endio(struct buffer_head *bh, int uptodate)
 {
 	struct buffer_head *real_bh = bh->b_private;
-	struct gfs2_sbd *sdp = GFS2_SB(real_bh->b_page->mapping->host);
+	struct gfs2_bufdata *bd = real_bh->b_private;
+	struct gfs2_sbd *sdp = bd->bd_gl->gl_sbd;
 
 	end_buffer_write_sync(bh, uptodate);
 	free_buffer_head(bh);
-- 
1.5.1.2

