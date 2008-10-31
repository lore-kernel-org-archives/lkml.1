Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbYJaMtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbYJaMtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 08:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYJaMs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 08:48:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51735 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbYJaMs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 08:48:57 -0400
Date: Fri, 31 Oct 2008 13:47:44 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: disk statistics issue in 2.6.27
Message-ID: <20081031124743.GH31673@kernel.dk>
References: <20081019113102.GA18440@xs4all.net> <20081020171248.GE19428@kernel.dk> <1224686272.25437.14.camel@n2o.xs4all.nl> <20081022171712.GO22217@kernel.dk> <1224777902.26805.17.camel@n2o.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224777902.26805.17.camel@n2o.xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23 2008, Miquel van Smoorenburg wrote:
> On Wed, 2008-10-22 at 19:17 +0200, Jens Axboe wrote:
> > On Wed, Oct 22 2008, Miquel van Smoorenburg wrote:
> > > On Mon, 2008-10-20 at 19:12 +0200, Jens Axboe wrote:
> > > > On Sun, Oct 19 2008, Miquel van Smoorenburg wrote:
> >
> > > > > I noticed that the "iostat -k -x 2" output does't make any sense.
> > > > > The number of reads/sec and number of writes/sec are about what I
> > > > > would expect, and so are the other fields, but rkB/sec and wkB/sec
> > > > > are  completely off-scale: gigabytes read/written per second.
> > > >
> > > 
> > > > Are the reported values in iostat any sort of multiple of the real
> > > > throughtput, or is is just insanely large?
> > > 
> > > It looks like it's a multiple, but it appears to vary between 128 and
> > > 512, and is different for reads and writes, so I do not know what to
> > > make of it.
> > > 
> 
> I added some debug statements to block/blk-core.c, and it appears that
> blk_end_io() is always called with nr_bytes == 16320 Kbytes (16711680).
> 
> Ofcourse I should have noticed earlier that iostat -x 2 always prints
> 32640 as "average request size" (in sectors).

You didn't happen to log a backtrace from that, did you? That's a weird
nr_bytes, it's 0xff0000.

I'm assuming this then fixes it, just wondering what the heck is going
on here.

diff --git a/block/blk-core.c b/block/blk-core.c
index 33c8d4b..a372618 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1712,11 +1710,12 @@ static int __end_that_request_first(struct request *req, int error,
 	if (blk_fs_request(req) && req->rq_disk) {
 		const int rw = rq_data_dir(req);
 		struct hd_struct *part;
-		int cpu;
+		int cpu, sectors;
 
+		sectors = min_t(int, nr_bytes >> 9, req->hard_nr_sectors);
 		cpu = part_stat_lock();
 		part = disk_map_sector_rcu(req->rq_disk, req->sector);
-		part_stat_add(cpu, part, sectors[rw], nr_bytes >> 9);
+		part_stat_add(cpu, part, sectors[rw], sectors);
 		part_stat_unlock();
 	}
 

-- 
Jens Axboe

