Return-Path: <linux-kernel-owner+w=401wt.eu-S1761995AbXHUBZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761995AbXHUBZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 21:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbXHUBZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 21:25:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56609 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760812AbXHUBZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 21:25:27 -0400
Date: Tue, 21 Aug 2007 07:08:14 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
cc: NeilBrown <neilb@suse.de>, Jan Engelhardt <jengelh@computergmbh.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 002 of 6] Introduce rq_for_each_segment replacing
 rq_for_each_bio
In-Reply-To: <Pine.LNX.4.62.0708201313260.6197@pademelon.sonytel.be>
Message-ID: <alpine.LFD.0.999.0708210523470.2774@enigma.security.iitk.ac.in>
References: <20070816211551.11839.patches@notabene> <1070816112100.12182@suse.de>
 <Pine.LNX.4.62.0708170910120.8381@pademelon.sonytel.be>
 <alpine.LFD.0.999.0708181953560.29105@enigma.security.iitk.ac.in>
 <Pine.LNX.4.64.0708181628350.5186@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.999.0708182016000.29105@enigma.security.iitk.ac.in>
 <Pine.LNX.4.62.0708201313260.6197@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-1933216916-1187656638=:2774"
Content-ID: <alpine.LFD.0.999.0708210701560.2774@enigma.security.iitk.ac.in>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-1933216916-1187656638=:2774
Content-Type: TEXT/PLAIN; CHARSET=iso-2022-jp
Content-ID: <alpine.LFD.0.999.0708210701561.2774@enigma.security.iitk.ac.in>

Hi Geert,


On Mon, 20 Aug 2007, Geert Uytterhoeven wrote:

> On Sat, 18 Aug 2007, Satyam Sharma wrote:
> > On Sat, 18 Aug 2007, Jan Engelhardt wrote:
> > > On Aug 18 2007 20:07, Satyam Sharma wrote:
> > > >On Fri, 17 Aug 2007, Geert Uytterhoeven wrote:
> > > >> On Thu, 16 Aug 2007, NeilBrown wrote:
> > > >> [...]
> > > >> >  		dev_dbg(&dev->sbd.core,
> > > >> >  			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
                                                                        ^^^

> > > >> > -			__func__, __LINE__, i, bio_segments(bio),
> > > >> > -			bio_sectors(bio), sector);
> > > >> > -		bio_for_each_segment(bvec, bio, j) {
> > > >> > +			__func__, __LINE__, i, bio_segments(iter.bio),
> > > >> > +			bio_sectors(iter.bio),
> > > >> > +			(unsigned long)iter.bio->bi_sector);
                                ^^^^^^^^^^^^^^^          ^^^^^^^^^

> > > >> Superfluous cast: PS3 is 64-bit only, and casts are evil.
> > > 
> > > bi_sector is sector_t. The cast is ok, because printf will warn, and rightfully
> > > so since sector_t may just change its shape underneath.
> > 
> > Oh yeah, that's why the _cast_ _is_ needed in the first place, by the way.
> > I was mentioning why the cast itself should be (unsigned long long) otoh.
> 
> On 64-bit platforms, sector_t (which is either u64 or unsigned long, depending
> on CONFIG_LBD) is unsigned long, so there's no need for a cast. Hence there's
> no compiler warning to be silenced by adding the cast.

This is turning rather funny :-)

* Why the printk() conversion specifier must be "%llu"?

When reusing parts of this code (such as this debug message) for another
32-bit driver (we certainly seem to care about this, as per your reply),
the largest size of sector_t can be "unsigned long long", thereby causing
truncated output, and the following warning:

warning: format ‘%lu’ expects type ‘long unsigned int’, but argument 2 has
type ‘sector_t’

Therefore, let us not depend on the fact that this driver is being used
only for 64-bit platforms as of now (especially since this is in drivers/
and not in arch/) and rather make the printk() specifier as "%llu".

[ Sadly, I had to repeat most of my previous mail, which Jan Engelhardt
appears to have snipped. ]

* Why we require an explicit (unsigned long long) cast?

Having made the above change (and say we don't have an explicit cast
there), that line now becomes:

	printk("... %llu\n", ..., iter.bio->bi_sector);

Now if we build this code with CONFIG_LBD=n, sector_t becomes just an
"unsigned long" (whereas printk specifier is the larger "%llu") thereby
causing:

warning: format ‘%llu’ expects type ‘long long unsigned int’, but argument
2 has type ‘sector_t’

Therefore, let us shut this up with an explicit (unsigned long long) cast,
as is done in most other existing code in the kernel where we want to get
bi_sector printed out, which would correctly convert the value to the
larger integer type (even negative ones, due to sign-extension) and print
it out.


> On the other hand, adding a cast may hide bugs:
>   - cast to unsigned long long: When sector_t is changed to an even larger
>     type, it will be silently truncated as well.

IMHO, this is not a valid enough reason, given the above (BTW if/when that
happens, we'll have to update the printk conversion specifer as well).

Personally, I'd say code that assumes "sizeof(unsigned long long) ==
sizeof(unsigned long)", and also that assumes "sizeof(unsigned long) ==
sizeof(sector_t)" -- both assumptions _are_ made by the above code --
is not good taste, even if both may be true for PS3 platform. So unless
we decide "nobody except that platform would ever build this driver
anyway", I'd suggest to make the printk specifier as "%llu" and use an
explicit (unsigned long long) cast. Therefore (on top of this series):

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

diff -ruNp a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
--- a/drivers/block/ps3disk.c	2007-08-21 06:52:34.000000000 +0530
+++ b/drivers/block/ps3disk.c	2007-08-21 06:56:07.000000000 +0530
@@ -100,10 +100,10 @@ static void ps3disk_scatter_gather(struc
 	rq_for_each_segment(bvec, req, iter) {
 		unsigned long flags;
 		dev_dbg(&dev->sbd.core,
-			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
+			"%s:%u: bio %u: %u segs %u sectors from %llu\n",
 			__func__, __LINE__, i, bio_segments(iter.bio),
 			bio_sectors(iter.bio),
-			(unsigned long)iter.bio->bi_sector);
+			(unsigned long long)iter.bio->bi_sector);
 
 		size = bvec->bv_len;
 		buf = bvec_kmap_irq(bvec, flags);
@@ -142,8 +142,9 @@ static int ps3disk_submit_request_sg(str
 
 	start_sector = req->sector * priv->blocking_factor;
 	sectors = req->nr_sectors * priv->blocking_factor;
-	dev_dbg(&dev->sbd.core, "%s:%u: %s %lu sectors starting at %lu\n",
-		__func__, __LINE__, op, sectors, start_sector);
+	dev_dbg(&dev->sbd.core, "%s:%u: %s %llu sectors starting at %llu\n",
+		__func__, __LINE__, op, (unsigned long long)sectors,
+		(unsigned long long)start_sector);
 
 	if (write) {
 		ps3disk_scatter_gather(dev, req, 1);
--464262402-1933216916-1187656638=:2774--
