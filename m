Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbZCLQ5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbZCLQ5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbZCLQ5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:57:16 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:7173 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZCLQ5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:57:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=YwJqzVDXEHMTeofxGceeHMmHr2UCYuUEuo328ZA3Z19rxAtYUYrovB1+LMxn+e8+9d
         3X9csNePDiJ0aqUU9mpUnCWYBFYbtRA2w7R91yogQI+S+MLNyiTeibi7XwI2hgx9THLq
         uvzuNRcAM2Q2gUQANIaiOsCndTjN9xf9lv1N8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 3/3] ide-{cd,floppy}: do not map all cmds to an sg
Date: Thu, 12 Mar 2009 17:58:56 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-next-20090311; KDE/4.2.0; i686; ; )
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1236158216-23052-1-git-send-email-petkovbb@gmail.com> <200903111734.28956.bzolnier@gmail.com> <20090312071248.GA26881@liondog.tnic>
In-Reply-To: <20090312071248.GA26881@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903121758.56808.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Borislav Petkov wrote:
> On Wed, Mar 11, 2009 at 05:34:28PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday 10 March 2009, Borislav Petkov wrote:
> > > Hi,
> > > 
> > > > If the mainline is broken sg fix can wait but to be honest I don't see much
> > > > point in delaying it (it is an independent problem and the bugfix should be
> > > > a completely safe one-liner).
> > > 
> > > --
> > > From: Borislav Petkov <petkovbb@gmail.com>
> > > Date: Tue, 10 Mar 2009 07:04:52 +0100
> > > Subject: [PATCH] ide-floppy: do not map dataless cmds to an sg
> > > 
> > > since it fails the virt_to_page() translation check with DEBUG_VIRTUAL
> > > enabled.
> > > 
> > > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > 
> > I applied it with some changes:
> > 
> > > ---
> > >  drivers/ide/ide-atapi.c  |   12 ++++++++++++
> > >  drivers/ide/ide-floppy.c |    6 ++++--
> > >  2 files changed, 16 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> > > index a5596a6..11a680c 100644
> > > --- a/drivers/ide/ide-atapi.c
> > > +++ b/drivers/ide/ide-atapi.c
> > > @@ -90,6 +90,12 @@ static void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
> > >  	rq->cmd_flags |= REQ_PREEMPT;
> > >  	rq->buffer = (char *)pc;
> > >  	rq->rq_disk = disk;
> > > +
> > > +	if (pc->req_xfer) {
> > > +		rq->data = pc->buf;
> > > +		rq->data_len = pc->req_xfer;
> > > +	}
> > > +
> > >  	memcpy(rq->cmd, pc->c, 12);
> > >  	if (drive->media == ide_tape)
> > >  		rq->cmd[13] = REQ_IDETAPE_PC1;
> > > @@ -112,6 +118,12 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
> > >  	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
> > >  	rq->cmd_type = REQ_TYPE_SPECIAL;
> > >  	rq->buffer = (char *)pc;
> > > +
> > > +	if (pc->req_xfer) {
> > > +		rq->data = pc->buf;
> > > +		rq->data_len = pc->req_xfer;
> > > +	}
> > > +
> > >  	memcpy(rq->cmd, pc->c, 12);
> > >  	if (drive->media == ide_tape)
> > >  		rq->cmd[13] = REQ_IDETAPE_PC1;
> > 
> > ide-atapi.c part doesn't seem to be needed for fixing the issue
> > so I removed it (IMO it would fit much better with your sg setup
> > cleanup patch than this one)
> 
> No, you need that part. And especially the rq->data assignment.
> Take a look at ide_floppy_get_capacity() - it calls into
> ide_queue_pc_tail() with pc->req_xfer == 255 resulting from the
> ide_floppy_create_read_capacity_cmd(). However, the rq->data is still
> NULL if you'd remove the chunk I added and you get

[...]

Ah I see it now but this is a separate issue from the original one
(OOPS on DEBUG_VIRTUAL=y)!  I somehow missed it (probably becasue
patch description fails to mention this important information)
and thus tried to be smart while merging the patch...

Anyway, I replaced the patch in pata tree by your original one.

Thanks,
Bart
