Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbZDWWEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbZDWWEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbZDWWDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:03:50 -0400
Received: from n23.bullet.mail.mud.yahoo.com ([68.142.206.162]:43753 "HELO
	n23.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756216AbZDWWDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:03:49 -0400
X-Yahoo-Newman-Id: 185510.71479.bm@omp414.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=M9o2ZOBY/hGTeJufnH/Nmbj+MLWqfJnZJ3LCanGFssxisYaeYBbjwIqRWOqvflmfLCb0VtBIwJxSu60okS7quVa5Y5qLhyS7bZuiGnKlOjQjeAxFYcxNIFeiuDBwXH/DkddXO5csIBpAjXw79iqiAbnMJ1ZMiPjaW6OHHxibmfE=  ;
X-YMail-OSG: 6eV7JLkVM1koK6dAkASY_wTiqfPJb5ySeue6303VwJzC7inA_HJ0eCb6.q_9TNGn.slvpiHfJRTB94GDelx4PfeGJZoapid9_hThWf6K6iYVbZ7pz6Oicr5ZcuvuN_uPDBdguK5sUtF1ZmigAJImwVWsw02hw.gOQZO0GoPjWxloVrIb.mUCmlIdI9lhWF_tQnboV0SOvhOeFs36I93Vfg5p3.N0hiWyssxQq2wSvb7pFYjsV7GaPOvTldR4ER7MtyhwiWe3ql49zeELW8ElxN4XxlUFwfHQ27SdhUDbTMFyiRj3.sM-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
Subject: Re: [PATCH] TWL4030: add function to send PB messages
Date: Thu, 23 Apr 2009 15:03:47 -0700
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>
References: <1240407833-28060-1-git-send-email-peter.de-schrijver@nokia.com>
In-Reply-To: <1240407833-28060-1-git-send-email-peter.de-schrijver@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904231503.47287.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 April 2009, Peter 'p2' De Schrijver wrote:
> This patch moves sending of powerbus messages to a separate function.

Can you add #defines for those register offsets, and use
those as names instead of 0x14/0x15/0x16?  And at least
use BIT(x) instead of (1 << x).

If this moves into twl4030_core.c (as I ask about elsewhere),
those registers can just be defines local to that file.

Otherwise this seems ok.


> It also 
> makes sure I2C access to the powerbus is enabled.
> 
> Signed-off-by: Peter 'p2' De Schrijver <peter.de-schrijver@nokia.com>
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

Worth a comment that PB_CFG.BIT(0) == PB_I2C_BUSY ... true if there's
a word queued for the power bus, but not yet sent.  And that we assume
no other I2C master is sending such events...


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

I'd probably combine wait_pb_ready() with this; not that
this is wrong, but you should only need to set BIT(1) once,
and there's no need to re-read that byte to test BIT(0).

Minor point ... I hate needless I/O.  This isn't a critical
path though.


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
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



