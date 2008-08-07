Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbYHGRPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbYHGRPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbYHGRPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:15:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:24876 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbYHGRPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:15:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=XTFFMbfOrbcp0mXEdFtex1JoYiCHDx2HPkC5Xumbuan/f578PCMlF3JveZe06Pw7y0
         OnkNY4SAcq0knpEaiUF/wPnbiTJ8ZESe3jFCV/q2cNgBvlvl6tKweIgdzQH0TZFcRV6u
         1gNDZYTS91hCL8Qcd8Wb/OENQPvesIr2Ql0xU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-floppy: use scatterlists for pio transfers
Date: Thu, 7 Aug 2008 18:57:09 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080805051113.GA15834@gollum.tnic> <200808061805.01126.bzolnier@gmail.com> <20080806193056.GA31312@gollum.tnic>
In-Reply-To: <20080806193056.GA31312@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808071857.09609.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008, Borislav Petkov wrote:
> On Wed, Aug 06, 2008 at 06:05:00PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > On Tuesday 05 August 2008, Borislav Petkov wrote:
> > > Hi Bart,
> > > 
> > > here's my first stab at using scatterlists in ide-floppy. I've adapted your
> > > ide-scsi version to fit in here. The change here is that i use pc->b_count as
> > > a sort-of completion counter to know when i'm at the end of the sg element and
> > > be able to switch to the next/finish transfer. I've tested the patch with the
> > > Iomega ZIP drive i have here - it works. We should do some more testing first
> > > though, before sending it upstream.
> > 
> > [...]
> > 
> > > @@ -569,7 +577,7 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
> > >  	memcpy(rq->cmd, pc->c, 12);
> > >  
> > >  	pc->rq = rq;
> > > -	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
> > > +	pc->b_count = 0;
> > >  	if (rq->cmd_flags & REQ_RW)
> > >  		pc->flags |= PC_FLAG_WRITING;
> > >  	pc->buf = NULL;
> > 
> > Don't we also need to zero pc->b_count in idefloppy_blockpc_cmd()?
> > 
> > [ idefloppy_init_pc() clears whole pc so ->b_count assignment
> >   to zero is not strictly necessary ]
> 
> We probably should and i should've probably hit that during testing and maybe
> hit an OOPS along that path but we don't do REQ_TYPE_BLOCK_PC in ide-floppy
> yet, as it appears, and since idefloppy_blockpc_cmd() is only called when
> blk_pc_request(rq) that's why this one doesn't matter here. We should consider
> it though when we convert to using BLOCK_PC type rq's.

Unless somebody tries to use SG_IO ioctl (however I don't know if anybody has
actually ever tried so it as well may be that it hasn't worked before...).

Anyway I applied the patch and fixed pc->b_count while at it (just-in-case).
