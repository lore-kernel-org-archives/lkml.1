Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYISRb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYISRb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYISRbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:31:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbYISRbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:31:17 -0400
Date: Fri, 19 Sep 2008 13:28:45 -0400 (EDT)
Message-Id: <20080919.132845.59649006.k-ueda@ct.jp.nec.com>
To: michaelc@cs.wisc.edu
Cc: dm-devel@redhat.com, James.Bottomley@HansenPartnership.com,
       j-nomura@ce.jp.nec.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, k-ueda@ct.jp.nec.com
Subject: Re: [dm-devel] [PATCH 2/2] scsi: exports busy status via
 bdi_lld_congested
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <48D3CDEC.9060407@cs.wisc.edu>
References: <20080919.104756.41628866.k-ueda@ct.jp.nec.com>
	<20080919.104922.97297160.k-ueda@ct.jp.nec.com>
	<48D3CDEC.9060407@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Fri, 19 Sep 2008 11:06:04 -0500, Mike Christie wrote:
> Kiyoshi Ueda wrote:
> > This patch change scsi mid layer to export its busy status.
> > Not set the busy flag, when scsi can't dispatch I/Os anymore and
> > needs to kill I/Os.  Otherwise, request stacking drivers may hold
> > requests forever.
> > 
> > 
> > Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> > Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > ---
> >  drivers/scsi/scsi.c     |    4 ++--
> >  drivers/scsi/scsi_lib.c |   23 ++++++++++++++++++++++-
> >  2 files changed, 24 insertions(+), 3 deletions(-)
> > 
> > Index: scsi-misc-2.6/drivers/scsi/scsi_lib.c
> > ===================================================================
> > --- scsi-misc-2.6.orig/drivers/scsi/scsi_lib.c
> > +++ scsi-misc-2.6/drivers/scsi/scsi_lib.c
> > @@ -459,17 +459,30 @@ static void scsi_init_cmd_errh(struct sc
> >  
> >  void scsi_device_unbusy(struct scsi_device *sdev)
> >  {
> > +	int host_congested;
> >  	struct Scsi_Host *shost = sdev->host;
> >  	unsigned long flags;
> >  
> >  	spin_lock_irqsave(shost->host_lock, flags);
> >  	shost->host_busy--;
> > +	if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
> > +	    shost->host_blocked || shost->host_self_blocked ||
> > +	    scsi_host_in_recovery(shost))
> > +		host_congested = 1;
> > +	else
> > +		host_congested = 0;
> > +
> 
> You might want to check if the starget busy too (scsi-misc has this but 
> Jens's tree and linus do not)? The code below that I snipped from 
> scsi_request_fn will set the congested bits if scsi_target_queue_ready 
> returns 0, so above here you would want to clear it if it not congested 
> anymore.

Yes, thank you for noticing that.
Since I was looking at scsi-misc and your target patch is in
scsi-post-merge, I overlooked it.
I'll rebase my patches and repost again.

Thanks,
Kiyoshi Ueda
