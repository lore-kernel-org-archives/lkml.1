Return-Path: <linux-kernel-owner+w=401wt.eu-S935054AbZDCP54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935054AbZDCP54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933520AbZDCPzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:55:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32777 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933224AbZDCPzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:55:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/41] Document the slow work thread pool [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:54:57 +0100
Message-ID: <20090403155457.28714.45072.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the slow work thread pool.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 Documentation/slow-work.txt |  174 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/slow-work.h   |    2 
 kernel/slow-work.c          |    2 
 3 files changed, 178 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/slow-work.txt


diff --git a/Documentation/slow-work.txt b/Documentation/slow-work.txt
new file mode 100644
index 0000000..ebc50f8
--- /dev/null
+++ b/Documentation/slow-work.txt
@@ -0,0 +1,174 @@
+		     ====================================
+		     SLOW WORK ITEM EXECUTION THREAD POOL
+		     ====================================
+
+By: David Howells <dhowells@redhat.com>
+
+The slow work item execution thread pool is a pool of threads for performing
+things that take a relatively long time, such as making mkdir calls.
+Typically, when processing something, these items will spend a lot of time
+blocking a thread on I/O, thus making that thread unavailable for doing other
+work.
+
+The standard workqueue model is unsuitable for this class of work item as that
+limits the owner to a single thread or a single thread per CPU.  For some
+tasks, however, more threads - or fewer - are required.
+
+There is just one pool per system.  It contains no threads unless something
+wants to use it - and that something must register its interest first.  When
+the pool is active, the number of threads it contains is dynamic, varying
+between a maximum and minimum setting, depending on the load.
+
+
+====================
+CLASSES OF WORK ITEM
+====================
+
+This pool support two classes of work items:
+
+ (*) Slow work items.
+
+ (*) Very slow work items.
+
+The former are expected to finish much quicker than the latter.
+
+An operation of the very slow class may do a batch combination of several
+lookups, mkdirs, and a create for instance.
+
+An operation of the ordinarily slow class may, for example, write stuff or
+expand files, provided the time taken to do so isn't too long.
+
+Operations of both types may sleep during execution, thus tying up the thread
+loaned to it.
+
+
+THREAD-TO-CLASS ALLOCATION
+--------------------------
+
+Not all the threads in the pool are available to work on very slow work items.
+The number will be between one and one fewer than the number of active threads.
+This is configurable (see the "Pool Configuration" section).
+
+All the threads are available to work on ordinarily slow work items, but a
+percentage of the threads will prefer to work on very slow work items.
+
+The configuration ensures that at least one thread will be available to work on
+very slow work items, and at least one thread will be available that won't work
+on very slow work items at all.
+
+
+=====================
+USING SLOW WORK ITEMS
+=====================
+
+Firstly, a module or subsystem wanting to make use of slow work items must
+register its interest:
+
+	 int ret = slow_work_register_user();
+
+This will return 0 if successful, or a -ve error upon failure.
+
+
+Slow work items may then be set up by:
+
+ (1) Declaring a slow_work struct type variable:
+
+	#include <linux/slow-work.h>
+
+	struct slow_work myitem;
+
+ (2) Declaring the operations to be used for this item:
+
+	struct slow_work_ops myitem_ops = {
+		.get_ref = myitem_get_ref,
+		.put_ref = myitem_put_ref,
+		.execute = myitem_execute,
+	};
+
+     [*] For a description of the ops, see section "Item Operations".
+
+ (3) Initialising the item:
+
+	slow_work_init(&myitem, &myitem_ops);
+
+     or:
+
+	vslow_work_init(&myitem, &myitem_ops);
+
+     depending on its class.
+
+A suitably set up work item can then be enqueued for processing:
+
+	int ret = slow_work_enqueue(&myitem);
+
+This will return a -ve error if the thread pool is unable to gain a reference
+on the item, 0 otherwise.
+
+
+The items are reference counted, so there ought to be no need for a flush
+operation.  When all a module's slow work items have been processed, and the
+module has no further interest in the facility, it should unregister its
+interest:
+
+	slow_work_unregister_user();
+
+
+===============
+ITEM OPERATIONS
+===============
+
+Each work item requires a table of operations of type struct slow_work_ops.
+All members are required:
+
+ (*) Get a reference on an item:
+
+	int (*get_ref)(struct slow_work *work);
+
+     This allows the thread pool to attempt to pin an item by getting a
+     reference on it.  This function should return 0 if the reference was
+     granted, or a -ve error otherwise.  If an error is returned,
+     slow_work_enqueue() will fail.
+
+     The reference is held whilst the item is queued and whilst it is being
+     executed.  The item may then be requeued with the same reference held, or
+     the reference will be released.
+
+ (*) Release a reference on an item:
+
+	void (*put_ref)(struct slow_work *work);
+
+     This allows the thread pool to unpin an item by releasing the reference on
+     it.  The thread pool will not touch the item again once this has been
+     called.
+
+ (*) Execute an item:
+
+	void (*execute)(struct slow_work *work);
+
+     This should perform the work required of the item.  It may sleep, it may
+     perform disk I/O and it may wait for locks.
+
+
+==================
+POOL CONFIGURATION
+==================
+
+The slow-work thread pool has a number of configurables:
+
+ (*) /proc/sys/kernel/slow-work/min-threads
+
+     The minimum number of threads that should be in the pool whilst it is in
+     use.  This may be anywhere between 2 and max-threads.
+
+ (*) /proc/sys/kernel/slow-work/max-threads
+
+     The maximum number of threads that should in the pool.  This may be
+     anywhere between min-threads and 255 or NR_CPUS * 2, whichever is greater.
+
+ (*) /proc/sys/kernel/slow-work/vslow-percentage
+
+     The percentage of active threads in the pool that may be used to execute
+     very slow work items.  This may be between 1 and 99.  The resultant number
+     is bounded to between 1 and one fewer than the number of active threads.
+     This ensures there is always at least one thread that can process very
+     slow work items, and always at least one thread that won't.
diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
index 8262809..8595827 100644
--- a/include/linux/slow-work.h
+++ b/include/linux/slow-work.h
@@ -7,6 +7,8 @@
  * modify it under the terms of the GNU General Public Licence
  * as published by the Free Software Foundation; either version
  * 2 of the Licence, or (at your option) any later version.
+ *
+ * See Documentation/slow-work.txt
  */
 
 #ifndef _LINUX_SLOW_WORK_H
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index 3f65900..cf2bc01 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -7,6 +7,8 @@
  * modify it under the terms of the GNU General Public Licence
  * as published by the Free Software Foundation; either version
  * 2 of the Licence, or (at your option) any later version.
+ *
+ * See Documentation/slow-work.txt
  */
 
 #include <linux/module.h>

