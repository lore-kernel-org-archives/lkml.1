Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbXGaHKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbXGaHKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 03:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbXGaHKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 03:10:10 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:10453 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbXGaHKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 03:10:09 -0400
Date: Tue, 31 Jul 2007 11:10:43 +0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Subject: bi_end_io question
Message-ID: <20070731071043.GA19019@dnb.sw.ru>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I want implement some sort of snapshot dev.
In order to do this i've replaced original q->make_request_fn
with specific one which cowed all write requests.
My first attempt looks like this:
static int mysnap_make_request(request_queue_t *q, struct bio *bio)
{
	struct bio cl_bio;
	make_request_fn *fn = get_original_make_fn(q);
	if(bio->bi_rw & (1 << BIO_RW){
	/* This is write request, so we have to cow it first*/
		cl_bio = clone_bio(bio);
		submit_bio(READ, &cl_bio);
		wait_for_completion(&complete); 
		save_cowed_bio(&cl_bio);
		/* At this time old data has successfully saved in cow
		 * area so we may safely perform original request */
	}
	/* call original make_request_fn function for bio*/
	return fn(q, bio);
}
But this implementation has significance performance drawback because
of waiting for read request completion.

So i want use a-sync implementation:
static int my_make_original_request(struct bio *bio, unsigned int bytes_done,
                               int err)
{
	if(bio->bi_size == 0) {
		/* restore original request info */
		struct pending_request*  pr = bio->bi_private;
		/* make original write request */
		ret = pr->fn(pr->q, pr->bio);
		/* error handling logic here*/
	}
}
static int mysnap_make_request_v2(request_queue_t *q, struct bio *bio)
{
	struct bio cl_bio;
	make_request_fn *fn = get_original_make_fn(q);
	if(bio->bi_rw & (1 << BIO_RW){
	/* This is write request, so we have to cow it first*/
		cl_bio = clone_bio(bio);
		cl_bio->bi_private = store_request(fn, q, bio)
		cl_bio->bi_end_io = my_make_original_request;
		/* after read request ended original write request 
		 * will be queued */
		submit_bio(READ, &cl_bio, q);
		/* We dont have to wait submitted bio here any more,
		 * because write request will be automaticaly queued
		 * by cl_bio->bi_end_io callcack.
		 * All job has been done at this moment.
		 */
		return 0;
	}
	/* call original make_request_fn function for bio*/
	return fn(q, bio);
}
My question is following:
1)Can i safely call make_request_fn from ->bi_end_io callback 
  (as it done in my_make_original_request function)
2)May be you have any other sound idea?

thank you.

