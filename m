Return-Path: <linux-kernel-owner+w=401wt.eu-S1423292AbXDYIeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423292AbXDYIeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423296AbXDYIeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:34:18 -0400
Received: from ns1.suse.de ([195.135.220.2]:43957 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423292AbXDYIeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:34:17 -0400
From: Neil Brown <neilb@suse.de>
To: Brad Campbell <brad@wasp.net.au>
Date: Wed, 25 Apr 2007 18:34:06 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17967.4734.783140.512857@notabene.brown>
Cc: Jens Axboe <jens.axboe@oracle.com>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
In-Reply-To: message from Brad Campbell on Tuesday April 24
References: <4621FAF0.7000705@wasp.net.au>
	<46220339.9080205@wasp.net.au>
	<4623FB29.1000603@redhat.com>
	<17956.22235.574867.179016@notabene.brown>
	<20070418123757.GC3796@kernel.dk>
	<46261ACE.1050407@wasp.net.au>
	<20070418132157.GC3720@kernel.dk>
	<462B10C3.1030906@wasp.net.au>
	<20070423073543.GE5311@kernel.dk>
	<462E5D38.5000801@wasp.net.au>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday April 24, brad@wasp.net.au wrote:
> [105449.653682] cfq: rbroot not empty, but ->next_rq == NULL! Fixing up, report the issue to 
> lkml@vger.kernel.org
> [105449.683646] cfq: busy=1,drv=0,timer=0
> [105449.694871] cfq rr_list:
> [105449.702715]   3108: sort=0,next=00000000,q=0/1,a=1/0,d=0/0,f=69
> [105449.720693] cfq busy_list:
> [105449.729054] cfq idle_list:
> [105449.737418] cfq cur_rr:

Ok, I have a theory.

An ELEVATOR_FRONT_MERGE occurs which changes req->sector and calls
->elevator_merged_fn which is cfq_merged_request.

At this time there is already a request in cfq with the same sector
number, and that request is the only other request on the queue.

cfq_merged_request calls cfq_reposition_rq_rb which removes the
req from ->sortlist and then calls cfq_add_rq_rb to add it back (at
the new location because ->sector has changed).

cfq_add_rq_rb finds there is already a request with the same sector
number and so elv_rb_add returns an __alias which is passed to
cfq_dispatch_insert. 
This calls cfq_remove_request and as that is the only request present,
->next_rq gets set to NULL.
The old request with the new sector number is then added to the
->sortlist, but ->next_rq is never set - it remains NULL.

How likely it would be to get two requests with the same sector number
I don't know.  I wouldn't expect it to ever happen - I have seen it
before, but it was due to a bug in ext3.  Maybe XFS does it
intentionally some times?

You could test this theory by putting a
   WARN_ON(cfqq->next_rq == NULL);
at the end of cfq_reposition_rq_rb, just after the cfq_add_rq_rb call.

I will leave the development of a suitable fix up to Jens if he agrees
that this is possible.

NeilBrown
