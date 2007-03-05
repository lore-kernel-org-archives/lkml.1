Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbXCEKVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbXCEKVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbXCEKVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:21:11 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40055 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282AbXCEKVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:21:08 -0500
Date: Mon, 5 Mar 2007 02:17:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marc St-Jean <stjeanma@pmc-sierra.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] drivers: PMC MSP71xx LED driver
Message-Id: <20070305021741.b3e3ee5f.akpm@linux-foundation.org>
In-Reply-To: <200702262348.l1QNmtBV015237@pasqua.pmc-sierra.bc.ca>
References: <200702262348.l1QNmtBV015237@pasqua.pmc-sierra.bc.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 26 Feb 2007 17:48:55 -0600 Marc St-Jean <stjeanma@pmc-sierra.com> wrote:
> [PATCH] drivers: PMC MSP71xx LED driver
> 
> Patch to add LED driver for the PMC-Sierra MSP71xx devices.
> 
> This patch references some platform support files previously
> submitted to the linux-mips@linux-mips.org list.
> 
> Thanks,
> @@ -0,0 +1,464 @@
> +/*
> +    Special LED-over-TWI-PCA9554 driver for PMC Sierra's Garibaldi
> +    (and potentially other) boards
> +
> +    Based on pca9539.c Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; version 2 of the License.
> +*/
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/kthread.h>
> +#include <linux/i2c.h>
> +
> +#include <msp_led_macros.h>
> +
> +#define POLL_PERIOD msecs_to_jiffies(125) /* Poll at 125ms */
> +
> +/* The externally available "registers" */
> +/* TODO: We must somehow ensure these are in "shared memory" for the other VPE
> + *       to access */
> +u32 _msp_led_register[MSP_LED_COUNT];
> +
> +/* Internal polling data */
> +static struct i2c_client *pmctwiled_device[MSP_LED_NUM_DEVICES];
> +static int pmctwiled_running;
> +static struct task_struct *pmctwiled_pollthread;
> +static u32 private_msp_led_register[MSP_LED_COUNT];
> +static u16 current_period;
> +
> +/* Addresses to scan */
> +#define PMCTWILED_BASEADDRESS	(0x38)
> +
> +static unsigned short normal_i2c[] = {
> +	PMCTWILED_BASEADDRESS + 0,
> +	PMCTWILED_BASEADDRESS + 1,
> +	PMCTWILED_BASEADDRESS + 2,
> +	PMCTWILED_BASEADDRESS + 3,
> +	PMCTWILED_BASEADDRESS + 4,
> +	I2C_CLIENT_END
> +};
> +
> +/* Insmod parameters */
> +I2C_CLIENT_INSMOD_1(pmctwiled);
> +
> +enum pca9554_cmd {
> +	PCA9554_INPUT		= 0,
> +	PCA9554_OUTPUT		= 1,
> +	PCA9554_INVERT		= 2,
> +	PCA9554_DIRECTION	= 3,
> +};
> +
> +static int pmctwiled_attach_adapter(struct i2c_adapter *adapter);
> +static int pmctwiled_detect(struct i2c_adapter *adapter, int address, int kind);
> +static int pmctwiled_detach_client(struct i2c_client *client);
> +
> +/* This is the driver that will be inserted */
> +static struct i2c_driver pmctwiled_driver = {
> +	.driver = {
> +		.name		= "pmctwiled",
> +	},
> +	.attach_adapter	= pmctwiled_attach_adapter,
> +	.detach_client	= pmctwiled_detach_client,
> +};
> +
> +struct pmctwiled_data {
> +	struct i2c_client client;
> +};
> +
> +static int pmctwiled_attach_adapter( struct i2c_adapter *adapter )
> +{
> +	return i2c_probe(adapter, &addr_data, pmctwiled_detect);
> +}
> +
> +/* This function is called by i2c_probe */
> +static int pmctwiled_detect( struct i2c_adapter *adapter, int address, int kind )
> +{
> +	struct i2c_client *new_client = NULL;	/* client structure */
> +	struct pmctwiled_data *data = NULL;		/* local data structure */
> +	int err = 0;
> +	int devId = address - PMCTWILED_BASEADDRESS;
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +		goto exit;
> +
> +	/* OK. For now, we presume we have a valid client. We now create the
> +	   client structure, even though we cannot fill it completely yet. */
> +	if (!(data = kzalloc(sizeof(struct pmctwiled_data), GFP_KERNEL))) {

It is more robust to use kzalloc(sizeof(*data), ...) here.

> +		err = -ENOMEM;
> +		goto exit;
> +	}
> +	memset (data, 0x00, sizeof(*data));

As you did here.

This memset is unneeded.

> +	new_client = &data->client;
> +	i2c_set_clientdata(new_client, data);
> +	new_client->addr = address;
> +	new_client->adapter = adapter;
> +	new_client->driver = &pmctwiled_driver;
> +	new_client->flags = 0;
> +
> +	/* Detection:
> +	 *   The pca9554 only has 4 registers (0-3).
> +	 * All other reads should fail
> +	 */
> +	if( i2c_smbus_read_byte_data(new_client, 3) < 0
> +	 || i2c_smbus_read_byte_data(new_client, 4) >= 0 )

Previous coding style comments apply.

> +		goto exit_kfree;
> +
> +	/* Found PCA9554 (probably) */
> +	strlcpy(new_client->name, "pca9554", I2C_NAME_SIZE);
> +	printk( "Detected PCA9554 I/O chip (device %d) at 0x%02x\n",
> +			devId, address);
> +
> +	/* Tell the I2C layer a new client has arrived */
> +	if ((err = i2c_attach_client(new_client)))
> +		goto exit_kfree;
> +
> +	/* Register this in the list of available devices, and set up the
> +	 * initial state */
> +	i2c_smbus_write_byte_data( new_client, PCA9554_OUTPUT,
> +		i2c_smbus_read_byte_data(new_client, PCA9554_INPUT) );
> +	i2c_smbus_write_byte_data( new_client, PCA9554_DIRECTION,
> +			(u8)mspLedInitialInputState[devId] );
> +	pmctwiled_device[devId] = new_client;
> +	
> +	return 0;
> +
> +exit_kfree:
> +	kfree(data);
> +exit:
> +	return err;
> +}
> +
> +static int pmctwiled_detach_client( struct i2c_client *client )
> +{
> +	int err;
> +	int devId = client->addr - PMCTWILED_BASEADDRESS;
> +
> +	/* Clear reference so poll thread doesn't use while detaching */
> +	pmctwiled_device[devId] = NULL;
> +
> +	/* Remove this device from the list of devices */
> +	if ((err = i2c_detach_client(client)))
> +		return err;

Please avoid compounding operations in this manner.  We prefer

	err = i2c_detach_client(client);
	if (err)
		return err;

> +	kfree(i2c_get_clientdata(client));
> +	
> +	return 0;
> +}
>
> ...
>
> +inline void mode_bits_update( u32 *ledRegPtr, msp_led_mode_t mode )
> +{
> +	/* TODO: validate mode*/
> +	*ledRegPtr |= MSP_LED_MODE_MASK;
> +	*ledRegPtr &= (~((u32) MSP_LED_MODE_MASK) | mode);
> +}

