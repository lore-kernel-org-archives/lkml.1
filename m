Return-Path: <linux-kernel-owner+w=401wt.eu-S1761891AbXEQUUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761891AbXEQUUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761584AbXEQUUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:20:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59445 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759513AbXEQUUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:20:42 -0400
Date: Thu, 17 May 2007 13:17:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Peer Chen" <pchen@nvidia.com>, <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Robert Hancock" <hancockr@shaw.ca>,
       "Kuan Luo" <kluo@nvidia.com>
Subject: Re: [PATCH] drivers/ata: Add the SW NCQ support to sata_nv for
 MCP51/MCP55/MCP61
Message-Id: <20070517131742.029e9fd0.akpm@linux-foundation.org>
In-Reply-To: <20070517131235.8f9445cc.akpm@linux-foundation.org>
References: <15F501D1A78BD343BE8F4D8DB854566B13CD8F45@hkemmail01.nvidia.com>
	<464A94D7.30300@garzik.org>
	<15F501D1A78BD343BE8F4D8DB854566B13F197C0@hkemmail01.nvidia.com>
	<20070517131235.8f9445cc.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 13:12:35 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> The patch generates warnings:
> 
> drivers/ata/sata_nv.c:2118: warning: cast from pointer to integer of different size
> drivers/ata/sata_nv.c:2118: warning: cast to pointer from integer of different size
> 
> due to some quite suspicious-looknig code:
> 
>         prd = (struct ata_prd*)((u64)pp->prd + ATA_PRD_TBL_SZ*qc->tag);
> 
> we have
> 
> struct ata_prd {
> 	        u32                     addr;
> 	        u32                     flags_len;
> };
> 
> and the code is casting a pointer to this into a pointer to u64, then
> adding stuff to it, then casting it back to the correct type.
> 
> Can't we simply do this?
> 
> --- a/drivers/ata/sata_nv.c~drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix
> +++ a/drivers/ata/sata_nv.c
> @@ -2115,7 +2115,7 @@ static void nv_fill_sg(struct ata_queued
>  	WARN_ON(qc->__sg == NULL);
>  	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
>  
> -	prd = (struct ata_prd*)((u64)pp->prd + ATA_PRD_TBL_SZ*qc->tag);
> +	prd = pp->prd + ATA_PRD_TBL_SZ*qc->tag;
>  
>  	idx = 0;
>  	ata_for_each_sg(sg, qc) {

hm, no.

ugh, I dunno what's going on here and I think I'd prefer not to.  Can't
we come up with some typesafe way of doing this without casting?

Meanwhile, I'll switch the cast from u64 to long.
