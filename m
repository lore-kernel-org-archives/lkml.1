Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZGATx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZGATx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZGATxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:53:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60038 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbZGATxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:53:48 -0400
Message-ID: <4A4BBECD.8000908@redhat.com>
Date: Wed, 01 Jul 2009 15:53:49 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] add block IO documentation to tracepoint docbook
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------000207060603040402050900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000207060603040402050900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The following patch adds block IO tracepoint documentation to the tracepoint
docbook.

Signed-off-by: William Cohen <wcohen@xxxxxxxxxx>

--------------000207060603040402050900
Content-Type: text/plain;
 name="blk_trace_doc3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="blk_trace_doc3.patch"

diff --git a/Documentation/DocBook/tracepoint.tmpl b/Documentation/DocBook/tracepoint.tmpl
index b0756d0..41824b2 100644
--- a/Documentation/DocBook/tracepoint.tmpl
+++ b/Documentation/DocBook/tracepoint.tmpl
@@ -16,6 +16,15 @@
      </address>
     </affiliation>
    </author>
+   <author>
+    <firstname>William</firstname>
+    <surname>Cohen</surname>
+    <affiliation>
+     <address>
+      <email>wcohen@redhat.com</email>
+     </address>
+    </affiliation>
+   </author>
   </authorgroup>
 
   <legalnotice>
@@ -86,4 +95,8 @@
 !Iinclude/trace/events/irq.h
   </chapter>
 
+  <chapter id="block">
+   <title>Block IO</title>
+!Iinclude/trace/events/block.h
+  </chapter>
 </book>
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index d6b05f4..3e89091 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -8,6 +8,16 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM block
 
+/**
+ * block_rq_abort - Abort Block Operation Request
+ * @q: queue containing the block operation request
+ * @rq: block IO operation request
+ *
+ * Called immediately after pending block IO operation request @rq in
+ * queue @q is aborted. The fields in the operation request @rq
+ * can be examined to determine which device and sectors the pending
+ * operation would access.
+ */
 TRACE_EVENT(block_rq_abort,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
@@ -40,6 +50,16 @@ TRACE_EVENT(block_rq_abort,
 		  __entry->nr_sector, __entry->errors)
 );
 
+/**
+ * block_rq_insert - Insert Block Operation Request into Queue
+ * @q: target queue
+ * @rq: block IO operation request
+ *
+ * Called immediately before block operation request @rq is inserted
+ * into queue @q.  The fields in the operation request @rq struct can
+ * be examined to determine which device and sectors the pending
+ * operation would access.
+ */
 TRACE_EVENT(block_rq_insert,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
@@ -74,6 +94,14 @@ TRACE_EVENT(block_rq_insert,
 		  __entry->nr_sector, __entry->comm)
 );
 
+/**
+ * block_rq_issue - Issue Pending Block IO Request Operation to Device Driver
+ * @q: queue holding operation
+ * @rq: block IO operation operation request
+ *
+ * Called when block operation request @rq from queue @q is sent to a
+ * device driver for processing.
+ */
 TRACE_EVENT(block_rq_issue,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
@@ -108,6 +136,15 @@ TRACE_EVENT(block_rq_issue,
 		  __entry->nr_sector, __entry->comm)
 );
 
+/**
+ * block_rq_requeue - Place Block IO Request Back on a Queue
+ * @q: queue holding operation
+ * @rq: block IO operation request
+ *
+ * The block operation request @rq is being placed back into queue
+ * @q.  For some reason the request was not completed and needs to be
+ * put back in the queue.
+ */
 TRACE_EVENT(block_rq_requeue,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
@@ -140,6 +177,17 @@ TRACE_EVENT(block_rq_requeue,
 		  __entry->nr_sector, __entry->errors)
 );
 
+/**
+ * block_rq_complete - Block IO Operation Completed by Device Driver
+ * @q: queue containing the block operation request
+ * @rq: block operations request
+ *
+ * The block_rq_complete tracepoint event indicates that some portion
+ * of operation request has been completed by the device driver.  If
+ * the @rq->bio is NULL, then there is absolutely no additonal work to
+ * do for the request. If @rq->bio is non-NULL then there is
+ * additional work is required to complete the request.
+ */
 TRACE_EVENT(block_rq_complete,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
@@ -171,6 +219,18 @@ TRACE_EVENT(block_rq_complete,
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->errors)
 );
+
+/**
+ * block_bio_bounce - Used Bounce Buffer When Processing Block Operation
+ * @q: queue holding the block operation
+ * @bio: block operation
+ *
+ * A bounce buffer was used to handle the block operation @bio in @q.
+ * This occurs when hardware limitations prevent a direct transfer of
+ * data between the @bio data memory area and the IO device.  Use of a
+ * bounce buffer requires extra copying of data and decreases
+ * performance.
+ */
 TRACE_EVENT(block_bio_bounce,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
@@ -199,6 +259,14 @@ TRACE_EVENT(block_bio_bounce,
 		  __entry->nr_sector, __entry->comm)
 );
 
+/**
+ * block_bio_complete - Completed All Work on the Block Operation
+ * @q: queue holding the block operation
+ * @bio: block operation completed
+ *
+ * This tracepoint indicates there is no further work to do on this
+ * block IO operation @bio.
+ */
 TRACE_EVENT(block_bio_complete,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
@@ -226,6 +294,14 @@ TRACE_EVENT(block_bio_complete,
 		  __entry->nr_sector, __entry->error)
 );
 
