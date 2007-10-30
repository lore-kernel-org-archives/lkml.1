Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbXJ3JKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbXJ3JKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbXJ3JJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:09:53 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:19708 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbXJ3JJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:09:52 -0400
Date: Tue, 30 Oct 2007 10:09:34 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Dirk Hohndel <hohndel@linux.intel.com>, Andries Brouwer <aeb@cwi.nl>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add_partition silently ignored errors
Message-ID: <20071030100934.6d2a8f12@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071030080742.GE4993@kernel.dk>
References: <20071029154339.00512901@gondolin.boeblingen.de.ibm.com>
	<20071029154849.GA24187@bigserver.hohndel.org>
	<20071030080742.GE4993@kernel.dk>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 09:07:42 +0100,
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Mon, Oct 29 2007, Dirk Hohndel wrote:
> > diff --git a/block/ioctl.c b/block/ioctl.c
> > index 52d6385..bb3933e 100644
> > --- a/block/ioctl.c
> > +++ b/block/ioctl.c
> > @@ -61,7 +61,10 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
> >  				}
> >  			}
> >  			/* all seems OK */
> > -			add_partition(disk, part, start, length, ADDPART_FLAG_NONE);
> > +			if (add_partition(disk, part, start, length, ADDPART_FLAG_NONE)) {
> > +				mutex_unlock(&bdev->bd_mutex);
> > +				return -EBUSY;
> > +			}
> >  			mutex_unlock(&bdev->bd_mutex);
> >  			return 0;
> >  		case BLKPG_DEL_PARTITION:
> > diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> > index 722e12e..cd92471 100644
> > --- a/fs/partitions/check.c
> > +++ b/fs/partitions/check.c
> > @@ -368,13 +368,13 @@ void delete_partition(struct gendisk *disk, int part)
> >  	kobject_put(&p->kobj);
> >  }
> >  
> > -void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
> > +int add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
> >  {
> >  	struct hd_struct *p;
> >  
> >  	p = kzalloc(sizeof(*p), GFP_KERNEL);
> >  	if (!p)
> > -		return;
> > +		return -1;
> 
> Why not return the 'correct' error codes, instead of always -1 and
> making that -EBUSY at the caller? This one should be -ENOMEM.

Oops, you're right. I agree.

> 
> IIRC, Al recently vetoed a similar patch. As far as I'm concerned, with
> the correct return values, the patch then looks fine to me.

We need some kind of check concerning the kobject to avoid mysterious
errors (especially checking for the failed kobject_add() is needed).
Whether we want just to inform the user of the failure instead of
failing the function is another question.
