Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbYKFVLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbYKFVLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbYKFVLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:11:32 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:2600 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbYKFVLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:11:31 -0500
Subject: Re: [PATCH] cciss: firmware version is invalid
From: "Stillwell, Bryan" <bryan.stillwell@hp.com>
To: Tim Gardner <timg@tpi.com>
Cc: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>,
       ISS StorageDev <iss_storagedev@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081106201204.9C2AEF8A65@sepang.rtg.net>
References: <20081106201204.9C2AEF8A65@sepang.rtg.net>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 14:11:30 -0700
Message-Id: <1226005890.13433.390.camel@aki.stillwell>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim,

Thanks for getting this merged, but I believe this patch is preferred
over the original one I attached:

http://userweb.kernel.org/~akpm/mmotm/broken-out/cciss-fix-regression-firmware-not-displayed-in-procfs-again-and-again.patch

The reason for this according to Mike Miller is: "The first fix could be
called anytime something changed on the controller such as number of
logical volumes, etc.  This patch will get called only once for each
controller."

Thanks,
Bryan

On Thu, 2008-11-06 at 20:12 +0000, Tim Gardner wrote:
> >From b659b0b0e14f5e3c049bf5c8d2883587cdbfe344 Mon Sep 17 00:00:00 2001
> From: Tim Gardner <tim.gardner@canonical.com>
> Date: Thu, 6 Nov 2008 12:34:25 -0700
> Subject: [PATCH] cciss: Firmware Version is invalid
>  OriginalAuthor: bryan.stillwell@hp.com
>  OriginalLocation: http://launchpadlibrarian.net/18582511/cciss_firmware_version_fix.patch
>  Bug: https://bugs.launchpad.net/bugs/284031
> 
> Emit a CISS_INQUIRY command to read the firmware version.
> 
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> Cc: stable@kernel.org
> ---
>  drivers/block/cciss.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index b73116e..844b806 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -1631,6 +1631,7 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time)
>         int ctlr = h->ctlr;
>         int num_luns;
>         ReportLunData_struct *ld_buff = NULL;
> +       InquiryData_struct *inq_buff = NULL;
>         int return_code;
>         int listlength = 0;
>         int i;
> @@ -1651,6 +1652,26 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time)
>         h->busy_configuring = 1;
>         spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> 
> +       inq_buff = kzalloc(sizeof(InquiryData_struct), GFP_KERNEL);
> +       if (inq_buff == NULL) {
> +               printk(KERN_ERR "cciss: out of memory\n");
> +               return ENOMEM;
> +       }
> +
> +       /* Get the firmware version */
> +       return_code = sendcmd_withirq(CISS_INQUIRY, ctlr, inq_buff,
> +               sizeof(InquiryData_struct), 0, 0 ,0, TYPE_CMD);
> +       if (return_code == IO_OK) {
> +               h->firm_ver[0] = inq_buff->data_byte[32];
> +               h->firm_ver[1] = inq_buff->data_byte[33];
> +               h->firm_ver[2] = inq_buff->data_byte[34];
> +               h->firm_ver[3] = inq_buff->data_byte[35];
> +       } else {         /* send command failed */
> +               printk(KERN_WARNING "cciss: unable to determine firmware"
> +                       " version of controller\n");
> +       }
> +
> +       /* Get the number of logical volumes */
>         ld_buff = kzalloc(sizeof(ReportLunData_struct), GFP_KERNEL);
>         if (ld_buff == NULL)
>                 goto mem_msg;
> --
> 1.5.6.3
> 

