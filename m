Return-Path: <linux-kernel-owner+w=401wt.eu-S1751366AbXCFVm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbXCFVm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXCFVm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:42:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:11332 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbXCFVmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:42:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=aD9nEMBlTTQZw9jIeuK4Nq8Qp4+hYrEwJWJ1tGnHTlTZ51MXdiutF+g9BWA/9QnnIVqe57fyIVMY47MEYmw5Pf5TnW9KiwXKmvHP9gqeWqB8k0P97lL2e+leHjyBe4PONBZcqsXvTiD1/sm1rBeC5YIVnzzFhQa+MxzReZMtsc4=
Date: Wed, 7 Mar 2007 00:43:02 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Wu, Bryan" <bryan.wu@analog.com>
Cc: khali@linux-fr.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mhfan@ustc.edu
Subject: Re: [PATCH -mm] Blackfin: blackfin i2c driver
Message-ID: <20070306214301.GA5590@martell.zuzino.mipt.ru>
References: <1173164058.31825.16.camel@roc-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173164058.31825.16.camel@roc-desktop>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 02:54:18PM +0800, Wu, Bryan wrote:
> [PATCH] Blackfin: blackfin i2c driver
>
> The i2c linux driver for blackfin architecture which supports both GPIO
> i2c operation and blackfin on-chip TWI controller i2c operation.

> +config TWICLK_KHZ
> +	int "TWI clock (kHZ)"
> +	depends on I2C_BFIN_TWI
> +	default 50
> +	help
> +		The unit of the TWI clock is kilo HZ. Please divide the clock 
> +		by 1024 if you count it in HZ. The value should be less than 400.

Indentation in Kconfig files is Tab-Space-Space.

> --- /dev/null
> +++ linux-2.6/drivers/i2c/busses/i2c-bfin-gpio.c

> +static int __init i2c_hhbf_init(void)
> +{
> +
> +    if(gpio_request(CONFIG_BFIN_SCL, NULL)) {
> +    	printk(KERN_ERR "%s: gpio_request GPIO %d failed \n",__FUNCTION__, CONFIG_BFIN_SCL);

I may be first to ask this, but, please, use __func__ in all new code.
__FUNCTION__ is gcc-2.95-ism, which is no longer supported.

> +	return -1;
> +	}
> +
> +    if(gpio_request(CONFIG_BFIN_SDA, NULL)) {
> +    	printk(KERN_ERR "%s: gpio_request GPIO %d failed \n",__FUNCTION__, CONFIG_BFIN_SDA);

__func__, Do you need to gpio_free() ?

> +	return -1;
> +	}
> +
> +
> +    gpio_direction_output(CONFIG_BFIN_SCL);
> +    gpio_direction_input(CONFIG_BFIN_SDA);
> +    gpio_set_value(CONFIG_BFIN_SCL, 1);    
> +
> +    return i2c_bit_add_bus(&hhbf_ops);

Do you need unwinding with gpio_free() like below?

> +static void __exit i2c_hhbf_exit(void)
> +{
> +    gpio_free(CONFIG_BFIN_SCL);
> +    gpio_free(CONFIG_BFIN_SDA);    

trailing whitespace.

> +    i2c_bit_del_bus(&hhbf_ops);
> +}

> --- /dev/null
> +++ linux-2.6/drivers/i2c/busses/i2c-bfin-twi.c

> +static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
> +{
> +	unsigned short twi_int_stat = bfin_read_TWI_INT_STAT();
> +	unsigned short mast_stat = bfin_read_TWI_MASTER_STAT();
> +
> +	if (XMTSERV & twi_int_stat) {

Please, put bitmasks on the right. Much easier to read. See below for
other places.

	if (twi_int_stat & XMTSERV)

Also, I'd rename variable to twi_intr_status, to not confuse with
statistics or something.

> +		/* Transmit next data */
> +		if (iface->writeNum > 0) {
> +			bfin_write_TWI_XMT_DATA8(*(iface->transPtr++));
> +			iface->writeNum--;

StudlyCaps.

> +static int bfin_twi_master_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
> +{
> +	struct bfin_twi_iface* iface = (struct bfin_twi_iface*)adap->algo_data;
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

> +int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
> +			unsigned short flags, char read_write,
> +			u8 command, int size, union i2c_smbus_data * data)
> +{
> +	struct bfin_twi_iface* iface = (struct bfin_twi_iface*)adap->algo_data;
> +	int rc = 0;
> +
> +	if (!(bfin_read_TWI_CONTROL() & TWI_ENA))
> +		return -ENXIO;
> +
> +	down(&iface->twi_lock);
> +
> +	while(bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
> +		up(&iface->twi_lock);
> +		schedule();
> +		down(&iface->twi_lock);
> +	}

Smells like schedule() abuse for delays.

> +	switch (iface->cur_mode) {
> +	case TWI_I2C_MODE_STANDARDSUB:
> +		bfin_write_TWI_XMT_DATA8(iface->command);
> +		bfin_write_TWI_INT_MASK(MCOMP | MERR | ((iface->read_write == I2C_SMBUS_READ) ? RCVSERV : XMTSERV));
> +		SSYNC();
> +
> +		if (iface->writeNum + 1 <= 255)
> +			bfin_write_TWI_MASTER_CTL(((iface->writeNum+1) << 6));

Too many ():

			bfin_write_TWI_MASTER_CTL((iface->writeNum + 1) << 6);

> +		else {
> +			bfin_write_TWI_MASTER_CTL(( 0xff << 6 ));

ditto

> +			iface->manual_stop = 1;
> +		}
> +		/* Master enable */
> +		bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() | MEN | ((CONFIG_TWICLK_KHZ>100) ? FAST : 0));
> +		break;
> +	case TWI_I2C_MODE_COMBINED:
> +		bfin_write_TWI_XMT_DATA8(iface->command);
> +		bfin_write_TWI_INT_MASK(MCOMP | MERR | RCVSERV | XMTSERV);
> +		SSYNC();
> +
> +		if (iface->writeNum > 0)
> +			bfin_write_TWI_MASTER_CTL(((iface->writeNum+1) << 6));

ditto

> +		else
> +			bfin_write_TWI_MASTER_CTL(( 0x1 << 6 ));

ditto, etc

> +static int __init i2c_bfin_twi_init(void)
> +{

> +	rc = request_irq(twi_iface.irq, bfin_twi_interrupt_entry, SA_INTERRUPT, "i2c-bfin-twi", &twi_iface);
> +	if (rc) {
> +		printk(KERN_ERR "i2c-bfin-twi: can't get IRQ %d !\n", twi_iface.irq);
> +		return -ENODEV;
> +	}
> +
> +	/* Set TWI internal clock as 10MHz */
> +	bfin_write_TWI_CONTROL(((get_sclk() / 1024 / 1024 + 5) / 10) & 0x7F);
> +
> +	/* Set Twi interface clock as specified */
> +	if (CONFIG_TWICLK_KHZ > 400)
> +		bfin_write_TWI_CLKDIV((( 5*1024 / 400 ) << 8) | (( 5*1024 / 400 ) & 0xFF));
> +	else
> +		bfin_write_TWI_CLKDIV((( 5*1024 / CONFIG_TWICLK_KHZ ) << 8) | (( 5*1024 / CONFIG_TWICLK_KHZ ) & 0xFF));
> +
> +	/* Enable TWI */
> +	bfin_write_TWI_CONTROL(bfin_read_TWI_CONTROL() | TWI_ENA);
> +	SSYNC();
> +
> +	return i2c_add_adapter(p_adap);

free_irq on error?

