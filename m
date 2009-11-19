Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbZKSRVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbZKSRVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbZKSRVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:21:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755AbZKSRVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:21:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/28] SLOW_WORK: Allow the owner of a work item to determine
	if it is queued or not
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:21:04 +0000
Message-ID: <20091119172104.1679.72147.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function (slow_work_is_queued()) to permit the owner of a work item to
determine if the item is queued or not.

The work item is counted as being queued if it is actually on the queue, not
just if it is pending.  If it is executing and pending, then it is not on the
queue, but will rather be put back on the queue when execution finishes.

This permits a caller to quickly work out if it may be able to put another,
dependent work item on the queue behind it, or whether it will have to wait
till that is finished.

This can be used by CacheFiles to work out whether the creation a new object
can be immediately deferred when it has to wait for an old object to be
deleted, or whether a wait must take place.  If a wait is necessary, then the
slow-work thread can otherwise get blocked, preventing the deletion from
taking place.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/slow-work.txt |   15 +++++++++++++++
 include/linux/slow-work.h   |   19 +++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/Documentation/slow-work.txt b/Documentation/slow-work.txt
index f120238..0169c9d 100644
--- a/Documentation/slow-work.txt
+++ b/Documentation/slow-work.txt
@@ -144,6 +144,21 @@ from being taken away before it completes.  module should almost certainly be
 THIS_MODULE.
 
 
+================
+HELPER FUNCTIONS
+================
+
+The slow-work facility provides a function by which it can be determined
+whether or not an item is queued for later execution:
+
+	bool queued = slow_work_is_queued(struct slow_work *work);
+
+If it returns false, then the item is not on the queue (it may be executing
+with a requeue pending).  This can be used to work out whether an item on which
+another depends is on the queue, thus allowing a dependent item to be queued
+after it.
+
+
 ===============
 ITEM OPERATIONS
 ===============
diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
index f414851..bfd3ab4 100644
--- a/include/linux/slow-work.h
+++ b/include/linux/slow-work.h
@@ -120,6 +120,25 @@ static inline void vslow_work_init(struct slow_work *work,
 	INIT_LIST_HEAD(&work->link);
 }
 
+/**
+ * slow_work_is_queued - Determine if a slow work item is on the work queue
+ * work: The work item to test
+ *
+ * Determine if the specified slow-work item is on the work queue.  This
+ * returns true if it is actually on the queue.
+ *
+ * If the item is executing and has been marked for requeue when execution
+ * finishes, then false will be returned.
+ *
+ * Anyone wishing to wait for completion of execution can wait on the
+ * SLOW_WORK_EXECUTING bit.
+ */
+static inline bool slow_work_is_queued(struct slow_work *work)
+{
+	unsigned long flags = work->flags;
+	return flags & SLOW_WORK_PENDING && !(flags & SLOW_WORK_EXECUTING);
+}
+
 extern int slow_work_enqueue(struct slow_work *work);
 extern void slow_work_cancel(struct slow_work *work);
 extern int slow_work_register_user(struct module *owner);

