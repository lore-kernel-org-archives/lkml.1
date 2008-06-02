Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYFBRLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYFBRLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYFBRLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:11:15 -0400
Received: from styx.suse.cz ([82.119.242.94]:55185 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753049AbYFBRLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:11:14 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] quota: Remove use of info_any_dirty()
Date: Mon,  2 Jun 2008 19:11:07 +0200
Message-Id: <12124266712838-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12124266711334-git-send-email-jack@suse.cz>
References: y
 <12124266712214-git-send-email-jack@suse.cz>
 <12124266711334-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is only a single place which uses info_any_dirty() and that
is a trivial macro, just remove the use of this macro completely.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota.c            |    7 +++++--
 include/linux/quota.h |    2 --
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/quota.c b/fs/quota.c
index db1cc9f..f0702f4 100644
--- a/fs/quota.c
+++ b/fs/quota.c
@@ -199,8 +199,11 @@ restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
 		/* This test just improves performance so it needn't be reliable... */
 		for (cnt = 0, dirty = 0; cnt < MAXQUOTAS; cnt++)
-			if ((type == cnt || type == -1) && sb_has_quota_enabled(sb, cnt)
-			    && info_any_dirty(&sb_dqopt(sb)->info[cnt]))
+			if ((type == cnt || type == -1)
+			    && sb_has_quota_enabled(sb, cnt)
+			    && (info_dirty(&sb_dqopt(sb)->info[cnt])
+				|| !list_empty(&sb_dqopt(sb)->
+					info[cnt].dqi_dirty_list)))
 				dirty = 1;
 		if (!dirty)
 			continue;
diff --git a/include/linux/quota.h b/include/linux/quota.h
index dcddfb2..6f1d97d 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -224,8 +224,6 @@ struct super_block;
 
 extern void mark_info_dirty(struct super_block *sb, int type);
 #define info_dirty(info) test_bit(DQF_INFO_DIRTY_B, &(info)->dqi_flags)
-#define info_any_dquot_dirty(info) (!list_empty(&(info)->dqi_dirty_list))
-#define info_any_dirty(info) (info_dirty(info) || info_any_dquot_dirty(info))
 
 #define sb_dqopt(sb) (&(sb)->s_dquot)
 #define sb_dqinfo(sb, type) (sb_dqopt(sb)->info+(type))
-- 
1.5.2.4

