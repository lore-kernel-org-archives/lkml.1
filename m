Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbXDYK74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbXDYK74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932185AbXDYK7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:59:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280AbXDYK7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:59:52 -0400
From: Neil Brown <neilb@suse.de>
To: Brad Campbell <brad@wasp.net.au>
Date: Wed, 25 Apr 2007 20:59:33 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17967.13461.154177.135843@notabene.brown>
Cc: Jens Axboe <jens.axboe@oracle.com>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
In-Reply-To: message from Brad Campbell on Wednesday April 25
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
	<17967.4734.783140.512857@notabene.brown>
	<462F2810.6000909@wasp.net.au>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday April 25, brad@wasp.net.au wrote:
> 
> [  756.311074] BUG: at block/cfq-iosched.c:543 cfq_reposition_rq_rb()
> [  756.329615]  [<c0204fa1>] cfq_merged_request+0x71/0x80
> [  756.345046]  [<c0204f30>] cfq_merged_request+0x0/0x80
> [  756.360216]  [<c01fb4ae>] elv_merged_request+0x4e/0x50
> [  756.375647]  [<c01ff1a7>] __make_request+0x1a7/0x2f0
> [  756.390557]  [<c01ff497>] generic_make_request+0x127/0x190
> [  756.407025]  [<c02bb011>] chunk_aligned_read+0x111/0x1c0
                               ^^^^^^^^^^^^^^^^^
> [  756.422974]  [<c01ff497>] generic_make_request+0x127/0x190
> [  756.439443]  [<c02bb448>] make_request+0x388/0x3b0
> [  756.453834]  [<c016e027>] __bio_add_page+0x147/0x1c0
> [  756.468742]  [<c016dbff>] bio_alloc_bioset+0x7f/0x150
> [  756.483913]  [<c02bac50>] raid5_mergeable_bvec+0x0/0x90
> [  756.499604]  [<c016e107>] bio_add_page+0x37/0x50
> [  756.513473]  [<c01ff497>] generic_make_request+0x127/0x190
> [  756.529943]  [<c013586a>] mempool_free+0x2a/0x60
> [  756.543812]  [<c016dadd>] bio_free+0x1d/0x40
> [  756.556645]  [<c01ff546>] submit_bio+0x46/0xc0
> [  756.571389]  [<c020a396>] radix_tree_node_alloc+0x16/0x60
> [  756.587610]  [<c020a5c2>] radix_tree_insert+0xe2/0x130
> [  756.603039]  [<c0139575>] __pagevec_lru_add+0x75/0x80
> [  756.618207]  [<c0171971>] mpage_bio_submit+0x11/0x20
> [  756.633117]  [<c01720e0>] mpage_readpages+0x100/0x140
                               ^^^^^^^^^^^^^^^

So it is a regular data read (not metadata of any sort) which is
by-passing the stripe cache.  I was expecting some sort of metadata
read.
I wander what this is merging in-front of... maybe a stripe-cache
read.
I guess it doesn't tell us anything really interesting, which is
probably a good thing - it means everything else is working properly.

I wonder if we should avoid bypassing the stripe cache if the needed stripes
are already in the cache... or if at least one needed stripe is.... or
if the array is degraded...
Probably in the degraded case we should never bypass the cache, as if
we do, then a sequential read of a full stripe will read every block
twice.  I'd better to some performance measurements.

Thanks for all the patient testing.

NeilBrown
