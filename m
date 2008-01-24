Return-Path: <linux-kernel-owner+w=401wt.eu-S1759348AbYAXRCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbYAXRCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758320AbYAXQ6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbYAXQ6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:38 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 12/19] dlm: reject messages from non-members
Date: Thu, 24 Jan 2008 10:50:35 -0600
Message-Id: <1201193442-8260-13-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Messages from nodes that are no longer members of the lockspace should be
ignored.  When nodes are removed from the lockspace, recovery can
sometimes complete quickly enough that messages arrive from a removed node
after recovery has completed.  When processed, these messages would often
cause an error message, and could in some cases change some state, causing
problems.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c   |    9 ++++++++-
 fs/dlm/member.c |    4 ++--
 fs/dlm/member.h |    3 ++-
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index d5e8ea1..c3b9fca 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1,7 +1,7 @@
 /******************************************************************************
 *******************************************************************************
 **
-**  Copyright (C) 2005-2007 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2005-2008 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -3643,6 +3643,13 @@ static void receive_lookup_reply(struct dlm_ls *ls, struct dlm_message *ms)
 
 static void _receive_message(struct dlm_ls *ls, struct dlm_message *ms)
 {
+	if (!dlm_is_member(ls, ms->m_header.h_nodeid)) {
+		log_debug(ls, "ignore non-member message %d from %d %x %x %d",
+			  ms->m_type, ms->m_header.h_nodeid, ms->m_lkid,
+			  ms->m_remid, ms->m_result);
+		return;
+	}
+
 	switch (ms->m_type) {
 
 	/* messages sent to a master node */
diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index e9cdcab..fa17f5a 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -1,7 +1,7 @@
 /******************************************************************************
 *******************************************************************************
 **
-**  Copyright (C) 2005-2007 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2005-2008 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -70,7 +70,7 @@ static void dlm_remove_member(struct dlm_ls *ls, struct dlm_member *memb)
 	ls->ls_num_nodes--;
 }
 
-static int dlm_is_member(struct dlm_ls *ls, int nodeid)
+int dlm_is_member(struct dlm_ls *ls, int nodeid)
 {
 	struct dlm_member *memb;
 
diff --git a/fs/dlm/member.h b/fs/dlm/member.h
index 927c08c..7a26fca 100644
--- a/fs/dlm/member.h
+++ b/fs/dlm/member.h
@@ -1,7 +1,7 @@
 /******************************************************************************
 *******************************************************************************
 **
-**  Copyright (C) 2005 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2005-2008 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -19,6 +19,7 @@ void dlm_clear_members(struct dlm_ls *ls);
 void dlm_clear_members_gone(struct dlm_ls *ls);
 int dlm_recover_members(struct dlm_ls *ls, struct dlm_recover *rv,int *neg_out);
 int dlm_is_removed(struct dlm_ls *ls, int nodeid);
+int dlm_is_member(struct dlm_ls *ls, int nodeid);
 
 #endif                          /* __MEMBER_DOT_H__ */
 
-- 
1.5.3.3

