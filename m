Return-Path: <linux-kernel-owner+w=401wt.eu-S969817AbXFHRsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969817AbXFHRsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969286AbXFHRs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:48:27 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48983 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965780AbXFHRs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:48:26 -0400
Date: Fri, 8 Jun 2007 10:48:16 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [git patches] ocfs2 fixes
Message-ID: <20070608174816.GG20632@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/aops.c            |   20 ++++++++++----------
 fs/ocfs2/cluster/masklog.c |    3 +--
 2 files changed, 11 insertions(+), 12 deletions(-)

Mark Fasheh:
      ocfs2: Fix invalid assertion during write on 64k pages

Tiger Yang:
      ocfs2: Fix masklog breakage

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 0023b31..a480b09 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -798,6 +798,11 @@ int ocfs2_map_and_write_splice_data(stru
 	}
 	to = from + bytes;
 
+	BUG_ON(from > PAGE_CACHE_SIZE);
+	BUG_ON(to > PAGE_CACHE_SIZE);
+	BUG_ON(from < cluster_start);
+	BUG_ON(to > cluster_end);
+
 	if (wc->w_this_page_new)
 		ret = ocfs2_map_page_blocks(wc->w_this_page, p_blkno, inode,
 					    cluster_start, cluster_end, 1);
@@ -809,11 +814,6 @@ int ocfs2_map_and_write_splice_data(stru
 		goto out;
 	}
 
-	BUG_ON(from > PAGE_CACHE_SIZE);
-	BUG_ON(to > PAGE_CACHE_SIZE);
-	BUG_ON(from > osb->s_clustersize);
-	BUG_ON(to > osb->s_clustersize);
-
 	src = buf->ops->map(sp->s_pipe, buf, 1);
 	dst = kmap_atomic(wc->w_this_page, KM_USER1);
 	memcpy(dst + from, src + src_from, bytes);
@@ -890,6 +890,11 @@ int ocfs2_map_and_write_user_data(struct
 
 	to = from + bytes;
 
+	BUG_ON(from > PAGE_CACHE_SIZE);
+	BUG_ON(to > PAGE_CACHE_SIZE);
+	BUG_ON(from < cluster_start);
+	BUG_ON(to > cluster_end);
+
 	if (wc->w_this_page_new)
 		ret = ocfs2_map_page_blocks(wc->w_this_page, p_blkno, inode,
 					    cluster_start, cluster_end, 1);
@@ -901,11 +906,6 @@ int ocfs2_map_and_write_user_data(struct
 		goto out;
 	}
 
-	BUG_ON(from > PAGE_CACHE_SIZE);
-	BUG_ON(to > PAGE_CACHE_SIZE);
-	BUG_ON(from > osb->s_clustersize);
-	BUG_ON(to > osb->s_clustersize);
-
 	dst = kmap(wc->w_this_page);
 	memcpy(dst + from, bp->b_src_buf + src_from, bytes);
 	kunmap(wc->w_this_page);
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index a93620c..2b205f5 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -144,8 +144,7 @@ static struct kobj_type mlog_ktype = {
 };
 
 static struct kset mlog_kset = {
-	.kobj  = {.name = "logmask"},
-	.ktype = &mlog_ktype
+	.kobj   = {.name = "logmask", .ktype = &mlog_ktype},
 };
 
 int mlog_sys_init(struct kset *o2cb_subsys)
