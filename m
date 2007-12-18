Return-Path: <linux-kernel-owner+w=401wt.eu-S1762715AbXLRSML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762715AbXLRSML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761371AbXLRSLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:11:51 -0500
Received: from styx.suse.cz ([82.119.242.94]:60732 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760909AbXLRSLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:11:50 -0500
Date: Tue, 18 Dec 2007 19:11:48 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Don't send quota messages repeatedly when hardlimit reached
Message-ID: <20071218181148.GH31091@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  attached patch makes sending of quota netlink messages behave the same
way as printing to console - i.e., we send a message when hardlimit is
reached and then send next message only when user gets below hardlimit.
This avoids flooding with message about hardlimit being reached... Andrew,
please apply. Thanks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

We should send quota message to netlink only once when hardlimit
is reached. Otherwise user could easily make the system busy by
trying to exceed the hardlimit (and also the messages could
be anoying if you cannot stop writing just now).

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/dquot.c b/fs/dquot.c
index 686ab63..cee7c6f 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -827,6 +827,18 @@ static inline void dquot_decr_space(struct dquot *dquot, qsize_t number)
 	clear_bit(DQ_BLKS_B, &dquot->dq_flags);
 }
 
+static int warning_issued(struct dquot *dquot, const int warntype)
+{
+	int flag = (warntype == QUOTA_NL_BHARDWARN ||
+		warntype == QUOTA_NL_BSOFTLONGWARN) ? DQ_BLKS_B :
+		((warntype == QUOTA_NL_IHARDWARN ||
+		warntype == QUOTA_NL_ISOFTLONGWARN) ? DQ_INODES_B : 0);
+
+	if (!flag)
+		return 0;
+	return test_and_set_bit(flag, &dquot->dq_flags);
+}
+
 #ifdef CONFIG_PRINT_QUOTA_WARNING
 static int flag_print_warnings = 1;
 
@@ -845,16 +857,12 @@ static inline int need_print_warning(struct dquot *dquot)
 }
 
 /* Print warning to user which exceeded quota */
-static void print_warning(struct dquot *dquot, const char warntype)
+static void print_warning(struct dquot *dquot, const int warntype)
 {
 	char *msg = NULL;
 	struct tty_struct *tty;
-	int flag = (warntype == QUOTA_NL_BHARDWARN ||
-		warntype == QUOTA_NL_BSOFTLONGWARN) ? DQ_BLKS_B :
-		((warntype == QUOTA_NL_IHARDWARN ||
-		warntype == QUOTA_NL_ISOFTLONGWARN) ? DQ_INODES_B : 0);
 
-	if (!need_print_warning(dquot) || (flag && test_and_set_bit(flag, &dquot->dq_flags)))
+	if (!need_print_warning(dquot))
 		return;
 
 	mutex_lock(&tty_mutex);
@@ -970,7 +977,8 @@ static inline void flush_warnings(struct dquot * const *dquots, char *warntype)
 	int i;
 
 	for (i = 0; i < MAXQUOTAS; i++)
-		if (dquots[i] != NODQUOT && warntype[i] != QUOTA_NL_NOWARN) {
+		if (dquots[i] != NODQUOT && warntype[i] != QUOTA_NL_NOWARN &&
+		    !warning_issued(dquots[i], warntype[i])) {
 #ifdef CONFIG_PRINT_QUOTA_WARNING
 			print_warning(dquots[i], warntype[i]);
 #endif
