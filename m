Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYGKLGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYGKLGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbYGKLB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:01:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756625AbYGKLBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:54 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/18] [GFS2] Allow local DF locks when holding a cached EX glock
Date: Fri, 11 Jul 2008 11:11:16 +0100
Message-Id: <12157711153366-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12157711133727-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
 <1215771089769-git-send-email-swhiteho@redhat.com>
 <1215771091790-git-send-email-swhiteho@redhat.com>
 <12157710931623-git-send-email-swhiteho@redhat.com>
 <12157710954145-git-send-email-swhiteho@redhat.com>
 <12157710973601-git-send-email-swhiteho@redhat.com>
 <12157710983282-git-send-email-swhiteho@redhat.com>
 <12157711013356-git-send-email-swhiteho@redhat.com>
 <12157711023743-git-send-email-swhiteho@redhat.com>
 <12157711041157-git-send-email-swhiteho@redhat.com>
 <1215771106247-git-send-email-swhiteho@redhat.com>
 <12157711073280-git-send-email-swhiteho@redhat.com>
 <12157711093284-git-send-email-swhiteho@redhat.com>
 <12157711133727-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

We already allow local SH locks while we hold a cached EX glock, so here
we allow DF locks as well. This works only because we rely on the VFS's
invalidation for locally cached data, and because if we hold an EX lock,
then we know that no other node can be caching data relating to this
file.

It dramatically speeds up initial writes to O_DIRECT files since we fall
back to buffered I/O for this and would otherwise bounce between DF and
EX modes on each and every write call. The lessons to be learned from
that are to ensure that (for the time being anyway) O_DIRECT files are
preallocated and that they are written to using reasonably large I/O
sizes. Even so this change fixes that corner case nicely

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index cd0aa21..13391e5 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -267,8 +267,12 @@ static inline int may_grant(const struct gfs2_glock *gl, const struct gfs2_holde
 		return 1;
 	if (gh->gh_flags & GL_EXACT)
 		return 0;
-	if (gh->gh_state == LM_ST_SHARED && gl->gl_state == LM_ST_EXCLUSIVE)
-		return 1;
+	if (gl->gl_state == LM_ST_EXCLUSIVE) {
+		if (gh->gh_state == LM_ST_SHARED && gh_head->gh_state == LM_ST_SHARED)
+			return 1;
+		if (gh->gh_state == LM_ST_DEFERRED && gh_head->gh_state == LM_ST_DEFERRED)
+			return 1;
+	}
 	if (gl->gl_state != LM_ST_UNLOCKED && (gh->gh_flags & LM_FLAG_ANY))
 		return 1;
 	return 0;
-- 
1.5.1.2

