Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbXKCNtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbXKCNtA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 09:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbXKCNsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 09:48:53 -0400
Received: from smtp-106-saturday.nerim.net ([62.4.16.106]:56162 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753964AbXKCNsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 09:48:52 -0400
Date: Sat, 3 Nov 2007 14:48:49 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 3/4] Blackfin I2C/TWI driver: add missing pin mux
 operation
Message-ID: <20071103144849.5453dc53@hyperion.delvare>
In-Reply-To: <1193984664-10609-4-git-send-email-bryan.wu@analog.com>
References: <1193984664-10609-1-git-send-email-bryan.wu@analog.com>
	<1193984664-10609-4-git-send-email-bryan.wu@analog.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Fri,  2 Nov 2007 14:24:23 +0800, Bryan Wu wrote:
> Blackfin TWI controller hardware pin should be requested from GPIO port controller
> Before BF54x, there is no need to do this. But as long as BF54x and BF52x
> are supported by this generic driver, the missing pin mux operation should be
> added.
> 
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---
>  drivers/i2c/busses/i2c-bfin-twi.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
> index e495454..727625b 100644
> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> @@ -34,6 +34,7 @@
>  #include <linux/platform_device.h>
>  
>  #include <asm/blackfin.h>
> +#include <asm/portmux.h>
>  #include <asm/irq.h>
>  
>  #define POLL_TIMEOUT       (2 * HZ)
> @@ -63,6 +64,7 @@ struct bfin_twi_iface {
>  	int			msg_num;
>  	int			cur_msg;
>  	void __iomem		*regs_base;
> +	int			bus_num;
>  };
>  
>  
> @@ -89,6 +91,24 @@ DEFINE_TWI_REG(XMT_DATA16, 0x84)
>  DEFINE_TWI_REG(RCV_DATA8, 0x88)
>  DEFINE_TWI_REG(RCV_DATA16, 0x8C)
>  
> +static int setup_pin_mux(int action, struct bfin_twi_iface *iface)

I suggest swapping the order of the parameters - it makes more sense to
pass the object first and the action second than the other way around
IMHO.

Also, all other functions in this driver are named bfin_twi_<something>
so it would be nicer to do the same here.

> +{
> +
> +	u16 pin_req[2][3] = {
> +		{P_TWI0_SCL, P_TWI0_SDA, 0},
> +		{P_TWI1_SCL, P_TWI1_SDA, 0},
> +	};

See my previous review: this array should be const and possibly static.

> +
> +	if (action) {
> +		if (peripheral_request_list(pin_req[iface->bus_num], DRV_NAME))
> +			return -EFAULT;

Mike Frysinger suggested that you should return the error code from
peripheral_request_list() and I agree with him.

> +	} else {
> +		peripheral_free_list(pin_req[iface->bus_num]);
> +	}
> +
> +	return 0;
> +}
> +
>  static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
>  {
>  	unsigned short twi_int_status = read_INT_STAT(iface);
> @@ -640,6 +660,7 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
>  		goto out_error_no_irq;
>  	}
>  
> +	iface->bus_num = pdev->id;
>  	init_timer(&(iface->timeout_timer));
>  	iface->timeout_timer.function = bfin_twi_timeout;
>  	iface->timeout_timer.data = (unsigned long)iface;
> @@ -652,6 +673,8 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
>  	p_adap->class = I2C_CLASS_ALL;
>  	p_adap->dev.parent = &pdev->dev;
>  
> +	setup_pin_mux(1, iface);

You must check the error code and handle it.

> +
>  	rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
>  		IRQF_DISABLED, pdev->name, iface);
>  	if (rc) {
> @@ -701,6 +724,7 @@ static int i2c_bfin_twi_remove(struct platform_device *pdev)
>  
>  	i2c_del_adapter(&(iface->adap));
>  	free_irq(iface->irq, iface);
> +	setup_pin_mux(0, iface);

If you do this here, then you should also do it in the error path in
i2c_bfin_twi_probe().

>  
>  	return 0;
>  }


-- 
Jean Delvare
