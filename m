Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbXGFOwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbXGFOwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbXGFOwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:52:33 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:11566 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbXGFOwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:52:33 -0400
Date: Fri, 6 Jul 2007 18:51:32 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, vtaras@openvz.org
Subject: Write-only stuff in CFQ data structures
Message-ID: <20070706145131.GB11067@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, there are some write-only fields in cfq_data and cfq_queue to be
added in 2.6.22. I'm attaching patch to show what can be deleted, but
something suspicious is going on:

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index baef5fc..eed7020 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -109,9 +109,6 @@ struct cfq_data {
 	unsigned int cfq_slice_idle;
 
 	struct list_head cic_list;
-
-	sector_t new_seek_mean;
-	u64 new_seek_total;
 };
 
 /*
@@ -151,8 +148,6 @@ struct cfq_queue {
 
 	/* various state flags, see below */
 	unsigned int flags;
-
-	sector_t last_request_pos;
 };
 
 enum cfqq_state_flags {
@@ -1570,11 +1565,6 @@ cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_io_context *cic,
 	else
 		sdist = cic->last_request_pos - rq->sector;
 
-	if (!cic->seek_samples) {
-		cfqd->new_seek_total = (7*cic->seek_total + (u64)256*sdist) / 8;
-		cfqd->new_seek_mean = cfqd->new_seek_total / 256;
-	}
-
 	/*
 	 * Don't allow the seek distance to get too large from the
 	 * odd fragment, pagein, etc
@@ -1710,7 +1700,6 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfq_update_idle_window(cfqd, cfqq, cic);
 
 	cic->last_request_pos = rq->sector + rq->nr_sectors;
-	cfqq->last_request_pos = cic->last_request_pos;
 
 	if (cfqq == cfqd->active_queue) {
 		/*

