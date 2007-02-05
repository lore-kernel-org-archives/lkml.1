Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbXBEOLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbXBEOLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932755AbXBEOLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:11:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932736AbXBEOLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:11:48 -0500
Subject: [DLM] Fix spin lock already unlocked bug [13/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Patrick Caulfield <pcaulfie@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:19:52 +0000
Message-Id: <1170685192.11001.296.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From c239b99d90a2b667505cf5b397e8506be5dc3e9c Mon Sep 17 00:00:00 2001
From: Patrick Caulfield <pcaulfie@redhat.com>
Date: Tue, 2 Jan 2007 17:08:54 +0000
Subject: [PATCH] [DLM] Fix spin lock already unlocked bug

I just noticed this message when testing some other changes I'd made to
lowcomms (to use workqueues) but the problem seems to be in the current
git trees too. I'm amazed no-one has seen it.

    BUG: spinlock already unlocked on CPU#1, dlm_recoverd/16868

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms-tcp.c b/fs/dlm/lowcomms-tcp.c
index 18b91c6..ce5e7cd 100644
--- a/fs/dlm/lowcomms-tcp.c
+++ b/fs/dlm/lowcomms-tcp.c
@@ -709,6 +709,7 @@ void *dlm_lowcomms_get_buffer(int nodeid, int len,
 	if (!con)
 		return NULL;
 
+	spin_lock(&con->writequeue_lock);
 	e = list_entry(con->writequeue.prev, struct writequeue_entry, list);
 	if ((&e->list == &con->writequeue) ||
 	    (PAGE_CACHE_SIZE - e->end < len)) {
@@ -747,6 +748,7 @@ void dlm_lowcomms_commit_buffer(void *mh)
 	struct connection *con = e->con;
 	int users;
 
+	spin_lock(&con->writequeue_lock);
 	users = --e->users;
 	if (users)
 		goto out;
-- 
1.4.4.2



