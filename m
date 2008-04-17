Return-Path: <linux-kernel-owner+w=401wt.eu-S934726AbYDQJj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726AbYDQJj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763409AbYDQJZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933393AbYDQJZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:38 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/48] [GFS2] Get rid of gl_waiters2
Date: Thu, 17 Apr 2008 09:38:48 +0100
Message-Id: <12084215931509-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084215913125-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch reduces memory by replacing the int variable
gl_waiters2 by a single bit in the gl_flags.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index befcda0..951cb91 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -595,11 +595,12 @@ static void run_queue(struct gfs2_glock *gl)
 			blocked = rq_mutex(gh);
 		} else if (test_bit(GLF_DEMOTE, &gl->gl_flags)) {
 			blocked = rq_demote(gl);
-			if (gl->gl_waiters2 && !blocked) {
+			if (test_bit(GLF_WAITERS2, &gl->gl_flags) &&
+				     !blocked) {
 				set_bit(GLF_DEMOTE, &gl->gl_flags);
 				gl->gl_demote_state = LM_ST_UNLOCKED;
 			}
-			gl->gl_waiters2 = 0;
+			clear_bit(GLF_WAITERS2, &gl->gl_flags);
 		} else if (!list_empty(&gl->gl_waiters3)) {
 			gh = list_entry(gl->gl_waiters3.next,
 					struct gfs2_holder, gh_list);
@@ -710,7 +711,7 @@ static void handle_callback(struct gfs2_glock *gl, unsigned int state,
 	} else if (gl->gl_demote_state != LM_ST_UNLOCKED &&
 			gl->gl_demote_state != state) {
 		if (test_bit(GLF_DEMOTE_IN_PROGRESS,  &gl->gl_flags)) 
-			gl->gl_waiters2 = 1;
+			set_bit(GLF_WAITERS2, &gl->gl_flags);
 		else 
 			gl->gl_demote_state = LM_ST_UNLOCKED;
 	}
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 39bab7b..fe14f6a 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -167,6 +167,7 @@ enum {
 	GLF_DIRTY		= 5,
 	GLF_DEMOTE_IN_PROGRESS	= 6,
 	GLF_LFLUSH		= 7,
+	GLF_WAITERS2		= 8,
 };
 
 struct gfs2_glock {
@@ -186,7 +187,6 @@ struct gfs2_glock {
 	struct list_head gl_holders;
 	struct list_head gl_waiters1;	/* HIF_MUTEX */
 	struct list_head gl_waiters3;	/* HIF_PROMOTE */
-	int gl_waiters2;		/* GIF_DEMOTE */
 
 	const struct gfs2_glock_operations *gl_ops;
 
-- 
1.5.1.2

