Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbYGCVJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbYGCVJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYGCVJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:09:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbYGCVJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:09:08 -0400
Date: Thu, 3 Jul 2008 17:08:10 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Avoid bio_endio recursion
In-Reply-To: <20080702082511.GF20055@kernel.dk>
Message-ID: <Pine.LNX.4.64.0807031704120.20244@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com>
 <20080624080744.GL20851@kernel.dk> <Pine.LNX.4.64.0806241017390.23052@engineering.redhat.com>
 <20080625082421.GU20851@kernel.dk> <Pine.LNX.4.64.0806252008380.11130@engineering.redhat.com>
 <20080626070723.GL20851@kernel.dk> <Pine.LNX.4.64.0807020001290.9097@engineering.redhat.com>
 <20080702082511.GF20055@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008, Jens Axboe wrote:

> On Wed, Jul 02 2008, Mikulas Patocka wrote:
>>> Right, that wont work of course. Completions are typically done through
>>> a softirq, so it is not currently done with hard interrupts disabled.
>>
>> I thought, from hardirq - that's what IDE is doing. And they are called
>> with interrupts disabled (maybe unless you specify unmaskirq, which is not
>> default). What block driver does completions with softirq? ... and why?
>
> The key word is 'typically', the old IDE driver really isn't used very
> much. The SCSI layer and eg cciss uses the block layer softirq
> completions, so that is what 99% of the uses will be.

I use the old IDE driver, I don't see a reason why driver should create 
SCSI requests and lower layer translate them to ATA commands.

Just to look, this is the first version of the patch without disabling 
interrupts. If you are concerned about disabling interrupts, you can go 
this way.

Mikulas

Index: linux-2.6.26-rc5-devel/fs/bio.c
===================================================================
--- linux-2.6.26-rc5-devel.orig/fs/bio.c	2008-06-18 16:05:45.000000000 +0200
+++ linux-2.6.26-rc5-devel/fs/bio.c	2008-06-18 23:27:28.000000000 +0200
@@ -1168,6 +1168,25 @@
   **/
  void bio_endio(struct bio *bio, int error)
  {
+	static DEFINE_PER_CPU(local_t, bio_end_queue) = LOCAL_INIT(0);
+	local_t *bio_end_queue_ptr;
+	unsigned long l;
+
+	bio->bi_next = NULL;
+
+	bio_end_queue_ptr = &get_cpu_var(bio_end_queue);
+	if (local_read(bio_end_queue_ptr)) {
+insert_race:
+		bio->bi_next = (void *)local_read(bio_end_queue_ptr);
+		if (unlikely(local_cmpxchg(bio_end_queue_ptr, (unsigned long)bio->bi_next, (unsigned long)bio) != (unsigned long)bio->bi_next))
+			goto insert_race;
+		put_cpu_var(bio_end_queue);
+		return;
+	}
+
+	local_set(bio_end_queue_ptr, 1);
+
+process_bio:
  	if (error)
  		clear_bit(BIO_UPTODATE, &bio->bi_flags);
  	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
@@ -1175,6 +1194,19 @@

  	if (bio->bi_end_io)
  		bio->bi_end_io(bio, error);
+
+remove_race:
+	l = local_read(bio_end_queue_ptr);
+	if (l != 1) {
+		bio = (void *)l;
+		if (unlikely(local_cmpxchg(bio_end_queue_ptr, (unsigned long)bio, (unsigned long)bio->bi_next) != (unsigned long)bio))
+			goto remove_race;
+		goto process_bio;
+	}
+	if (unlikely(local_cmpxchg(bio_end_queue_ptr, 1, 0) != 1))
+		goto remove_race;
+
+	put_cpu_var(bio_end_queue);
  }

  void bio_pair_release(struct bio_pair *bp)
