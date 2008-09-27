Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbYI0R25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbYI0R25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYI0R2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:28:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:63134 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbYI0R2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:28:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Sg7avJGQ7RVGW6aut6lGhimDTx/e1g49aWfhIiTqKg4YNjW8GjkM97dw2w+kYc98xr
         YZM87jzPMysMDYsFOjmamO6LsfDaoFhDhXmGOwHcJP+anPd/PRJAx4cCSv2xEFhBUDz5
         EtI+wsXnqutjQDAwO4cXNCIoTUijZhAQFlK84=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 08/18] ide-floppy: use drive->capacity64 for caching current capacity
Date: Sat, 27 Sep 2008 17:34:55 +0200
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain> <20080907221519.24285.44318.sendpatchset@localhost.localdomain> <20080910112006.GA10263@gollum.tnic>
In-Reply-To: <20080910112006.GA10263@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809271734.55433.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 10 September 2008, Borislav Petkov wrote:
> Hi,
> 
> On Mon, Sep 08, 2008 at 12:15:19AM +0200, Bartlomiej Zolnierkiewicz wrote:
> > * Use drive->capacity64 for caching current capacity.
> > 
> > * Switch ide_floppy_capacity() to use drive->capacity64.
> > 
> > * Call set_capacity() in idefloppy_open() and ide_floppy_probe()
> >   instead of ide_floppy_get_capacity().
> > 
> > There should be no functional changes caused by this patch.
> > 
> > Cc: Borislav Petkov <petkovbb@gmail.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ide/ide-floppy.c |   23 +++++++++++++----------
> >  1 file changed, 13 insertions(+), 10 deletions(-)
> > 
> > Index: b/drivers/ide/ide-floppy.c
> > ===================================================================
> > --- a/drivers/ide/ide-floppy.c
> > +++ b/drivers/ide/ide-floppy.c
> > @@ -445,7 +445,9 @@ static int ide_floppy_get_flexible_disk_
> >  			drive->name, lba_capacity, capacity);
> >  		floppy->blocks = floppy->block_size ?
> >  			capacity / floppy->block_size : 0;
> > +		drive->capacity64 = floppy->blocks * floppy->bs_factor;
> 
> why do we do the assignment only in the capacity < lba_capacity case?
> drive->capacity64 is the total number of sectors, shouldn't we do
> 
> drive->capacity64 = floppy->blocks;
> 
> in the floppy->bs_factor == 1 case? Otherwise you have the case of calling

Probably we should...

> idefloppy_setup()
> |-> ide_floppy_get_capacity()
>     |-> ide_floppy_get_flexible_disk_page()
> 
> and having drive->capacity64 == 0 in the (capacity >= lba_capacity) case which
> assigns a capacity of 0 to disk->capacity in the set_capacity() call later ...
> 
> or am I missing something?

...my patch just modified the code to also set ->capacity64 in places
which previously were modifying ->blocks and/or ->bs_factor (since
->capacity64 replaced open-coded ->blocks * ->bs_factor calculation),
so I think that the above problem is as an orthogonal issue and it
is the best to address it in separate pre- or post- patch (could you
please take care of it?).

[...]

> > @@ -547,17 +551,12 @@ static int ide_floppy_get_capacity(ide_d
> >  	if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE))
> >  		(void) ide_floppy_get_flexible_disk_page(drive);
> >  
> > -	set_capacity(disk, floppy->blocks * floppy->bs_factor);
> > -
> >  	return rc;
> >  }
> >  
> >  sector_t ide_floppy_capacity(ide_drive_t *drive)
> >  {
> > -	idefloppy_floppy_t *floppy = drive->driver_data;
> > -	unsigned long capacity = floppy->blocks * floppy->bs_factor;
> > -
> > -	return capacity;
> > +	return drive->capacity64;
> 
> you can simplify this one even further by killing ide_floppy_capacity() and
> doing
> 
> 	set_capacity(disk, floppy->drive->capacity64);

I did it ide_floppy_capacity()-way to match ide_disk_capacity()
and ease the merge (probably ide_gd_capacity() can be removed now).

Thanks,
Bart
