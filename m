Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbYJWQN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbYJWQN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbYJWQNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:13:49 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2944 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYJWQNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:13:48 -0400
Date: Thu, 23 Oct 2008 18:13:37 +0200
From: Miquel van Smoorenburg <mikevs@xs4all.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] elevator.c: prevent flushing small requests to device
Message-ID: <20081023161333.GA28155@xs4all.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-NCC-RegID: nl.xs4all
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While tracing I/O patterns with blktrace (a great tool) a few
weeks ago I identified a minor issue in elevator.c

[PATCH] elevator.c: prevent flushing small requests to device

When elv_insert() is called to insert a new request, and the
device is plugged,  bit of code at the end of the function
will unplug the device if the number of pending requests >= q->unplug_thresh.

This means the current request is also sent to the device immidiately
while it is potentially mergeable with the next request. This has been
observed when a lot of small sequential requests are made.

By unplugging the device before we add the new request to the
queue this can be prevented.

Signed-off-by: Miquel van Smoorenburg <mikevs@xs4all.net>

diff -ruN linux-2.6.26.5.orig/block/elevator.c linux-2.6.26.5/block/elevator.c
--- linux-2.6.26.5.orig/block/elevator.c	2008-09-08 19:40:20.000000000 +0200
+++ linux-2.6.26.5/block/elevator.c	2008-10-23 00:33:21.000000000 +0200
@@ -602,6 +602,20 @@
 
 	case ELEVATOR_INSERT_SORT:
 		BUG_ON(!blk_fs_request(rq));
+		/*
+		 * If we're going to unplug the device, do it now before
+		 * we put a potentially small and mergeable new
+		 * request on the queue, instead of just after it.
+		 */
+		if (blk_queue_plugged(q)) {
+			int nrq = q->rq.count[READ] + q->rq.count[WRITE]
+				- q->in_flight;
+			if (nrq >= q->unplug_thresh)
+				__generic_unplug_device(q);
+			if (elv_queue_empty(q))
+				blk_plug_device(q);
+			unplug_it = 0;
+		}
 		rq->cmd_flags |= REQ_SORTED;
 		q->nr_sorted++;
 		if (rq_mergeable(rq)) {
