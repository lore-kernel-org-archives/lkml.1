Return-Path: <linux-kernel-owner+w=401wt.eu-S932587AbXBEOF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587AbXBEOF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932614AbXBEOF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:05:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932587AbXBEOF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:05:56 -0500
Subject: [DLM] fix receive_request() lvb copying [6/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:13:57 +0000
Message-Id: <1170684837.11001.282.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From f1d7674362afc47d0125e68dc7187e81f276a235 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Wed, 13 Dec 2006 10:39:20 -0600
Subject: [PATCH] [DLM] fix receive_request() lvb copying

LVB's are not sent as part of new requests, but the code receiving the
request was copying data into the lvb anyway.  The space in the message
where it mistakenly thought the lvb lived actually contained the resource
name, so it wound up incorrectly copying this name data into the lvb.  Fix
is to just create the lvb, not copy junk into it.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index cdf2cb9..d8e919b 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2430,8 +2430,12 @@ static int receive_request_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 
 	DLM_ASSERT(is_master_copy(lkb), dlm_print_lkb(lkb););
 
-	if (receive_lvb(ls, lkb, ms))
-		return -ENOMEM;
+	if (lkb->lkb_exflags & DLM_LKF_VALBLK) {
+		/* lkb was just created so there won't be an lvb yet */
+		lkb->lkb_lvbptr = allocate_lvb(ls);
+		if (!lkb->lkb_lvbptr)
+			return -ENOMEM;
+	}
 
 	return 0;
 }
-- 
1.4.4.2



