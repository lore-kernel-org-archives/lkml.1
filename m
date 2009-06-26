Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZFZFtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZFZFtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 01:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZFZFtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 01:49:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbZFZFtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 01:49:05 -0400
From: Neil Brown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Fri, 26 Jun 2009 15:49:39 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19012.24947.650584.93908@notabene.brown>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: block tree build failure
In-Reply-To: message from Jens Axboe on Friday June 26
References: <20090626125331.89c689f2.sfr@canb.auug.org.au>
	<f236aae1aa8ea7c4f3700dbca2f3ae14.squirrel@neil.brown.name>
	<20090626043937.GJ31415@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday June 26, jens.axboe@oracle.com wrote:
> On Fri, Jun 26 2009, NeilBrown wrote:
> > On Fri, June 26, 2009 12:53 pm, Stephen Rothwell wrote:
> > > Hi Jens,
> > >
> > > Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> > >
> > > block/blk-core.c: In function '__make_request':
> > > block/blk-core.c:1179: error: expected ';' before 'return'
> > >
> > > Caused by commit 6cf2a6c8d01514e86a8d38e4eeed402378b635dc ("Restore
> > > barrier support for md and probably other virtual devices") which I have
> > > reverted for today.
> > 
> > Arg, that's my fault - sorry.
> > 
> > +               bio_endio(bio, -EOPNOTSUPP)
> > +                       return 0;
> > 
> > should of course be
> > 
> > +               bio_endio(bio, -EOPNOTSUPP);
> > +               return 0;
> 
> I was certain I ran it through a compile cycle, sorry about that
> Stephen. And Neil sending uncompiled patches, very uncool. Did you even
> test it? I've pulled it for now.

I tested this time.
Without the patch a 'mount -o journal=1 /dev/md0 /mnt'
followed by writing to /mnt/something produces

Jun 26 15:34:18 dell kernel: JBD: barrier-based sync failed on md0 - disabling barriers

in the kernel logs.
With the patch, it doesn't.

Comment updated slightly too.

NeilBrown

Author: NeilBrown <neilb@suse.de>
Date:   Fri Jun 26 15:41:35 2009 +1000

Restore barrier support for md and probably other virtual devices.

The next_ordered flag is only meaningful for devices that use __make_request.
So move the test against next_ordered out of generic code and in to
__make_request

Since this test was added, barriers have not worked on md or any
devices that don't use __make_request and so don't bother to set
next_ordered.  (dm explicitly sets something other than
QUEUE_ORDERED_NONE since
  commit 99360b4c18f7675b50d283301d46d755affe75fd
but notes in the comments that it is otherwise meaningless).

Cc: Ken Milmore <ken.milmore@googlemail.com>
Cc: stable@kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/block/blk-core.c b/block/blk-core.c
index b06cf5c..2283116 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1172,6 +1172,11 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	const int unplug = bio_unplug(bio);
 	int rw_flags;
 
+	if (bio_barrier(bio) && bio_has_data(bio) &&
+	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return 0;
+	}
 	/*
 	 * low level driver can indicate that it wants pages above a
 	 * certain limit bounced to low memory (ie for highmem, or even
@@ -1472,11 +1477,6 @@ static inline void __generic_make_request(struct bio *bio)
 			err = -EOPNOTSUPP;
 			goto end_io;
 		}
-		if (bio_barrier(bio) && bio_has_data(bio) &&
-		    (q->next_ordered == QUEUE_ORDERED_NONE)) {
-			err = -EOPNOTSUPP;
-			goto end_io;
-		}
 
 		ret = q->make_request_fn(q, bio);
 	} while (ret);
