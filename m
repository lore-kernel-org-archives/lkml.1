Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZFWSzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZFWSzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZFWSzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:55:15 -0400
Received: from n14.bullet.mail.mud.yahoo.com ([68.142.206.41]:33828 "HELO
	n14.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752173AbZFWSzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:55:14 -0400
X-Yahoo-Newman-Id: 569405.31565.bm@omp423.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zRCLxb4L96SRmQ4X4rSK9IWpFuPD2J15J4Lpcj4n8YEGDty8q+0z4ATj/wGB6Ojacs9pCzTwEitB4huhctv+XegjJcjhP/1zvPihMOAOTIAUQlaDD25iFKlq24PAczzK2zYXAghAg4dxRB7wR5E0iGIvRJhKbrxMt6q/AOwIlQY=  ;
X-YMail-OSG: uth1qRUVM1nnPvyFbq20a.OE1cKj47DGDyJvHYmamztqhRGVO_h3oAZ3pGzZnm7u1cuzW7M1I1LRLkP6I0gXTu084WtgXVAbKHV8H3oKSr6qnlCQU5XH5BctnfT46Yysdx040Pb_wMwyw9jWMVxU6GhAyrguEuOjaHRUtZhpSPCWcE0GyyPiXkXUGYU8cca0oL9LkTBpNg0fJo3TFQB0JhXG6KkROeXMDLsCg2OLaBFEB3fI34RfJcpVMl4fgpm2_JHKjwTGiDhKRj9UXnVztJgt9c3kyUO6oBP8r.D1DplvoVS5r7J1
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] [drivers] [SPI] SPI_GPIO: add support for controllers with missing MISO pin
Date: Tue, 23 Jun 2009 11:55:15 -0700
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>,
       "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
       "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC0228288531@bssrvexch01.BS.local>
In-Reply-To: <E4D3F24EA6C9E54F817833EAE0D912AC0228288531@bssrvexch01.BS.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906231155.15339.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, Marek Szyprowski wrote:
> There are some boards that do not strictly follow SPI standard and use only 3 wires
> (SCLK, MOSI, SS) for connecting some simple auxiliary chips and controls them with GPIO
> based 'spi controller'. In this configuration the MISO line is missing (it is not
> required if the chip does not transfer any data back to host). The example of such
> board is a NCP ARM S3C64XX based machine. This patch adds support for such non-standard
> configuration in GPIO-based SPI controller.
> 
> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

This is missing one integrity feature:  it should reject all
requests that provide a read buffer, since obviously it can't
satisfy any such requests.

Also, please add a comment in spi_gpio_request() explaining
this point:  that output-only configs exist, and you're
supporting them by letting MISO be invalid.

Address those two points and this will be almost OK.


Thing is, this raises two related issues:  (a) there's the
analagous input-only case where MOSI isn't used, e.g. for
some kinds of sensor; and (b) there's also "real 3-wire SPI"
(spi->mode & SPI_3WIRE) where interactions are limited to
half duplex and one pin switches roles between MOSI and MISO.

Clearly this "output-only" case is a subset of SPI_3WIRE (the
MOMI/SISO pin can't switch direction) so one more change I
want to see is requiring that spi->mode flag be set in all
SPI devices registered when this mode is used.

If you have time, it would be good to generaize this patch
to cover all of those 3-wire modes ... accept all half
duplex calls, use gpio_direction_*() to switch direction.

If not -- e.g. nothing to test that with! -- then I can
understand, but please make your changes with that model
in mind, and leave an appropriate FIXME in place.

- Dave

p.s. I'll CC you on one more related patch.  Briefly,
     there's a new spi_master->flags field that should
     set SPI_MASTER_HALF_DUPLEX.  Arguably, this specific
     case should also advertise something like NO_RX.


> 
> --- 
> 
> diff --git a/drivers/spi/spi_gpio.c b/drivers/spi/spi_gpio.c
> index 26bd03e..16f74fd 100644
> --- a/drivers/spi/spi_gpio.c
> +++ b/drivers/spi/spi_gpio.c
> @@ -114,7 +114,10 @@ static inline void setmosi(const struct spi_device *spi, int is_on)
>  
>  static inline int getmiso(const struct spi_device *spi)
>  {
> -	return !!gpio_get_value(SPI_MISO_GPIO);
> +	if (gpio_is_valid(SPI_MISO_GPIO))
> +		return !!gpio_get_value(SPI_MISO_GPIO);
> +	else
> +		return 0;
>  }
>  
>  #undef pdata
> @@ -243,9 +246,11 @@ spi_gpio_request(struct spi_gpio_platform_data *pdata, const char *label)
>  	if (value)
>  		goto done;
>  
> -	value = spi_gpio_alloc(SPI_MISO_GPIO, label, true);
> -	if (value)
> -		goto free_mosi;
> +	if (gpio_is_valid(SPI_MISO_GPIO)) {
> +		value = spi_gpio_alloc(SPI_MISO_GPIO, label, true);
> +		if (value)
> +			goto free_mosi;
> +	}
>  
>  	value = spi_gpio_alloc(SPI_SCK_GPIO, label, false);
>  	if (value)
> @@ -254,7 +259,8 @@ spi_gpio_request(struct spi_gpio_platform_data *pdata, const char *label)
>  	goto done;
>  
>  free_miso:
> -	gpio_free(SPI_MISO_GPIO);
> +	if (gpio_is_valid(SPI_MISO_GPIO))
> +		gpio_free(SPI_MISO_GPIO);
>  free_mosi:
>  	gpio_free(SPI_MOSI_GPIO);
>  done:
> @@ -308,7 +314,8 @@ static int __init spi_gpio_probe(struct platform_device *pdev)
>  	if (status < 0) {
>  		spi_master_put(spi_gpio->bitbang.master);
>  gpio_free:
> -		gpio_free(SPI_MISO_GPIO);
> +		if (gpio_is_valid(SPI_MISO_GPIO))
> +			gpio_free(SPI_MISO_GPIO);
>  		gpio_free(SPI_MOSI_GPIO);
>  		gpio_free(SPI_SCK_GPIO);
>  		spi_master_put(master);
> @@ -332,7 +339,8 @@ static int __exit spi_gpio_remove(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, NULL);
>  
> -	gpio_free(SPI_MISO_GPIO);
> +	if (gpio_is_valid(SPI_MISO_GPIO))
> +		gpio_free(SPI_MISO_GPIO);
>  	gpio_free(SPI_MOSI_GPIO);
>  	gpio_free(SPI_SCK_GPIO);
> 
> 
> 



