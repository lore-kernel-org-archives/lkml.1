Return-Path: <linux-kernel-owner+w=401wt.eu-S1761799AbXJLRRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761799AbXJLRRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbXJLRRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:17:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067AbXJLRRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:17:44 -0400
Date: Fri, 12 Oct 2007 18:17:34 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Neil Brown <neilb@suse.de>
Subject: [2.6.24 PATCH 11/25] kcopyd use mutex instead of semaphore
Message-ID: <20071012171734.GV24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Neil Brown <neilb@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Kcopyd uses a semaphore as mutex.  Use the mutex API instead of the (binary)
semaphore,

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/kcopyd.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.23/drivers/md/kcopyd.c
===================================================================
--- linux-2.6.23.orig/drivers/md/kcopyd.c	2007-10-12 12:36:14.000000000 +0100
+++ linux-2.6.23/drivers/md/kcopyd.c	2007-10-12 13:15:41.000000000 +0100
@@ -198,7 +198,7 @@ struct kcopyd_job {
 	 * These fields are only used if the job has been split
 	 * into more manageable parts.
 	 */
-	struct semaphore lock;
+	struct mutex lock;
 	atomic_t sub_jobs;
 	sector_t progress;
 };
@@ -456,7 +456,7 @@ static void segment_complete(int read_er
 	sector_t count = 0;
 	struct kcopyd_job *job = (struct kcopyd_job *) context;
 
-	down(&job->lock);
+	mutex_lock(&job->lock);
 
 	/* update the error */
 	if (read_err)
@@ -480,7 +480,7 @@ static void segment_complete(int read_er
 			job->progress += count;
 		}
 	}
-	up(&job->lock);
+	mutex_unlock(&job->lock);
 
 	if (count) {
 		int i;
@@ -562,7 +562,7 @@ int kcopyd_copy(struct kcopyd_client *kc
 		dispatch_job(job);
 
 	else {
-		init_MUTEX(&job->lock);
+		mutex_init(&job->lock);
 		job->progress = 0;
 		split_job(job);
 	}
