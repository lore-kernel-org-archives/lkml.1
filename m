Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbYHLJbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbYHLJbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 05:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbYHLJbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 05:31:33 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:44496 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbYHLJbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 05:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Zi+EjGIxu5mvB2vf6LyliyLVSc+stFDYsFfP4DsXBCETkJl4EKqoaxnoe3KApQ5BmA
         p78qJ15LywBt2qadYnVOOZzaUdrVIjnvFuqp3q9gPABJHTTUi/EN8+f1HJnrABpP70oj
         QCE1V1J01syatwAsOoqU++g5LKAgOxTBEEN20=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 11/22] ide: add ide_set_media_lock() helper
Date: Tue, 12 Aug 2008 11:05:49 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain> <20080810153645.16255.80542.sendpatchset@localhost.localdomain> <20080811060232.GA15436@gollum.tnic>
In-Reply-To: <20080811060232.GA15436@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808121105.49645.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 August 2008, Borislav Petkov wrote:
> Hi,
> 
> On Sun, Aug 10, 2008 at 05:36:45PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > * Set IDE_AFLAG_NO_DOORLOCK in idetape_get_mode_sense_result(), check it
> >   in ide_tape_set_media_lock() and cleanup idetape_create_prevent_cmd().
> > 
> > * Set IDE_AFLAG_NO_DOORLOCK in ide_floppy_create_read_capacity_cmd() and
> >   check it instead of IDE_AFLAG_CLIK_DRIVE in ide_floppy_set_media_lock().
> > 
> > * Add ide_set_media_lock() helper and convert ide-{floppy,tape}.c to use it.
> > 
> > * Remove no longer used ide*_create_prevent_cmd()/ide*_set_media_lock().
> > 
> > * Update comment in <linux/ide.h> accordingly.
> > 
> > Cc: Borislav Petkov <petkovbb@gmail.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ide/ide-atapi.c  |   15 +++++++++++++++
> >  drivers/ide/ide-floppy.c |   32 +++++++-------------------------
> >  drivers/ide/ide-tape.c   |   41 ++++++++++-------------------------------
> >  include/linux/ide.h      |    6 ++++--
> >  4 files changed, 36 insertions(+), 58 deletions(-)
> > 
> > Index: b/drivers/ide/ide-atapi.c
> > ===================================================================
> > --- a/drivers/ide/ide-atapi.c
> > +++ b/drivers/ide/ide-atapi.c
> > @@ -162,6 +162,21 @@ int ide_queue_pc_tail(ide_drive_t *drive
> >  }
> >  EXPORT_SYMBOL_GPL(ide_queue_pc_tail);
> >  
> > +int ide_set_media_lock(ide_drive_t *drive, struct gendisk *disk, int on)
> > +{
> > +	struct ide_atapi_pc pc;
> > +
> > +	if (drive->atapi_flags & IDE_AFLAG_NO_DOORLOCK)
> > +		return 0;
> > +
> > +	ide_init_pc(&pc);
> > +	pc.c[0] = ALLOW_MEDIUM_REMOVAL;
> 
> Are we switching to SCSI opcodes? What about the generic packet commands in
> <include/linux/cdrom.h>?

I prefer to use them when possible but there is no strict policy.

[ SCSI defines are shorter, one of the drivers was using them already
  and it also makes easier for comparing code with SCSI. ]
