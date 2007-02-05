Return-Path: <linux-kernel-owner+w=401wt.eu-S932879AbXBEOck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbXBEOck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932905AbXBEOck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:32:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908AbXBEOci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:32:38 -0500
Subject: [DLM] saved dlm message can be dropped [41/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:40:42 +0000
Message-Id: <1170686442.11001.353.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 24b7195b114b8003274b02dd0c35fb73e75155d2 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Wed, 24 Jan 2007 10:11:45 -0600
Subject: [PATCH] [DLM] saved dlm message can be dropped

dlm_receive_message() returns 0 instead of returning 'error'.  What would
happen is that process_requestqueue would take a saved message off the
requestqueue and call receive_message on it.  receive_message would then
see that recovery had been aborted, set error to EINTR, and 'goto out',
expecting that the error would be returned.  Instead, 0 was always
returned, so process_requestqueue would think that the message had been
processed and delete it instead of saving it to process next time.  This
means the message (usually an unlock in my tests) would be lost.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 6ad2b8e..7c7ac2a 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3018,7 +3018,7 @@ int dlm_receive_message(struct dlm_header *hd, int nodeid, int recovery)
 {
 	struct dlm_message *ms = (struct dlm_message *) hd;
 	struct dlm_ls *ls;
-	int error;
+	int error = 0;
 
 	if (!recovery)
 		dlm_message_in(ms);
@@ -3135,7 +3135,7 @@ int dlm_receive_message(struct dlm_header *hd, int nodeid, int recovery)
  out:
 	dlm_put_lockspace(ls);
 	dlm_astd_wake();
-	return 0;
+	return error;
 }
 
 
-- 
1.4.4.2



