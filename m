Return-Path: <linux-kernel-owner+w=401wt.eu-S932719AbXCFHTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbXCFHTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932722AbXCFHTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:19:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53738 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719AbXCFHTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:19:13 -0500
Date: Mon, 5 Mar 2007 23:18:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: bryan.wu@analog.com
Cc: khali@linux-fr.org, linux-kernel@vger.kernel.org, mhfan@ustc.edu
Subject: Re: [PATCH -mm] Blackfin: blackfin i2c driver
Message-Id: <20070305231846.d4a31502.akpm@linux-foundation.org>
In-Reply-To: <1173164058.31825.16.camel@roc-desktop>
References: <1173164058.31825.16.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Mar 2007 14:54:18 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:

> Hi folks, 
> 
> [PATCH] Blackfin: blackfin i2c driver
> 
> The i2c linux driver for blackfin architecture which supports both GPIO
> i2c operation and blackfin on-chip TWI controller i2c operation.
> 

Little things...

> +static int __init i2c_hhbf_init(void)
> +{
> +
> +    if(gpio_request(CONFIG_BFIN_SCL, NULL)) {
> +    	printk(KERN_ERR "%s: gpio_request GPIO %d failed \n",__FUNCTION__, CONFIG_BFIN_SCL);
> +	return -1;
> +	}
> +
> +    if(gpio_request(CONFIG_BFIN_SDA, NULL)) {
> +    	printk(KERN_ERR "%s: gpio_request GPIO %d failed \n",__FUNCTION__, CONFIG_BFIN_SDA);
> +	return -1;
> +	}

whitespace breakage there

> +
> +    gpio_direction_output(CONFIG_BFIN_SCL);
> +    gpio_direction_input(CONFIG_BFIN_SDA);
> +    gpio_set_value(CONFIG_BFIN_SCL, 1);    
> +
> +    return i2c_bit_add_bus(&hhbf_ops);
> +}
> +
> +#define TWI_I2C_MODE_COMBINED		0x04
> +
> +struct bfin_twi_iface
> +{

	struct bfin_twi_iface {

> +	struct semaphore 	twi_lock;

Can this be converted to a mutex?

> +	int			irq;
> +	spinlock_t		lock;
> + */
>
> ...
>
> +static int bfin_twi_master_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
> +{
> +	struct bfin_twi_iface* iface = (struct bfin_twi_iface*)adap->algo_data;

This code has zillions of unneeded casts of void*

> +	struct i2c_msg *pmsg;
> +	int i, ret;
> +	int rc = 0;
> +
> +	if (!(bfin_read_TWI_CONTROL() & TWI_ENA))
> +		return -ENXIO;
> +
> +	down(&iface->twi_lock);
> +
> +	while (bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
> +		up(&iface->twi_lock);
> +		schedule();
> +		down(&iface->twi_lock);
> +	}

That's a busy loop until this task's timeslice has expired.  It'll work,
but it'll suck a bit.  (Repeated in several places)

> +	ret = 0;
> +	for (i = 0; rc >= 0 && i < num;) {
> +		pmsg = &msgs[i++];

Strange.  Why not do the i++ in the `for' statement?

> +		if (pmsg->flags & I2C_M_TEN) {
> +			printk(KERN_ERR "i2c-bfin-twi: 10 bits addr not supported !\n");
> +			rc = -EINVAL;
> +			break;
> +		}
> +
>
> ...
>
> +	switch (iface->cur_mode) {
> +	case TWI_I2C_MODE_STANDARDSUB:
> +		bfin_write_TWI_XMT_DATA8(iface->command);
> +		bfin_write_TWI_INT_MASK(MCOMP | MERR | ((iface->read_write == I2C_SMBUS_READ) ? RCVSERV : XMTSERV));

It's preferred if code is readable in an 80-col display.

> +		SSYNC();
> +
> +		if (iface->writeNum + 1 <= 255)
> +			bfin_write_TWI_MASTER_CTL(((iface->writeNum+1) << 6));

