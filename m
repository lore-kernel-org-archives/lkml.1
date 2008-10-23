Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbYJWIY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYJWIY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYJWIYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:24:41 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:36546 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbYJWIYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:24:39 -0400
Date: Thu, 23 Oct 2008 10:23:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org,
       jeff@garzik.org
Subject: Re: [PATCH 1/2] libata: get rid of ATA_MAX_QUEUE loop in ata_qc_complete_multiple()
Message-ID: <20081023082340.GX22217@kernel.dk>
References: <1224661243-7929-1-git-send-email-jens.axboe@oracle.com> <1224661243-7929-2-git-send-email-jens.axboe@oracle.com> <878wsgqyix.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878wsgqyix.fsf@denkblock.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22 2008, Elias Oltmanns wrote:
> Jens Axboe <jens.axboe@oracle.com> wrote:
> > We very rarely (if ever) complete more than one command in the
> > sactive mask at the time, even for extremely high IO rates. So
> > looping over the entire range of possible tags is pointless,
> > instead use __ffs() to just find the completed tags directly.
> >
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  drivers/ata/libata-core.c |   15 +++++++++------
> >  1 files changed, 9 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> > index 1ee9499..c3c53e7 100644
> > --- a/drivers/ata/libata-core.c
> > +++ b/drivers/ata/libata-core.c
> > @@ -4799,9 +4799,9 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
> >   */
> >  int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
> >  {
> > +	unsigned int i = 0;
> >  	int nr_done = 0;
> >  	u32 done_mask;
> > -	int i;
> >  
> >  	done_mask = ap->qc_active ^ qc_active;
> >  
> > @@ -4811,16 +4811,19 @@ int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
> >  		return -EINVAL;
> >  	}
> >  
> > -	for (i = 0; i < ATA_MAX_QUEUE; i++) {
> > +	while (done_mask) {
> >  		struct ata_queued_cmd *qc;
> > +		unsigned int next = __ffs(done_mask);
> >  
> > -		if (!(done_mask & (1 << i)))
> > -			continue;
> > -
> > -		if ((qc = ata_qc_from_tag(ap, i))) {
> > +		qc = ata_qc_from_tag(ap, i + next);
> > +		if (qc) {
> >  			ata_qc_complete(qc);
> >  			nr_done++;
> >  		}
> > +		if (++next >= ATA_MAX_QUEUE)
> > +			break;
> 
> If you think about it, this statement is equivalent to
> 
> 	if (ap->qc_active ^ qc_active == (1 << (ATA_MAX_QUEUE - 1)))
> 
> To fix this, you could say
> 
> 	if (++next + i >= ATA_MAX_QUEUE)
> 
> but perhaps it would be even more efficient (or not much worse) to skip
> this check entirely.

Yeah, the check should just be killed, that's the version I posted in
the reply to Tejun as well.

-- 
Jens Axboe

