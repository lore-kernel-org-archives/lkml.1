Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbZBRVGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbZBRVGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZBRVFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:05:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615AbZBRVFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:05:51 -0500
Date: Wed, 18 Feb 2009 13:04:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       openwrt-devel@lists.openwrt.org
Subject: Re: [PATCH] spi-gpio: Sanitize MISO bitvalue
Message-Id: <20090218130426.a12e6bfa.akpm@linux-foundation.org>
In-Reply-To: <200902151630.41426.mb@bu3sch.de>
References: <200902151630.41426.mb@bu3sch.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Feb 2009 16:30:41 +0100
Michael Buesch <mb@bu3sch.de> wrote:

> gpio_get_value() returns 0 or nonzero, but getmiso() expects 0 or 1.
> Sanitize the value to a 0/1 boolean.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> Well, we could also change the bitbang helpers in linux/spi/spi_bitbang.h
> or change the way the gpio_get_value API is defined, but I personally think
> this patch is pretty good as is.
> In any case, it fixes a real bug on platforms like the bcm47xx which
> return 0 or nonzero for gpio_get_value.
> 
> Index: linux-2.6/drivers/spi/spi_gpio.c
> ===================================================================
> --- linux-2.6.orig/drivers/spi/spi_gpio.c	2009-02-14 21:37:14.000000000 +0100
> +++ linux-2.6/drivers/spi/spi_gpio.c	2009-02-15 16:27:16.000000000 +0100
> @@ -114,7 +114,7 @@ static inline void setmosi(const struct 
>  
>  static inline int getmiso(const struct spi_device *spi)
>  {
> -	return gpio_get_value(SPI_MISO_GPIO);
> +	return !!gpio_get_value(SPI_MISO_GPIO);
>  }
>  
>  #undef pdata
> 

Seems somewhat pointless, really.  It's a very common C idiom to treat
any non-zero value as true, and the above just adds a couple more
instructions which we didn't need to execute.

If this function is speed-critical (which is what David's comment
implies) then perhaps this should be "fixed" by tightening up the
(presently apparently undocumented) interface?  And then speeding up
all the other getmiso() implementations?
