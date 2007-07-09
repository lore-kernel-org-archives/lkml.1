Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbXGIQi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbXGIQi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758013AbXGIQYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757961AbXGIQYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:34 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Simplify multiple glock aquisition
Date: Mon,  9 Jul 2007 17:02:51 +0100
Message-Id: <11839970793713-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970773694-git-send-email-swhiteho@redhat.com>
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
 <11839970383020-git-send-email-swhiteho@redhat.com>
 <11839970403929-git-send-email-swhiteho@redhat.com>
 <11839970421091-git-send-email-swhiteho@redhat.com>
 <11839970442448-git-send-email-swhiteho@redhat.com>
 <11839970463325-git-send-email-swhiteho@redhat.com>
 <11839970481383-git-send-email-swhiteho@redhat.com>
 <1183997050365-git-send-email-swhiteho@redhat.com>
 <11839970521835-git-send-email-swhiteho@redhat.com>
 <11839970542719-git-send-email-swhiteho@redhat.com>
 <1183997056121-git-send-email-swhiteho@redhat.com>
 <11839970573954-git-send-email-swhiteho@redhat.com>
 <11839970591207-git-send-email-swhiteho@redhat.com>
 <11839970611456-git-send-email-swhiteho@redhat.com>
 <11839970633982-git-send-email-swhiteho@redhat.com>
 <11839970653759-git-send-email-swhiteho@redhat.com>
 <1183997067333-git-send-email-swhiteho@redhat.com>
 <11839970691406-git-send-email-swhiteho@redhat.com>
 <11839970711372-git-send-email-swhiteho@redhat.com>
 <1183997073435-git-send-email-swhiteho@redhat.com>
 <11839970752058-git-send-email-swhiteho@redhat.com>
 <11839970773694-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

There is a bug in the code which acquires multiple glocks where if the
initial out-of-order attempt fails part way though we can land up trying
to acquire the wrong number of glocks. This is part of the fix for red
hat bz #239737. The other part of the bz doesn't apply to upstream
kernels since it was fixed by:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d3717bdf8f08a0e1039158c8bab2c24d20f492b6

Since the out-of-order code doesn't appear to add anything to the
performance of GFS2, this patch just removed it rather than trying to
fix it. It should be much easier to see whats going on here now. In
addition, we don't allocate any memory unless we are using a lot of
glocks (which is a relatively uncommon case).

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 384cae6..3f0974e 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1327,10 +1327,6 @@ static int nq_m_sync(unsigned int num_gh, struct gfs2_holder *ghs,
  * @num_gh: the number of structures
  * @ghs: an array of struct gfs2_holder structures
  *
- * Figure out how big an impact this function has.  Either:
- * 1) Replace this code with code that calls gfs2_glock_prefetch()
- * 2) Forget async stuff and just call nq_m_sync()
- * 3) Leave it like it is
  *
  * Returns: 0 on success (all glocks acquired),
  *          errno on failure (no glocks acquired)
@@ -1338,62 +1334,28 @@ static int nq_m_sync(unsigned int num_gh, struct gfs2_holder *ghs,
 
 int gfs2_glock_nq_m(unsigned int num_gh, struct gfs2_holder *ghs)
 {
-	int *e;
-	unsigned int x;
-	int borked = 0, serious = 0;
+	struct gfs2_holder *tmp[4];
+	struct gfs2_holder **pph = tmp;
 	int error = 0;
 
-	if (!num_gh)
+	switch(num_gh) {
+	case 0:
 		return 0;
-
-	if (num_gh == 1) {
+	case 1:
 		ghs->gh_flags &= ~(LM_FLAG_TRY | GL_ASYNC);
 		return gfs2_glock_nq(ghs);
-	}
-
-	e = kcalloc(num_gh, sizeof(struct gfs2_holder *), GFP_KERNEL);
-	if (!e)
-		return -ENOMEM;
-
-	for (x = 0; x < num_gh; x++) {
-		ghs[x].gh_flags |= LM_FLAG_TRY | GL_ASYNC;
-		error = gfs2_glock_nq(&ghs[x]);
-		if (error) {
-			borked = 1;
-			serious = error;
-			num_gh = x;
+	default:
+		if (num_gh <= 4)
 			break;
-		}
+		pph = kmalloc(num_gh * sizeof(struct gfs2_holder *), GFP_NOFS);
+		if (!pph)
+			return -ENOMEM;
 	}
 
-	for (x = 0; x < num_gh; x++) {
-		error = e[x] = glock_wait_internal(&ghs[x]);
-		if (error) {
-			borked = 1;
-			if (error != GLR_TRYFAILED && error != GLR_CANCELED)
-				serious = error;
-		}
-	}
-
-	if (!borked) {
-		kfree(e);
-		return 0;
-	}
-
-	for (x = 0; x < num_gh; x++)
-		if (!e[x])
-			gfs2_glock_dq(&ghs[x]);
-
-	if (serious)
-		error = serious;
-	else {
-		for (x = 0; x < num_gh; x++)
-			gfs2_holder_reinit(ghs[x].gh_state, ghs[x].gh_flags,
-					  &ghs[x]);
-		error = nq_m_sync(num_gh, ghs, (struct gfs2_holder **)e);
-	}
+	error = nq_m_sync(num_gh, ghs, pph);
 
-	kfree(e);
+	if (pph != tmp)
+		kfree(pph);
 
 	return error;
 }
-- 
1.5.1.2

