Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab0CBF1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 00:27:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab0CBF1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 00:27:52 -0500
Subject: Re: [PATCH] Don't change direction flags in struct request.
From: James Bottomley <James.Bottomley@suse.de>
To: Hugh Daschbach <hdasch@broadcom.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>,
       Eddie Williams <Eddie.Williams@steeleye.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1268976690-3386-2-git-send-email-hdasch@broadcom.com>
References: <1268976690-3386-1-git-send-email-hdasch@broadcom.com>
	 <1268976690-3386-2-git-send-email-hdasch@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Mar 2010 10:56:58 +0530
Message-ID: <1267507618.7936.11.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-18 at 22:31 -0700, Hugh Daschbach wrote:
> The EMC multipath device handler should not change the I/O direction
> flags of its trespass command request.
> 
> The CFQ elevator may BUG if the direction flags on an I/O request are
> changed after allocation.  cfq_set_request() and cfq_put_request()
> count READ and WRITE requests separately.  Changing the I/O request
> direction after blk_get_request() allocates the request throws off
> this CFQ accounting.

This description doesn't really match what the problem seems to be
below:

> Signed-off-by: Hugh Daschbach <hdasch@broadcom.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_emc.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
> index 6196675..3709342 100644
> --- a/drivers/scsi/device_handler/scsi_dh_emc.c
> +++ b/drivers/scsi/device_handler/scsi_dh_emc.c
> @@ -269,10 +269,12 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
>  				unsigned char *buffer)
>  {
>  	struct request *rq;
> +	int mode = READ;
>  	int len = 0;
>  
> -	rq = blk_get_request(sdev->request_queue,
> -			(cmd == MODE_SELECT) ? WRITE : READ, GFP_NOIO);
> +	if (cmd == MODE_SELECT || cmd == MODE_SELECT_10)
> +		mode = WRITE;
> +	rq = blk_get_request(sdev->request_queue, mode, GFP_NOIO);

So the actual bug is failure to set WRITE for MODE_SELECT_10.

>  	if (!rq) {
>  		sdev_printk(KERN_INFO, sdev, "get_req: blk_get_request failed");
>  		return NULL;
> @@ -284,12 +286,10 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
>  	switch (cmd) {
>  	case MODE_SELECT:
>  		len = sizeof(short_trespass);
> -		rq->cmd_flags |= REQ_RW;

And this is just cosmetic ... the flags already having been set by the
allocation, they don't need to be set again.

>  		rq->cmd[1] = 0x10;
>  		break;
>  	case MODE_SELECT_10:
>  		len = sizeof(long_trespass);
> -		rq->cmd_flags |= REQ_RW;
>  		rq->cmd[1] = 0x10;
>  		break;
>  	case INQUIRY:

Chandra, can you tidy this up and take it, please?

Thanks,

James


