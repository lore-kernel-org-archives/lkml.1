Return-Path: <linux-kernel-owner+w=401wt.eu-S1760695AbXJDJX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbXJDJX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759522AbXJDJRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759512AbXJDJRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:50 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 19/51] [GFS2] Force unstuff of hidden quota inode
Date: Thu,  4 Oct 2007 09:49:12 +0100
Message-Id: <11914878252873-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878231394-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

This patch forcibly unstuffs (if stuffed) the hidden quota inode at the
first availble opportunity. In any practical scenario the quota inode
won't be stuffed, so this is ok to do. Unstuffing the quota inode allows
us to ignore the case of a stuffed quota inode in gfs2_adjust_quota().

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 6e546ee..5dfa465 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -614,6 +614,16 @@ static int gfs2_adjust_quota(struct gfs2_inode *ip, loff_t loc,
 	s64 value;
 	int err = -EIO;
 
+	if (gfs2_is_stuffed(ip)) {
+		struct gfs2_alloc *al = NULL;
+		al = gfs2_alloc_get(ip);
+		/* just request 1 blk */
+		al->al_requested = 1;
+		gfs2_inplace_reserve(ip);
+		gfs2_unstuff_dinode(ip, NULL);
+		gfs2_inplace_release(ip);
+		gfs2_alloc_put(ip);
+	}
 	page = grab_cache_page(mapping, index);
 	if (!page)
 		return -ENOMEM;
-- 
1.5.1.2

