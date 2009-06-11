Return-Path: <linux-kernel-owner+w=401wt.eu-S1760728AbZFKPaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbZFKPaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499AbZFKP3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:29:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55891 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbZFKP3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:29:19 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Christine Caulfield <ccaulfie@redhat.com>
Subject: [PATCH 3/4] dlm: connect to nodes earlier
Date: Thu, 11 Jun 2009 10:20:48 -0500
Message-Id: <1244733649-26003-4-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christine Caulfield <ccaulfie@redhat.com>

Make network connections to other nodes earlier, in the context of
dlm_recoverd.  This avoids connecting to nodes from dlm_send where we
try to avoid allocations which could possibly deadlock if memory reclaim
goes into the cluster fs which may try to do a dlm operation.

Signed-off-by: Christine Caulfield <ccaulfie@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lowcomms.c |   16 +++++++++++++++-
 fs/dlm/lowcomms.h |    3 ++-
 fs/dlm/member.c   |   11 +++++++++--
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 609108a..2559a97 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -309,6 +309,20 @@ static void lowcomms_state_change(struct sock *sk)
 		lowcomms_write_space(sk);
 }
 
+int dlm_lowcomms_connect_node(int nodeid)
+{
+	struct connection *con;
+
+	if (nodeid == dlm_our_nodeid())
+		return 0;
+
+	con = nodeid2con(nodeid, GFP_NOFS);
+	if (!con)
+		return -ENOMEM;
+	lowcomms_connect_sock(con);
+	return 0;
+}
+
 /* Make a socket active */
 static int add_sock(struct socket *sock, struct connection *con)
 {
@@ -1421,7 +1435,7 @@ static int work_start(void)
 static void stop_conn(struct connection *con)
 {
 	con->flags |= 0x0F;
-	if (con->sock)
+	if (con->sock && con->sock->sk)
 		con->sock->sk->sk_user_data = NULL;
 }
 
diff --git a/fs/dlm/lowcomms.h b/fs/dlm/lowcomms.h
index a9a9618..1311e64 100644
--- a/fs/dlm/lowcomms.h
+++ b/fs/dlm/lowcomms.h
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2009 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -19,6 +19,7 @@ void dlm_lowcomms_stop(void);
 int dlm_lowcomms_close(int nodeid);
 void *dlm_lowcomms_get_buffer(int nodeid, int len, gfp_t allocation, char **ppc);
 void dlm_lowcomms_commit_buffer(void *mh);
+int dlm_lowcomms_connect_node(int nodeid);
 
 #endif				/* __LOWCOMMS_DOT_H__ */
 
diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index 26133f0..2afb770 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -1,7 +1,7 @@
 /******************************************************************************
 *******************************************************************************
 **
-**  Copyright (C) 2005-2008 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2005-2009 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -17,6 +17,7 @@
 #include "recover.h"
 #include "rcom.h"
 #include "config.h"
+#include "lowcomms.h"
 
 static void add_ordered_member(struct dlm_ls *ls, struct dlm_member *new)
 {
@@ -45,7 +46,7 @@ static void add_ordered_member(struct dlm_ls *ls, struct dlm_member *new)
 static int dlm_add_member(struct dlm_ls *ls, int nodeid)
 {
 	struct dlm_member *memb;
-	int w;
+	int w, error;
 
 	memb = kzalloc(sizeof(struct dlm_member), GFP_KERNEL);
 	if (!memb)
@@ -57,6 +58,12 @@ static int dlm_add_member(struct dlm_ls *ls, int nodeid)
 		return w;
 	}
 
+	error = dlm_lowcomms_connect_node(nodeid);
+	if (error < 0) {
+		kfree(memb);
+		return error;
+	}
+
 	memb->nodeid = nodeid;
 	memb->weight = w;
 	add_ordered_member(ls, memb);
-- 
1.5.5.6

