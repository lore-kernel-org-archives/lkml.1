Return-Path: <linux-kernel-owner+w=401wt.eu-S1031657AbXEAKKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031657AbXEAKKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031658AbXEAKKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:10:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161199AbXEAKKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:10:02 -0400
Subject: [GFS2] Fix log entry list corruption [9/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org,
       "Benjamin E. Marzinski" <bmarzins@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:05:29 +0100
Message-Id: <1178013929.5462.144.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6883562588bc6c70776ecc396ee7eda36c2c8da9 Mon Sep 17 00:00:00 2001
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 23 Mar 2007 09:05:12 +0000
Subject: [PATCH] [GFS2] Fix log entry list corruption

When glock_lo_add and rg_lo_add attempt to add an element to the log, they
check to see if has already been added before locking the log. If another
process adds that element to the log in this window between the check and
locking the log, the element will be added to the list twice. This causes
the log element list to become corrupted in such a way that the log element
can never be successfully removed from the list. This patch pulls the
list_empty() check inside the log lock, to remove this window.

Signed-off-by: Benjamin E. Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 16bb4b4..f82d84d 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -33,16 +33,17 @@ static void glock_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 
 	tr->tr_touched = 1;
 
-	if (!list_empty(&le->le_list))
-		return;
-
 	gl = container_of(le, struct gfs2_glock, gl_le);
 	if (gfs2_assert_withdraw(sdp, gfs2_glock_is_held_excl(gl)))
 		return;
-	gfs2_glock_hold(gl);
-	set_bit(GLF_DIRTY, &gl->gl_flags);
 
 	gfs2_log_lock(sdp);
+	if (!list_empty(&le->le_list)){
+		gfs2_log_unlock(sdp);
+		return;
+	}
+	gfs2_glock_hold(gl);
+	set_bit(GLF_DIRTY, &gl->gl_flags);
 	sdp->sd_log_num_gl++;
 	list_add(&le->le_list, &sdp->sd_log_le_gl);
 	gfs2_log_unlock(sdp);
@@ -415,13 +416,14 @@ static void rg_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 
 	tr->tr_touched = 1;
 
-	if (!list_empty(&le->le_list))
-		return;
-
 	rgd = container_of(le, struct gfs2_rgrpd, rd_le);
-	gfs2_rgrp_bh_hold(rgd);
 
 	gfs2_log_lock(sdp);
+	if (!list_empty(&le->le_list)){
+		gfs2_log_unlock(sdp);
+		return;
+	}
+	gfs2_rgrp_bh_hold(rgd);
 	sdp->sd_log_num_rg++;
 	list_add(&le->le_list, &sdp->sd_log_le_rg);
 	gfs2_log_unlock(sdp);
-- 
1.5.1.2



