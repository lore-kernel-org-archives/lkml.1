Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbYJXIQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbYJXIQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 04:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYJXIP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 04:15:58 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34521 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbYJXIP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 04:15:56 -0400
Date: Fri, 24 Oct 2008 10:14:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH 1/2] libata: get rid of ATA_MAX_QUEUE loop in ata_qc_complete_multiple()
Message-ID: <20081024081455.GY22217@kernel.dk>
References: <1224661243-7929-1-git-send-email-jens.axboe@oracle.com> <1224661243-7929-2-git-send-email-jens.axboe@oracle.com> <48FFFA15.8060603@kernel.org> <20081023064357.GT22217@kernel.dk> <20081023134017.GA22217@kernel.dk> <87tzb39w5r.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tzb39w5r.fsf@denkblock.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23 2008, Elias Oltmanns wrote:
> Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Thu, Oct 23 2008, Jens Axboe wrote:
> >> On Thu, Oct 23 2008, Tejun Heo wrote:
> >
> >> > while (done_mask) {
> >> >         struct ata_queued_cmd *qc;
> >> >         unsigned int next = __ffs(done_mask);
> >> > 
> >> >         tag += next;
> >> >         if ((qc = ata_qc_from_tag(ap, tag))) {
> >> >                 ata_qc_complete(qc);
> >> >                 nr_done++;
> >> >         }
> >> >         next++;
> >> >         tag += next;
> >> >         done_mask >>= next;
> >> > }
> >> 
> >> That doesn't work (you're adding next to tag twice), it needs a little
> >> tweak:
> >> 
> >> while (done_mask) {
> >>         struct ata_queued_cmd *qc;
> >>         unsigned int next = __ffs(done_mask);
> >> 
> >>         if ((qc = ata_qc_from_tag(ap, tag + next))) {
> >>                 ata_qc_complete(qc);
> >>                 nr_done++;
> >>         }
> >>         next++;
> >>         tag += next;
> >>         done_mask >>= next;
> >> }
> >> 
> >> and I think it should work. Not tested yet :-)
> >
> > Pondered some more, and it can't work. The problem is that if we
> > complete tag 31, we attempt to shift done_mask down by 32 bits. On a
> > 32-bit arch, that's not defined. So we DO need a check like the existing
> > one, or something similar.
> >
> > So I don't think we need to make changes to this patch either, at least
> > unless one of you can come up with a better check that avoids a branch.
> 
> What about a switch outside the while loop:
> 
> 	if (done_mask == ATA_MAX_QUEUE >> 1) {
> 		if ((qc = ata_qc_from_tag(ap, ATA_MAX_QUEUE >> 1))) {
> 			ata_qc_complete(qc);
> 			nr_done = 1;
> 		}
> 	} else
> 		while (done_mask)
> 			...
> 
> Alternatively, you could just alter tag and done_mask (tag =
> ATA_MAX_QUEUE >> 2, done_mask = 2) and enter the while loop
> unconditionally. But then, you claimed that there will hardly ever be
> more than one command to complete, so my suggestions will probably not
> improve anything in real life.

Honestly, I think the current check is a lot cleaner then.

-- 
Jens Axboe

