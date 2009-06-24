Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZFXBtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZFXBtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 21:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZFXBsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 21:48:42 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:43438 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZFXBsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 21:48:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=JGF7VSdyYr6xaMD9yq5UcK0LSUzqh39nV+OqH7pTVuldw+Y8FoEpZC1XYr0CEO6CUI
         J0LyaXR3qjGjKz4WxyLu0oZo1EKN8Sf/QlU+PAwEkyyhaLscLq6ldDfIEHHSl5A4iDTn
         fnZV3cLlJ9j0vDd2tWhsyrnC25le7k/R6MLTY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 3/6] ide: always kill the whole request on error
Date: Wed, 24 Jun 2009 02:49:32 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       petkovbb@gmail.com, htejun@gmail.com
References: <200906232327.27610.bzolnier@gmail.com> <20090623.161904.177489795.davem@davemloft.net>
In-Reply-To: <20090623.161904.177489795.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906240249.33505.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009 01:19:04 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Tue, 23 Jun 2009 23:27:27 +0200
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: always kill the whole request on error
> > 
> > * Use blk_rq_bytes() instead of obsolete ide_rq_bytes() in ide_kill_rq()
> >   and ide_floppy_do_request() for failed requests.
> >   [ bugfix part ]
> > 
> > * Use blk_rq_bytes() instead of obsolete ide_rq_bytes() in ide_do_devset()
> >   and ide_complete_drive_reset().  Then remove ide_rq_bytes().
> >   [ cleanup part ]
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > 'cleanup part' tested, limited testing with 'bugfix part'
> > (using simulated failures of disk fs requests)
> 
> Considering this alongsize patch #2, it even more begs the
> question as to why special requests on floppy and tape were
> handled differently.  And that 'error <= 0' test, strange.

TBH I fail to see how it relates to changes present in _this_ patch
as no change in _this_ patch affects special tape/floppy requests..

> I have a hard time believing all of these differences are there for no
> reason at all. :-)

Lets keep personal believes aside in the technical discussions. ;)

> >  drivers/ide/ide-devsets.c |    2 +-
> >  drivers/ide/ide-eh.c      |    2 +-
> >  drivers/ide/ide-floppy.c  |    2 +-
> >  drivers/ide/ide-io.c      |   14 ++------------
> >  include/linux/ide.h       |    1 -
> >  5 files changed, 5 insertions(+), 16 deletions(-)
> > 
> > Index: b/drivers/ide/ide-devsets.c
> > ===================================================================
> > --- a/drivers/ide/ide-devsets.c
> > +++ b/drivers/ide/ide-devsets.c
> > @@ -183,6 +183,6 @@ ide_startstop_t ide_do_devset(ide_drive_
> >  	err = setfunc(drive, *(int *)&rq->cmd[1]);
> >  	if (err)
> >  		rq->errors = err;
> > -	ide_complete_rq(drive, err, ide_rq_bytes(rq));
> > +	ide_complete_rq(drive, err, blk_rq_bytes(rq));
> >  	return ide_stopped;
> >  }
> > Index: b/drivers/ide/ide-eh.c
> > ===================================================================
> > --- a/drivers/ide/ide-eh.c
> > +++ b/drivers/ide/ide-eh.c
> > @@ -149,7 +149,7 @@ static inline void ide_complete_drive_re
> >  	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET) {
> >  		if (err <= 0 && rq->errors == 0)
> >  			rq->errors = -EIO;
> > -		ide_complete_rq(drive, err ? err : 0, ide_rq_bytes(rq));
> > +		ide_complete_rq(drive, err ? err : 0, blk_rq_bytes(rq));
> >  	}
> >  }
> >  
> > Index: b/drivers/ide/ide-floppy.c
> > ===================================================================
> > --- a/drivers/ide/ide-floppy.c
> > +++ b/drivers/ide/ide-floppy.c
> > @@ -293,7 +293,7 @@ out_end:
> >  	drive->failed_pc = NULL;
> >  	if (blk_fs_request(rq) == 0 && rq->errors == 0)
> >  		rq->errors = -EIO;
> > -	ide_complete_rq(drive, -EIO, ide_rq_bytes(rq));
> > +	ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
> >  	return ide_stopped;
> >  }
> >  
> > Index: b/drivers/ide/ide-io.c
> > ===================================================================
> > --- a/drivers/ide/ide-io.c
> > +++ b/drivers/ide/ide-io.c
> > @@ -112,16 +112,6 @@ void ide_complete_cmd(ide_drive_t *drive
> >  	}
> >  }
> >  
> > -/* obsolete, blk_rq_bytes() should be used instead */
> > -unsigned int ide_rq_bytes(struct request *rq)
> > -{
> > -	if (blk_pc_request(rq))
> > -		return blk_rq_bytes(rq);
> > -	else
> > -		return blk_rq_cur_sectors(rq) << 9;
> > -}
> > -EXPORT_SYMBOL_GPL(ide_rq_bytes);
> > -
> >  int ide_complete_rq(ide_drive_t *drive, int error, unsigned int nr_bytes)
> >  {
> >  	ide_hwif_t *hwif = drive->hwif;
> > @@ -152,14 +142,14 @@ void ide_kill_rq(ide_drive_t *drive, str
> >  
> >  	if ((media == ide_floppy || media == ide_tape) && drv_req) {
> >  		rq->errors = 0;
> > -		ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
> >  	} else {
> >  		if (media == ide_tape)
> >  			rq->errors = IDE_DRV_ERROR_GENERAL;
> >  		else if (blk_fs_request(rq) == 0 && rq->errors == 0)
> >  			rq->errors = -EIO;
> > -		ide_complete_rq(drive, -EIO, ide_rq_bytes(rq));
> >  	}
> > +
> > +	ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
> >  }
> >  
> >  static void ide_tf_set_specify_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
> > Index: b/include/linux/ide.h
> > ===================================================================
> > --- a/include/linux/ide.h
> > +++ b/include/linux/ide.h
> > @@ -1062,7 +1062,6 @@ int generic_ide_ioctl(ide_drive_t *, str
> >  extern int ide_vlb_clk;
> >  extern int ide_pci_clk;
> >  
> > -unsigned int ide_rq_bytes(struct request *);
> >  int ide_end_rq(ide_drive_t *, struct request *, int, unsigned int);
> >  void ide_kill_rq(ide_drive_t *, struct request *);
