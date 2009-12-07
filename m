Return-Path: <linux-kernel-owner+w=401wt.eu-S935116AbZLGNxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935116AbZLGNxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935072AbZLGNxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:53:23 -0500
Received: from smtp.nokia.com ([192.100.122.230]:29321 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935048AbZLGNxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:53:23 -0500
Date: Mon, 7 Dec 2009 15:53:09 +0200
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, "gadiyar@ti.com" <gadiyar@ti.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       List Linux Omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/1] mfd: twl4030: clarify the return value for read
 and write
Message-ID: <20091207135309.GA23829@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <5A47E75E594F054BAF48C5E4FC4B92AB0309DAC23C@dbde02.ent.ti.com>
 <449d505b874c236e4d0df0c1f765918386a4d58b.1260187781.git.amit.kucheria@verdurent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <449d505b874c236e4d0df0c1f765918386a4d58b.1260187781.git.amit.kucheria@verdurent.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Dec 2009 13:53:13.0377 (UTC) FILETIME=[9E7A3110:01CA7744]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 01:17:29PM +0100, ext Amit Kucheria wrote:
> Infact, we can just return -EIO so that caller knows for sure that all
> messages were not tranferred. Please consider fixed patch instead.
> 
> We should be checking if all the messages were tranferred or not. And return
> -1 for failure. Currently we return success (0) even if none of messages were
> transferred successfully.
> 
> Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
> ---
>  drivers/mfd/twl4030-core.c |   24 ++++++++++++++++--------
>  1 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
> index 56f1de5..3d2c413 100644
> --- a/drivers/mfd/twl4030-core.c
> +++ b/drivers/mfd/twl4030-core.c
> @@ -292,10 +292,14 @@ int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
>  	ret = i2c_transfer(twl->client->adapter, twl->xfer_msg, 1);
>  	mutex_unlock(&twl->xfer_lock);
>  
> -	/* i2cTransfer returns num messages.translate it pls.. */
> -	if (ret >= 0)
> -		ret = 0;
> -	return ret;
> +	/* i2c_transfer returns number of messages transferred */
> +	if (ret != 1) {
> +		pr_err("%s: i2c_write failed to transfer all messages\n",
> +			DRIVER_NAME);
> +		return -EIO;

How about reporting the actual error that has occurred and reported by i2c_transfer?
Instead of just masking it as EIO? If i2c_transfer returns something > 0 then EIO should be right.
But if returns and error code, then that error code must be reported to upper layers.

> +	} else {
> +		return 0;
> +	}
>  }
>  EXPORT_SYMBOL(twl4030_i2c_write);
>  
> @@ -344,10 +348,14 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
>  	ret = i2c_transfer(twl->client->adapter, twl->xfer_msg, 2);
>  	mutex_unlock(&twl->xfer_lock);
>  
> -	/* i2cTransfer returns num messages.translate it pls.. */
> -	if (ret >= 0)
> -		ret = 0;
> -	return ret;
> +	/* i2c_transfer returns number of messages transferred */
> +	if (ret != 2) {
> +		pr_err("%s: i2c_read failed to transfer all messages\n",
> +			DRIVER_NAME);
> +		return -EIO;


dito.

> +	} else {
> +		return 0;
> +	}
>  }
>  EXPORT_SYMBOL(twl4030_i2c_read);
>  
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Eduardo Valentin
