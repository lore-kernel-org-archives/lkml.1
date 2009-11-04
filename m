Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbZKDLmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbZKDLmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbZKDLmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:42:45 -0500
Received: from mga06.intel.com ([134.134.136.21]:12200 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755399AbZKDLmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:42:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,679,1249282800"; 
   d="scan'208";a="464227933"
Date: Wed, 4 Nov 2009 12:44:36 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ben Dooks <ben@simtec.co.uk>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       Simtec Linux Team <linux@simtec.co.uk>
Subject: Re: tps60501: Allow configuration of VDCDC2
Message-ID: <20091104114435.GB3607@sortiz.org>
References: <20091102165230.757607586@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102165230.757607586@fluff.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Mon, Nov 02, 2009 at 04:52:30PM +0000, Ben Dooks wrote:
> Add function to allow the configuation fo the VDCDC2 register by
> external users, to allow changing of the standard and low-power
> running modes.
> 
> This is needed, for example, for the Simtec IM2440D20 where we need
> to use the low-power mode to shutdown the LDO/DCDC that are not needed
> during suspend (saving substantial power) and the runtime use of the
> low-power mode to change VCore.
Applied to my for-next branch, thanks.

Cheers,
Samuel.


> Signed-off-by: Ben Dooks <ben@simtec.co.uk>
> Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>
> 
> ---
>  drivers/mfd/tps65010.c       |   28 ++++++++++++++++++++++++++++
>  include/linux/i2c/tps65010.h |   19 +++++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> Index: b/drivers/mfd/tps65010.c
> ===================================================================
> --- a/drivers/mfd/tps65010.c	2009-11-02 15:55:43.000000000 +0000
> +++ b/drivers/mfd/tps65010.c	2009-11-02 16:40:04.000000000 +0000
> @@ -964,6 +964,34 @@ int tps65010_config_vregs1(unsigned valu
>  }
>  EXPORT_SYMBOL(tps65010_config_vregs1);
>  
> +int tps65010_config_vdcdc2(unsigned value)
> +{
> +	struct i2c_client *c;
> +	int	 status;
> +
> +	if (!the_tps)
> +		return -ENODEV;
> +
> +	c = the_tps->client;
> +	mutex_lock(&the_tps->lock);
> +
> +	pr_debug("%s: vdcdc2 0x%02x\n", DRIVER_NAME,
> +		 i2c_smbus_read_byte_data(c, TPS_VDCDC2));
> +
> +	status = i2c_smbus_write_byte_data(c, TPS_VDCDC2, value);
> +
> +	if (status != 0)
> +		printk(KERN_ERR "%s: Failed to write vdcdc2 register\n",
> +			DRIVER_NAME);
> +	else
> +		pr_debug("%s: vregs1 0x%02x\n", DRIVER_NAME,
> +			 i2c_smbus_read_byte_data(c, TPS_VDCDC2));
> +
> +	mutex_unlock(&the_tps->lock);
> +	return status;
> +}
> +EXPORT_SYMBOL(tps65010_config_vdcdc2);
> +
>  /*-------------------------------------------------------------------------*/
>  /* tps65013_set_low_pwr parameter:
>   * mode: ON or OFF
> Index: b/include/linux/i2c/tps65010.h
> ===================================================================
> --- a/include/linux/i2c/tps65010.h	2009-11-02 15:55:26.000000000 +0000
> +++ b/include/linux/i2c/tps65010.h	2009-11-02 15:55:43.000000000 +0000
> @@ -72,6 +72,21 @@
>  #define	TPS_VDCDC1		0x0c
>  #	define	TPS_ENABLE_LP		(1 << 3)
>  #define	TPS_VDCDC2		0x0d
> +#	define	TPS_LP_COREOFF	(1 << 7)
> +#	define 	TPS_VCORE_1_8V	(7<<4)
> +#	define 	TPS_VCORE_1_5V	(6 << 4)
> +#	define 	TPS_VCORE_1_4V	(5 << 4)
> +#	define 	TPS_VCORE_1_3V	(4 << 4)
> +#	define 	TPS_VCORE_1_2V	(3 << 4)
> +#	define 	TPS_VCORE_1_1V	(2 << 4)
> +#	define 	TPS_VCORE_1_0V	(1 << 4)
> +#	define 	TPS_VCORE_0_85V	(0 << 4)
> +#	define	TPS_VCORE_LP_1_2V (3 << 2)
> +#	define	TPS_VCORE_LP_1_1V (2 << 2)
> +#	define	TPS_VCORE_LP_1_0V (1 << 2)
> +#	define	TPS_VCORE_LP_0_85V (0 << 2)
> +#	define	TPS_VIB		(1 << 1)
> +#	define	TPS_VCORE_DISCH	(1 << 0)
>  #define	TPS_VREGS1		0x0e
>  #	define	TPS_LDO2_ENABLE	(1 << 7)
>  #	define	TPS_LDO2_OFF	(1 << 6)
> @@ -152,6 +167,10 @@ extern int tps65010_config_vregs1(unsign
>   */
>  extern int tps65013_set_low_pwr(unsigned mode);
>  
> +/* tps65010_set_vdcdc2
> + *  value to be written to VDCDC2
> + */
> +extern int tps65010_config_vdcdc2(unsigned value);
>  
>  struct i2c_client;
>  
> 
> -- 
> Ben (ben@fluff.org, http://www.fluff.org/)
> 
>   'a smiley only costs 4 bytes'

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
