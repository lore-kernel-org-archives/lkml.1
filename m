Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbXJWGtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbXJWGtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 02:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbXJWGts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 02:49:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38690
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbXJWGtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 02:49:47 -0400
Date: Mon, 22 Oct 2007 23:50:10 -0700 (PDT)
Message-Id: <20071022.235010.59469063.davem@davemloft.net>
To: jens.axboe@oracle.com
CC: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: IDE crash...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm debugging a blk_rq_map_sg() crash that i'm getting on sparc64 as
root is mounted over IDE.  I think I know what is happening now.

The IDE sg table is allocated and initialized like this in
drivers/ide/ide-probe.c:

	x = kmalloc(sizeof(struct scatterlist) * nents, GFP_XXX);
	sg_init_table(x, nents);

So far, so good.

Now, ide_map_sg() passes requests down to blk_rq_map_sg() like this in
drivers/block/ide-io.c:

		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);

Ok, so what does blk_rq_map_sg() do?

	sg = NULL;
	rq_for_each_segment(bvec, rq, iter) {
 ...
		if (bvprv && cluster) {
 ...
		} else {
new_segment:
			if (!sg)
				sg = sglist;
			else
				sg = sg_next(sg);
 ...
		}
		bvprv = bvec;
	} /* segments in rq */

	if (sg)
		__sg_mark_end(sg);

So let's say the first request comes in and needs 2 segs.
This will mark sg[1].page_link with 0x2

If the next request from IDE needs 4 segs, we'll OOPS because
sg_next() on &sg[1] will see page_link bit 0x2 is set and
therefore return NULL.

A quick look shows that if you're testing on SCSI (or something
layered on top of it like SATA or PATA) you won't see this seemingly
guarenteed crash because the SCSI mid-layer allocates a fresh sglist
via mempool_alloc() and runs sg_init_table() on it for every I/O
request.
