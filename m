Return-Path: <linux-kernel-owner+w=401wt.eu-S1750720AbXB0U3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750720AbXB0U3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbXB0U3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:29:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50508 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbXB0U3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:29:38 -0500
Date: Tue, 27 Feb 2007 12:26:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marc St-Jean <stjeanma@pmc-sierra.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] drivers: PMC MSP71xx GPIO char driver
Message-Id: <20070227122606.8ec3f09a.akpm@linux-foundation.org>
In-Reply-To: <200702232328.l1NNSJXr015186@pasqua.pmc-sierra.bc.ca>
References: <200702232328.l1NNSJXr015186@pasqua.pmc-sierra.bc.ca>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 23 Feb 2007 17:28:19 -0600 Marc St-Jean <stjeanma@pmc-sierra.com> wrote:
> [PATCH] drivers: PMC MSP71xx GPIO char driver
> 
> Patch to add a GPIO char driver for the PMC-Sierra
> MSP71xx devices.
> 
> This patch references some platform support files previously
> submitted to the linux-mips@linux-mips.org list.
> 

Comments:

> +static int msp_blink_running;

Could have type `bool'.

> +static DEFINE_SPINLOCK(msp_blink_lock);
> +static DECLARE_COMPLETION(msp_blink_wait);
> +
> +struct blinkTable_t {

a) It uses StudlyCaps

b) the _t suffix is used for typedefs.

I suggest this be renamed to `struct blink_table'.

> +	uint32_t count;
> +	uint32_t period;
> +	uint32_t dcycle;

u32 is preferred.

> +static uint32_t msp_gpio_read_data_extended(void)

everywhere...

