Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbYJJQXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbYJJQXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbYJJQXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:23:06 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:9867 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762018AbYJJQXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:23:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=LYlU7t5d+hhj9i97/SP23+kuUxFMjFIr4VRTSmoSWnmENx3L78gdYdwTP8pCu5J0/L
         +gNAb73PE+8XDdnLCQC/GhW7+P+u/EPlti00+5Pvf+d17106JsiUka/t38oSSD0gb9ph
         Mae2glIkcXjaOD05a1AwSBQYF0NUvu2zHBHmc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH 4/7] ide: ide_hwgroup_t.rq doesn't need an ide_lock held
Date: Fri, 10 Oct 2008 18:20:18 +0200
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20081008202930.19112.90371.sendpatchset@localhost.localdomain> <20081008203002.19112.519.sendpatchset@localhost.localdomain> <87abdcg86j.fsf@denkblock.local>
In-Reply-To: <87abdcg86j.fsf@denkblock.local>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810101820.18641.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2008, Elias Oltmanns wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: ide_hwgroup_t.rq doesn't need an ide_lock held
> >
> > While at it:
> > - no need to check for hwgroup presence in ide_dump_opcode()
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> [...]
> > Index: b/drivers/ide/ide-io.c
> > ===================================================================
> > --- a/drivers/ide/ide-io.c
> > +++ b/drivers/ide/ide-io.c
> [...]
> > @@ -274,7 +269,11 @@ static void ide_complete_pm_request (ide
> >  		drive->dev_flags &= ~IDE_DFLAG_BLOCKED;
> >  		blk_start_queue(drive->queue);
> >  	}
> > -	HWGROUP(drive)->rq = NULL;
> > +	spin_unlock_irqrestore(&ide_lock, flags);
> > +
> > +	drive->hwif->hwgroup->rq = NULL;
> > +
> > +	spin_lock_irqsave(&ide_lock, flags);
> >  	if (__blk_end_request(rq, 0, 0))
> >  		BUG();
> >  	spin_unlock_irqrestore(&ide_lock, flags);
> 
> Is it really an improvement to release the lock here?

Yes since it is a preparation for using the right lock here
(drive->queue->queue_lock instead of ide_lock) which is done
in patch #6/7:

@@ -263,10 +260,8 @@ static void ide_complete_pm_request (ide
 
 	drive->hwif->hwgroup->rq = NULL;
 
-	spin_lock_irqsave(&ide_lock, flags);
-	if (__blk_end_request(rq, 0, 0))
+	if (blk_end_request(rq, 0, 0))
 		BUG();
-	spin_unlock_irqrestore(&ide_lock, flags);
 }

[ ide_lock and drive->queue->queue_lock are the same lock at the moment
  (which is wrong since they are meant to protect completely different
  things) but after this patchset it should be quite easy to address  ]

Also ide_complete_pm_request() above is used only for completion of
PM suspend/resume requests and is not really performance critical.

Thanks,
Bart
