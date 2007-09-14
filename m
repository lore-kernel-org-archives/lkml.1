Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbXINK1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbXINK1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 06:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXINK13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 06:27:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46992 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583AbXINK12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 06:27:28 -0400
Date: Fri, 14 Sep 2007 03:27:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-box <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com,
       linux-kernel@vger.kernel.org, sumant.patro@lsi.com
Subject: Re: [PATCH 1/4] scsi: megaraid_sas -- add hibernation support
Message-Id: <20070914032717.e007de65.akpm@linux-foundation.org>
In-Reply-To: <1189513284.6082.4.camel@dhcp-75-534.se.lsil.com>
References: <1189513284.6082.4.camel@dhcp-75-534.se.lsil.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 12:21:24 +0000 linux-box <bo.yang@lsi.com> wrote:

> The megaraid_sas driver doesn't support the hibernation, the suspend/resume  
> routine implemented to support the hibernation.
> 
> Signed-off-by: Bo Yang <bo.yang@lsi.com> 
> 
> ---
>  drivers/scsi/megaraid/megaraid_sas.c |  309 +++++++++++++++++++------
>  drivers/scsi/megaraid/megaraid_sas.h |    1
>  2 files changed, 240 insertions(+), 70 deletions(-)
> diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
> --- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-07-01 22:25:57.000000000 -0400
> +++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-07-31 23:57:11.000000000 -0400
> @@ -1804,6 +1804,81 @@ static void megasas_complete_cmd_dpc(uns
>  }
>  
>  /**
> + * megasas_issue_init_mfi -	Initializes the FW
> + * @instance:		Adapter soft state
> + *
> + * Issues the INIT MFI cmd
> + */
> +static int
> +megasas_issue_init_mfi(struct megasas_instance *instance)
> +{
> +	u32 context;
> +
> +	struct megasas_cmd *cmd;
> +
> +	struct megasas_init_frame *init_frame;
> +	struct megasas_init_queue_info *initq_info;
> +	dma_addr_t init_frame_h;
> +	dma_addr_t initq_info_h;
> +
> +	/*
> +	 * Prepare a init frame. Note the init frame points to queue info
> +	 * structure. Each frame has SGL allocated after first 64 bytes. For
> +	 * this frame - since we don't need any SGL - we use SGL's space as
> +	 * queue info structure
> +	 *
> +	 * We will not get a NULL command below. We just created the pool.
> +	 */
> +	cmd = megasas_get_cmd(instance);
> +
> +	init_frame = (struct megasas_init_frame *)cmd->frame;

This would be better as

	init_frame = &cmd->frame.init;

please review the whole driver for this.

> +	initq_info = (struct megasas_init_queue_info *)
> +		((unsigned long)init_frame + 64);

And here we could do

	initq_info = (struct megasas_init_queue_info *)(init_frame + 1);

although that's not really a lot nicer.


