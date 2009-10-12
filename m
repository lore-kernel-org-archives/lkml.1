Return-Path: <linux-kernel-owner+w=401wt.eu-S1758506AbZJLWMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbZJLWMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758114AbZJLWMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:12:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757242AbZJLWMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:12:32 -0400
Date: Mon, 12 Oct 2009 15:11:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: alek.du@intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: Fix test on unsigned in lnw_irq_type()
Message-Id: <20091012151127.312c986a.akpm@linux-foundation.org>
In-Reply-To: <4AD33958.7020900@gmail.com>
References: <4AD33958.7020900@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 16:12:40 +0200
Roel Kluin <roel.kluin@gmail.com> wrote:

> The wrong test was used, gpio is unsigned.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
> index 5711ce5..0d0cbc0 100644
> --- a/drivers/gpio/langwell_gpio.c
> +++ b/drivers/gpio/langwell_gpio.c
> @@ -123,8 +123,11 @@ static int lnw_irq_type(unsigned irq, unsigned type)
>  	void __iomem *grer = (void __iomem *)(&lnw->reg_base->GRER[reg]);
>  	void __iomem *gfer = (void __iomem *)(&lnw->reg_base->GFER[reg]);
>  
> -	if (gpio < 0 || gpio > lnw->chip.ngpio)
> +	if (irq < lnw->irq_base || gpio > lnw->chip.ngpio ||
> +			reg >= ARRAY_SIZE(lnw->reg_base->GRER)
> +			reg >= ARRAY_SIZE(lnw->reg_base->GFER))
>  		return -EINVAL;
> +
>  	spin_lock_irqsave(&lnw->lock, flags);
>  	if (type & IRQ_TYPE_EDGE_RISING)
>  		value = readl(grer) | BIT(gpio % 32);

Makes the code unfortunately complex.  It'd be better to make `gpio' a
signed quantity, or even..

--- a/drivers/gpio/langwell_gpio.c~gpio-fix-test-on-unsigned-in-lnw_irq_type
+++ a/drivers/gpio/langwell_gpio.c
@@ -123,7 +123,7 @@ static int lnw_irq_type(unsigned irq, un
 	void __iomem *grer = (void __iomem *)(&lnw->reg_base->GRER[reg]);
 	void __iomem *gfer = (void __iomem *)(&lnw->reg_base->GFER[reg]);
 
-	if (gpio < 0 || gpio > lnw->chip.ngpio)
+	if ((s32)gpio < 0 || gpio > lnw->chip.ngpio)
 		return -EINVAL;
 	spin_lock_irqsave(&lnw->lock, flags);
 	if (type & IRQ_TYPE_EDGE_RISING)
_

