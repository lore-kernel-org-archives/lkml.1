Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbZFXDnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbZFXDnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 23:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZFXDm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 23:42:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbZFXDm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 23:42:57 -0400
From: Neil Brown <neilb@suse.de>
To: Ken Milmore <ken.milmore@googlemail.com>
Date: Wed, 24 Jun 2009 13:43:35 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19009.41191.662901.179565@notabene.brown>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Write barriers on MD RAID1
In-Reply-To: message from Ken Milmore on Sunday June 21
References: <4A188CAD.1080009@googlemail.com>
	<0fa4b1e19d3edb12931e0d641ce2c7d7.squirrel@neil.brown.name>
	<4A3E3C49.7010907@googlemail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday June 21, ken.milmore@googlemail.com wrote:
> I thought I had better bump my previous post as this regression is still 
> present in 2.6.29.5.

Thanks Ken.

> 
> To recap, commit cec0707e40ae25794b5a2de7b7f03c51961f80d9 has broken 
> write barriers on md raid1 block devices in 2.6.29 and later kernels. 
> Reversing this commit appears to fix the problem.
> 
> Please let me know if I'm harassing the wrong maintainers here!

Jens,
  have you had a chance to look at this?

I think the following patch is appropriate and should go in to
-stable.

Thanks,
NeilBrown


>From addd8b129835a63d6df9a38eae20caaa15de5988 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 24 Jun 2009 13:39:15 +1000
Subject: [PATCH] Restore barrier support for md and probably other virtual devices.

The next_ordered flag is only meaningful for devices that use __make_request.
So move the test against next_ordered out of generic code and in to
__make_request

Since this test was added, barriers have not worked on md, and (I
think) dm and similar devices that don't use __make_request and so
don't bother to set next_ordered.

Cc: stable@kernel.org
Cc: Ken Milmore <ken.milmore@googlemail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 block/blk-core.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b06cf5c..fc221aa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1172,6 +1172,11 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	const int unplug = bio_unplug(bio);
 	int rw_flags;
 
+	if (bio_barrier(bio) && bio_has_data(bio) &&
+	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
+		bio_endio(bio, -EOPNOTSUPP)
+			return 0;
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
-- 
1.6.3.1

