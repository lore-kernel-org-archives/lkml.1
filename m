Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbXJXLbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbXJXLbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXJXLbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:31:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60468 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbXJXLbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:31:40 -0400
Message-ID: <471F2D12.50006@garzik.org>
Date: Wed, 24 Oct 2007 07:31:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com,
       aacraid@adaptec.com, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH -mm 11/11] aacraid: use pci_set_dma_max_seg_size
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org> <20071024173019I.tomof@acm.org>
In-Reply-To: <20071024173019I.tomof@acm.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> This sets the segment size limit properly via pci_set_dma_max_seg_size
> and remove blk_queue_max_segment_size because scsi-ml calls it.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/aacraid/linit.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 038980b..04d6a65 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -435,9 +435,6 @@ static int aac_slave_configure(struct scsi_device *sdev)
>  		else if (depth < 2)
>  			depth = 2;
>  		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
> -		if (!(((struct aac_dev *)host->hostdata)->adapter_info.options &
> -				AAC_OPT_NEW_COMM))
> -			blk_queue_max_segment_size(sdev->request_queue, 65536);
>  	} else
>  		scsi_adjust_queue_depth(sdev, 0, 1);
>  
> @@ -1045,6 +1042,12 @@ static int __devinit aac_probe_one(struct pci_dev *pdev,
>  	if (error < 0)
>  		goto out_deinit;
>  
> +	if (!(aac->adapter_info.options & AAC_OPT_NEW_COMM)) {
> +		error = pci_set_dma_max_seg_size(pdev, 65536);
> +		if (error)
> +			goto out_deinit;
> +	}


is this needed, given that the default is already 65536?

	Jeff



