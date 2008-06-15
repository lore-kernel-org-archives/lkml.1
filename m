Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbYFOK13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbYFOK13 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 06:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757027AbYFOK1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 06:27:20 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:45235 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbYFOK1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 06:27:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent:from;
        b=Ox68na2zNtfrNmDxYRqx7lZMaN5TOZI8LR1rpbG9I0OfteksDOh65MrFEIk7EQ1wTM
         ipkjPVAkKPB1XEzH0vNYEaMZq+PVO26zoxJUyByKjiXMrhudLsQhWCEB7FNKm/vZkQuH
         kYmcEvV7A/tujE9e/EugtEqMIR3ePex7IPk1o=
Date: Sun, 15 Jun 2008 12:27:13 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 00/18] misc generic ide stuff
Message-ID: <20080615102713.GC7622@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com> <200806141929.00459.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806141929.00459.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 07:29:00PM +0200, Bartlomiej Zolnierkiewicz wrote:

Hi,

> 
> Hi,
> 
> On Thursday 12 June 2008, Borislav Petkov wrote:
> > Hi Bart,
> > 
> > here are some generic ide conversion patches. The first 12 are what i thought
> > you suggested :) concerning prepping the ide-cd code for the generic layer. The
> > remaining 6 are what i've done so far wrt removing ide_atapi_pc from the ide
> > drivers. It is obvious that this is not trivial and I basically tiptoe around the
> 
> Thanks.
> 
> I applied patches #1-2, #5-12 and #14-15.
> 
> I skipped patches #3-4, #13 and #16-18 for now
> (more details in replies to corresponding mails).
> 
> > landmines in the IRQ handler and request issue paths :). This raises also
> > several questions:
> > 
> > 1. ide-cd uses the cdrom_info struct for e.g. dma status notification, the other
> > ide drivers use it per packet command in pc->flags. Well the last are kinda too
> > much to carry for _each_ command and i'm thinking maybe put all that in the
> > ide_drive_t and make it generic enough to fit all drivers. This way
> > pc->callback() can also be harboured there. One concern might be when a flag is
> > strictly per packet command which could be put somewhere else (maybe in the
> > struct request since it already has members when it is used as a packet
> > command).
> 
> Some pc->flags describe device's properties and thus should be moved to
> ide_drive_t (->dev_flags) while some other correspond to the queued command
> and moving them to ide_drive_t would be a bad idea IMO.

With "the last" i meant pc->flags and not "per packet" so i completely agree:
per-packet commands go somewhere in rq and the others land in ide_drive_t.

> For ATA commands I was planning to put taskfile flags into rq->special field
> (well, I actually implemented it in draft patch and it looks OK) so maybe we
> can do something similar for packet commands.

Yep, i was looking for a field to put all those per-command flags into so
rq->special sounds good. Will prepare some patches for that later.

> > 2. Can all that pc->xferred, pc->b_count, pc->errors and pc->cur_pos accounting
> > be safely mapped to a rq? I see some discrepancies like is pc->buf_size ==
> > rq->data_len, what about pc->req_xfer? I'll have a more detailed look at those
> > when i have more spare time later.
> 
> If you ask if they can be mapped 'directly' then the answer is: "probably no"
> but if the question is whether it is possible to do it after some changes then
> the answer is: "probably yes". :)
> 
> [ However it may be necessary to convert ATAPI drivers to use scatterlists
>   instead of open-coded ->bio walking for PIO transfers first. ]

Looking into it right now...

Thanks.

-- 
Regards/Gruﬂ,
    Boris.
