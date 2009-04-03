Return-Path: <linux-kernel-owner+w=401wt.eu-S934747AbZDCRYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934747AbZDCRYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759328AbZDCRYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:24:32 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:22872 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759234AbZDCRYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:24:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mTqF0+54BjtNVgDOkQzabuZ6kixV4XM46mXXT10kF4VUla4VztUepeMWaB/BVyaBa9SIhjnMnS54WSLUS4M5Xpz/ap6i0xyCjgEOpI754LHxdElMnrERNkN/1Dv9upS7i4Xj2gWUlKnjY+tt+EAVRDM0U9HCl08ijy9/1QcHfgM=  ;
X-YMail-OSG: .6XmSFIVM1maBMMUUMstAQvNAkpXf716maBinD_BIzYbkrp.052R_v_iYyZieQHgY5HthSF7q1M0qCZUYQ.6S.Mld5eVY.MzJnsEMkp0mJ6.Q0l06HVF9MKLBvfibDLhOcAX90hTSvE3UlcoA3X0dZvZ9SxHgKgKVQm67HGozFxbNgcsGu8o9TeTTVJZEj4N9wB67qHznH3u9a9Q7_ebkFo6aIoX1cPEwa0YvpbW7rNfv2iF6YEICZdRJj5nbheFPYUlw_kuMTa_4bxyr0_ZNtN6vEAJALRogRp3jQLK0Et6z7V90D.LvovYa6nnNRsKo732U3FSaSbmWfW0t245sQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
Date: Fri, 3 Apr 2009 10:24:27 -0700
User-Agent: KMail/1.9.10
Cc: Linux MTD <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
References: <200903260042.42091.david-b@pacbell.net> <1238753062.3711.109.camel@macbook.infradead.org>
In-Reply-To: <1238753062.3711.109.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904031024.27662.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009, David Woodhouse wrote:
> On Thu, 2009-03-26 at 00:42 -0700, David Brownell wrote:
> > 
> > @@ -343,6 +343,11 @@ static struct mtd_part *add_one_partitio
> >         slave->mtd.name = part->name;
> >         slave->mtd.owner = master->owner;
> >  
> > +       /* NOTE:  we don't arrange MTDs as a tree; it'd be error-prone
> > +        * to have the same data be in two different partitions.
> > +        */
> > +       slave->mtd.dev.parent = master->dev.parent;
> 
> Can you elaborate on that? I think we _do_ want to arrange partitions as
> sub-devices of the master, don't we? 

They're part of a tree, and are subdevices of the physical flash
node, so those partitions get nodes like:

	.../physical_flashdev
		/block/mtdblock*
		/mtd/mtd*
		/mtd/mtd*ro

If that were "slave->mtd.dev.parent = &master->dev" instead
(you could try it!), not only would most MTD drivers need to
change to register that master->dev ("mtd0" here), but the
tree would look something like (from memory):

	.../physical_flashdev
		/block/mtdblock*
		/mtd/mtd0
			/mtd/mtd*
			/mtd/mtd*ro
		/mtd/mtd0ro

which is at the very least ugly, confusing, counter-intuitive,
and internally inconsistent (why do all the block nodes show
up where you'd expect, but not all the MTD/chardev ones).


> And I'd rather not change the way 
> they appear at a later date; I'd prefer them to be that way from the
> beginning.

Agreed.  The focus of this patch was getting a model that
would evolve later ... attributes and tool support being
the most apparent issues.

 
> >         slave->mtd.read = part_read;
> >         slave->mtd.write = part_write;
> >  
> > @@ -493,7 +498,9 @@ out_register:
> >   * This function, given a master MTD object and a partition table, creates
> >   * and registers slave MTD objects which are bound to the master according to
> >   * the partition definitions.
> > - * (Q: should we register the master MTD object as well?)
> > + *
> > + * We don't register the master, or expect the caller to have done so,
> > + * for reasons of data integrity.
> >   */
> 
> Again, can you elaborate?

Same point as above ... presuming an A to that long-standing Q.


> A lot of devices do just that. Where you have a partition table of some
> kind that's actually stored on the flash, that might be the only way to
> access it.

I happen never to have come across such a flash layout;
that's presumably what "RedBoot" does (eCOS)?

As I'm sure you're aware, MTDs don't need to be registered
to be used.  There's no innate need to "do just that" just
to support RedBoot-style internal partition tables.

As a rule I've seen partitioning be provided by Linux, or
cmdlinepart.  Systems using u-boot or proprietary loaders
just "know" where they, their data, and the kernel are to
be found; Linux tables either declare them as read-only
partitions or, less often, only list writable parts of
the flash chip.

One way to model RedBoot tables that might be to have a
partition table node "device_type" that's distinct from
the MTD node type, even if it's still coupled to the
same generic "mtd_info".  I'm not sure what to make of
that technique, but it might be useful elsewhere in MTD.

Another way to model RedBoot tables is ... just hide them.
Don't expose an MTD with that data (or "just that data").
Can Linux contine to operate if some tool modifies that
partition data, or must it reboot?


> I really don't like the way our partitioning works at the moment.

Arguably fixing that would be a prerequisite to making
stable driver model support ... which is part of the
reason this was a "patch/RFC".  :)

I will confess to trying to avoid opening the can of
worms too far, and suspecting that parts of the MTD
stack I've never needed would expose more issues.

- Dave
