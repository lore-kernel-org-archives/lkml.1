Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbYLWQOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbYLWQOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYLWQNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:13:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48931 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYLWQNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:13:04 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/10] dlm: fix up memory allocation flags
Date: Tue, 23 Dec 2008 10:58:34 -0600
Message-Id: <1230051523-5478-2-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Use ls_allocation for memory allocations, which a cluster fs sets to
GFP_NOFS.  Use GFP_NOFS for allocations when no lockspace struct is
available.  Taking dlm locks needs to avoid calling back into the
cluster fs because write-out can require taking dlm locks.

Cc: Christine Caulfield <ccaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lowcomms.c |    1 +
 fs/dlm/memory.c   |    6 +++---
 fs/dlm/midcomms.c |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 3962262..1e72031 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -295,6 +295,7 @@ static int add_sock(struct socket *sock, struct connection *con)
 	con->sock->sk->sk_write_space = lowcomms_write_space;
 	con->sock->sk->sk_state_change = lowcomms_state_change;
 	con->sock->sk->sk_user_data = con;
+	con->sock->sk->sk_allocation = GFP_NOFS;
 	return 0;
 }
 
diff --git a/fs/dlm/memory.c b/fs/dlm/memory.c
index 54c14c6..c1775b8 100644
--- a/fs/dlm/memory.c
+++ b/fs/dlm/memory.c
@@ -39,7 +39,7 @@ char *dlm_allocate_lvb(struct dlm_ls *ls)
 {
 	char *p;
 
-	p = kzalloc(ls->ls_lvblen, GFP_KERNEL);
+	p = kzalloc(ls->ls_lvblen, ls->ls_allocation);
 	return p;
 }
 
@@ -57,7 +57,7 @@ struct dlm_rsb *dlm_allocate_rsb(struct dlm_ls *ls, int namelen)
 
 	DLM_ASSERT(namelen <= DLM_RESNAME_MAXLEN,);
 
-	r = kzalloc(sizeof(*r) + namelen, GFP_KERNEL);
+	r = kzalloc(sizeof(*r) + namelen, ls->ls_allocation);
 	return r;
 }
 
@@ -72,7 +72,7 @@ struct dlm_lkb *dlm_allocate_lkb(struct dlm_ls *ls)
 {
 	struct dlm_lkb *lkb;
 
-	lkb = kmem_cache_zalloc(lkb_cache, GFP_KERNEL);
+	lkb = kmem_cache_zalloc(lkb_cache, ls->ls_allocation);
 	return lkb;
 }
 
diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 07ac709..f3396c6 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -112,7 +112,7 @@ int dlm_process_incoming_buffer(int nodeid, const void *base,
 		   ordinary messages). */
 
 		if (msglen > sizeof(__tmp) && p == &__tmp.p) {
-			p = kmalloc(dlm_config.ci_buffer_size, GFP_KERNEL);
+			p = kmalloc(dlm_config.ci_buffer_size, GFP_NOFS);
 			if (p == NULL)
 				return ret;
 		}
-- 
1.5.5.1

