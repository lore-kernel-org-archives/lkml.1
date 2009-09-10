Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbZIJKaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbZIJKaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZIJKaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:30:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755514AbZIJKaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:30:06 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/15] GFS2: Remove unused sysfs file
Date: Thu, 10 Sep 2009 12:28:07 +0100
Message-Id: <1252582087-10007-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1252582087-10007-15-git-send-email-swhiteho@redhat.com>
References: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-2-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-3-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-4-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-5-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-6-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-7-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-8-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-9-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-10-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-11-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-12-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-13-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-14-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-15-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The /sys/fs/gfs2/<fsname>/lock_module/id file has been unused for
some time now, so we can remove it. We still accept the mount option
though, as userspace still sends that.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/incore.h     |    1 -
 fs/gfs2/ops_fstype.c |    6 +-----
 fs/gfs2/sys.c        |    8 --------
 3 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 52436ab..6edb423 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -496,7 +496,6 @@ struct gfs2_sb_host {
  */
 
 struct lm_lockstruct {
-	u32 ls_id;
 	unsigned int ls_jid;
 	unsigned int ls_first;
 	unsigned int ls_first_done;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 8e3f00e..52fb6c0 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1028,7 +1028,6 @@ static int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
 
 	ls->ls_ops = lm;
 	ls->ls_first = 1;
-	ls->ls_id = 0;
 
 	for (options = args->ar_hostdata; (o = strsep(&options, ":")); ) {
 		substring_t tmp[MAX_OPT_ARGS];
@@ -1046,10 +1045,7 @@ static int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
 			ls->ls_jid = option;
 			break;
 		case Opt_id:
-			ret = match_int(&tmp[0], &option);
-			if (ret)
-				goto hostdata_error;
-			ls->ls_id = option;
+			/* Obsolete, but left for backward compat purposes */
 			break;
 		case Opt_first:
 			ret = match_int(&tmp[0], &option);
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 0d4f7e9..4463297 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -320,12 +320,6 @@ static ssize_t block_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 	return ret;
 }
 
-static ssize_t lkid_show(struct gfs2_sbd *sdp, char *buf)
-{
-	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	return sprintf(buf, "%u\n", ls->ls_id);
-}
-
 static ssize_t lkfirst_show(struct gfs2_sbd *sdp, char *buf)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
@@ -390,7 +384,6 @@ static struct gfs2_attr gdlm_attr_##_name = __ATTR(_name,_mode,_show,_store)
 GDLM_ATTR(proto_name,		0444, proto_name_show,		NULL);
 GDLM_ATTR(block,		0644, block_show,		block_store);
 GDLM_ATTR(withdraw,		0644, withdraw_show,		withdraw_store);
-GDLM_ATTR(id,			0444, lkid_show,		NULL);
 GDLM_ATTR(jid,			0444, jid_show,			NULL);
 GDLM_ATTR(first,		0444, lkfirst_show,		NULL);
 GDLM_ATTR(first_done,		0444, first_done_show,		NULL);
@@ -402,7 +395,6 @@ static struct attribute *lock_module_attrs[] = {
 	&gdlm_attr_proto_name.attr,
 	&gdlm_attr_block.attr,
 	&gdlm_attr_withdraw.attr,
-	&gdlm_attr_id.attr,
 	&gdlm_attr_jid.attr,
 	&gdlm_attr_first.attr,
 	&gdlm_attr_first_done.attr,
-- 
1.6.2.5

