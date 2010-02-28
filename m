Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032209Ab0B1Ww6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 17:52:58 -0500
Received: from mga12.intel.com ([143.182.124.36]:2273 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1032075Ab0B1Ww5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 17:52:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,557,1262592000"; 
   d="scan'208";a="249129952"
Date: Sun, 28 Feb 2010 23:54:07 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: mturquette@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH] MFD: TWL4030: introduce remove_script function
Message-ID: <20100228225406.GA3391@sortiz.org>
References: <1266858990-3915-1-git-send-email-mturquette@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266858990-3915-1-git-send-email-mturquette@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Mon, Feb 22, 2010 at 11:16:30AM -0600, mturquette@gmail.com wrote:
> From: Mike Turquette <mturquette@ti.com>
> 
> New function twl4030_remove_script(u8 flags) takes a script type as
> defined in twl.h and prevents any script already loaded in that position
> from running.  This is accomplished by programming SEQ_ADD_* to 0x3f,
> the END_OF_SCRIPT value, where SEQ_ADD_* is determined by flags.
Patch applied, thanks a lot.

Cheers,
Samuel.


> Signed-off-by: Mike Turquette <mturquette@ti.com>
> ---
> 
> Based on MFD for-next branch.
> 
> Future users of this function include OMAP board files for machines
> facing a race condition between sleep and warm reset.
> 
>  drivers/mfd/twl4030-power.c |   50 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/twl.h     |    1 +
>  2 files changed, 51 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> index 5b045ff..7efa878 100644
> --- a/drivers/mfd/twl4030-power.c
> +++ b/drivers/mfd/twl4030-power.c
> @@ -461,6 +461,56 @@ out:
>  	return err;
>  }
>  
> +int twl4030_remove_script(u8 flags)
> +{
> +	int err = 0;
> +
> +	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, R_KEY_1,
> +			R_PROTECT_KEY);
> +	if (err) {
> +		pr_err("twl4030: unable to unlock PROTECT_KEY\n");
> +		return err;
> +	}
> +
> +	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, R_KEY_2,
> +			R_PROTECT_KEY);
> +	if (err) {
> +		pr_err("twl4030: unable to unlock PROTECT_KEY\n");
> +		return err;
> +	}
> +
> +	if (flags & TWL4030_WRST_SCRIPT) {
> +		err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, END_OF_SCRIPT,
> +				R_SEQ_ADD_WARM);
> +		if (err)
> +			return err;
> +	}
> +	if (flags & TWL4030_WAKEUP12_SCRIPT) {
> +		if (err)
> +		err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, END_OF_SCRIPT,
> +				R_SEQ_ADD_S2A12);
> +			return err;
> +	}
> +	if (flags & TWL4030_WAKEUP3_SCRIPT) {
> +		err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, END_OF_SCRIPT,
> +				R_SEQ_ADD_S2A3);
> +		if (err)
> +			return err;
> +	}
> +	if (flags & TWL4030_SLEEP_SCRIPT) {
> +		err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, END_OF_SCRIPT,
> +				R_SEQ_ADD_A2S);
> +		if (err)
> +			return err;
> +	}
> +
> +	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0, R_PROTECT_KEY);
> +	if (err)
> +		pr_err("TWL4030 Unable to relock registers\n");
> +
> +	return err;
> +}
> +
>  void __init twl4030_power_init(struct twl4030_power_data *twl4030_scripts)
>  {
>  	int err = 0;
> diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
> index 33d9d5c..d4baff8 100644
> --- a/include/linux/i2c/twl.h
> +++ b/include/linux/i2c/twl.h
> @@ -550,6 +550,7 @@ struct twl4030_power_data {
>  };
>  
>  extern void twl4030_power_init(struct twl4030_power_data *triton2_scripts);
> +extern int twl4030_remove_script(u8 flags);
>  
>  struct twl4030_codec_audio_data {
>  	unsigned int	audio_mclk;
> -- 
> 1.6.3.2
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