Lose the StudlyCaps.   led_reg_ptr here.

> +/**
> + * sync_led_timer_with_polling_count - Synchronizes the led timer with polling thread
> + * 									   count
> + * @ledId: Index for the private led register used to obtain timer information
> + * @ledRegPtr: Pointer to the new led register value
> + *  
> + * returns 0: If led is in its final period
> + * returns 1: If led is in its initial period
> + * 
> + * This function determines if the led timer is in its initial period or the final, 
> + * relative to the TWI-polling thread count (current_period) and updates the previous
> + * timer value in the private led register.  If the state of the led needs to be
> + * turned off (i.e. when the led has timed out) then the mode bits in the current led 
> + * register pointer is set to MSP_LED_OFF and the other data bits are set to 0.         

This comment looks awful in an 80-column display.

> + **/
> +inline int sync_led_timer_with_polling_count( int ledId, u32 *ledRegPtr )

This non-static inline function will cause two copies to be generated: one
in the caller in this C file, one for external callers.

It's too large to inline: delete the `inline' keyword.

> +{
> +	/* Timer variables */
> +	int isInInitialPeriod = 0;
> +	u8 timer, ledTimeOut,initialPeriod, finalPeriod;
> +	u16 totalPeriod;

No StudlyCaps, please.

> +	/* determine the progress into the current cycle, relative to the POLL_PERIOD */
> +	initialPeriod = (u8)(*ledRegPtr >> MSP_LED_INITIALPERIOD_SHIFT);
> +	finalPeriod = (u8)(*ledRegPtr >> MSP_LED_FINALPERIOD_SHIFT);
> +	ledTimeOut = (u8)(*ledRegPtr >> MSP_LED_WATCHDOG_SHIFT);
> +	timer = (u8)(private_msp_led_register[ledId] >> MSP_LED_WATCHDOG_SHIFT);

I assume all these (u8) casts are unneeded.

> +	totalPeriod = (u16)initialPeriod + (u16)finalPeriod;

And here.

> +	if (totalPeriod != 0) {
> +		isInInitialPeriod = (current_period % totalPeriod) < initialPeriod;
> +	}
> +
> +	/* if the ledTimeOut is set, adjust the current state to be either ON or OFF */
> +	if (ledTimeOut > 0) {
> +		if (timer >= ledTimeOut) {
> +			/* set the register to OFF state */
> +			mode_bits_update(ledRegPtr,MSP_LED_OFF);
> +			timer = 0;
> +			
> +			/*
> +			 * TODO:
> +			 * This introduces a race condition with other thread using
> +			 * shared memory and must be fixed.
> +			 */
> +			msp_led_turn_off(ledId);
> +		}
> +		else {
> +			timer += 1;
> +		}
> +		/* update timer */
> +		*ledRegPtr &= ~(0xff << MSP_LED_WATCHDOG_SHIFT);
> +		*ledRegPtr |= (timer << MSP_LED_WATCHDOG_SHIFT);
> +	}
> +	
> +	return isInInitialPeriod;
> +}
> +
> +/**
> + * led_update - Sets the mode bits of the given led register
> + * @ledId - id pertaining to the led that needs update
> + * @prevDirectionBitsPtr - points to the previous direction bits on the bus
> + * @prevDataBitsPtr - points to the previous data bits on the bus
> + * @currDirectionBitsPtr - points to the new direction bits for bus update
> + * @currDataBitsPtr - points to the new data bits for bus update
> + * 
> + * returns 1 - led is in output mode
> + *         0 - led is in input mode and hasn't been updated
> + * 
> + * Sets the given mode value to the given led register.
> + **/
> +inline int led_update( int ledId, u8 *prevDirectionBitsPtr, u8 *prevDataBitsPtr, 
> +						u8 *currDirectionBitsPtr, u8 *currDataBitsPtr )

