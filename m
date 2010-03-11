Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab0CKRdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:33:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933410Ab0CKRc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:32:56 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/3] GFS2: Allow the number of committed revokes to temporarily be negative
Date: Thu, 11 Mar 2010 17:22:00 +0000
Message-Id: <1268328121-10797-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1268328121-10797-2-git-send-email-swhiteho@redhat.com>
References: <1268328121-10797-1-git-send-email-swhiteho@redhat.com>
 <1268328121-10797-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

GFS2 tracks the number of revokes and unrevokes that are part of committed
transactions via sd_log_commited_revoke. It is possible for one process to add
revokes during its transaction, while another process unrevokes them during its
transaction. If the second process finishes its transaction first,
sd_log_commited_revoke will be decremented by the number of unrevokes that the
second process did, without first being incremented by the number of revokes
the first process did. This is fine, since all started transactions must be
completed before the journal can be flushed.  However, sd_log_commited_revoke
is an unsigned integer, and log_refund() causes an assertion failure if it
would go negative at the end of a transaction.  This patch makes
sd_log_commited_revoke a signed integer and allows it to go negative.
__gfs2_log_flush() still checks that it mataches the actual number of revokes.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/incore.h |    2 +-
 fs/gfs2/log.c    |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index b8025e5..3aac46f 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -616,7 +616,7 @@ struct gfs2_sbd {
 	unsigned int sd_log_blks_reserved;
 	unsigned int sd_log_commited_buf;
 	unsigned int sd_log_commited_databuf;
-	unsigned int sd_log_commited_revoke;
+	int sd_log_commited_revoke;
 
 	unsigned int sd_log_num_buf;
 	unsigned int sd_log_num_revoke;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 4511b08..e5bf4b5 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -417,7 +417,7 @@ static unsigned int calc_reserved(struct gfs2_sbd *sdp)
 	databufhdrs_needed = (sdp->sd_log_commited_databuf +
 			      (dbuf_limit - 1)) / dbuf_limit;
 
-	if (sdp->sd_log_commited_revoke)
+	if (sdp->sd_log_commited_revoke > 0)
 		revokes = gfs2_struct2blk(sdp, sdp->sd_log_commited_revoke,
 					  sizeof(u64));
 
@@ -790,7 +790,6 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	gfs2_assert_withdraw(sdp, (((int)sdp->sd_log_commited_buf) >= 0) ||
 			     (((int)sdp->sd_log_commited_databuf) >= 0));
 	sdp->sd_log_commited_revoke += tr->tr_num_revoke - tr->tr_num_revoke_rm;
-	gfs2_assert_withdraw(sdp, ((int)sdp->sd_log_commited_revoke) >= 0);
 	reserved = calc_reserved(sdp);
 	gfs2_assert_withdraw(sdp, sdp->sd_log_blks_reserved + tr->tr_reserved >= reserved);
 	unused = sdp->sd_log_blks_reserved - reserved + tr->tr_reserved;
-- 
1.6.2.5

