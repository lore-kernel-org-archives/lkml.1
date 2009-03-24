Return-Path: <linux-kernel-owner+w=401wt.eu-S1762655AbZCXUJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762655AbZCXUJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbZCXUJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:09:33 -0400
Received: from n10.bullet.mail.mud.yahoo.com ([209.191.125.208]:26989 "HELO
	n10.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753110AbZCXUJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:09:32 -0400
X-Yahoo-Newman-Id: 568506.86810.bm@omp425.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZW2TlLbI3vljkYx5qEi7NVzU9fnS/oqNZVL8XM383DaqAoQuYcdoBeh6wTnLOzbf71IoZHiVS4CXnUL6reK5Zm12O1wyVp91dFmmz1AQ6/tIIjzORBcse6TMm4C8HdUMDYbXbFU9SDP4/fm9BkHD+U1lRYy/L4ZSyWti/hnwAkc=  ;
X-YMail-OSG: 1GcDthgVM1lGUVbAQ680ltJvFmnV3bHYA8qbe6juv1K.vMQTeVMJD7LZXrOSipaYRyjLOTwCnr75UoZm9u6MlCrF61U.5L23BoHCjhemkyJOygA9s_sk6nSujQ6BUOQ_3ta9VbxNYOuvPo59c4ABB_pNJWduONzdSg3mMDIK5EHXwEVWobKtNWSyMLgLbs.TRO6661ZjM3Q.K4A2qj.qVa5jpdp38p8ufJ90K8Z6sCk-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Daniel =?iso-8859-1?q?Gl=F6ckner?= <dg@emlix.com>
Subject: Re: [patch 3/6] xtensa: add spi mmc host to s6105 platform
Date: Tue, 24 Mar 2009 13:09:27 -0700
User-Agent: KMail/1.9.10
Cc: Chris Zankel <chris@zankel.net>, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <1237822462-32109-1-git-send-email-dg@emlix.com> <1237822462-32109-3-git-send-email-dg@emlix.com>
In-Reply-To: <1237822462-32109-3-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903241309.27310.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 March 2009, Daniel Glöckner wrote:
> Signed-off-by: Daniel Glöckner <dg@emlix.com>

Looks OK to me.  FWIW I don't expect to ack arch patches
that just use public interfaces...


> ---
>  arch/xtensa/platforms/s6105/device.c |   55 ++++++++++++++++++++++++++++++++++
>  1 files changed, 55 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
> index a7ea916..789448e 100644
> --- a/arch/xtensa/platforms/s6105/device.c
> +++ b/arch/xtensa/platforms/s6105/device.c
> @@ -11,9 +11,11 @@
>  #include <linux/init.h>
>  #include <linux/irq.h>
>  #include <linux/phy.h>
> +#include <linux/mmc/host.h>
>  #include <linux/platform_device.h>
>  #include <linux/serial.h>
>  #include <linux/serial_8250.h>
> +#include <linux/spi/mmc_spi.h>
>  #include <linux/spi/spi.h>
>  #include <linux/spi/spi_s6000.h>
>  
> @@ -209,7 +211,60 @@ static __devinitdata struct s6_spi_platform_data s6_spi_pdata = {
>  #define S6_SPI_CS_EXPANSION	3
>  #define S6_SPI_CS_MMC_SLOT	4
>  
> +static int __devinit s6_init_mmc_host(struct device *spi,
> +				      irqreturn_t (*handler)(int, void *),
> +				      void *mmc)
> +{
> +	int ret;
> +	ret = gpio_request(GPIO_SD_WP, "mmc_wp");
> +	if (ret < 0)
> +		return ret;
> +	ret = gpio_request(GPIO_SD_IRQ, "mmc_irq");
> +	if (ret < 0)
> +		return ret;
> +	ret = gpio_direction_input(GPIO_SD_WP);
> +	if (ret < 0)
> +		return ret;
> +	ret = gpio_direction_input(GPIO_SD_IRQ);
> +	if (ret < 0)
> +		return ret;
> +	ret = gpio_to_irq(GPIO_SD_IRQ);
> +	if (ret < 0)
> +		return ret;
> +	ret = request_irq(ret, handler,
> +			  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
> +			  "mmc_slot", mmc);
> +	return ret;
> +}
> +
> +static void __devexit s6_exit_mmc_host(struct device *spi, void *mmc)
> +{
> +	free_irq(gpio_to_irq(GPIO_SD_IRQ), mmc);
> +	gpio_free(GPIO_SD_IRQ);
> +	gpio_free(GPIO_SD_WP);
> +}
> +
> +static int s6_mmc_get_ro(struct device *spi)
> +{
> +	return gpio_get_value(GPIO_SD_WP);
> +}
> +
> +static struct mmc_spi_platform_data s6_spi_mmc_pdata = {
> +	.caps = 0,
> +	.ocr_mask = MMC_VDD_32_33,
> +	.init = s6_init_mmc_host,
> +	.exit = __devexit_p(s6_exit_mmc_host),
> +	.get_ro = s6_mmc_get_ro,
> +};
> +
>  static struct spi_board_info __initdata s6_spi_devices[] = {
> +	{
> +		.modalias = "mmc_spi",
> +		.platform_data = &s6_spi_mmc_pdata,
> +		.bus_num = S6_SPI_BUS_NUM,
> +		.chip_select = S6_SPI_CS_MMC_SLOT,
> +		.max_speed_hz = 50000000,
> +	},
>  };
>  
>  static struct platform_device platform_devices[] = {
> -- 
> 1.6.2.107.ge47ee
> 
> 



