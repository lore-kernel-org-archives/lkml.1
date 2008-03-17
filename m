Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbYCQRZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbYCQRZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYCQRZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:25:41 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41757 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbYCQRZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:25:39 -0400
Subject: Re: ultrastor.c is a bit-rot
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <47DEA3F3.7070908@panasas.com>
References: <47DE8736.8020405@panasas.com>
	 <1205767383.6767.139.camel@localhost.localdomain>
	 <47DE95A9.8060502@panasas.com>
	 <1205769786.6767.140.camel@localhost.localdomain>
	 <47DEA3F3.7070908@panasas.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 17 Mar 2008 12:25:35 -0500
Message-Id: <1205774735.6767.148.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-17 at 19:01 +0200, Boaz Harrosh wrote:
> In Hebrew we say: "You make me drink Kerosene". 

Slàinte mhath as we say in English.

> An "obvious enough to apply the best straight line fix" submitted below:
> 
> I say dump it, it's unused.
> 
> Boaz
> ---
> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Mon, 17 Mar 2008 18:40:03 +0200
> Subject: [PATCH] ultrastor: Fix for ISA DMA allocation
> 
> "obvious enough to apply the best straight line fix" submitted
> below.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> CC: Andi Kleen <ak@suse.de>
> ---
>  drivers/scsi/ultrastor.c |   24 +++++++++++++++++++++---
>  1 files changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
> index f385dce..04441eb 100644
> --- a/drivers/scsi/ultrastor.c
> +++ b/drivers/scsi/ultrastor.c
> @@ -255,8 +255,9 @@ static struct ultrastor_config
>    unsigned long mscp_free;
>  #endif
>    volatile unsigned char aborted[ULTRASTOR_MAX_CMDS];
> -  struct mscp mscp[ULTRASTOR_MAX_CMDS];
> -} config = {0};
> +  struct mscp *mscp;
> +  dma_addr_t dma;
> +} config;
>  
>  /* Set this to 1 to reset the SCSI bus on error.  */
>  static int ultrastor_bus_reset;
> @@ -646,12 +647,29 @@ static int ultrastor_24f_detect(struct scsi_host_template * tpnt)
>  
>  static int ultrastor_detect(struct scsi_host_template * tpnt)
>  {
> +	int ret;
> +
>  	tpnt->proc_name = "ultrastor";
> -	return ultrastor_14f_detect(tpnt) || ultrastor_24f_detect(tpnt);
> +
> +	if (!config.mscp)
> +		config.mscp = dma_alloc_coherent(NULL,
> +			sizeof(*config.mscp) * ULTRASTOR_MAX_CMDS,
> +			&config.dma, GFP_KERNEL);

Error handling here, I'm afraid; dma_alloc_coherent can return NULL.

Other than that, looks great.

James


