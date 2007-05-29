Return-Path: <linux-kernel-owner+w=401wt.eu-S1762426AbXE2Bbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762426AbXE2Bbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 21:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbXE2Bbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 21:31:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49545 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbXE2Bbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 21:31:42 -0400
Message-ID: <465B8277.9010001@garzik.org>
Date: Mon, 28 May 2007 21:31:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Paul Mundt <lethal@linux-sh.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, garyhade@us.ibm.com
Subject: Re: [PATCH] libata: implement ata_wait_after_reset()
References: <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com> <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com> <20070511005217.GA23186@linux-sh.org> <464439C8.7090309@gmail.com> <20070512034928.GB29259@linux-sh.org> <20070516003002.GA18863@linux-sh.org> <464B3505.20004@gmail.com>
In-Reply-To: <464B3505.20004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> -	msleep(150);
> +	/* wait a while before checking status */
> +	ata_wait_after_reset(ap, deadline);
[...]
> -	msleep(150);
> +	/* wait a while before checking status */
> +	ata_wait_after_reset(ap, deadline);
>  
>  	/* Before we perform post reset processing we want to see if
>  	 * the bus shows 0xFF because the odd clown forgets the D7
> @@ -3543,8 +3583,8 @@ int sata_std_hardreset(struct ata_port *
>  		return 0;
>  	}
>  
> -	/* wait a while before checking status, see SRST for more info */
> -	msleep(150);
> +	/* wait a while before checking status */
> +	ata_wait_after_reset(ap, deadline);
>  
>  	rc = ata_wait_ready(ap, deadline);
[...]
> -	msleep(150);
> +	/* wait a while before checking status */
> +	ata_wait_after_reset(ap, deadline);
>  
>  	/* Before we perform post reset processing we want to see if
>  	 * the bus shows 0xFF because the odd clown forgets the D7
> Index: work/drivers/ata/sata_inic162x.c
> ===================================================================
> --- work.orig/drivers/ata/sata_inic162x.c
> +++ work/drivers/ata/sata_inic162x.c
> @@ -446,7 +446,7 @@ static int inic_hardreset(struct ata_por
>  		struct ata_taskfile tf;
>  
>  		/* wait a while before checking status */
> -		msleep(150);
> +		ata_wait_after_reset(ap, deadline);
>  
>  		rc = ata_wait_ready(ap, deadline);
[...]

The main thing that bothers me is not the increase in delay, but the 
fact that this create converts a delay/Status-poll sequence into a 
delay/Status-poll/Status-poll sequence.

ata_wait_after_reset() immediately before ata_wait_ready() seems highly 
redundant.  Why not just poll Status once?

	Jeff



