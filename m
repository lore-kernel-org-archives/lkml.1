Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYJHGeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYJHGeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 02:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYJHGeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 02:34:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:9458 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbYJHGeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 02:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=OahSYOoHyp1Sgpx6/zwP0LjNt3840yZkS+H7JJ/n15qBxhPZtbSNSJTnVKb/9HqiY9
         5wDxs12fLE8nGM2jvQjHBTUV8rxgyyX5UEtRUQkx/oTXASNfT0wLw2LXOUzKNr0ddaOd
         8fNHTmXPkRSh17TmXgF5WQnXDW3b1eIeF2teM=
Date: Wed, 8 Oct 2008 08:33:52 +0200
To: Mark de Wever <koraq@xs4all.nl>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Gadi Oxman <gadio@netvision.net.il>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch][repost] ide-tape build fix
Message-ID: <20081008063352.GA13530@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Mark de Wever <koraq@xs4all.nl>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Sergei Shtylyov <sshtylyov@ru.mvista.com>,
	Gadi Oxman <gadio@netvision.net.il>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080921185138.GA16310@localhost> <48D79ABD.8060805@ru.mvista.com> <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com> <20080922204129.GA3495@localhost> <48D80949.4080901@ru.mvista.com> <20080923074845.GB5656@gollum.tnic> <20080923165914.GA7803@localhost> <9ea470500809231011p5ea37fc4u71eeeddf6ccec45a@mail.gmail.com> <20080923212018.GA3348@localhost> <20081007182615.GA2400@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007182615.GA2400@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 07, 2008 at 08:26:15PM +0200, Mark de Wever wrote:
> I never got a reaction on this patch, but please apply it.
> 
> In order to compile the kernel with IDETAPE_DEBUG_LOG enabled I had to
> apply the following build fix.

Bugger, I should be getting at least warnings when compiling this but I don't.
This is because I don't have CONFIG_LBD enabled. However, the %ld and %d
format specifiers are also not entirely correct but gcc doesn't warn about them
- I guess it checks only size but not signedness...

> Signed-off-by: Mark de Wever <koraq@xs4all.nl>
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 3833189..7258eca 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -978,9 +978,10 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
>  	struct request *postponed_rq = tape->postponed_rq;
>  	u8 stat;
>  
> -	debug_log(DBG_SENSE, "sector: %ld, nr_sectors: %ld,"
> +	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %ld,"

the other format specifiers should be rq->nr_sectors: %lu, rq->current_nr_sectors: %u.

>  			" current_nr_sectors: %d\n",
> -			rq->sector, rq->nr_sectors, rq->current_nr_sectors);
> +			(unsigned long long)rq->sector, rq->nr_sectors, 
> +			rq->current_nr_sectors);
>  
>  	if (!blk_special_request(rq)) {
>  		/* We do not support buffer cache originated requests. */
> 

Would you like to redo your patch and add a proper comment ontop?

Thanks.

-- 
Regards/Gruss,
    Boris.
