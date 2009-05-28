Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbZE1Wdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbZE1Wdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZE1Wdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:33:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60804 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbZE1Wdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:33:37 -0400
Date: Thu, 28 May 2009 18:33:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       npiggin@suse.de
Cc: Divyesh Shah <dpshah@google.com>, Nauman Rafique <nauman@google.com>
Subject: Query about anticipatory IO scheduler dynamic write batch size
	updation logic
Message-ID: <20090528223330.GC4335@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens, Nick,

I am having a look at anticipatory dynamic write batch size updation logic
and can't understand it. Hence thought it is easier to ask.

IIUC, update_write_batch(), calculates how much time a write batch has
taken and if writes are taking more time than allocated batch size, then
it decreases the number of writes to issue from the write batch and vice
versa.

Currently, update_write_batch() waits for first read request to finish,
and then it comapres the current value of jiffies with "current_batch_expires".

I got two questions here.

- ad->current_batch_expires gets updated with the expiry time of next READ
  batch in as_completed_request() before we call update_write_batch().

  That means effectively we are making sure that as long as writes don't
  consume more than (WRITE + READ) batch size, things are fine.  I am
  guessing that this is not intentional and probably is the side affect
  of following patch.

	commit d585d0b9d73ed999cc7b8cf3cac4a5b01abb544e
	Author: Divyesh Shah <dpshah@google.com>
	Date:   Mon Jun 16 18:37:08 2008 +0200

    	block: Fix the starving writes bug in the anticipatory IO scheduler


- Why do we call update_write_batch() after completion of first read
  request. Shoulnd't it be called after last write request has completed
  from the write batch? Calling it after first read makes it unfair
  beacuse next read might cause a big seek time and we will account that
  into time taken by previous write batch?
 

For the first issue, I wrote a quick crude test patch as follows.

---
 block/as-iosched.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux12/block/as-iosched.c
===================================================================
--- linux12.orig/block/as-iosched.c	2009-04-30 00:48:16.000000000 -0400
+++ linux12/block/as-iosched.c	2009-05-28 17:43:31.000000000 -0400
@@ -103,6 +103,8 @@ struct as_data {
 	sector_t new_seek_mean;
 
 	unsigned long current_batch_expires;
+	unsigned long last_write_batch_expires; /* ideal expiry time of last
+						 * write batch */
 	unsigned long last_check_fifo[2];
 	int changed_batch;		/* 1: waiting for old batch to end */
 	int new_batch;			/* 1: waiting on first read complete */
@@ -811,7 +813,7 @@ static void update_write_batch(struct as
 	unsigned long batch = ad->batch_expire[BLK_RW_ASYNC];
 	long write_time;
 
-	write_time = (jiffies - ad->current_batch_expires) + batch;
+	write_time = (jiffies - ad->last_write_batch_expires) + batch;
 	if (write_time < 0)
 		write_time = 0;
 
@@ -847,6 +849,14 @@ static void as_completed_request(struct 
 	}
 
 	if (ad->changed_batch && ad->nr_dispatched == 1) {
+		/*
+		 * If this was write batch finishing, store the expiry time
+		 * so that it can be used to update write batch size when
+		 * next read request finishes.
+		 */
+		if (ad->batch_data_dir == BLK_RW_SYNC)
+			ad->last_write_batch_expires =
+						ad->current_batch_expires;
 		ad->current_batch_expires = jiffies +
 					ad->batch_expire[ad->batch_data_dir];
 		kblockd_schedule_work(q, &ad->antic_work);


I did a basic test with and without the patch.

I am having a SATA disk and running a reader and a writer with anticipatory
scheduler. I am reading a 2.1 G file and writting the same size file.
Following is my test script.

dd if=/mnt/sdb/testzerofile2 of=/dev/null &
reader=$!
echo "launched reader $reader"

dd if=/dev/zero of=/mnt/sdb/testzerofile1 bs=4K count=524288 &
writer=$!
echo "launched writer $writer"

wait $reader
echo "reader finished"

With current AS (2.6.30-rc4), writer finishes first and gets more
bandwidth.

Without patch
=============

First run
=========
2147483648 bytes (2.1 GB) copied, 49.1937 s, 43.7 MB/s
2147483648 bytes (2.1 GB) copied, 54.8708 s, 39.1 MB/s
reader finished

Second run
==========
2147483648 bytes (2.1 GB) copied, 47.9976 s, 44.7 MB/s
2147483648 bytes (2.1 GB) copied, 58.8639 s, 36.5 MB/s
reader finished

With-patch
==========
First run
---------
2147483648 bytes (2.1 GB) copied, 45.4351 s, 47.3 MB/s
reader finished
2147483648 bytes (2.1 GB) copied, 50.6594 s, 42.4 MB/s

Second run
----------
2147483648 bytes (2.1 GB) copied, 45.8888 s, 46.8 MB/s
reader finished
2147483648 bytes (2.1 GB) copied, 51.1322 s, 42.0 MB/s


Note that without patch, writer wins the race and with patch, reader wins
the race. I am not sure what is the expected behavior from AS but I
thought at least I will ask the question.

Thanks
Vivek