+/**
+ * block_bio_backmerge - Merging Block Operation to the End of an Existing Operation
+ * @q: queue holding operation
+ * @bio: new block operation to merge
+ *
+ * Merging block request @bio to the end of an existing block request
+ * in queue @q.
+ */
 TRACE_EVENT(block_bio_backmerge,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
@@ -254,6 +330,14 @@ TRACE_EVENT(block_bio_backmerge,
 		  __entry->nr_sector, __entry->comm)
 );
 
+/**
+ * block_bio_frontmerge - Merging Block Operation to the beginning of an Existing Operation
+ * @q: queue holding operation
+ * @bio: new block operation to merge
+ *
+ * Merging block IO operation @bio to the beginning of an existing block
+ * operation in queue @q.
+ */
 TRACE_EVENT(block_bio_frontmerge,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
@@ -282,6 +366,13 @@ TRACE_EVENT(block_bio_frontmerge,
 		  __entry->nr_sector, __entry->comm)
 );
 
+/**
+ * block_bio_queue - Putting New Block IO Operation in Queue
+ * @q: queue holding operation
+ * @bio: new block operation
+ *
+ * About to  place the block IO operation @bio into queue @q.
+ */
 TRACE_EVENT(block_bio_queue,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
@@ -310,6 +401,15 @@ TRACE_EVENT(block_bio_queue,
 		  __entry->nr_sector, __entry->comm)
 );
 
+/**
+ * block_getrq - Get a Free Request Entry in Queue for Block IO Operations
+ * @q: queue for operations
+ * @bio: pending block IO operation
+ * @rw: low bit indicates a read (%0) or a write (%1)
+ *
+ * A request struct for queue @q has been allocated to handle the
+ * block IO operation @bio.
+ */
 TRACE_EVENT(block_getrq,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
@@ -339,6 +439,17 @@ TRACE_EVENT(block_getrq,
 		  __entry->nr_sector, __entry->comm)
 );
 
+/**
+ * block_sleeprq - Waiting to Get a Free Request Entry in Queue for Block IO Operation
+ * @q: queue for operation
+ * @bio: pending block IO operation
+ * @rw: low bit indicates a read (%0) or a write (%1)
+ *
+ * In the case where a request struct cannot be provided for queue @q,
+ * the process needs to wait for an request struct to become
+ * available.  This tracepoint event is generated each time the
+ * process goes to sleep waiting for request struct become available.
+ */
 TRACE_EVENT(block_sleeprq,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
@@ -368,6 +479,14 @@ TRACE_EVENT(block_sleeprq,
 		  __entry->nr_sector, __entry->comm)
 );
 
+/**
+ * block_plug - Keep Operations Requests in Request Queue
+ * @q: request queue to plug
+ *
+ * Plug the request queue @q.  Do not allow block operation requests
+ * to be sent to the device driver. Instead, accumulate requests in
+ * the queue to improve throughput performance of the block device.
+ */
 TRACE_EVENT(block_plug,
 
 	TP_PROTO(struct request_queue *q),
@@ -385,6 +504,13 @@ TRACE_EVENT(block_plug,
 	TP_printk("[%s]", __entry->comm)
 );
 
+/**
+ * block_unplug_timer - Timed Release of Operations Requests in Queue to Device Driver
+ * @q: request queue to unplug
+ *
+ * Unplug the request queue @q because a timer expired and allow block
+ * operation requests to be sent to the device driver.
+ */
 TRACE_EVENT(block_unplug_timer,
 
 	TP_PROTO(struct request_queue *q),
@@ -404,6 +530,13 @@ TRACE_EVENT(block_unplug_timer,
 	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
 );
 
+/**
+ * block_unplug_io - Release of Operations Requests in Request Queue
+ * @q: request queue to unplug
+ *
+ * Unplug request queue @q because device driver is scheduled to work
+ * on elements in the request queue.
+ */
 TRACE_EVENT(block_unplug_io,
 
 	TP_PROTO(struct request_queue *q),
@@ -423,6 +556,17 @@ TRACE_EVENT(block_unplug_io,
 	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
 );
 
+/**
+ * block_split - Split a Single bio struct into Two bio structs
+ * @q: queue containing the bio
+ * @bio: block operation being split
+ * @new_sector: The starting sector for the new bio
+ *
+ * The bio request @bio in request queue @q needs to be split into two
+ * bio requests. The newly created @bio request starts at
+ * @new_sector. This split may be required due to hardware limitation
+ * such as operation crossing device boundaries in a RAID system.
+ */
 TRACE_EVENT(block_split,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio,
@@ -453,6 +597,16 @@ TRACE_EVENT(block_split,
 		  __entry->comm)
 );
 
+/**
+ * block_remap - Map Request for a Partition to the Raw Device
+ * @q: queue holding the operation
+ * @bio: revised operation
+ * @dev: device for the operation
+ * @from: original sector for the operation
+ *
+ * An operation for a partion on a block device has been mapped to the
+ * raw block device.
+ */
 TRACE_EVENT(block_remap,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,

--------------000207060603040402050900--
