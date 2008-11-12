Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbYKLSrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbYKLSrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYKLSrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:47:18 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:36162 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbYKLSrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:47:17 -0500
Date: Wed, 12 Nov 2008 19:49:57 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28] mfd: Correct WM8350 I2C return code usage
Message-ID: <20081112184956.GA17382@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1226324477-21022-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226324477-21022-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Nov 10, 2008 at 01:41:17PM +0000, Mark Brown wrote:
> The vendor BSP used for the WM8350 development provided an I2C driver
> which incorrectly returned zero on succesful sends rather than the
> number of transmitted bytes, an error which was then propagated into the
> WM8350 I2C accessors.
Shouldnt we fix the accessors behaviour instead ?
Currently, that would mean fixing some of the wm8350-core static functions.
Slightly bigger patch, but that would keep the i2c interface consistent.
What do you think ?

Cheers,
Samuel.

> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8350-i2c.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/wm8350-i2c.c b/drivers/mfd/wm8350-i2c.c
> index 8dfe21b..3e0ce0e 100644
> --- a/drivers/mfd/wm8350-i2c.c
> +++ b/drivers/mfd/wm8350-i2c.c
> @@ -30,7 +30,12 @@ static int wm8350_i2c_read_device(struct wm8350 *wm8350, char reg,
>  	ret = i2c_master_send(wm8350->i2c_client, &reg, 1);
>  	if (ret < 0)
>  		return ret;
> -	return i2c_master_recv(wm8350->i2c_client, dest, bytes);
> +	ret = i2c_master_recv(wm8350->i2c_client, dest, bytes);
> +	if (ret < 0)
> +		return ret;
> +	if (ret != bytes)
> +		return -EIO;
> +	return 0;
>  }
>  
>  static int wm8350_i2c_write_device(struct wm8350 *wm8350, char reg,
> @@ -38,13 +43,19 @@ static int wm8350_i2c_write_device(struct wm8350 *wm8350, char reg,
>  {
>  	/* we add 1 byte for device register */
>  	u8 msg[(WM8350_MAX_REGISTER << 1) + 1];
> +	int ret;
>  
>  	if (bytes > ((WM8350_MAX_REGISTER << 1) + 1))
>  		return -EINVAL;
>  
>  	msg[0] = reg;
>  	memcpy(&msg[1], src, bytes);
> -	return i2c_master_send(wm8350->i2c_client, msg, bytes + 1);
> +	ret = i2c_master_send(wm8350->i2c_client, msg, bytes + 1);
> +	if (ret < 0)
> +		return ret;
> +	if (ret != bytes + 1)
> +		return -EIO;
> +	return 0;
>  }
>  
>  static int wm8350_i2c_probe(struct i2c_client *i2c,
> -- 
> 1.5.6.5
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
