Return-Path: <linux-kernel-owner+w=401wt.eu-S1031093AbXDQFLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031093AbXDQFLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 01:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031095AbXDQFLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 01:11:17 -0400
Received: from ns2.suse.de ([195.135.220.15]:47124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031093AbXDQFLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 01:11:17 -0400
From: Neil Brown <neilb@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Date: Tue, 17 Apr 2007 15:10:51 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17956.22235.574867.179016@notabene.brown>
Cc: Brad Campbell <brad@wasp.net.au>, Jens Axboe <jens.axboe@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
In-Reply-To: message from Chuck Ebbert on Monday April 16
References: <4621FAF0.7000705@wasp.net.au>
	<46220339.9080205@wasp.net.au>
	<4623FB29.1000603@redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday April 16, cebbert@redhat.com wrote:
> 
> cfq_dispatch_insert() was called with rq == 0. This one is getting really
> annoying... and md is involved again (RAID0 this time.)

Yeah... weird.
RAID0 is so light-weight and so different from RAID1 or RAID5 that I
feel fairly safe concluding that the problem isn't in or near md.
But that doesn't help you.

This really feels like a locking problem.

The problem occurs when ->next_rq is NULL, but ->sort_list.rb_node is
not NULL.  That happens plenty of times in the code (particularly as
the first request is inserted) but always under ->queue_lock so it
should never be visible to cfq_dispatch_insert..

Except that drivers/scsi/ide-scsi.c:idescsi_eh_reset calls
elv_next_request which could ultimately call __cfq_dispatch_requests
without taking ->queue_lock (that I can see).  But you probably aren't
using ide-scsi (does anyone?).

Given that interrupts are always disabled when queue_lock is taken, it
might be useful to add
   WARN_ON(!irqs_disabled());
every time ->next_rq is set.
Something like the following.

It might show something useful.... if we are lucky.

NeilBrown


diff .prev/block/cfq-iosched.c ./block/cfq-iosched.c
--- .prev/block/cfq-iosched.c	2007-04-17 15:01:36.000000000 +1000
+++ ./block/cfq-iosched.c	2007-04-17 15:02:25.000000000 +1000
@@ -628,6 +628,7 @@ static void cfq_remove_request(struct re
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 
+	BUG_ON(!irqs_disabled());
 	if (cfqq->next_rq == rq)
 		cfqq->next_rq = cfq_find_next_rq(cfqq->cfqd, cfqq, rq);
 
@@ -1810,6 +1811,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, s
 	/*
 	 * check if this request is a better next-serve candidate)) {
 	 */
+	BUG_ON(!irqs_disabled());
 	cfqq->next_rq = cfq_choose_req(cfqd, cfqq->next_rq, rq);
 	BUG_ON(!cfqq->next_rq);
 

