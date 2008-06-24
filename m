Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbYFXO2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbYFXO2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbYFXO2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:28:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427AbYFXO2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:28:31 -0400
Date: Tue, 24 Jun 2008 10:27:52 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Avoid bio_endio recursion
In-Reply-To: <20080624080744.GL20851@kernel.dk>
Message-ID: <Pine.LNX.4.64.0806241017390.23052@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com>
 <20080624080744.GL20851@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jun 2008, Jens Axboe wrote:

> On Tue, Jun 24 2008, Mikulas Patocka wrote:
>> Hi
>>
>> bio_endio calls bi_end_io callback. In case of stacked devices (raid, dm),
>> bio_end_io may call bio_endio again, up to an unspecified length.
>>
>> The crash because of stack overflow was really observed on sparc64. And
>> this recursion was one of the contributing factors (using 9 stack frames
>> --- that is 1728 bytes).
>
> Looks good, I like the concept. Can you please make it a little less
> goto driven, though? The next_bio and goto next_bio could just be a
> while().
>
> -- 
> Jens Axboe
>

Hi.

This is the patch, slightly de-goto-ized. (it still contains one, I think 
that while (1) { ... break ... } is no better readable than goto).

I found another problem in my previous patch, I forgot about the "error" 
variable (it would cause misbehavior for example if disk fails, submits an 
error and raid driver turns this failure into success). We need to save 
the error variable somewhere in the bio, there is no other place where it 
could be placed. I temporarily saved it to bi_idx, because it's unused at 
this place.

Mikulas

--


Avoid recursion on bio_endio. bio_endio calls bio->bi_end_io which may in turn
call bio_endio again. When this recursion happens, put the new bio to the queue
and process it later, from the top-level bio_endio.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.26-rc7-devel/fs/bio.c
===================================================================
--- linux-2.6.26-rc7-devel.orig/fs/bio.c	2008-06-23 13:49:45.000000000 +0200
+++ linux-2.6.26-rc7-devel/fs/bio.c	2008-06-24 11:17:24.000000000 +0200
@@ -1168,13 +1168,44 @@
   **/
  void bio_endio(struct bio *bio, int error)
  {
+	static DEFINE_PER_CPU(struct bio **, bio_end_queue) = { NULL };
+	struct bio ***bio_end_queue_ptr;
+	struct bio *bio_queue;
+
+	unsigned long flags;
+
+	bio->bi_idx = error;
  	if (error)
  		clear_bit(BIO_UPTODATE, &bio->bi_flags);
  	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
-		error = -EIO;
+		bio->bi_idx = -EIO;
+
+	local_irq_save(flags);
+	bio_end_queue_ptr = &__get_cpu_var(bio_end_queue);
+
+	if (*bio_end_queue_ptr) {
+		**bio_end_queue_ptr = bio;
+		*bio_end_queue_ptr = &bio->bi_next;
+		bio->bi_next = NULL;
+	} else {
+		bio_queue = NULL;
+		*bio_end_queue_ptr = &bio_queue;
+
+next_bio:
+		if (bio->bi_end_io)
+			bio->bi_end_io(bio, (short)bio->bi_idx);
+
+		if (bio_queue) {
+			bio = bio_queue;
+			bio_queue = bio->bi_next;
+			if (!bio_queue)
+				*bio_end_queue_ptr = &bio_queue;
+			goto next_bio;
+		}
+		*bio_end_queue_ptr = NULL;
+	}

-	if (bio->bi_end_io)
-		bio->bi_end_io(bio, error);
+	local_irq_restore(flags);
  }

  void bio_pair_release(struct bio_pair *bp)
