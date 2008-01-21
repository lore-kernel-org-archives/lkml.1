Return-Path: <linux-kernel-owner+w=401wt.eu-S1759021AbYAUKOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021AbYAUKOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759934AbYAUKCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758840AbYAUKCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:45 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 33/58] [GFS2] use pid for plock owner for nfs clients
Date: Mon, 21 Jan 2008 09:21:51 +0000
Message-Id: <12009073981159-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1200907397123-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
 <12009073823161-git-send-email-swhiteho@redhat.com>
 <12009073841692-git-send-email-swhiteho@redhat.com>
 <12009073862261-git-send-email-swhiteho@redhat.com>
 <12009073883125-git-send-email-swhiteho@redhat.com>
 <12009073891848-git-send-email-swhiteho@redhat.com>
 <12009073913676-git-send-email-swhiteho@redhat.com>
 <12009073933630-git-send-email-swhiteho@redhat.com>
 <12009073953412-git-send-email-swhiteho@redhat.com>
 <1200907397123-git-send-email-swhiteho@redhat.com>
Message-Id: <ab3bb4dcd58fb0236e220007044ea74b3ca714e7.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

The fl_owner is that of lockd when posix locks arrive from nfs
clients, so it can't be used to distinguish between lock holders.
Use fl_pid as owner instead; it's the pid of the process on the
nfs client.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking/dlm/plock.c b/fs/gfs2/locking/dlm/plock.c
index 1f7b038..2ebd374 100644
--- a/fs/gfs2/locking/dlm/plock.c
+++ b/fs/gfs2/locking/dlm/plock.c
@@ -89,15 +89,19 @@ int gdlm_plock(void *lockspace, struct lm_lockname *name,
 	op->info.number		= name->ln_number;
 	op->info.start		= fl->fl_start;
 	op->info.end		= fl->fl_end;
-	op->info.owner		= (__u64)(long) fl->fl_owner;
 	if (fl->fl_lmops && fl->fl_lmops->fl_grant) {
+		/* fl_owner is lockd which doesn't distinguish
+		   processes on the nfs client */
+		op->info.owner	= (__u64) fl->fl_pid;
 		xop->callback	= fl->fl_lmops->fl_grant;
 		locks_init_lock(&xop->flc);
 		locks_copy_lock(&xop->flc, fl);
 		xop->fl		= fl;
 		xop->file	= file;
-	} else
+	} else {
+		op->info.owner	= (__u64)(long) fl->fl_owner;
 		xop->callback	= NULL;
+	}
 
 	send_op(op);
 
@@ -203,7 +207,10 @@ int gdlm_punlock(void *lockspace, struct lm_lockname *name,
 	op->info.number		= name->ln_number;
 	op->info.start		= fl->fl_start;
 	op->info.end		= fl->fl_end;
-	op->info.owner		= (__u64)(long) fl->fl_owner;
+	if (fl->fl_lmops && fl->fl_lmops->fl_grant)
+		op->info.owner	= (__u64) fl->fl_pid;
+	else
+		op->info.owner	= (__u64)(long) fl->fl_owner;
 
 	send_op(op);
 	wait_event(recv_wq, (op->done != 0));
@@ -242,7 +249,10 @@ int gdlm_plock_get(void *lockspace, struct lm_lockname *name,
 	op->info.number		= name->ln_number;
 	op->info.start		= fl->fl_start;
 	op->info.end		= fl->fl_end;
-	op->info.owner		= (__u64)(long) fl->fl_owner;
+	if (fl->fl_lmops && fl->fl_lmops->fl_grant)
+		op->info.owner	= (__u64) fl->fl_pid;
+	else
+		op->info.owner	= (__u64)(long) fl->fl_owner;
 
 	send_op(op);
 	wait_event(recv_wq, (op->done != 0));
-- 
1.5.1.2