80-cols.

Remove inline.

> +	u32 currLedReg;
> +	msp_led_mode_t currMode, prevMode;
> +	msp_led_direction_t currDirection, prevDirection;
> +	int isInInitialPeriod;
> +	
> +	/* Read the shared memory into a temporary variable */
> +	int pin = ledId % MSP_LED_NUM_DEVICE_PINS;
> +	currLedReg = _msp_led_register[ledId];
> +				
> +	/* Check if the input direction has changed to output */
> +	prevDirection = (msp_led_direction_t)
> +				((private_msp_led_register[ledId] & MSP_LED_DIRECTION_MASK) >> 
> +				   MSP_LED_DIRECTION_SHIFT);
> +	currDirection = (msp_led_direction_t)
> +				((currLedReg & MSP_LED_DIRECTION_MASK) >>
> +				   MSP_LED_DIRECTION_SHIFT);
> +	if ((prevDirection == MSP_LED_INPUT) && (currDirection != MSP_LED_OUTPUT))
> +		return 0;
> +
> +	/* get the previous mode of the LED */
> +	prevMode = (msp_led_mode_t)(private_msp_led_register[ledId] & MSP_LED_MODE_MASK);
> +
> +	if (prevMode == MSP_LED_ON)
> +		*prevDataBitsPtr |= (1 << pin);
> +
> +	if (prevDirection == MSP_LED_INPUT)
> +		*prevDirectionBitsPtr |= (1 << pin);
> +
> +
> +	/* Update timer and obtain the current period */
> +	isInInitialPeriod = sync_led_timer_with_polling_count(ledId, &currLedReg);
> +
> +	/* get the current mode of the LED */
> +	currMode = (msp_led_mode_t)(currLedReg & MSP_LED_MODE_MASK);
> +
> +	switch (currMode) {
> +		case MSP_LED_BLINK:
> +			if (isInInitialPeriod) {
> +				*currDataBitsPtr |= (1 << pin);
> +				mode_bits_update(&currLedReg, MSP_LED_ON);
> +			} else {
> +				mode_bits_update(&currLedReg,MSP_LED_OFF);
> +			}
> +			break;
> +		case MSP_LED_BLINK_INVERT:
> +			if (!isInInitialPeriod) {
> +				*currDataBitsPtr |= (1 << pin);
> +				mode_bits_update(&currLedReg, MSP_LED_ON);
> +			} else {
> +				mode_bits_update(&currLedReg,MSP_LED_OFF);
> +
> +			}
> +			break;
> +		case MSP_LED_OFF:
> +			/* Assuming that the led be turned off when set to output mode */
> +			break;
> +		case MSP_LED_ON:
> +			*currDataBitsPtr |= (1 << pin);
> +			break;
> +	}