> +{
> +	int pin;
> +	uint32_t tmp, retval = 0;
> +	
> +	tmp = *EXTENDED_GPIO_REG;
> +	for( pin = 0; pin < EXTENDED_GPIO_COUNT; pin++ ) {
> +		uint32_t bit = 0;
> +		/*
> +		 * In output mode, read CLR bit
> +		 * In input mode, read SET bit
> +		 */
> +		if( tmp & (EXTENDED_GPIO_CFG_ENABLE <<
> +					EXTENDED_GPIO_CFG_SHIFT(pin)) )

Please convert all the code to sue standard whitespace conventions:

	for (i = 0; i < n; i++) {

and

	if (foo && bar)

> +			bit = (EXTENDED_GPIO_DATA_CLR <<
> +					EXTENDED_GPIO_DATA_SHIFT(pin));

Uneeded parens.

> +			retval |= (1 << pin);

Ditto.

> +static int msp_gpio_ioctl( struct inode *inode, struct file *file,
> +		unsigned int cmd, unsigned long arg)
> +{
> +	static struct msp_gpio_ioctl_io_data data;
> +	static struct msp_gpio_ioctl_blink_data blink;
> +
> +	switch( cmd ) {

	switch (cmd) {

> +		case MSP_GPIO_BLINK:
> +			if( copy_from_user(&blink, (struct msp_gpio_ioctl_blink_data *)arg, sizeof(blink) ) )
> +				return -EFAULT;
> +			break;
> +		default:
> +			if( copy_from_user(&data, (struct msp_gpio_ioctl_io_data *)arg, sizeof(data) ) )
> +				return -EFAULT;
> +			break;

Please indent the body of the switch one tabstop less than this.

Please fit all the code into 80-cols.

> +	}
> +
> +	switch( cmd ) {
> +		case MSP_GPIO_IN:
> +			if( msp_gpio_in( &data.data, data.mask ) )

Lots of dittos here.

> +/* -- Module functions -- */
> +
> +static int msp_gpio_blinkthread( void *none )

Why is this a "module function"?

> +{
> +	int firstrun = 1;
> +	
> +	msp_blink_running = 1;
> +	while( msp_blink_running ) {
> +		uint32_t mask = 0, data = 0;
> +		int i, blinking = 0;
> +		spin_lock( &msp_blink_lock );
> +		for( i = 0; i < MSP_NUM_GPIOS; i++ ) {
> +			/* use blinkTable[i].period as 'blink enabled' test */
> +			if( blinkTable[i].period) {
> +				blinking = 1;
> +				mask |= MSP_GPIO_BIT(i);
> +				blinkTable[i].count++;
> +
> +				if( blinkTable[i].count >=
> +						blinkTable[i].period )
> +					blinkTable[i].count = 0;
> +
> +				if( blinkTable[i].count <
> +					(blinkTable[i].period *
> +					 blinkTable[i].dcycle / 100 ) )
> +					data |= MSP_GPIO_BIT(i);
> +			}
> +		}
> +		spin_unlock( &msp_blink_lock );
> +
> +		if( !firstrun || blinking )
> +			msp_gpio_write_data( data, mask );
> +		else
> +			firstrun = 0;
> +
> +		if( blinking ) {
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			schedule_timeout (HZ/100);

schedule_timeout_interruptible), or ssleep().

This kernel thread will probably break suspend.  I suspect a
try_to_freeze() is needed.

> +		} else {
> +			wait_for_completion_interruptible( &msp_blink_wait );
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int __init msp_gpio_init(void)
> +{
> +	if( misc_register(&msp_gpio_miscdev) ) {
> +		printk( "Device registration failed\n" );
> +		goto err_miscdev;
> +	}
> +
> +	msp_blinkthread = kthread_run( msp_gpio_blinkthread, NULL, "gpio_blink" );
> +	if( msp_blinkthread == NULL )
> +	{

	if (msp_blinkthread == NULL) {

> +		printk( "Could not start kthread\n" );
> +		goto err_blinkthread;
> +	}
> +
> +	printk( "MSP7120 GPIO subsystem initialized\n" );

Please give all the printks a facility level (KERN_INFO, etc)

> +	return 0;
> +
> +err_blinkthread:
> +	misc_deregister(&msp_gpio_miscdev);
> +err_miscdev:
> +	return -ENOMEM;
> +}
> +
> +static void __exit msp_gpio_exit(void)
> +{
> +	msp_blink_running = 0;
> +	complete( &msp_blink_wait );
> +	kthread_stop( msp_blinkthread );
> +
> +	misc_deregister(&msp_gpio_miscdev);
> +}

I think msp_blink_running can just be removed - use kthread_should_stop().

> +module_init(msp_gpio_init);
> +module_exit(msp_gpio_exit);
> +
> +EXPORT_SYMBOL(msp_gpio_in);
> +EXPORT_SYMBOL(msp_gpio_out);
> +EXPORT_SYMBOL(msp_gpio_mode);
> +EXPORT_SYMBOL(msp_gpio_blink);
> +EXPORT_SYMBOL(msp_gpio_noblink);

What uses these exports?

> +#include <msp_gpio_macros.h>
> +
> +/* IOCTL structs macros */
> +
> +struct msp_gpio_ioctl_io_data

	struct foo {

> +{
> +	uint32_t data;
> +	uint32_t mask;
> +};
> +
> +struct msp_gpio_ioctl_blink_data
> +{

Ditto.

> +	uint32_t mask;
> +	uint32_t period;
> +	uint32_t dcycle;
> +};
> +
> +#define MSP_GPIO_IOCTL_BASE	'Z'
> +
> +/* Reads the current data bits */
> +#define MSP_GPIO_IN		_IOWR(MSP_GPIO_IOCTL_BASE, 0, \
> +					struct msp_gpio_ioctl_io_data )

Remvove space before the )

> +
> +/* Writes data bits */
> +#define MSP_GPIO_OUT	_IOW (MSP_GPIO_IOCTL_BASE, 1, \
> +					struct msp_gpio_ioctl_io_data )
> +
> +/*
> + * Sets all masked pins to the msp_gpio_mode_t given in the data field
> + */
> +#define MSP_GPIO_MODE	_IOW (MSP_GPIO_IOCTL_BASE, 2, \
> +					struct msp_gpio_ioctl_io_data )

Dittoes.

> +/* 
> + * Starts any masked LEDs blinking with parameters as follows:
> + *   - period - The time in 100ths of a second for a single period
> + *              (set to '0' to stop blinking)
> + *   - dcycle - The 'duty cycle' - what percentage of the period should the
> + *              gpio be on?
> + */
> +#define MSP_GPIO_BLINK	_IOW (MSP_GPIO_IOCTL_BASE, 3, \
> +					struct msp_gpio_ioctl_blink_data )

And remove space before (

> +/* Bit flags and masks for GPIOs */
> +#define MSP_GPIO_BIT(gpio)	(1 << gpio)

This probably obscures more than it reveals.  Better to open-code it.

> +#define MSP_NUM_GPIOS		(20)
> +
> +#define MSP_GPIO_ALL_MASK 	((1<<MSP_NUM_GPIOS) - 1)
> +
> +#define MSP_GPIO_NONE_MASK 	(0LL)
> +
> +#define MSP_GPIO_FREE_MASK	MSP_GPIO_ALL_MASK
> +
> +/* The following is only available to other modules */
> +
> +#ifdef __KERNEL__
> +
> +/*
> + * Reads the bits specified by the mask and puts the values in data.
> + * May include output statuses also, if in mask.
> + *
> + * Returns 0 on success
> + */
> +extern int msp_gpio_in( uint32_t *data, uint32_t mask );

Busted whitespace, use u32

> +
> +/*
> + * Sets the specified data to the masked pins
> + *
> + * Returns 0 on success or one of the following:
> + *  -EINVAL if any of the pins in the mask are not free or not already in output
> + *  mode
> + */
> +extern int msp_gpio_out( uint32_t data, uint32_t mask );
> +
> +/*
> + * Sets all masked pins to the specified msp_gpio_mode_t
> + *
> + * Returns 0 on success or one of the following:
> + *  -EINVAL if any of the pins in the mask are not free, or if any pins are not
> + *  allowed to be set to the specified mode
> + */
> +extern int msp_gpio_mode( msp_gpio_mode_t mode, uint32_t mask );

It's more conventional to document functions in the .c file, using
kerneldoc format.

> +/*
> + * Stops the specified GPIOs from blinking
> + */
> +extern int msp_gpio_noblink( uint32_t mask );
> +
> +/*
> + * Configures GPIO(s) to blink
> + *  - mask shows which GPIOs to blink
> + *  - period is the time in 100ths of a second for the total period
> + *    (0 disables blinking)
> + *  - dcycle is the percentage of the period where the GPIO is HI
> + */
> +int msp_gpio_blink( uint32_t mask, uint32_t period, uint32_t dcycle );
> +
> +/* Special bitflags and whatnot for the driver's convenience */
> +#define GPIO_REG_COUNT		4
> +const uint32_t GPIO_DATA_COUNT[] = { 2, 4, 4, 6 };
> +const uint32_t GPIO_DATA_SHIFT[] = { 0, 2, 6, 10 };
> +const uint32_t GPIO_DATA_MASK[]  = { 0x03, 0x0f, 0x0f, 0x3f };
> +volatile uint32_t * const GPIO_DATA_REG[] = {
> +	GPIO_DATA1_REG, GPIO_DATA2_REG, GPIO_DATA3_REG, GPIO_DATA4_REG,
> +};
> +const uint32_t GPIO_CFG_MASK[]   = { 0x0000ff, 0x00ffff, 0x00ffff, 0xffffff };
> +volatile uint32_t * const GPIO_CFG_REG[] = {
> +	GPIO_CFG1_REG, GPIO_CFG2_REG, GPIO_CFG3_REG, GPIO_CFG4_REG,
> +};

This should all be moved from .h into .c.  As it is, if two .c files
include this header, we'll get additional copies of this data.  And a
linker error.

Please don't use volatile.  Kernel standard I/O operations (inb, readl,
etc) handle all this.


