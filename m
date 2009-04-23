Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbZDWOwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbZDWOwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbZDWOwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:52:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55524 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441AbZDWOwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:52:05 -0400
Date: Thu, 23 Apr 2009 15:52:02 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
Cc: linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH] TWL4030: add function to send PB messages
Message-ID: <20090423145201.GT30105@sirena.org.uk>
References: <1240492089-14410-1-git-send-email-peter.de-schrijver@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240492089-14410-1-git-send-email-peter.de-schrijver@nokia.com>
X-Cookie: My vaseline is RUNNING...
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 04:08:08PM +0300, Peter 'p2' De Schrijver wrote:
> And now with fix to make it compile.
> 
> This patch moves sending of powerbus messages to a separate function. It also
> makes sure I2C access to the powerbus is enabled.
> 
> Signed-off-by: Peter 'p2' De Schrijver <peter.de-schrijver@nokia.com>

CCing in Liam (the primary regulator maintainer) and David (the TWL4030
regulator expert).  When submitting patches it is always best to CC the
relevant maintainers, it is extremely easy for things to get dropped on
the floor otherwise.

> ---
>  drivers/regulator/twl4030-regulator.c |   72 +++++++++++++++++++++++++++++---
>  1 files changed, 65 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
> index 472c35a..df9a94b 100644
> --- a/drivers/regulator/twl4030-regulator.c
> +++ b/drivers/regulator/twl4030-regulator.c
> @@ -16,6 +16,7 @@
>  #include <linux/regulator/driver.h>
>  #include <linux/regulator/machine.h>
>  #include <linux/i2c/twl4030.h>
> +#include <linux/delay.h>
>  
>  
>  /*
> @@ -81,6 +82,69 @@ twl4030reg_write(struct twlreg_info *info, unsigned offset, u8 value)
>  			value, info->base + offset);
>  }
>  
> +static int twl4030_wait_pb_ready(void)
> +{
> +
> +	u8 pb_status;
> +	int status, timeout = 10;
> +
> +	do {
> +		status = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER,
> +						&pb_status, 0x14);
> +		if (status < 0)
> +			return status;
> +
> +		if (!(pb_status & 1))
> +			return 0;
> +
> +		mdelay(1);
> +		timeout--;
> +
> +	} while (timeout);
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int twl4030_send_pb_msg(unsigned msg)
> +{
> +
> +	u8 pb_state;
> +	int status;
> +
> +	/* save powerbus configuration */
> +	status = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER,
> +					&pb_state, 0x14);
> +	if (status < 0)
> +		return status;
> +
> +	/* Enable I2C access to powerbus */
> +	status = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
> +					pb_state | (1<<1), 0x14);
> +	if (status < 0)
> +		return status;
> +
> +	status = twl4030_wait_pb_ready();
> +	if (status < 0)
> +		return status;
> +
> +	status = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, msg >> 8,
> +			0x15 /* PB_WORD_MSB */);
> +	if (status < 0)
> +		return status;
> +
> +	status = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, msg & 0xff,
> +			0x16 /* PB_WORD_LSB */);
> +	if (status < 0)
> +		return status;
> +
> +	status = twl4030_wait_pb_ready();
> +	if (status < 0)
> +		return status;
> +
> +	/* Restore powerbus configuration */
> +	return twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, pb_state, 0x14);
> +}
> +
>  /*----------------------------------------------------------------------*/
>  
>  /* generic power resource operations, which work on all regulators */
> @@ -177,13 +241,7 @@ static int twl4030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
>  	if (!(status & (P3_GRP | P2_GRP | P1_GRP)))
>  		return -EACCES;
>  
> -	status = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
> -			message >> 8, 0x15 /* PB_WORD_MSB */ );
> -	if (status >= 0)
> -		return status;
> -
> -	return twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
> -			message, 0x16 /* PB_WORD_LSB */ );
> +	return twl4030_send_pb_msg(message);
>  }
>  
>  /*----------------------------------------------------------------------*/
> -- 
> 1.5.6.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