Indent the switch body one tabstop to the left.

> +	if (currDirection == MSP_LED_INPUT)
> +		*currDirectionBitsPtr |= (1 << pin);
> +
> +	/* save the current mode */
> +	private_msp_led_register[ledId] = currLedReg;
> +	
> +	return 1;
> +}
> +
> +/**
> + * device_update - Updates led device(s) on GPIO
> + * @devId - id pertaining to the device that needs update
> + * 
> + * returns 1 - device exists
> + * 		   0 - device does not exist 
> + * 
> + * Every pin connected to the GPIO is updated if the state of the pin has changed
> + * from its previous value stored in the memory register.  A temporary variable,
> + * currLedReg is used to store the current value of the register corresponding to
> + * the pin under focus.  curLedReg gets its value from the global shared memory 
> + * registers for leds.  This value is compared with the previous value to determine
> + * if a change to the led pin is required.  The previous values are stored in the
> + * private led register, private_msp_led_register.
> + * 
> + **/
> +inline int device_update( int devId )

Coding-style, StudlyCaps, remove inline

> +{
> +	int pin;
> +	u8 currDirectionBits, currDataBits, prevDataBits, prevDirectionBits;
> +	currDirectionBits = currDataBits = prevDataBits = prevDirectionBits = 0;

The unneeded initialisations here are just to suppress the incorrect gcc
warning, yes?

If so, that should at least be comented.  And try to avoid declarations o
this form as well as multiple assignments.  So you want:

	u8 curr_direction_bits = 0;	/* Suppress gcc warning */
	u8 curr_data_bits = 0;		/* Suppress gcc warning */
	u8 prev_data_bits = 0;		/* Suppress gcc warning */
	u8 prev_direction_bits = 0;	/* Suppress gcc warning */

the initialisation does cause extra ode to be generated and we usually just
let te warning come out.  I think later gcc's fixed it.

> +	/* if the device wasn't detected */
> +	if (pmctwiled_device[devId] == NULL)
> +		return 0;					
> +
> +	/* iterate through each pin of the device and update register as necessary */
> +	for (pin=0; pin < MSP_LED_NUM_DEVICE_PINS; pin++) {

Put a space either side of '='

> +		int ledId = MSP_LED_DEVPIN(devId, pin);	
> +		led_update(ledId, &prevDirectionBits, &prevDataBits,
> +					&currDirectionBits, &currDataBits);
> +	}
> +	
> +	/* BUS OPERATIONS: if the previous state is different from the current state */
> +	if (currDataBits != prevDataBits) {
> +		i2c_smbus_write_byte_data(
> +			pmctwiled_device[devId], PCA9554_OUTPUT,
> +			~(currDataBits) );
> +	}
> +	if (currDirectionBits != prevDirectionBits) {
> +		i2c_smbus_write_byte_data(
> +			pmctwiled_device[devId], PCA9554_DIRECTION,
> +			currDirectionBits );
> +	}
> +	
> +	return 1;
> +} 
> +
> +static int pmctwiled_poll( void *data )
> +{
> +	pmctwiled_running = 1;
> +	current_period = 0;
> +	
> +	/* start the polling loop */
> +	while( pmctwiled_running ) {
> +		/* Starting Time */
> +		unsigned long pollEnd;
> +		unsigned long timeLeft;
> +		unsigned int pollStart = jiffies;
> +		
> +		/* update every device in here for the current period */
> +		int devId;
> +		for (devId = 0; devId < MSP_LED_NUM_DEVICES; devId++)
> +			device_update(devId);
> +		
> +		/* Ending Time */
> +		pollEnd = jiffies;
> +		if (pollEnd >= pollStart) {
> +			timeLeft = POLL_PERIOD - (pollEnd - pollStart);
> +		} else {
> +			timeLeft = POLL_PERIOD - ((0xffffffff - pollStart) + pollEnd);
> +			printk( "Warning: Delaying for %lu jiffies.  This may not be correct because of clock wrapping\n", timeLeft );
> +		}
> +		if (timeLeft > POLL_PERIOD) {
> +			printk( "Warning: Delay of %lu jiffies requested, defaulting back to %lu\n", timeLeft, POLL_PERIOD );
> +			timeLeft = POLL_PERIOD;
> +		}
> +		
> +		/* reshedule next polling interval */
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		schedule_timeout(timeLeft);
> +		current_period++;
> +	}
> +
> +	return 0;
> +}

