Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbYJFUlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbYJFUlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 16:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbYJFUlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 16:41:22 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:12400 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbYJFUlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 16:41:21 -0400
Message-ID: <48EA77EF.6080502@genesi-usa.com>
Date: Mon, 06 Oct 2008 15:41:19 -0500
From: Matt Sealey <matt@genesi-usa.com>
User-Agent: Thunderbird 2.0.0.18pre (Windows/20081005)
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
CC: Jeff Garzik <jgarzik@pobox.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Li Yang <leoli@freescale.com>, Wang Jian <lark@linux.net.cn>
Subject: Re: [PATCH] pata_of_platform: fix no irq handling
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
In-Reply-To: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a simple problem with the patch which is that an "IRQ 0" can and does
actually exist on a bunch of platforms, at least to the best of my knowledge.

Checking for -1 (which means for definite, no irq at all, because it is
totally unambiguous, as a -1 IRQ numbering is "impossible") is more correct.

The problem is the check against an unsigned value for interrupts (is there
any reason why you would need 4 billion interrupts possible instead of just
2 billion?) although I must say, the patch will work, and probably 99.9999999%
of people will never see a problem with it :)

-- 
Matt Sealey <matt@genesi-usa.com>
Genesi, Manager, Developer Relations

Anton Vorontsov wrote:
> When no irq specified the pata_of_platform fills the irq_res with -1,
> which is wrong to do for two reasons:
> 
> 1. By definition, 'no irq' should be IRQ 0, not some negative integer;
> 2. pata_platform checks for irq_res.start > 0, but since irq_res.start
>    is unsigned type, the check will be true for `-1'.
> 
> Reported-by: Steven A. Falco <sfalco@harris.com>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> 
> Resending again...
> 
>  drivers/ata/pata_of_platform.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
> index 408da30..1f18ad9 100644
> --- a/drivers/ata/pata_of_platform.c
> +++ b/drivers/ata/pata_of_platform.c
> @@ -52,7 +52,7 @@ static int __devinit pata_of_platform_probe(struct of_device *ofdev,
>  
>  	ret = of_irq_to_resource(dn, 0, &irq_res);
>  	if (ret == NO_IRQ)
> -		irq_res.start = irq_res.end = -1;
> +		irq_res.start = irq_res.end = 0;
>  	else
>  		irq_res.flags = 0;
>  
