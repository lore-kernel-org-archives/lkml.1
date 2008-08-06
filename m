Return-Path: <linux-kernel-owner+w=401wt.eu-S1760997AbYHFTbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbYHFTbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbYHFTat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:30:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:2296 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbYHFTas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:30:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=tUFasQ1XUKTtQtvby3nyrq89+hKzrDkpW/iAb6ofVWPhuesXehKrWzgxOz2aQ94jnS
         Xi8KYppzfHPqlMgabwh2Edbez6e8LM31CEh0I/farq+bfFfWCbETpTUuMZd34enInquT
         wUEY+jE++GtF+C+erZZLrqupSylABuWHBVlxI=
Date: Wed, 6 Aug 2008 21:30:56 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide-floppy: use scatterlists for pio transfers
Message-ID: <20080806193056.GA31312@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080805051113.GA15834@gollum.tnic> <200808061805.01126.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808061805.01126.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 06:05:00PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Tuesday 05 August 2008, Borislav Petkov wrote:
> > Hi Bart,
> > 
> > here's my first stab at using scatterlists in ide-floppy. I've adapted your
> > ide-scsi version to fit in here. The change here is that i use pc->b_count as
> > a sort-of completion counter to know when i'm at the end of the sg element and
> > be able to switch to the next/finish transfer. I've tested the patch with the
> > Iomega ZIP drive i have here - it works. We should do some more testing first
> > though, before sending it upstream.
> 
> [...]
> 
> > @@ -569,7 +577,7 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
> >  	memcpy(rq->cmd, pc->c, 12);
> >  
> >  	pc->rq = rq;
> > -	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
> > +	pc->b_count = 0;
> >  	if (rq->cmd_flags & REQ_RW)
> >  		pc->flags |= PC_FLAG_WRITING;
> >  	pc->buf = NULL;
> 
> Don't we also need to zero pc->b_count in idefloppy_blockpc_cmd()?
> 
> [ idefloppy_init_pc() clears whole pc so ->b_count assignment
>   to zero is not strictly necessary ]

We probably should and i should've probably hit that during testing and maybe
hit an OOPS along that path but we don't do REQ_TYPE_BLOCK_PC in ide-floppy
yet, as it appears, and since idefloppy_blockpc_cmd() is only called when
blk_pc_request(rq) that's why this one doesn't matter here. We should consider
it though when we convert to using BLOCK_PC type rq's.

-- 
Regards/Gruss,
    Boris.
