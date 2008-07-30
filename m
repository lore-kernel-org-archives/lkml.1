Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbYG3Xc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbYG3Xc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbYG3XcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:32:06 -0400
Received: from mx1.suse.de ([195.135.220.2]:35302 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847AbYG3XcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:32:04 -0400
Date: Wed, 30 Jul 2008 16:26:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>
Subject: [patch 01/29] quota: fix possible infinite loop in quota code
Message-ID: <20080730232639.GB30670@suse.de>
References: <20080730231003.655833364@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="quota-fix-possible-infinite-loop-in-quota-code.patch"
In-Reply-To: <20080730232451.GA30670@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Jan Kara <jack@suse.cz>

commit b48d380541f634663b71766005838edbb7261685 upstream

When quota structure is going to be dropped and it is dirty, quota code tries
to write it.  If the write fails for some reason (e.  g.  transaction cannot
be started because the journal is aborted), we try writing again and again and
again...  Fix the problem by clearing the dirty bit even if the write failed.

(akpm: for 2.6.27, 2.6.26.x and 2.6.25.x)

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: dingdinghua <dingdinghua85@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/dquot.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -554,6 +554,8 @@ static struct shrinker dqcache_shrinker 
  */
 static void dqput(struct dquot *dquot)
 {
+	int ret;
+
 	if (!dquot)
 		return;
 #ifdef __DQUOT_PARANOIA
@@ -586,7 +588,19 @@ we_slept:
 	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags) && dquot_dirty(dquot)) {
 		spin_unlock(&dq_list_lock);
 		/* Commit dquot before releasing */
-		dquot->dq_sb->dq_op->write_dquot(dquot);
+		ret = dquot->dq_sb->dq_op->write_dquot(dquot);
+		if (ret < 0) {
+			printk(KERN_ERR "VFS: cannot write quota structure on "
+				"device %s (error %d). Quota may get out of "
+				"sync!\n", dquot->dq_sb->s_id, ret);
+			/*
+			 * We clear dirty bit anyway, so that we avoid
+			 * infinite loop here
+			 */
+			spin_lock(&dq_list_lock);
+			clear_dquot_dirty(dquot);
+			spin_unlock(&dq_list_lock);
+		}
 		goto we_slept;
 	}
 	/* Clear flag in case dquot was inactive (something bad happened) */

-- 
