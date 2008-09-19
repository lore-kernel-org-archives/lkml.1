Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbYISQHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbYISQHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 12:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbYISQHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 12:07:04 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54222 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbYISQHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 12:07:03 -0400
Message-ID: <48D3CDEC.9060407@cs.wisc.edu>
Date: Fri, 19 Sep 2008 11:06:04 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: James.Bottomley@HansenPartnership.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 2/2] scsi: exports busy status via	bdi_lld_congested
References: <20080919.104756.41628866.k-ueda@ct.jp.nec.com> <20080919.104922.97297160.k-ueda@ct.jp.nec.com>
In-Reply-To: <20080919.104922.97297160.k-ueda@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kiyoshi Ueda wrote:
> This patch change scsi mid layer to export its busy status.
> Not set the busy flag, when scsi can't dispatch I/Os anymore and
> needs to kill I/Os.  Otherwise, request stacking drivers may hold
> requests forever.
> 
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/scsi.c     |    4 ++--
>  drivers/scsi/scsi_lib.c |   23 ++++++++++++++++++++++-
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 
> Index: scsi-misc-2.6/drivers/scsi/scsi_lib.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/scsi_lib.c
> +++ scsi-misc-2.6/drivers/scsi/scsi_lib.c
> @@ -459,17 +459,30 @@ static void scsi_init_cmd_errh(struct sc
>  
>  void scsi_device_unbusy(struct scsi_device *sdev)
>  {
> +	int host_congested;
>  	struct Scsi_Host *shost = sdev->host;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	shost->host_busy--;
> +	if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
> +	    shost->host_blocked || shost->host_self_blocked ||
> +	    scsi_host_in_recovery(shost))
> +		host_congested = 1;
> +	else
> +		host_congested = 0;
> +

You might want to check if the starget busy too (scsi-misc has this but 
Jens's tree and linus do not)? The code below that I snipped from 
scsi_request_fn will set the congested bits if scsi_target_queue_ready 
returns 0, so above here you would want to clear it if it not congested 
anymore.

>  	if (unlikely(scsi_host_in_recovery(shost) &&
>  		     (shost->host_failed || shost->host_eh_scheduled)))
>  		scsi_eh_wakeup(shost);
>  	spin_unlock(shost->host_lock);
> +
>  	spin_lock(sdev->request_queue->queue_lock);
>  	sdev->device_busy--;
> +	if (bdi_lld_congested(&sdev->request_queue->backing_dev_info) &&
> +	    !host_congested && sdev->device_busy < sdev->queue_depth &&
> +	    !sdev->device_blocked)
> +		clear_bdi_lld_congested(&sdev->request_queue->backing_dev_info);
>  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
>  }
>  



> @@ -1593,6 +1613,7 @@ static void scsi_request_fn(struct reque
>  	 * later time.
>  	 */
>  	spin_lock_irq(q->queue_lock);
> +	set_bdi_lld_congested(&q->backing_dev_info);
>  	blk_requeue_request(q, req);
>  	sdev->device_busy--;
>  	if(sdev->device_busy == 0)
