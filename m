Return-Path: <linux-kernel-owner+w=401wt.eu-S1756410AbZEZRDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbZEZRDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZEZRDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:03:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35439 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbZEZRDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:03:31 -0400
Subject: Re: [PATCH] libertas: adapt for dynamic firmware id allocation
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Marcel Holtmann <holtmann@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1243349510-5322-1-git-send-email-linville@tuxdriver.com>
References: <20090526140423.GA14683@sortiz.org>
	 <1243349510-5322-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 26 May 2009 13:02:33 -0400
Message-Id: <1243357353.8063.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 16:51 +0200, John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_spi.c |    8 ++++----
>  drivers/net/wireless/libertas/if_spi.h |    3 +++
>  drivers/net/wireless/libertas/if_usb.c |    8 ++------
>  3 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
> index 5fa55fe..b3dc609 100644
> --- a/drivers/net/wireless/libertas/if_spi.c
> +++ b/drivers/net/wireless/libertas/if_spi.c
> @@ -44,8 +44,8 @@ struct if_spi_card {
>  	struct lbs_private		*priv;
>  	struct libertas_spi_platform_data *pdata;
>  
> -	char				helper_fw_name[FIRMWARE_NAME_MAX];
> -	char				main_fw_name[FIRMWARE_NAME_MAX];
> +	char				helper_fw_name[IF_SPI_FW_NAME_MAX];
> +	char				main_fw_name[IF_SPI_FW_NAME_MAX];
>  
>  	/* The card ID and card revision, as reported by the hardware. */
>  	u16				card_id;
> @@ -1013,9 +1013,9 @@ static int if_spi_calculate_fw_names(u16 card_id,
>  		lbs_pr_err("Unsupported chip_id: 0x%02x\n", card_id);
>  		return -EAFNOSUPPORT;
>  	}
> -	snprintf(helper_fw, FIRMWARE_NAME_MAX, "libertas/gspi%d_hlp.bin",
> +	snprintf(helper_fw, IF_SPI_FW_NAME_MAX, "libertas/gspi%d_hlp.bin",
>  		 chip_id_to_device_name[i].name);
> -	snprintf(main_fw, FIRMWARE_NAME_MAX, "libertas/gspi%d.bin",
> +	snprintf(main_fw, IF_SPI_FW_NAME_MAX, "libertas/gspi%d.bin",
>  		 chip_id_to_device_name[i].name);
>  	return 0;
>  }
> diff --git a/drivers/net/wireless/libertas/if_spi.h b/drivers/net/wireless/libertas/if_spi.h
> index 2103869..f87eec4 100644
> --- a/drivers/net/wireless/libertas/if_spi.h
> +++ b/drivers/net/wireless/libertas/if_spi.h
> @@ -22,6 +22,9 @@
>  #define IF_SPI_CMD_BUF_SIZE 2400
>  
>  /***************** Firmware *****************/
> +
> +#define IF_SPI_FW_NAME_MAX 30
> +
>  struct chip_ident {
>  	u16 chip_id;
>  	u16 name;
> diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
> index ea3dc03..713c830 100644
> --- a/drivers/net/wireless/libertas/if_usb.c
> +++ b/drivers/net/wireless/libertas/if_usb.c
> @@ -61,11 +61,9 @@ static ssize_t if_usb_firmware_set(struct device *dev,
>  {
>  	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
>  	struct if_usb_card *cardp = priv->card;
> -	char fwname[FIRMWARE_NAME_MAX];
>  	int ret;
>  
> -	sscanf(buf, "%29s", fwname); /* FIRMWARE_NAME_MAX - 1 = 29 */
> -	ret = if_usb_prog_firmware(cardp, fwname, BOOT_CMD_UPDATE_FW);
> +	ret = if_usb_prog_firmware(cardp, buf, BOOT_CMD_UPDATE_FW);
>  	if (ret == 0)
>  		return count;
>  
> @@ -88,11 +86,9 @@ static ssize_t if_usb_boot2_set(struct device *dev,
>  {
>  	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
>  	struct if_usb_card *cardp = priv->card;
> -	char fwname[FIRMWARE_NAME_MAX];
>  	int ret;
>  
> -	sscanf(buf, "%29s", fwname); /* FIRMWARE_NAME_MAX - 1 = 29 */
> -	ret = if_usb_prog_firmware(cardp, fwname, BOOT_CMD_UPDATE_BOOT2);
> +	ret = if_usb_prog_firmware(cardp, buf, BOOT_CMD_UPDATE_BOOT2);
>  	if (ret == 0)
>  		return count;
>  

