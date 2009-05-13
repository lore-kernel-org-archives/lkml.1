Return-Path: <linux-kernel-owner+w=401wt.eu-S1760546AbZEMPC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546AbZEMPC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 11:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZEMPCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 11:02:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44376 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120AbZEMPCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 11:02:45 -0400
Date: Wed, 13 May 2009 11:00:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com
Cc: akpm@linux-foundation.org
Subject: Re: [PATCH 08/18] io-controller: idle for sometime on sync queue
	before expiring it
Message-ID: <20090513150002.GC7696@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-9-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241553525-28095-9-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 03:58:35PM -0400, Vivek Goyal wrote:
> o When a sync queue expires, in many cases it might be empty and then
>   it will be deleted from the active tree. This will lead to a scenario
>   where out of two competing queues, only one is on the tree and when a
>   new queue is selected, vtime jump takes place and we don't see services
>   provided in proportion to weight.
> 
> o In general this is a fundamental problem with fairness of sync queues
>   where queues are not continuously backlogged. Looks like idling is
>   only solution to make sure such kind of queues can get some decent amount
>   of disk bandwidth in the face of competion from continusouly backlogged
>   queues. But excessive idling has potential to reduce performance on SSD
>   and disks with commnad queuing.
> 
> o This patch experiments with waiting for next request to come before a
>   queue is expired after it has consumed its time slice. This can ensure
>   more accurate fairness numbers in some cases.
> 
> o Introduced a tunable "fairness". If set, io-controller will put more
>   focus on getting fairness right than getting throughput right.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---

Following is a fix which should go here. This patch helps me get much 
better fairness numbers for sync queues.


o Fix a window where a queue can be expired without doing busy wait for
  next request. This fix allows better fairness number for sync queues.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/elevator-fq.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: linux14/block/elevator-fq.c
===================================================================
--- linux14.orig/block/elevator-fq.c	2009-05-13 10:55:44.000000000 -0400
+++ linux14/block/elevator-fq.c	2009-05-13 10:55:50.000000000 -0400
@@ -3368,8 +3368,22 @@ void *elv_fq_select_ioq(struct request_q
 	/*
 	 * The active queue has run out of time, expire it and select new.
 	 */
-	if (elv_ioq_slice_used(ioq) && !elv_ioq_must_dispatch(ioq))
-		goto expire;
+	if (elv_ioq_slice_used(ioq) && !elv_ioq_must_dispatch(ioq)) {
+		/*
+		 * Queue has used up its slice. Wait busy is not on otherwise
+		 * we wouldn't have been here. There is a chance that after
+		 * slice expiry no request from the queue completed hence
+		 * wait busy timer could not be turned on. If that's the case
+		 * don't expire the queue yet. Next request completion from
+		 * the queue will arm the wait busy timer.
+		 */
+		if (efqd->fairness && !ioq->nr_queued
+		    && elv_ioq_nr_dispatched(ioq)) {
+			ioq = NULL;
+			goto keep_queue;
+		} else
+			goto expire;
+	}
 
 	/*
 	 * If we have a RT cfqq waiting, then we pre-empt the current non-rt
