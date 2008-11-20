Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbYKTOvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbYKTOvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbYKTOnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:43:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41079 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082AbYKTOn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:43:29 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/45] FS-Cache: Add and document asynchronous operation
	handling [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:43:22 +0000
Message-ID: <20081120144322.10667.76701.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and document asynchronous operation handling for use by FS-Cache's data
storage and retrieval routines.

The following documentation is added to:

	Documentation/filesystems/caching/operations.txt


		       ================================
		       ASYNCHRONOUS OPERATIONS HANDLING
		       ================================

========
OVERVIEW
========

FS-Cache has an asynchronous operations handling facility that it uses for its
data storage and retrieval routines.  Its operations are represented by
fscache_operation structs, though these are usually embedded into some other
structure.

This facility is available to and expected to be be used by the cache backends,
and FS-Cache will create operations and pass them off to the appropriate cache
backend for completion.

To make use of this facility, <linux/fscache-cache.h> should be #included.


===============================
OPERATION RECORD INITIALISATION
===============================

An operation is recorded in an fscache_operation struct:

	struct fscache_operation {
		union {
			struct work_struct fast_work;
			struct slow_work slow_work;
		};
		unsigned long		flags;
		fscache_operation_processor_t processor;
		...
	};

Someone wanting to issue an operation should allocate something with this
struct embedded in it.  They should initialise it by calling:

	void fscache_operation_init(struct fscache_operation *op,
				    fscache_operation_release_t release);

with the operation to be initialised and the release function to use.

The op->flags parameter should be set to indicate the CPU time provision and
the exclusivity (see the Parameters section).

The op->fast_work, op->slow_work and op->processor flags should be set as
appropriate for the CPU time provision (see the Parameters section).

FSCACHE_OP_WAITING may be set in op->flags prior to each submission of the
operation and waited for afterwards.


==========
PARAMETERS
==========

There are a number of parameters that can be set in the operation record's flag
parameter.  There are three options for the provision of CPU time in these
operations:

 (1) The operation may be done synchronously (FSCACHE_OP_MYTHREAD).  A thread
     may decide it wants to handle an operation itself without deferring it to
     another thread.

     This is, for example, used in read operations for calling readpages() on
     the backing filesystem in CacheFiles.  Although readpages() does an
     asynchronous data fetch, the determination of whether pages exist is done
     synchronously - and the netfs does not proceed until this has been
     determined.

     If this option is to be used, FSCACHE_OP_WAITING must be set in op->flags
     before submitting the operation, and the operating thread must wait for it
     to be cleared before proceeding:

		wait_on_bit(&op->flags, FSCACHE_OP_WAITING,
			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);


 (2) The operation may be fast asynchronous (FSCACHE_OP_FAST), in which case it
     will be given to keventd to process.  Such an operation is not permitted
     to sleep on I/O.

     This is, for example, used by CacheFiles to copy data from a backing fs
     page to a netfs page after the backing fs has read the page in.

     If this option is used, op->fast_work and op->processor must be
     initialised before submitting the operation:

		INIT_WORK(&op->fast_work, do_some_work);


 (3) The operation may be slow asynchronous (FSCACHE_OP_SLOW), in which case it
     will be given to the slow work facility to process.  Such an operation is
     permitted to sleep on I/O.

     This is, for example, used by FS-Cache to handle background writes of
     pages that have just been fetched from a remote server.

     If this option is used, op->slow_work and op->processor must be
     initialised before submitting the operation:

		fscache_operation_init_slow(op, processor)


Furthermore, operations may be one of two types:

 (1) Exclusive (FSCACHE_OP_EXCLUSIVE).  Operations of this type may not run in
     conjunction with any other operation on the object being operated upon.

     An example of this is the attribute change operation, in which the file
     being written to may need truncation.

 (2) Shareable.  Operations of this type may be running simultaneously.  It's
     up to the operation implementation to prevent interference between other
     operations running at the same time.


=========
PROCEDURE
=========

Operations are used through the following procedure:

 (1) The submitting thread must allocate the operation and initialise it
     itself.  Normally this would be part of a more specific structure with the
     generic op embedded within.

 (2) The submitting thread must then submit the operation for processing using
     one of the following two functions:

	int fscache_submit_op(struct fscache_object *object,
			      struct fscache_operation *op);

	int fscache_submit_exclusive_op(struct fscache_object *object,
					struct fscache_operation *op);

     The first function should be used to submit non-exclusive ops and the
     second to submit exclusive ones.  The caller must still set the
     FSCACHE_OP_EXCLUSIVE flag.

     If successful, both functions will assign the operation to the specified
     object and return 0.  -ENOBUFS will be returned if the object specified is
     permanently unavailable.

     The operation manager will defer operations on an object that is still
     undergoing lookup or creation.  The operation will also be deferred if an
     operation of conflicting exclusivity is in progress on the object.

     If the operation is asynchronous, the manager will retain a reference to
     it, so the caller should put their reference to it by passing it to:

	void fscache_put_operation(struct fscache_operation *op);

 (3) If the submitting thread wants to do the work itself, and has marked the
     operation with FSCACHE_OP_MYTHREAD, then it should monitor
     FSCACHE_OP_WAITING as described above and check the state of the object if
     necessary (the object might have died whilst the thread was waiting).

     When it has finished doing its processing, it should call
     fscache_put_operation() on it.

 (4) The operation holds an effective lock upon the object, preventing other
     exclusive ops conflicting until it is released.  The operation can be
     enqueued for further immediate asynchronous processing by adjusting the
     CPU time provisioning option if necessary, eg:

	op->flags &= ~FSCACHE_OP_TYPE;
	op->flags |= ~FSCACHE_OP_FAST;

     and calling:

	void fscache_enqueue_operation(struct fscache_operation *op)

     This can be used to allow other things to have use of the worker thread
     pools.


=====================
ASYNCHRONOUS CALLBACK
=====================

When used in asynchronous mode, the worker thread pool will invoke the
processor method with a pointer to the operation.  This should then get at the
container struct by using container_of():

	static void fscache_write_op(struct fscache_operation *_op)
	{
		struct fscache_storage *op =
			container_of(_op, struct fscache_storage, op);
	...
	}

The caller holds a reference on the operation, and will invoke
fscache_put_operation() when the processor function returns.  The processor
function is at liberty to call fscache_enqueue_operation() or to take extra
references.


Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/caching/operations.txt |  213 ++++++++++
 fs/fscache/Makefile                              |    1 
 fs/fscache/fsc-cache.c                           |    2 
 fs/fscache/fsc-internal.h                        |    8 
 fs/fscache/fsc-operation.c                       |  459 ++++++++++++++++++++++
 5 files changed, 681 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/filesystems/caching/operations.txt
 create mode 100644 fs/fscache/fsc-operation.c


diff --git a/Documentation/filesystems/caching/operations.txt b/Documentation/filesystems/caching/operations.txt
new file mode 100644
index 0000000..b6b070c
--- /dev/null
+++ b/Documentation/filesystems/caching/operations.txt
@@ -0,0 +1,213 @@
+		       ================================
+		       ASYNCHRONOUS OPERATIONS HANDLING
+		       ================================
+
+By: David Howells <dhowells@redhat.com>
+
+Contents:
+
+ (*) Overview.
+
+ (*) Operation record initialisation.
+
+ (*) Parameters.
+
+ (*) Procedure.
+
+ (*) Asynchronous callback.
+
+
+========
+OVERVIEW
+========
+
+FS-Cache has an asynchronous operations handling facility that it uses for its
+data storage and retrieval routines.  Its operations are represented by
+fscache_operation structs, though these are usually embedded into some other
+structure.
+
+This facility is available to and expected to be be used by the cache backends,
+and FS-Cache will create operations and pass them off to the appropriate cache
+backend for completion.
+
+To make use of this facility, <linux/fscache-cache.h> should be #included.
+
+
+===============================
+OPERATION RECORD INITIALISATION
+===============================
+
+An operation is recorded in an fscache_operation struct:
+
+	struct fscache_operation {
+		union {
+			struct work_struct fast_work;
+			struct slow_work slow_work;
+		};
+		unsigned long		flags;
+		fscache_operation_processor_t processor;
+		...
+	};
+
+Someone wanting to issue an operation should allocate something with this
+struct embedded in it.  They should initialise it by calling:
+
+	void fscache_operation_init(struct fscache_operation *op,
+				    fscache_operation_release_t release);
+
+with the operation to be initialised and the release function to use.
+
+The op->flags parameter should be set to indicate the CPU time provision and
+the exclusivity (see the Parameters section).
+
+The op->fast_work, op->slow_work and op->processor flags should be set as
+appropriate for the CPU time provision (see the Parameters section).
+
+FSCACHE_OP_WAITING may be set in op->flags prior to each submission of the
+operation and waited for afterwards.
+
+
+==========
+PARAMETERS
+==========
+
+There are a number of parameters that can be set in the operation record's flag
+parameter.  There are three options for the provision of CPU time in these
+operations:
+
+ (1) The operation may be done synchronously (FSCACHE_OP_MYTHREAD).  A thread
+     may decide it wants to handle an operation itself without deferring it to
+     another thread.
+
+     This is, for example, used in read operations for calling readpages() on
+     the backing filesystem in CacheFiles.  Although readpages() does an
+     asynchronous data fetch, the determination of whether pages exist is done
+     synchronously - and the netfs does not proceed until this has been
+     determined.
+
+     If this option is to be used, FSCACHE_OP_WAITING must be set in op->flags
+     before submitting the operation, and the operating thread must wait for it
+     to be cleared before proceeding:
+
+		wait_on_bit(&op->flags, FSCACHE_OP_WAITING,
+			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+
+
+ (2) The operation may be fast asynchronous (FSCACHE_OP_FAST), in which case it
+     will be given to keventd to process.  Such an operation is not permitted
+     to sleep on I/O.
+
+     This is, for example, used by CacheFiles to copy data from a backing fs
+     page to a netfs page after the backing fs has read the page in.
+
+     If this option is used, op->fast_work and op->processor must be
+     initialised before submitting the operation:
+
+		INIT_WORK(&op->fast_work, do_some_work);
+
+
+ (3) The operation may be slow asynchronous (FSCACHE_OP_SLOW), in which case it
+     will be given to the slow work facility to process.  Such an operation is
+     permitted to sleep on I/O.
+
+     This is, for example, used by FS-Cache to handle background writes of
+     pages that have just been fetched from a remote server.
+
+     If this option is used, op->slow_work and op->processor must be
+     initialised before submitting the operation:
+
+		fscache_operation_init_slow(op, processor)
+
+
+Furthermore, operations may be one of two types:
+
+ (1) Exclusive (FSCACHE_OP_EXCLUSIVE).  Operations of this type may not run in
+     conjunction with any other operation on the object being operated upon.
+
+     An example of this is the attribute change operation, in which the file
+     being written to may need truncation.
+
+ (2) Shareable.  Operations of this type may be running simultaneously.  It's
+     up to the operation implementation to prevent interference between other
+     operations running at the same time.
+
+
+=========
+PROCEDURE
+=========
+
+Operations are used through the following procedure:
+
+ (1) The submitting thread must allocate the operation and initialise it
+     itself.  Normally this would be part of a more specific structure with the
+     generic op embedded within.
+
+ (2) The submitting thread must then submit the operation for processing using
+     one of the following two functions:
+
+	int fscache_submit_op(struct fscache_object *object,
+			      struct fscache_operation *op);
+
+	int fscache_submit_exclusive_op(struct fscache_object *object,
+					struct fscache_operation *op);
+
+     The first function should be used to submit non-exclusive ops and the
+     second to submit exclusive ones.  The caller must still set the
+     FSCACHE_OP_EXCLUSIVE flag.
+
+     If successful, both functions will assign the operation to the specified
+     object and return 0.  -ENOBUFS will be returned if the object specified is
+     permanently unavailable.
+
+     The operation manager will defer operations on an object that is still
+     undergoing lookup or creation.  The operation will also be deferred if an
+     operation of conflicting exclusivity is in progress on the object.
+
+     If the operation is asynchronous, the manager will retain a reference to
+     it, so the caller should put their reference to it by passing it to:
+
+	void fscache_put_operation(struct fscache_operation *op);
+
+ (3) If the submitting thread wants to do the work itself, and has marked the
+     operation with FSCACHE_OP_MYTHREAD, then it should monitor
+     FSCACHE_OP_WAITING as described above and check the state of the object if
+     necessary (the object might have died whilst the thread was waiting).
+
+     When it has finished doing its processing, it should call
+     fscache_put_operation() on it.
+
+ (4) The operation holds an effective lock upon the object, preventing other
+     exclusive ops conflicting until it is released.  The operation can be
+     enqueued for further immediate asynchronous processing by adjusting the
+     CPU time provisioning option if necessary, eg:
+
+	op->flags &= ~FSCACHE_OP_TYPE;
+	op->flags |= ~FSCACHE_OP_FAST;
+
+     and calling:
+
+	void fscache_enqueue_operation(struct fscache_operation *op)
+
+     This can be used to allow other things to have use of the worker thread
+     pools.
+
+
+=====================
+ASYNCHRONOUS CALLBACK
+=====================
+
+When used in asynchronous mode, the worker thread pool will invoke the
+processor method with a pointer to the operation.  This should then get at the
+container struct by using container_of():
+
+	static void fscache_write_op(struct fscache_operation *_op)
+	{
+		struct fscache_storage *op =
+			container_of(_op, struct fscache_storage, op);
+	...
+	}
+
+The caller holds a reference on the operation, and will invoke
+fscache_put_operation() when the processor function returns.  The processor
+function is at liberty to call fscache_enqueue_operation() or to take extra
+references.
diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
index f7b1947..d0c1abe 100644
--- a/fs/fscache/Makefile
+++ b/fs/fscache/Makefile
@@ -9,6 +9,7 @@ fscache-y := \
 	fsc-main.o \
 	fsc-netfs.o \
 	fsc-object.o \
+	fsc-operation.o \
 	fsc-proc.o \
 	fsc-stats.o
 
diff --git a/fs/fscache/fsc-cache.c b/fs/fscache/fsc-cache.c
index 8696c84..39a8518 100644
--- a/fs/fscache/fsc-cache.c
+++ b/fs/fscache/fsc-cache.c
@@ -195,7 +195,7 @@ void fscache_init_cache(struct fscache_cache *cache,
 	vsnprintf(cache->identifier, sizeof(cache->identifier), idfmt, va);
 	va_end(va);
 
-	INIT_WORK(&cache->op_gc, NULL);
+	INIT_WORK(&cache->op_gc, fscache_operation_gc);
 	INIT_LIST_HEAD(&cache->link);
 	INIT_LIST_HEAD(&cache->object_list);
 	INIT_LIST_HEAD(&cache->op_gc_list);
diff --git a/fs/fscache/fsc-internal.h b/fs/fscache/fsc-internal.h
index 1812282..ec8bfc7 100644
--- a/fs/fscache/fsc-internal.h
+++ b/fs/fscache/fsc-internal.h
@@ -71,7 +71,13 @@ extern void fscache_enqueue_object(struct fscache_object *);
 /*
  * fsc-operation.c
  */
-#define fscache_start_operations(obj) BUG()
+extern int fscache_submit_exclusive_op(struct fscache_object *,
+				       struct fscache_operation *);
+extern int fscache_submit_op(struct fscache_object *,
+			     struct fscache_operation *);
+extern void fscache_abort_object(struct fscache_object *);
+extern void fscache_start_operations(struct fscache_object *);
+extern void fscache_operation_gc(struct work_struct *);
 
 /*
  * fsc-stats.c
diff --git a/fs/fscache/fsc-operation.c b/fs/fscache/fsc-operation.c
new file mode 100644
index 0000000..0ee9c4e
--- /dev/null
+++ b/fs/fscache/fsc-operation.c
@@ -0,0 +1,459 @@
+/* FS-Cache worker operation management routines
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * See Documentation/filesystems/caching/operations.txt
+ */
+
+#define FSCACHE_DEBUG_LEVEL OPERATION
+#include <linux/module.h>
+#include "fsc-internal.h"
+
+atomic_t fscache_op_debug_id;
+EXPORT_SYMBOL(fscache_op_debug_id);
+
+/**
+ * fscache_enqueue_operation - Enqueue an operation for processing
+ * @op: The operation to enqueue
+ *
+ * Enqueue an operation for processing by the FS-Cache thread pool.
+ *
+ * This will get its own ref on the object.
+ */
+void fscache_enqueue_operation(struct fscache_operation *op)
+{
+	_enter("{OBJ%x OP%x,%u}",
+	       op->object->debug_id, op->debug_id, atomic_read(&op->usage));
+
+	ASSERT(op->processor != NULL);
+	ASSERTCMP(op->object->state, >=, FSCACHE_OBJECT_AVAILABLE);
+	ASSERTCMP(atomic_read(&op->usage), >, 0);
+
+	if (list_empty(&op->pend_link)) {
+		switch (op->flags & FSCACHE_OP_TYPE) {
+		case FSCACHE_OP_FAST:
+			_debug("queue fast");
+			atomic_inc(&op->usage);
+			if (!schedule_work(&op->fast_work))
+				fscache_put_operation(op);
+			break;
+		case FSCACHE_OP_SLOW:
+			_debug("queue slow");
+			slow_work_enqueue(&op->slow_work);
+			break;
+		case FSCACHE_OP_MYTHREAD:
+			_debug("queue for caller's attention");
+			break;
+		default:
+			printk(KERN_ERR "FS-Cache: Unexpected op type %lx",
+			       op->flags);
+			BUG();
+			break;
+		}
+		fscache_stat(&fscache_n_op_enqueue);
+	}
+}
+EXPORT_SYMBOL(fscache_enqueue_operation);
+
+/*
+ * start an op running
+ */
+static void fscache_run_op(struct fscache_object *object,
+			   struct fscache_operation *op)
+{
+	object->n_in_progress++;
+	if (test_and_clear_bit(FSCACHE_OP_WAITING, &op->flags))
+		wake_up_bit(&op->flags, FSCACHE_OP_WAITING);
+	if (op->processor)
+		fscache_enqueue_operation(op);
+	fscache_stat(&fscache_n_op_run);
+}
+
+/*
+ * submit an exclusive operation for an object
+ * - other ops are excluded from running simultaneously with this one
+ * - this gets any extra refs it needs on an op
+ */
+int fscache_submit_exclusive_op(struct fscache_object *object,
+				struct fscache_operation *op)
+{
+	int ret;
+
+	_enter("{OBJ%x OP%x},", object->debug_id, op->debug_id);
+
+	spin_lock(&object->lock);
+	ASSERTCMP(object->n_ops, >=, object->n_in_progress);
+	ASSERTCMP(object->n_ops, >=, object->n_exclusive);
+
+	ret = -ENOBUFS;
+	if (fscache_object_is_active(object)) {
+		op->object = object;
+		object->n_ops++;
+		object->n_exclusive++;	/* reads and writes must wait */
+
+		if (object->n_ops > 0) {
+			atomic_inc(&op->usage);
+			list_add_tail(&op->pend_link, &object->pending_ops);
+			fscache_stat(&fscache_n_op_pend);
+		} else if (!list_empty(&object->pending_ops)) {
+			atomic_inc(&op->usage);
+			list_add_tail(&op->pend_link, &object->pending_ops);
+			fscache_stat(&fscache_n_op_pend);
+			fscache_start_operations(object);
+		} else {
+			ASSERTCMP(object->n_in_progress, ==, 0);
+			fscache_run_op(object, op);
+		}
+
+		/* need to issue a new write op after this */
+		clear_bit(FSCACHE_OBJECT_PENDING_WRITE, &object->flags);
+		ret = 0;
+	} else if (object->state == FSCACHE_OBJECT_CREATING) {
+		op->object = object;
+		object->n_ops++;
+		object->n_exclusive++;	/* reads and writes must wait */
+		atomic_inc(&op->usage);
+		list_add_tail(&op->pend_link, &object->pending_ops);
+		fscache_stat(&fscache_n_op_pend);
+		ret = 0;
+	} else {
+		/* not allowed to submit ops in any other state */
+		BUG();
+	}
+
+	spin_unlock(&object->lock);
+	return ret;
+}
+
+/*
+ * report an unexpected submission
+ */
+static void fscache_report_unexpected_submission(struct fscache_object *object,
+						 struct fscache_operation *op,
+						 unsigned long ostate)
+{
+	static bool once_only;
+	struct fscache_operation *p;
+	unsigned n;
+
+	if (once_only)
+		return;
+	once_only = true;
+
+	kdebug("unexpected submission OP%x [OBJ%x %s]",
+	       op->debug_id, object->debug_id,
+	       fscache_object_states[object->state]);
+	kdebug("objstate=%s [%s]",
+	       fscache_object_states[object->state],
+	       fscache_object_states[ostate]);
+	kdebug("objflags=%lx", object->flags);
+	kdebug("objevent=%lx [%lx]", object->events, object->event_mask);
+	kdebug("ops=%u inp=%u exc=%u",
+	       object->n_ops, object->n_in_progress, object->n_exclusive);
+
+	if (!list_empty(&object->pending_ops)) {
+		n = 0;
+		list_for_each_entry(p, &object->pending_ops, pend_link) {
+			ASSERTCMP(p->object, ==, object);
+			kdebug("%p %p", op->processor, op->release);
+			n++;
+		}
+
+		kdebug("n=%u", n);
+	}
+
+	dump_stack();
+}
+
+/*
+ * submit an operation for an object
+ * - objects may be submitted only in the following states:
+ *   - during object creation (write ops may be submitted)
+ *   - whilst the object is active
+ *   - after an I/O error incurred in one of the two above states (op rejected)
+ * - this gets any extra refs it needs on an op
+ */
+int fscache_submit_op(struct fscache_object *object,
+		      struct fscache_operation *op)
+{
+	unsigned long ostate;
+	int ret;
+
+	_enter("{OBJ%x OP%x},{%u}",
+	       object->debug_id, op->debug_id, atomic_read(&op->usage));
+
+	ASSERTCMP(atomic_read(&op->usage), >, 0);
+
+	spin_lock(&object->lock);
+	ASSERTCMP(object->n_ops, >=, object->n_in_progress);
+	ASSERTCMP(object->n_ops, >=, object->n_exclusive);
+
+	ostate = object->state;
+	smp_rmb();
+
+	if (fscache_object_is_active(object)) {
+		op->object = object;
+		object->n_ops++;
+
+		if (object->n_exclusive > 0) {
+			atomic_inc(&op->usage);
+			list_add_tail(&op->pend_link, &object->pending_ops);
+			fscache_stat(&fscache_n_op_pend);
+		} else if (!list_empty(&object->pending_ops)) {
+			atomic_inc(&op->usage);
+			list_add_tail(&op->pend_link, &object->pending_ops);
+			fscache_stat(&fscache_n_op_pend);
+			fscache_start_operations(object);
+		} else {
+			ASSERTCMP(object->n_exclusive, ==, 0);
+			fscache_run_op(object, op);
+		}
+		ret = 0;
+	} else if (object->state == FSCACHE_OBJECT_CREATING) {
+		op->object = object;
+		object->n_ops++;
+		atomic_inc(&op->usage);
+		list_add_tail(&op->pend_link, &object->pending_ops);
+		fscache_stat(&fscache_n_op_pend);
+		ret = 0;
+	} else if (!test_bit(FSCACHE_IOERROR, &object->cache->flags)) {
+		fscache_report_unexpected_submission(object, op, ostate);
+		ASSERT(!fscache_object_is_active(object));
+		ret = -ENOBUFS;
+	} else {
+		ret = -ENOBUFS;
+	}
+
+	spin_unlock(&object->lock);
+	return ret;
+}
+
+/*
+ * queue an object for withdrawal on error, aborting all following asynchronous
+ * operations
+ */
+void fscache_abort_object(struct fscache_object *object)
+{
+	_enter("{OBJ%x}", object->debug_id);
+
+	fscache_raise_event(object, FSCACHE_OBJECT_EV_ERROR);
+}
+
+/*
+ * jump start the operation processing on an object
+ * - caller must hold object->lock
+ */
+void fscache_start_operations(struct fscache_object *object)
+{
+	struct fscache_operation *op;
+	bool stop = false;
+
+	while (!list_empty(&object->pending_ops) && !stop) {
+		op = list_entry(object->pending_ops.next,
+				struct fscache_operation, pend_link);
+
+		if (test_bit(FSCACHE_OP_EXCLUSIVE, &op->flags)) {
+			if (object->n_in_progress > 0)
+				break;
+			stop = true;
+		}
+		list_del_init(&op->pend_link);
+		object->n_in_progress++;
+
+		if (test_and_clear_bit(FSCACHE_OP_WAITING, &op->flags))
+			wake_up_bit(&op->flags, FSCACHE_OP_WAITING);
+		if (op->processor)
+			fscache_enqueue_operation(op);
+
+		/* the pending queue was holding a ref on the object */
+		fscache_put_operation(op);
+	}
+
+	ASSERTCMP(object->n_in_progress, <=, object->n_ops);
+
+	_debug("woke %d ops on OBJ%x",
+	       object->n_in_progress, object->debug_id);
+}
+
+/*
+ * release an operation
+ * - queues pending ops if this is the last in-progress op
+ */
+void fscache_put_operation(struct fscache_operation *op)
+{
+	struct fscache_object *object;
+	struct fscache_cache *cache;
+
+	_enter("{OBJ%x OP%x,%d}",
+	       op->object->debug_id, op->debug_id, atomic_read(&op->usage));
+
+	ASSERTCMP(atomic_read(&op->usage), >, 0);
+
+	if (!atomic_dec_and_test(&op->usage))
+		return;
+
+	_debug("PUT OP");
+	if (test_and_set_bit(FSCACHE_OP_DEAD, &op->flags))
+		BUG();
+
+	fscache_stat(&fscache_n_op_release);
+
+	if (op->release) {
+		op->release(op);
+		op->release = NULL;
+	}
+
+	object = op->object;
+
+	/* now... we may get called with the object spinlock held, so we
+	 * complete the cleanup here only if we can immediately acquire the
+	 * lock, and defer it otherwise */
+	if (!spin_trylock(&object->lock)) {
+		_debug("defer put");
+		fscache_stat(&fscache_n_op_deferred_release);
+
+		cache = object->cache;
+		spin_lock(&cache->op_gc_list_lock);
+		list_add_tail(&op->pend_link, &cache->op_gc_list);
+		spin_unlock(&cache->op_gc_list_lock);
+		schedule_work(&cache->op_gc);
+		_leave(" [defer]");
+		return;
+	}
+
+	if (test_bit(FSCACHE_OP_EXCLUSIVE, &op->flags)) {
+		ASSERTCMP(object->n_exclusive, >, 0);
+		object->n_exclusive--;
+	}
+
+	ASSERTCMP(object->n_in_progress, >, 0);
+	object->n_in_progress--;
+	if (object->n_in_progress == 0)
+		fscache_start_operations(object);
+
+	ASSERTCMP(object->n_ops, >, 0);
+	object->n_ops--;
+	if (object->n_ops == 0)
+		fscache_raise_event(object, FSCACHE_OBJECT_EV_CLEARED);
+
+	spin_unlock(&object->lock);
+
+	kfree(op);
+	_leave(" [done]");
+}
+EXPORT_SYMBOL(fscache_put_operation);
+
+/*
+ * garbage collect operations that have had their release deferred
+ */
+void fscache_operation_gc(struct work_struct *work)
+{
+	struct fscache_operation *op;
+	struct fscache_object *object;
+	struct fscache_cache *cache =
+		container_of(work, struct fscache_cache, op_gc);
+	int count = 0;
+
+	_enter("");
+
+	do {
+		spin_lock(&cache->op_gc_list_lock);
+		if (list_empty(&cache->op_gc_list)) {
+			spin_unlock(&cache->op_gc_list_lock);
+			break;
+		}
+
+		op = list_entry(cache->op_gc_list.next,
+				struct fscache_operation, pend_link);
+		list_del(&op->pend_link);
+		spin_unlock(&cache->op_gc_list_lock);
+
+		object = op->object;
+
+		_debug("GC DEFERRED REL OBJ%x OP%x",
+		       object->debug_id, op->debug_id);
+		fscache_stat(&fscache_n_op_gc);
+
+		ASSERTCMP(atomic_read(&op->usage), ==, 0);
+
+		spin_lock(&object->lock);
+		if (test_bit(FSCACHE_OP_EXCLUSIVE, &op->flags)) {
+			ASSERTCMP(object->n_exclusive, >, 0);
+			object->n_exclusive--;
+		}
+
+		ASSERTCMP(object->n_in_progress, >, 0);
+		object->n_in_progress--;
+		if (object->n_in_progress == 0)
+			fscache_start_operations(object);
+
+		ASSERTCMP(object->n_ops, >, 0);
+		object->n_ops--;
+		if (object->n_ops == 0)
+			fscache_raise_event(object, FSCACHE_OBJECT_EV_CLEARED);
+
+		spin_unlock(&object->lock);
+
+	} while (count++ < 20);
+
+	if (!list_empty(&cache->op_gc_list))
+		schedule_work(&cache->op_gc);
+
+	_leave("");
+}
+
+/*
+ * allow the slow work item processor to get a ref on an operation
+ */
+static int fscache_op_get_ref(struct slow_work *work)
+{
+	struct fscache_operation *op =
+		container_of(work, struct fscache_operation, slow_work);
+
+	atomic_inc(&op->usage);
+	return 0;
+}
+
+/*
+ * allow the slow work item processor to discard a ref on an operation
+ */
+static void fscache_op_put_ref(struct slow_work *work)
+{
+	struct fscache_operation *op =
+		container_of(work, struct fscache_operation, slow_work);
+
+	fscache_put_operation(op);
+}
+
+/*
+ * execute an operation using the slow thread pool to provide processing context
+ * - the caller holds a ref to this object, so we don't need to hold one
+ */
+static void fscache_op_execute(struct slow_work *work)
+{
+	struct fscache_operation *op =
+		container_of(work, struct fscache_operation, slow_work);
+	unsigned long start;
+
+	_enter("{OBJ%x OP%x,%d}",
+	       op->object->debug_id, op->debug_id, atomic_read(&op->usage));
+
+	ASSERT(op->processor != NULL);
+	start = jiffies;
+	op->processor(op);
+	fscache_hist(fscache_ops_histogram, start);
+
+	_leave("");
+}
+
+const struct slow_work_ops fscache_op_slow_work_ops = {
+	.get_ref	= fscache_op_get_ref,
+	.put_ref	= fscache_op_put_ref,
+	.execute	= fscache_op_execute,
+};

