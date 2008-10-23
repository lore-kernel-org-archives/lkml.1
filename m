Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYJWGi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYJWGi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYJWGiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:38:15 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47181 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbYJWGiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:38:15 -0400
Date: Thu, 23 Oct 2008 08:37:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH 1/2] libata: get rid of ATA_MAX_QUEUE loop in ata_qc_complete_multiple()
Message-ID: <20081023063716.GS22217@kernel.dk>
References: <1224661243-7929-1-git-send-email-jens.axboe@oracle.com> <1224661243-7929-2-git-send-email-jens.axboe@oracle.com> <48FFFA15.8060603@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FFFA15.8060603@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23 2008, Tejun Heo wrote:
> Jens Axboe wrote:
> > @@ -4811,16 +4811,19 @@ int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
> >               return -EINVAL;
> >       }
> >
> > -     for (i = 0; i < ATA_MAX_QUEUE; i++) {
> > +     while (done_mask) {
> >               struct ata_queued_cmd *qc;
> > +             unsigned int next = __ffs(done_mask);
> >
> > -             if (!(done_mask & (1 << i)))
> > -                     continue;
> > -
> > -             if ((qc = ata_qc_from_tag(ap, i))) {
> > +             qc = ata_qc_from_tag(ap, i + next);
> > +             if (qc) {
> >                       ata_qc_complete(qc);
> >                       nr_done++;
> >               }
> > +             if (++next >= ATA_MAX_QUEUE)
> > +                     break;
> > +             i += next;
> > +             done_mask >>= next;
> 
> Shouldn't this be...
> 
>         i += next + 1;
>         if (i >= ATA_MAX_QUEUE)
>                 break;
> 
> or better...
> 
> while (done_mask) {
>         struct ata_queued_cmd *qc;
>         unsigned int next = __ffs(done_mask);
> 
>         tag += next;
>         if ((qc = ata_qc_from_tag(ap, tag))) {
>                 ata_qc_complete(qc);
>                 nr_done++;
>         }
>         next++;
>         tag += next;
>         done_mask >>= next;
> }
> 
> done_mask is guaranteed to be zero at when tag reaches ATA_MAX_QUEUE.

That does indeed look a lot cleaner. I think it was rewritten at some
point and kept some of the logic for not passing 0 into __ffs, but it's
clearly pointless now.

I'll send out a revised patch when it's tested.

-- 
Jens Axboe

