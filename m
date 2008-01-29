Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbYA2WId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbYA2WId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYA2WIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:08:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbYA2WIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:08:24 -0500
Date: Tue, 29 Jan 2008 16:00:04 -0600
From: David Teigland <teigland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, fabbione@ubuntu.com
Subject: Re: [PATCH 07/19] dlm: swap bytes for rcom lock reply
Message-ID: <20080129220004.GB28690@redhat.com>
References: <1201193442-8260-8-git-send-email-teigland@redhat.com> <20080126220029.98dc3826.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126220029.98dc3826.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 10:00:29PM -0800, Andrew Morton wrote:
> > On Thu, 24 Jan 2008 10:50:30 -0600 David Teigland <teigland@redhat.com> wrote:
> >  void dlm_rcom_in(struct dlm_rcom *rc)
> >  {
> >  	struct dlm_header *hd = (struct dlm_header *) rc;
> 
> aww, c'mon guys, this is nonsense.
> 
> 	struct dlm_header *hd = &rc->rc_header;
> 
> there seems to be rather a lot of this unnecessary casting going on in dlm. 
> Please do a hunt-and-exterminate.

Most of the casting appears to involve either rc_buf in dlm_rcom, or
lkb_astparam in dlm_lkb.  I don't see a way of changing the former, but a
union might improve the latter.  I'll work on another patch for astparam,
but here's a quick one covering what's above.


>From 6bbb692117ff86d5a22a154b2b16bf16b8753629 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Tue, 29 Jan 2008 14:52:10 -0600
Subject: [PATCH] dlm: clean ups

A couple small clean-ups.  Remove unnecessary wrapper-functions in
rcom.c, and remove unnecessary casting and an unnecessary ASSERT in
util.c.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/rcom.c |   25 +++++--------------------
 fs/dlm/util.c |   16 +++++-----------
 2 files changed, 10 insertions(+), 31 deletions(-)

diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index ae2fd97..026824c 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2005-2007 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2005-2008 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -197,11 +197,6 @@ static void receive_sync_reply(struct dlm_ls *ls, struct dlm_rcom *rc_in)
 	spin_unlock(&ls->ls_rcom_spin);
 }
 
-static void receive_rcom_status_reply(struct dlm_ls *ls, struct dlm_rcom *rc_in)
-{
-	receive_sync_reply(ls, rc_in);
-}
-
 int dlm_rcom_names(struct dlm_ls *ls, int nodeid, char *last_name, int last_len)
 {
 	struct dlm_rcom *rc;
@@ -254,11 +249,6 @@ static void receive_rcom_names(struct dlm_ls *ls, struct dlm_rcom *rc_in)
 	send_rcom(ls, mh, rc);
 }
 
-static void receive_rcom_names_reply(struct dlm_ls *ls, struct dlm_rcom *rc_in)
-{
-	receive_sync_reply(ls, rc_in);
-}
-
 int dlm_send_rcom_lookup(struct dlm_rsb *r, int dir_nodeid)
 {
 	struct dlm_rcom *rc;
@@ -381,11 +371,6 @@ static void receive_rcom_lock(struct dlm_ls *ls, struct dlm_rcom *rc_in)
 	send_rcom(ls, mh, rc);
 }
 
-static void receive_rcom_lock_reply(struct dlm_ls *ls, struct dlm_rcom *rc_in)
-{
-	dlm_recover_process_copy(ls, rc_in);
-}
-
 /* If the lockspace doesn't exist then still send a status message
    back; it's possible that it just doesn't have its global_id yet. */
 
@@ -481,11 +466,11 @@ void dlm_receive_rcom(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
 		break;
 
 	case DLM_RCOM_STATUS_REPLY:
-		receive_rcom_status_reply(ls, rc);
+		receive_sync_reply(ls, rc);
 		break;
 
 	case DLM_RCOM_NAMES_REPLY:
-		receive_rcom_names_reply(ls, rc);
+		receive_sync_reply(ls, rc);
 		break;
 
 	case DLM_RCOM_LOOKUP_REPLY:
@@ -493,11 +478,11 @@ void dlm_receive_rcom(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
 		break;
 
 	case DLM_RCOM_LOCK_REPLY:
-		receive_rcom_lock_reply(ls, rc);
+		dlm_recover_process_copy(ls, rc);
 		break;
 
 	default:
-		DLM_ASSERT(0, printk("rc_type=%x\n", rc->rc_type););
+		log_error(ls, "receive_rcom bad type %d", rc->rc_type);
 	}
  out:
 	return;
diff --git a/fs/dlm/util.c b/fs/dlm/util.c
index 11c6a45..4d9c1f4 100644
--- a/fs/dlm/util.c
+++ b/fs/dlm/util.c
@@ -1,7 +1,7 @@
 /******************************************************************************
 *******************************************************************************
 **
-**  Copyright (C) 2005 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2005-2008 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -85,9 +85,7 @@ static int from_dlm_errno(int err)
 
 void dlm_message_out(struct dlm_message *ms)
 {
-	struct dlm_header *hd = (struct dlm_header *) ms;
-
-	header_out(hd);
+	header_out(&ms->m_header);
 
 	ms->m_type		= cpu_to_le32(ms->m_type);
 	ms->m_nodeid		= cpu_to_le32(ms->m_nodeid);
@@ -111,9 +109,7 @@ void dlm_message_out(struct dlm_message *ms)
 
 void dlm_message_in(struct dlm_message *ms)
 {
-	struct dlm_header *hd = (struct dlm_header *) ms;
-
-	header_in(hd);
+	header_in(&ms->m_header);
 
 	ms->m_type		= le32_to_cpu(ms->m_type);
 	ms->m_nodeid		= le32_to_cpu(ms->m_nodeid);
@@ -179,10 +175,9 @@ static void rcom_config_in(struct rcom_config *rf)
 
 void dlm_rcom_out(struct dlm_rcom *rc)
 {
-	struct dlm_header *hd = (struct dlm_header *) rc;
 	int type = rc->rc_type;
 
-	header_out(hd);
+	header_out(&rc->rc_header);
 
 	rc->rc_type		= cpu_to_le32(rc->rc_type);
 	rc->rc_result		= cpu_to_le32(rc->rc_result);
@@ -199,10 +194,9 @@ void dlm_rcom_out(struct dlm_rcom *rc)
 
 void dlm_rcom_in(struct dlm_rcom *rc)
 {
-	struct dlm_header *hd = (struct dlm_header *) rc;
 	int type;
 
-	header_in(hd);
+	header_in(&rc->rc_header);
 
 	rc->rc_type		= le32_to_cpu(rc->rc_type);
 	rc->rc_result		= le32_to_cpu(rc->rc_result);
-- 
1.5.3.3

