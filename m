Return-Path: <linux-kernel-owner+w=401wt.eu-S932752AbXBEOLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752AbXBEOLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:11:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932735AbXBEOLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:11:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932736AbXBEOLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:11:00 -0500
Subject: [DLM] Fix schedule() calls [12/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Patrick Caulfield <pcaulfie@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:19:04 +0000
Message-Id: <1170685144.11001.294.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7c571f88ff49e883ee57f0abf1e155f2d4965a75 Mon Sep 17 00:00:00 2001
From: Patrick Caulfield <pcaulfie@redhat.com>
Date: Tue, 2 Jan 2007 17:01:05 +0000
Subject: [PATCH] [DLM] Fix schedule() calls

I was a little over-enthusiastic turning schedule() calls int cond_sched() when fixing the DLM for Andrew Morton.

These four should really be calls to schedule() or the dlm can busy-wait.

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms-sctp.c b/fs/dlm/lowcomms-sctp.c
index fe158d7..0940a80 100644
--- a/fs/dlm/lowcomms-sctp.c
+++ b/fs/dlm/lowcomms-sctp.c
@@ -1109,7 +1109,7 @@ static int dlm_recvd(void *data)
 		set_current_state(TASK_INTERRUPTIBLE);
 		add_wait_queue(&lowcomms_recv_wait, &wait);
 		if (!test_bit(CF_READ_PENDING, &sctp_con.flags))
-			cond_resched();
+			schedule();
 		remove_wait_queue(&lowcomms_recv_wait, &wait);
 		set_current_state(TASK_RUNNING);
 
@@ -1141,7 +1141,7 @@ static int dlm_sendd(void *data)
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (write_list_empty())
-			cond_resched();
+			schedule();
 		set_current_state(TASK_RUNNING);
 
 		if (sctp_con.eagain_flag) {
diff --git a/fs/dlm/lowcomms-tcp.c b/fs/dlm/lowcomms-tcp.c
index 3b22473..18b91c6 100644
--- a/fs/dlm/lowcomms-tcp.c
+++ b/fs/dlm/lowcomms-tcp.c
@@ -996,7 +996,7 @@ static int dlm_recvd(void *data)
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (read_list_empty())
-			cond_resched();
+			schedule();
 		set_current_state(TASK_RUNNING);
 
 		process_sockets();
@@ -1030,7 +1030,7 @@ static int dlm_sendd(void *data)
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (write_and_state_lists_empty())
-			cond_resched();
+			schedule();
 		set_current_state(TASK_RUNNING);
 
 		process_state_queue();
-- 
1.4.4.2



