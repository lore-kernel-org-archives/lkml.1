Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbYJTL2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbYJTL2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 07:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYJTL2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 07:28:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:32957 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbYJTL2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 07:28:11 -0400
Date: Mon, 20 Oct 2008 20:27:24 +0900
To: mike.miller@hp.com
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       adobriyan@gmail.com
Subject: Re: [PATCH 2/2] cciss: fix regression firmware version not
 displayed in procfs (again and again)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081016231730.GA26824@roadking.ldev.net>
References: <20081016231730.GA26824@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081020202744Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 18:17:30 -0500
Mike Miller <mike.miller@hp.com> wrote:

> Patch 2 of 2
> 
> The regression was introduced by commit
> 6ae5ce8e8d4de666f31286808d2285aa6a50fa40.
> This patch fixes a regression where the controller firmware version is not
> displayed in procfs. The previous patch would be called anytime something
> changed. This will get called only once for each controller.
> 
> This one addresses the un-needed initialization and the freeing of inq_buf.
> 
> Please consider this for inclusion.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 0f367b1..c3f0c17 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -3404,7 +3404,8 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
>  	int i;
>  	int j = 0;
>  	int rc;
> -	int dac;
> +	int dac, return_code;
> +	InquiryData_struct *inq_buff;

Needs to be:

> +	InquiryData_struct *inq_buff = NULL;

The driver uses 'goto clean4' before calling kzalloc for inq_buff
(e.g. in the case of cmd_pool_bits allocation failure). It means that
you could kfree with an uninitialized address?


>  	i = alloc_cciss_hba();
>  	if (i < 0)
> @@ -3510,6 +3511,25 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
>  	/* Turn the interrupts on so we can service requests */
>  	hba[i]->access.set_intr_mask(hba[i], CCISS_INTR_ON);
>  
> +	/* Get the firmware version */
> +	inq_buff = kzalloc(sizeof(InquiryData_struct), GFP_KERNEL);
> +	if (inq_buff == NULL) {
> +		printk(KERN_ERR "cciss: out of memory\n");
> +		return -ENOMEM;

Needs to use 'goto clean4' instead of just return -ENOMEM here? The
driver needs to clean up the allocated resource.


> +	}
> +
> +	return_code = sendcmd_withirq(CISS_INQUIRY, i, inq_buff,
> +		sizeof(InquiryData_struct), 0, 0 , 0, TYPE_CMD);
> +	if (return_code == IO_OK) {
> +		hba[i]->firm_ver[0] = inq_buff->data_byte[32];
> +		hba[i]->firm_ver[1] = inq_buff->data_byte[33];
> +		hba[i]->firm_ver[2] = inq_buff->data_byte[34];
> +		hba[i]->firm_ver[3] = inq_buff->data_byte[35];
> +	} else {	 /* send command failed */
> +		printk(KERN_WARNING "cciss: unable to determine firmware"
> +			" version of controller\n");
> +	}
> +
>  	cciss_procinit(i);
>  
>  	hba[i]->cciss_max_sectors = 2048;
> @@ -3520,6 +3540,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
>  	return 1;
>  
>  clean4:
> +	kfree(inq_buff);
>  #ifdef CONFIG_CISS_SCSI_TAPE
>  	kfree(hba[i]->scsi_rejects.complete);
>  #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
