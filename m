Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbYJBIXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbYJBIXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYJBIWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:22:51 -0400
Received: from bu3sch.de ([62.75.166.246]:55714 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbYJBIWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:22:51 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Rakib Mullick" <rakib.mullick@gmail.com>
Subject: Re: [PATCH] drivers/gpio/bt8xxgpio.c Fix compilation warning.
Date: Thu, 2 Oct 2008 10:22:12 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <b9df5fa10810012359oac41498sf716ce51b39a36ce@mail.gmail.com>
In-Reply-To: <b9df5fa10810012359oac41498sf716ce51b39a36ce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810021022.13252.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 October 2008 08:59:11 Rakib Mullick wrote:
> drivers/gpio/bt8xxgpio.c: In function `bt8xxgpio_remove':
> drivers/gpio/bt8xxgpio.c:247: warning: ignoring return value of
> `gpiochip_remove', declared with attribute warn_unused_result
> 
> Following patch removes the above warning.
> Thanks.
> 
> Signed-off-by:	Md.Rakib H. Mullick (rakib.mullick@gmail.com)
> 
> --- linux-2.6.27-rc8.orig/drivers/gpio/bt8xxgpio.c	2008-10-01
> 19:20:59.000000000 +0600
> +++ linux-2.6.27-rc8/drivers/gpio/bt8xxgpio.c	2008-10-02
> 12:30:26.374544032 +0600
> @@ -242,9 +242,14 @@ err_freebg:
> 
>  static void bt8xxgpio_remove(struct pci_dev *pdev)
>  {
> +	int err;
>  	struct bt8xxgpio *bg = pci_get_drvdata(pdev);
> 
> -	gpiochip_remove(&bg->gpio);
> +	err = gpiochip_remove(&bg->gpio);
> +	if (err) {
> +		printk(KERN_ERR "bt8xxgpio: Resource busy. Failed to remove.\n");
> +		return ;
> +	}
> 
>  	bgwrite(0, BT848_INT_MASK);
>  	bgwrite(~0x0, BT848_INT_STAT);
> 
> 

NACK.
gpiolib should be fixed.
It is impossible to handle this case. What your patch does is to leave the device
in an inconsistent state, if the gpio remove fails.

gpiolib is broken. It should not allow failure for the remove function, as most
callers cannot handle it. gpiolib should force-remove any users of the gpio line,
if the chip driver removes the chip. That's really the only way we can fix this.
Breaking the driver (to leak resources or leave the device in an inconsistent state)
just to get rid of a bogus warning is not the right fix.
Please ignore this warning for now.

-- 
Greetings Michael.
