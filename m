Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZHBUom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZHBUom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbZHBUol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:44:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:47259 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753627AbZHBUok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:44:40 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/ng5NyQs/n27UzTaLObqugYwaYqCbqqkW1ZJfunB
	C+gX/ExwsSLg/J
Date: Sun, 2 Aug 2009 22:44:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Julia Lawall <julia@diku.dk>
cc: Kurt Garloff <garloff@suse.de>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/5] drivers/scsi: Use DIV_ROUND_CLOSEST
In-Reply-To: <Pine.LNX.4.64.0908012149050.25693@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.0908022235310.12625@axis700.grange>
References: <Pine.LNX.4.64.0908012149050.25693@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Aug 2009, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
> but is perhaps more readable.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @haskernel@
> @@
> 
> #include <linux/kernel.h>
> 
> @depends on haskernel@
> expression x,__divisor;
> @@
> 
> - (((x) + ((__divisor) / 2)) / (__divisor))
> + DIV_ROUND_CLOSEST(x,__divisor)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/scsi/tmscsim.c              |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> Diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> index 9a42734..7322f30 100644
> --- a/drivers/scsi/tmscsim.c
> +++ b/drivers/scsi/tmscsim.c
> @@ -1125,7 +1125,8 @@ dc390_MsgIn_set_sync (struct dc390_acb* pACB, struct dc390_srb* pSRB)
>      {
>        if (! (bval & FAST_SCSI)) wval1++;
>        printk (KERN_INFO "DC390: Target %i: Sync transfer %i.%1i MHz, Offset %i\n", pDCB->TargetID, 
> -	      40/wval1, ((40%wval1)*10+wval1/2)/wval1, pDCB->SyncOffset & 0x0f);
> +		40/wval1, DIV_ROUND_CLOSEST((40 % wval1) * 10, wval1),
> +		pDCB->SyncOffset & 0x0f);
>      }
>    
>    dc390_reprog (pACB, pDCB);

With all my respect to these scripted clean-up efforts, I am not sure this 
really improves anything. I.e., I am not sure, that

	z = DIV_ROUND_CLOSEST(x, y);

is better readable than

	z = (x + y / 2) / y;

Besides, I do realise, that tmscsim.c indentation is dreadful (legacy 
code...) but this patch changes it further from

	printk("...",
	       x,
	       y);

to

	printk("...",
		x,
		y);

which doesn't seem like an improvement to me either. That said, this does 
compile, and I don't see why this shouldn't work, so, if we really want 
this change here's the

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