Remove pmctwiled_running, use kthread_should_stop()

> +void __init pmctwiled_setup(void)
> +{
> +	static int called;
> +	int dev;
> +
> +	/* check if already initialized */
> +	if( called )
> +		return;

This cannot happen (can it?)

> +	/* initialize LEDs to default state */
> +	for( dev = 0; dev < MSP_LED_NUM_DEVICES; dev++ ) {
> +		int pin;
> +		pmctwiled_device[dev] = NULL;
> +		
> +		for( pin = 0; pin < 8; pin++ ) {
> +			int led = MSP_LED_DEVPIN(dev,pin);
> +			if (mspLedInitialInputState[dev] & (1 << pin)) {				
> +				msp_led_disable(led);
> +			} else {
> +				msp_led_enable(led);
> +				if (mspLedInitialPinState[dev] & (1 << pin))									
> +					msp_led_turn_on(led);				
> +				else			
> +					msp_led_turn_off(led);
> +			}
> +			
> +			/* Initialize the private led register memory */
> +			private_msp_led_register[led] = 0;
> +		}
> +	}
> +	
> +	/* indicate initialised */
> +	called++;
> +}
>
>
> +++ b/include/asm-mips/pmc-sierra/msp71xx/msp_led_macros.h
> @@ -0,0 +1,282 @@
> +/*
> + * $Id: msp_led_macros.h,v 1.3 2006/12/18 18:16:19 stjeanma Exp $

Please remove all CVS IDs from all patches.  Once this code hits mainline
they become meaningless.

> +static const u8 mspLedInitialInputState[] = {
> +	/* No outputs on device 0 or 1, these are inputs only */
> +	MSP_LED_INPUT_MODE, MSP_LED_INPUT_MODE,
> +	/* All outputs on device 2 through 4 */
> +	MSP_LED_OUTPUT_MODE, MSP_LED_OUTPUT_MODE, MSP_LED_OUTPUT_MODE,
> +};
> +
> +/* For each device, which output pins should start on and off:
> + * One byte per device:
> + *  0 = OFF = HI
> + *  1 = ON  = Lo
> + */
> +static const u8 mspLedInitialPinState[] = {
> +	0, 0, 	/* No initial state, these are input only */
> +	(1 << 1),	/* PWR_GREEN LED on, all others off */
> +	0,	/* All off */
> +	0,	/* All off */
> +};

Move these into a .c file.

> +typedef enum {
> +	MSP_LED_INPUT = 0,
> +	MSP_LED_OUTPUT,
> +} msp_led_direction_t;

No typedefs, please.   Convert this to

enum msp_led_direction {
	...
};

> +/* Output modes */
> +typedef enum {
> +	MSP_LED_OFF = 0,		/* Off steady */
> +	MSP_LED_ON,				/* On steady */
> +	MSP_LED_BLINK,			/* On for initialPeriod, off for finalPeriod */
> +	MSP_LED_BLINK_INVERT,	/* Off for initialPeriod, on for finalPeriod */
> +} msp_led_mode_t;

Ditto.

> +/* For non-LED pins, these macros set HI and LO accordingly */
> +#define msp_led_pin_hi	msp_led_turn_off
> +#define msp_led_pin_lo	msp_led_turn_on

eww.

static inline wrapper functions are preferred.  Write code in C, not cpp
where possible.


