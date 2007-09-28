Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbXI1Uq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbXI1Uq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbXI1Uqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:46:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:38831 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbXI1Uqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:46:45 -0400
Date: Fri, 28 Sep 2007 13:44:34 -0700
From: Randy Dunlap <randy.dunlap@ORACLE.COM>
To: bo yang <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org, Bo.yang@lsi.com, Sumant.patro@lsi.com
Subject: Re: [PATCH 4/8] scsi: megaraid_sas - check max_sgl reported by FW
 for setting max_sectors_per_req
Message-Id: <20070928134434.4675c409.randy.dunlap@oracle.com>
In-Reply-To: <1190820936.5955.17.camel@dhcp-75-534.se.lsil.com>
References: <1190820936.5955.17.camel@dhcp-75-534.se.lsil.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 11:35:36 -0400 bo yang wrote:

> 1. Setting the max_sectors_per_req based on max SGL supported by the FW. Prior versions calculated  
>         this value from controller info's max_sectors_1, max_sectors_2. For certain controllers/FW, 
>         this was resulting in a value greater than max SGL supported by the FW. Now we take the min  
>         of max sgl from FW and max_sectors calculation.
> 
> 2. Increased MFI_POLL_TIMEOUT_SECS to 60 seconds from 10. FW may take a max of 60 seconds to  
>         respond to the INIT cmd.
> 
> Signed-off-by: Bo Yang <bo.yang@lsi.com>
> 
> ---
>  drivers/scsi/megaraid/megaraid_sas.c |   13 +++++++++----
>  drivers/scsi/megaraid/megaraid_sas.h |    2 +-
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff -uprN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
> --- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-09-27 20:40:14.000000000 -0700
> +++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-09-27 04:39:44.000000000 -0700
> @@ -1960,6 +1960,7 @@ static int megasas_init_mfi(struct megas
>  	u32 reply_q_sz;
>  	u32 max_sectors_1;
>  	u32 max_sectors_2;
> +	u32 tmp_sectors;
>  	struct megasas_register_set __iomem *reg_set;
>  	struct megasas_ctrl_info *ctrl_info;
>  	/*
> @@ -2052,17 +2053,21 @@ static int megasas_init_mfi(struct megas
>  	 * Note that older firmwares ( < FW ver 30) didn't report information
>  	 * to calculate max_sectors_1. So the number ended up as zero always.
>  	 */
> +	tmp_sectors = 0;
>  	if (ctrl_info && !megasas_get_ctrl_info(instance, ctrl_info)) {
>  
>  		max_sectors_1 = (1 << ctrl_info->stripe_sz_ops.min) *
>  		    ctrl_info->max_strips_per_io;
>  		max_sectors_2 = ctrl_info->max_request_size;
>  
> -		instance->max_sectors_per_req = (max_sectors_1 < max_sectors_2)
> +		tmp_sectors = (max_sectors_1 < max_sectors_2)
>  		    ? max_sectors_1 : max_sectors_2;

		tmp_sectors = min_t(u32, max_sectors_1, max_sectors_2);

> -	} else
> -		instance->max_sectors_per_req = instance->max_num_sge *
> -		    PAGE_SIZE / 512;
> +	}
> +
> +	instance->max_sectors_per_req = instance->max_num_sge *
> +						PAGE_SIZE / 512;
> +	if (tmp_sectors && (instance->max_sectors_per_req > tmp_sectors))
> +		instance->max_sectors_per_req = tmp_sectors;
>  
>  	kfree(ctrl_info);


---
~Randy
Phaedrus says that Quality is about caring.
