Return-Path: <linux-kernel-owner+w=401wt.eu-S1946271AbXBCCl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946271AbXBCCl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946279AbXBCCl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:41:58 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53455 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946274AbXBCClv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:41:51 -0500
Message-Id: <20070203024216.653370000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:33 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Linas Vepstas <linas@austin.ibm.com>, Jens Axboe <axboe@suse.de>
Subject: [patch 29/59] elevator: move clearing of unplug flag earlier
Content-Disposition: inline; filename=elevator-move-clearing-of-unplug-flag-earlier.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Linas Vepstas <linas@austin.ibm.com>

A flag was recently added to the elevator code to avoid
performing an unplug when reuests are being re-queued.
The goal of this flag was to avoid a deep recursion that
can occur when re-queueing requests after a SCSI device/host
reset.  See http://lkml.org/lkml/2006/5/17/254

However, that fix added the flag near the bottom of a case
statement, where an earlier break (in an if statement) could
transport one out of the case, without setting the flag.
This patch sets the flag earlier in the case statement.

I re-discovered the deep recursion recently during testing;
I was told that it was a known problem, and the fix to it was
in the kernel I was testing. Indeed it was ... but it didn't
fix the bug. With the patch below, I no longer see the bug.

Signed-off by: Linas Vepstas <linas@austin.ibm.com>
Signed-off-by: Jens Axboe <axboe@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 block/elevator.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- linux-2.6.19.2.orig/block/elevator.c
+++ linux-2.6.19.2/block/elevator.c
@@ -572,6 +572,12 @@ void elv_insert(request_queue_t *q, stru
 		 */
 		rq->cmd_flags |= REQ_SOFTBARRIER;
 
+		/*
+		 * Most requeues happen because of a busy condition,
+		 * don't force unplug of the queue for that case.
+		 */
+		unplug_it = 0;
+
 		if (q->ordseq == 0) {
 			list_add(&rq->queuelist, &q->queue_head);
 			break;
@@ -586,11 +592,6 @@ void elv_insert(request_queue_t *q, stru
 		}
 
 		list_add_tail(&rq->queuelist, pos);
-		/*
-		 * most requeues happen because of a busy condition, don't
-		 * force unplug of the queue for that case.
-		 */
-		unplug_it = 0;
 		break;
 
 	default:

--
