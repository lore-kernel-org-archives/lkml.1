Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbYCPQo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbYCPQo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 12:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYCPQoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 12:44:18 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:27591 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYCPQoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 12:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=B07hm/roKEN2LT9YsETw9hoNCQnJLxDNuXglqW8gLyRYI7NesdU6xkbX+w4566CODbRgeslgIptMFPDAtJpx/0LmbtKG4FpW14LxM/eHttUvOVk4u2wFys3vOQKOLf/ZWcKdHyBKAbvaePP4md1gAOGyIMrZkSghvEK9HZvQZT4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH] ide-tape: Avoid potential null pointer dereference in idetape_abort_pipeline()
Date: Sun, 16 Mar 2008 17:58:22 +0100
User-Agent: KMail/1.9.9
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Gadi Oxman <gadio@netvision.net.il>,
       LKML <linux-kernel@vger.kernel.org>
References: <alpine.LNX.1.00.0803150123450.29784@dragon.funnycrock.com> <87prtw2413.fsf@saeurebad.de>
In-Reply-To: <87prtw2413.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161758.23087.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 15 March 2008, Johannes Weiner wrote:
> Hi Jesper,
> 
> Jesper Juhl <jesper.juhl@gmail.com> writes:
> 
> > If a NULL 'new_last_stage' is passed to idetape_abort_pipeline() then 
> > we'll dereference a NULL pointer and go *boom*. 
> > The function does test for a null pointer, unfortunately it only does it 
> > after having already dereferenced it.
> 
> Did you hit an oops because of this?
> 
> > @@ -814,11 +814,14 @@ static void idetape_abort_pipeline(ide_drive_t *drive,
> >  				   idetape_stage_t *new_last_stage)
> >  {
> >  	idetape_tape_t *tape = drive->driver_data;
> > -	idetape_stage_t *stage = new_last_stage->next;
> > +	idetape_stage_t *stage = NULL;
> >  	idetape_stage_t *nstage;
> >  
> >  	debug_log(DBG_PROCS, "%s: Enter %s\n", tape->name, __func__);
> >  
> > +	if (new_last_stage)
> > +		stage = new_last_stage->next;
> > +
> >  	while (stage) {
> >  		nstage = stage->next;
> >  		idetape_kfree_stage(tape, stage);
> 
> ]		--tape->nr_stages;
> ]		--tape->nr_pending_stages;
> ]		stage = nstage;
> ]	}
> ]	if (new_last_stage)
> ]		new_last_stage->next = NULL;
> 
> ... because if not, and new_last_stage will never be NULL at all in this
> function, the check here could be removed instead of adding another one.
> Or perhaps a BUG_ON(!stage) in idetape_end_request() already?
> 
> Bartlomiej, please have a look at the following patch.  Should all of
> these hand-checks in the file be replaced by BUG_ON()s?  Or be removed
> completely?

I think that they should be removed completely.

> 	Hannes
> 
> --
> 
> Turn possible NULL-pointer dereference in idetape_active_next_stage()
> into an explicit bug and remove the warn-only checking for it.
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> 
> ---
> The explicit checking of @stage indicates that someone was expecting
> that it could be NULL here.  Could someone with real understanding of
> the code check if the condition is realistic?
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 43e0e05..b63f928 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -724,17 +724,15 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
>  
>  static void idetape_activate_next_stage(ide_drive_t *drive)
>  {
> +	struct request *rq;
>  	idetape_tape_t *tape = drive->driver_data;
>  	idetape_stage_t *stage = tape->next_stage;
> -	struct request *rq = &stage->rq;
>  
>  	debug_log(DBG_PROCS, "Enter %s\n", __func__);
>  
> -	if (stage == NULL) {
> -		printk(KERN_ERR "ide-tape: bug: Trying to activate a non"
> -				" existing stage\n");
> -		return;
> -	}
> +	BUG_ON(!stage);
> +
> +	rq = &stage->rq;

[ stage->rq will OOPS anyway in case of bug so no need for BUG_ON() ]
 
>  	rq->rq_disk = tape->disk;
>  	rq->buffer = NULL;

Please recast the patch and resumbit.

Thanks,
Bart
