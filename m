Return-Path: <linux-kernel-owner+w=401wt.eu-S934730AbZKYNcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934730AbZKYNcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934706AbZKYNcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:32:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933704AbZKYN2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:05 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/30] GFS2: Fix potential race in glock code
Date: Wed, 25 Nov 2009 14:22:26 +0000
Message-Id: <1259158975-28499-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-1-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to be careful of the ordering between clearing the
GLF_LOCK bit and scheduling the workqueue.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/glock.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 8b674b1..a3f90ad 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -672,12 +672,17 @@ out:
 	return;
 
 out_sched:
+	clear_bit(GLF_LOCK, &gl->gl_flags);
+	smp_mb__after_clear_bit();
 	gfs2_glock_hold(gl);
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
 		gfs2_glock_put_nolock(gl);
+	return;
+
 out_unlock:
 	clear_bit(GLF_LOCK, &gl->gl_flags);
-	goto out;
+	smp_mb__after_clear_bit();
+	return;
 }
 
 static void delete_work_func(struct work_struct *work)
@@ -1375,10 +1380,11 @@ static int gfs2_shrink_glock_memory(int nr, gfp_t gfp_mask)
 				handle_callback(gl, LM_ST_UNLOCKED, 0);
 				nr--;
 			}
+			clear_bit(GLF_LOCK, &gl->gl_flags);
+			smp_mb__after_clear_bit();
 			if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
 				gfs2_glock_put_nolock(gl);
 			spin_unlock(&gl->gl_spin);
-			clear_bit(GLF_LOCK, &gl->gl_flags);
 			spin_lock(&lru_lock);
 			continue;
 		}
-- 
1.6.2.5

