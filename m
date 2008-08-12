Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbYHLTf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbYHLTf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYHLTfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:35:51 -0400
Received: from smooth.piipiip.net ([194.100.76.170]:52780 "EHLO
	smooth.piipiip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYHLTfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:35:50 -0400
X-Greylist: delayed 1795 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Aug 2008 15:35:50 EDT
Date: Tue, 12 Aug 2008 22:05:47 +0300
From: Riku Voipio <riku.voipio@iki.fi>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds-pca9532: Fix memory leak and properly handle errors
Message-ID: <20080812190547.GA3616@kos.to>
References: <alpine.LNX.1.10.0808080047290.16201@titan.stealer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0808080047290.16201@titan.stealer.net>
X-message-flag: Warning: message not sent with a DRM-Certified client
User-Agent: Mutt/1.5.11+cvs20060126
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: nchip@kos.to
X-SA-Exim-Scanned: No (on smooth.piipiip.net); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 12:49:40AM +0200, Sven Wegener wrote:
> When the registration fails, we need to release the memory we allocated. Also
> we need to save the error from led_classdev_register and propagate it up, else
> we'll return success, even if we failed.

> Not-yet-signed-off-by: Sven Wegener <sven.wegener@stealer.net>
> Cc: Riku Voipio <riku.voipio@iki.fi>

Driver in general works after this, error path(s) not tested.

Acked-By: Riku Voipio <riku.voipio@iki.fi>

> ---
>  drivers/leds/leds-pca9532.c |   22 +++++++++++++---------
>  1 files changed, 13 insertions(+), 9 deletions(-)
> 
> I don't have the hardware. Riku, can you please test if it still works as 
> expected.
> 
> diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
> index 4064d4f..16af817 100644
> --- a/drivers/leds/leds-pca9532.c
> +++ b/drivers/leds/leds-pca9532.c
> @@ -204,8 +204,8 @@ static int pca9532_configure(struct i2c_client *client,
>  			led->ldev.brightness = LED_OFF;
>  			led->ldev.brightness_set = pca9532_set_brightness;
>  			led->ldev.blink_set = pca9532_set_blink;
> -			if (led_classdev_register(&client->dev,
> -				&led->ldev) < 0)	{
> +			err = led_classdev_register(&client->dev, &led->ldev);
> +			if (err < 0) {
>  				dev_err(&client->dev,
>  					"couldn't register LED %s\n",
>  					led->name);
> @@ -263,7 +263,6 @@ exit:
>  			}
>  
>  	return err;
> -
>  }
>  
>  static int pca9532_probe(struct i2c_client *client,
> @@ -271,12 +270,16 @@ static int pca9532_probe(struct i2c_client *client,
>  {
>  	struct pca9532_data *data = i2c_get_clientdata(client);
>  	struct pca9532_platform_data *pca9532_pdata = client->dev.platform_data;
> +	int err;
> +
> +	if (!pca9532_pdata)
> +		return -EIO;
>  
>  	if (!i2c_check_functionality(client->adapter,
>  		I2C_FUNC_SMBUS_BYTE_DATA))
>  		return -EIO;
>  
> -	data = kzalloc(sizeof(struct pca9532_data), GFP_KERNEL);
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
>  	if (!data)
>  		return -ENOMEM;
>  
> @@ -285,12 +288,13 @@ static int pca9532_probe(struct i2c_client *client,
>  	data->client = client;
>  	mutex_init(&data->update_lock);
>  
> -	if (pca9532_pdata == NULL)
> -		return -EIO;
> -
> -	pca9532_configure(client, data, pca9532_pdata);
> -	return 0;
> +	err = pca9532_configure(client, data, pca9532_pdata);
> +	if (err) {
> +		kfree(data);
> +		i2c_set_clientdata(client, NULL);
> +	}
>  
> +	return err;
>  }
>  
>  static int pca9532_remove(struct i2c_client *client)

-- 
"rm -rf" only sounds scary if you don't have backups
