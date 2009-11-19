Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZKSRUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZKSRUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbZKSRUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:20:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770AbZKSRUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:20:43 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/28] SLOW_WORK: Make slow_work_ops ->get_ref/->put_ref
	optional
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:20:44 +0000
Message-ID: <20091119172044.1679.24462.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>

Make the ability for the slow-work facility to take references on a work item
optional as not everyone requires this.

Even the internal slow-work stubs them out, so those can be got rid of too.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/slow-work.txt |    2 +-
 kernel/slow-work.c          |   36 ++++++++++++++++--------------------
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/Documentation/slow-work.txt b/Documentation/slow-work.txt
index f12fda3..c655c51 100644
--- a/Documentation/slow-work.txt
+++ b/Documentation/slow-work.txt
@@ -125,7 +125,7 @@ ITEM OPERATIONS
 ===============
 
 Each work item requires a table of operations of type struct slow_work_ops.
-All members are required:
+Only ->execute() is required, getting and putting of a reference are optional.
 
  (*) Get a reference on an item:
 
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index dd08f37..fccf421 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -145,6 +145,20 @@ static DECLARE_COMPLETION(slow_work_last_thread_exited);
 static int slow_work_user_count;
 static DEFINE_MUTEX(slow_work_user_lock);
 
+static inline int slow_work_get_ref(struct slow_work *work)
+{
+	if (work->ops->get_ref)
+		return work->ops->get_ref(work);
+
+	return 0;
+}
+
+static inline void slow_work_put_ref(struct slow_work *work)
+{
+	if (work->ops->put_ref)
+		work->ops->put_ref(work);
+}
+
 /*
  * Calculate the maximum number of active threads in the pool that are
  * permitted to process very slow work items.
@@ -248,7 +262,7 @@ static bool slow_work_execute(int id)
 	}
 
 	/* sort out the race between module unloading and put_ref() */
-	work->ops->put_ref(work);
+	slow_work_put_ref(work);
 
 #ifdef CONFIG_MODULES
 	module = slow_work_thread_processing[id];
@@ -309,7 +323,6 @@ int slow_work_enqueue(struct slow_work *work)
 	BUG_ON(slow_work_user_count <= 0);
 	BUG_ON(!work);
 	BUG_ON(!work->ops);
-	BUG_ON(!work->ops->get_ref);
 
 	/* when honouring an enqueue request, we only promise that we will run
 	 * the work function in the future; we do not promise to run it once
@@ -339,7 +352,7 @@ int slow_work_enqueue(struct slow_work *work)
 		if (test_bit(SLOW_WORK_EXECUTING, &work->flags)) {
 			set_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags);
 		} else {
-			if (work->ops->get_ref(work) < 0)
+			if (slow_work_get_ref(work) < 0)
 				goto cant_get_ref;
 			if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
 				list_add_tail(&work->link, &vslow_work_queue);
@@ -480,21 +493,6 @@ static void slow_work_cull_timeout(unsigned long data)
 }
 
 /*
- * Get a reference on slow work thread starter
- */
-static int slow_work_new_thread_get_ref(struct slow_work *work)
-{
-	return 0;
-}
-
-/*
- * Drop a reference on slow work thread starter
- */
-static void slow_work_new_thread_put_ref(struct slow_work *work)
-{
-}
-
-/*
  * Start a new slow work thread
  */
 static void slow_work_new_thread_execute(struct slow_work *work)
@@ -529,8 +527,6 @@ static void slow_work_new_thread_execute(struct slow_work *work)
 
 static const struct slow_work_ops slow_work_new_thread_ops = {
 	.owner		= THIS_MODULE,
-	.get_ref	= slow_work_new_thread_get_ref,
-	.put_ref	= slow_work_new_thread_put_ref,
 	.execute	= slow_work_new_thread_execute,
 };
 

