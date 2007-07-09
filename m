Return-Path: <linux-kernel-owner+w=401wt.eu-S1759528AbXGIQba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528AbXGIQba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbXGIQXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640AbXGIQXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:53 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Abhijith Das <adas@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Quotas non-functional - fix another bug
Date: Mon,  9 Jul 2007 17:02:30 +0100
Message-Id: <11839970383020-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1183997036270-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
 <1183997034982-git-send-email-swhiteho@redhat.com>
 <1183997036270-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

This patch fixes a bug where gfs2 was writing update quota usage
information to the wrong location in the quota file.

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ondisk.c b/fs/gfs2/ondisk.c
index cd4cf05..a5b05ea 100644
--- a/fs/gfs2/ondisk.c
+++ b/fs/gfs2/ondisk.c
@@ -121,6 +121,16 @@ void gfs2_quota_in(struct gfs2_quota_host *qu, const void *buf)
 	qu->qu_value = be64_to_cpu(str->qu_value);
 }
 
+void gfs2_quota_out(const struct gfs2_quota_host *qu, void *buf)
+{
+	struct gfs2_quota *str = buf;
+
+	str->qu_limit = cpu_to_be64(qu->qu_limit);
+	str->qu_warn = cpu_to_be64(qu->qu_warn);
+	str->qu_value = cpu_to_be64(qu->qu_value);
+	memset(&str->qu_reserved, 0, sizeof(str->qu_reserved));
+}
+
 void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 {
 	const struct gfs2_dinode_host *di = &ip->i_di;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index fcd3ee2..8a58815 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -573,12 +573,13 @@ static int gfs2_adjust_quota(struct gfs2_inode *ip, loff_t loc,
 	struct inode *inode = &ip->i_inode;
 	struct address_space *mapping = inode->i_mapping;
 	unsigned long index = loc >> PAGE_CACHE_SHIFT;
-	unsigned offset = loc & (PAGE_CACHE_SHIFT - 1);
+	unsigned offset = loc & (PAGE_CACHE_SIZE - 1);
 	unsigned blocksize, iblock, pos;
 	struct buffer_head *bh;
 	struct page *page;
 	void *kaddr;
-	__be64 *ptr;
+	char *ptr;
+	struct gfs2_quota_host qp;
 	s64 value;
 	int err = -EIO;
 
@@ -620,8 +621,10 @@ static int gfs2_adjust_quota(struct gfs2_inode *ip, loff_t loc,
 
 	kaddr = kmap_atomic(page, KM_USER0);
 	ptr = kaddr + offset;
-	value = (s64)be64_to_cpu(*ptr) + change;
-	*ptr = cpu_to_be64(value);
+	gfs2_quota_in(&qp, ptr);
+	qp.qu_value += change;
+	value = qp.qu_value;
+	gfs2_quota_out(&qp, ptr);
 	flush_dcache_page(page);
 	kunmap_atomic(kaddr, KM_USER0);
 	err = 0;
diff --git a/include/linux/gfs2_ondisk.h b/include/linux/gfs2_ondisk.h
index 9ecf929..01cc359 100644
--- a/include/linux/gfs2_ondisk.h
+++ b/include/linux/gfs2_ondisk.h
@@ -519,6 +519,7 @@ extern void gfs2_rindex_out(const struct gfs2_rindex_host *ri, void *buf);
 extern void gfs2_rgrp_in(struct gfs2_rgrp_host *rg, const void *buf);
 extern void gfs2_rgrp_out(const struct gfs2_rgrp_host *rg, void *buf);
 extern void gfs2_quota_in(struct gfs2_quota_host *qu, const void *buf);
+extern void gfs2_quota_out(const struct gfs2_quota_host *qu, void *buf);
 struct gfs2_inode;
 extern void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf);
 extern void gfs2_ea_header_in(struct gfs2_ea_header *ea, const void *buf);
-- 
1.5.1.2

