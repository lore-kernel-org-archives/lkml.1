Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbZG3MrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbZG3MrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbZG3Mqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:46:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46424 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbZG3Mqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:46:45 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/7] GFS2: Fix panic in glock memory shrinker
Date: Thu, 30 Jul 2009 14:45:20 +0100
Message-Id: <1248961524-30913-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1248961524-30913-3-git-send-email-swhiteho@redhat.com>
References: <1248961524-30913-1-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-2-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-3-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

It is possible for gfs2_shrink_glock_memory() to check a glock for
demotion
that's in the process of being freed by gfs2_glock_put().  In this case,
gfs2_shrink_glock_memory() will acquire a new reference to this glock,
and
then try to free the glock itself when it drops the refernce.  To solve
this, gfs2_shrink_glock_memory() just needs to check if the glock is in
the process of being freed, and if so skip it without ever unlocking the
lru_lock.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Acked-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/glock.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index fdb796c..827136e 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1314,6 +1314,10 @@ static int gfs2_shrink_glock_memory(int nr, gfp_t gfp_mask)
 		list_del_init(&gl->gl_lru);
 		atomic_dec(&lru_count);
 
+		/* Check if glock is about to be freed */
+		if (atomic_read(&gl->gl_ref) == 0)
+			continue;
+
 		/* Test for being demotable */
 		if (!test_and_set_bit(GLF_LOCK, &gl->gl_flags)) {
 			gfs2_glock_hold(gl);
-- 
1.6.2.2

