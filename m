Return-Path: <linux-kernel-owner+w=401wt.eu-S1161425AbXBZXtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161425AbXBZXtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161424AbXBZXtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:49:05 -0500
Received: from father.pmc-sierra.com ([216.241.224.13]:37639 "HELO
	father.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161420AbXBZXtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:49:01 -0500
From: Marc St-Jean <stjeanma@pmc-sierra.com>
Date: Mon, 26 Feb 2007 17:48:55 -0600
Message-Id: <200702262348.l1QNmtBV015237@pasqua.pmc-sierra.bc.ca>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: PMC MSP71xx LED driver
Cc: linux-mips@linux-mips.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] drivers: PMC MSP71xx LED driver

Patch to add LED driver for the PMC-Sierra MSP71xx devices.

This patch references some platform support files previously
submitted to the linux-mips@linux-mips.org list.

Thanks,
Marc

Signed-off-by: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
---
 drivers/i2c/chips/Kconfig                            |    9 
 drivers/i2c/chips/Makefile                           |    1 
 drivers/i2c/chips/pmctwiled.c                        |  464 +++++++++++++++++++
 include/asm-mips/pmc-sierra/msp71xx/msp_led_macros.h |  282 +++++++++++
 4 files changed, 756 insertions(+)

diff --git a/drivers/i2c/chips/Kconfig b/drivers/i2c/chips/Kconfig
index 87ee3ce..3bef46b 100644
--- a/drivers/i2c/chips/Kconfig
+++ b/drivers/i2c/chips/Kconfig
@@ -50,6 +50,15 @@ config SENSORS_PCF8574
 	  These devices are hard to detect and rarely found on mainstream
 	  hardware.  If unsure, say N.
 
+config SENSORS_PMCTWILED
+	tristate "PMC Led-over-TWI driver"
+	depends on I2C && PMC_MSP
+	help
+	  The new VPE-safe backend driver for all the LEDs on the 7120 platform.
+
+	  While you may build this as a module, it is recommended you build it
+	  into the kernel monolithic so all drivers may access it at all times.
+
 config SENSORS_PCA9539
 	tristate "Philips PCA9539 16-bit I/O port"
 	depends on I2C && EXPERIMENTAL
diff --git a/drivers/i2c/chips/Makefile b/drivers/i2c/chips/Makefile
index 779868e..4e79e27 100644
--- a/drivers/i2c/chips/Makefile
+++ b/drivers/i2c/chips/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_SENSORS_M41T00)	+= m41t00.o
 obj-$(CONFIG_SENSORS_PCA9539)	+= pca9539.o
 obj-$(CONFIG_SENSORS_PCF8574)	+= pcf8574.o
 obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
+obj-$(CONFIG_SENSORS_PMCTWILED) += pmctwiled.o
 obj-$(CONFIG_ISP1301_OMAP)	+= isp1301_omap.o
 obj-$(CONFIG_TPS65010)		+= tps65010.o
 
diff --git a/drivers/i2c/chips/pmctwiled.c b/drivers/i2c/chips/pmctwiled.c
new file mode 100644
index 0000000..66de608
--- /dev/null
+++ b/drivers/i2c/chips/pmctwiled.c
@@ -0,0 +1,464 @@
+/*
+    Special LED-over-TWI-PCA9554 driver for PMC Sierra's Garibaldi
+    (and potentially other) boards
+
+    Based on pca9539.c Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; version 2 of the License.
+*/
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kthread.h>
+#include <linux/i2c.h>
+
+#include <msp_led_macros.h>
+
+#define POLL_PERIOD msecs_to_jiffies(125) /* Poll at 125ms */
+
+/* The externally available "registers" */
+/* TODO: We must somehow ensure these are in "shared memory" for the other VPE
+ *       to access */
+u32 _msp_led_register[MSP_LED_COUNT];
+
+/* Internal polling data */
+static struct i2c_client *pmctwiled_device[MSP_LED_NUM_DEVICES];
+static int pmctwiled_running;
+static struct task_struct *pmctwiled_pollthread;
+static u32 private_msp_led_register[MSP_LED_COUNT];
+static u16 current_period;
+
+/* Addresses to scan */
+#define PMCTWILED_BASEADDRESS	(0x38)
+
+static unsigned short normal_i2c[] = {
+	PMCTWILED_BASEADDRESS + 0,
+	PMCTWILED_BASEADDRESS + 1,
+	PMCTWILED_BASEADDRESS + 2,
+	PMCTWILED_BASEADDRESS + 3,
+	PMCTWILED_BASEADDRESS + 4,
+	I2C_CLIENT_END
+};
+
+/* Insmod parameters */
+I2C_CLIENT_INSMOD_1(pmctwiled);
+
+enum pca9554_cmd {
+	PCA9554_INPUT		= 0,
+	PCA9554_OUTPUT		= 1,
+	PCA9554_INVERT		= 2,
+	PCA9554_DIRECTION	= 3,
+};
+
+static int pmctwiled_attach_adapter(struct i2c_adapter *adapter);
+static int pmctwiled_detect(struct i2c_adapter *adapter, int address, int kind);
+static int pmctwiled_detach_client(struct i2c_client *client);
+
+/* This is the driver that will be inserted */
+static struct i2c_driver pmctwiled_driver = {
+	.driver = {
+		.name		= "pmctwiled",
+	},
+	.attach_adapter	= pmctwiled_attach_adapter,
+	.detach_client	= pmctwiled_detach_client,
+};
+
+struct pmctwiled_data {
+	struct i2c_client client;
+};
+
+static int pmctwiled_attach_adapter( struct i2c_adapter *adapter )
+{
+	return i2c_probe(adapter, &addr_data, pmctwiled_detect);
+}
+
+/* This function is called by i2c_probe */
+static int pmctwiled_detect( struct i2c_adapter *adapter, int address, int kind )
+{
+	struct i2c_client *new_client = NULL;	/* client structure */
+	struct pmctwiled_data *data = NULL;		/* local data structure */
+	int err = 0;
+	int devId = address - PMCTWILED_BASEADDRESS;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		goto exit;
+
+	/* OK. For now, we presume we have a valid client. We now create the
+	   client structure, even though we cannot fill it completely yet. */
+	if (!(data = kzalloc(sizeof(struct pmctwiled_data), GFP_KERNEL))) {
+		err = -ENOMEM;
+		goto exit;
+	}
+	memset (data, 0x00, sizeof(*data));
+	
+	new_client = &data->client;
+	i2c_set_clientdata(new_client, data);
+	new_client->addr = address;
+	new_client->adapter = adapter;
+	new_client->driver = &pmctwiled_driver;
+	new_client->flags = 0;
+
+	/* Detection:
+	 *   The pca9554 only has 4 registers (0-3).
+	 * All other reads should fail
+	 */
+	if( i2c_smbus_read_byte_data(new_client, 3) < 0
+	 || i2c_smbus_read_byte_data(new_client, 4) >= 0 )
+		goto exit_kfree;
+
+	/* Found PCA9554 (probably) */
+	strlcpy(new_client->name, "pca9554", I2C_NAME_SIZE);
+	printk( "Detected PCA9554 I/O chip (device %d) at 0x%02x\n",
+			devId, address);
+
+	/* Tell the I2C layer a new client has arrived */
+	if ((err = i2c_attach_client(new_client)))
+		goto exit_kfree;
+
+	/* Register this in the list of available devices, and set up the
+	 * initial state */
+	i2c_smbus_write_byte_data( new_client, PCA9554_OUTPUT,
+		i2c_smbus_read_byte_data(new_client, PCA9554_INPUT) );
+	i2c_smbus_write_byte_data( new_client, PCA9554_DIRECTION,
+			(u8)mspLedInitialInputState[devId] );
+	pmctwiled_device[devId] = new_client;
+	
+	return 0;
+
+exit_kfree:
+	kfree(data);
+exit:
+	return err;
+}
+
+static int pmctwiled_detach_client( struct i2c_client *client )
+{
+	int err;
+	int devId = client->addr - PMCTWILED_BASEADDRESS;
+
+	/* Clear reference so poll thread doesn't use while detaching */
+	pmctwiled_device[devId] = NULL;
+
+	/* Remove this device from the list of devices */
+	if ((err = i2c_detach_client(client)))
+		return err;
+
+	kfree(i2c_get_clientdata(client));
+	
+	return 0;
+}
+
+/**
+ * mode_bits_update - Sets the mode bits of the given led register
+ * @ledRegPtr: Pointer to the led register value that needs to be updated with
+ * 				   the given mode.
+ * @mode: new mode value to be set to the register
+ *
+ * Sets the given mode value to the given led register.
+ **/
+inline void mode_bits_update( u32 *ledRegPtr, msp_led_mode_t mode )
+{
+	/* TODO: validate mode*/
+	*ledRegPtr |= MSP_LED_MODE_MASK;
+	*ledRegPtr &= (~((u32) MSP_LED_MODE_MASK) | mode);
+}
+
+/**
+ * sync_led_timer_with_polling_count - Synchronizes the led timer with polling thread
+ * 									   count
+ * @ledId: Index for the private led register used to obtain timer information
+ * @ledRegPtr: Pointer to the new led register value
+ *  
+ * returns 0: If led is in its final period
+ * returns 1: If led is in its initial period
+ * 
+ * This function determines if the led timer is in its initial period or the final, 
+ * relative to the TWI-polling thread count (current_period) and updates the previous
+ * timer value in the private led register.  If the state of the led needs to be
+ * turned off (i.e. when the led has timed out) then the mode bits in the current led 
+ * register pointer is set to MSP_LED_OFF and the other data bits are set to 0.         
+ * 
+ **/
+inline int sync_led_timer_with_polling_count( int ledId, u32 *ledRegPtr )
+{
+	/* Timer variables */
+	int isInInitialPeriod = 0;
+	u8 timer, ledTimeOut,initialPeriod, finalPeriod;
+	u16 totalPeriod;
+
+	/* determine the progress into the current cycle, relative to the POLL_PERIOD */
+	initialPeriod = (u8)(*ledRegPtr >> MSP_LED_INITIALPERIOD_SHIFT);
+	finalPeriod = (u8)(*ledRegPtr >> MSP_LED_FINALPERIOD_SHIFT);
+	ledTimeOut = (u8)(*ledRegPtr >> MSP_LED_WATCHDOG_SHIFT);
+	timer = (u8)(private_msp_led_register[ledId] >> MSP_LED_WATCHDOG_SHIFT);
+
+	totalPeriod = (u16)initialPeriod + (u16)finalPeriod;
+	if (totalPeriod != 0) {
+		isInInitialPeriod = (current_period % totalPeriod) < initialPeriod;
+	}
+
+	/* if the ledTimeOut is set, adjust the current state to be either ON or OFF */
+	if (ledTimeOut > 0) {
+		if (timer >= ledTimeOut) {
+			/* set the register to OFF state */
+			mode_bits_update(ledRegPtr,MSP_LED_OFF);
+			timer = 0;
+			
+			/*
+			 * TODO:
+			 * This introduces a race condition with other thread using
+			 * shared memory and must be fixed.
+			 */
+			msp_led_turn_off(ledId);
+		}
+		else {
+			timer += 1;
+		}
+		/* update timer */
+		*ledRegPtr &= ~(0xff << MSP_LED_WATCHDOG_SHIFT);
+		*ledRegPtr |= (timer << MSP_LED_WATCHDOG_SHIFT);
+	}
+	
+	return isInInitialPeriod;
+}
+
+/**
+ * led_update - Sets the mode bits of the given led register
+ * @ledId - id pertaining to the led that needs update
+ * @prevDirectionBitsPtr - points to the previous direction bits on the bus
+ * @prevDataBitsPtr - points to the previous data bits on the bus
+ * @currDirectionBitsPtr - points to the new direction bits for bus update
+ * @currDataBitsPtr - points to the new data bits for bus update
+ * 
+ * returns 1 - led is in output mode
+ *         0 - led is in input mode and hasn't been updated
+ * 
+ * Sets the given mode value to the given led register.
+ **/
+inline int led_update( int ledId, u8 *prevDirectionBitsPtr, u8 *prevDataBitsPtr, 
+						u8 *currDirectionBitsPtr, u8 *currDataBitsPtr )
+{
+	u32 currLedReg;
+	msp_led_mode_t currMode, prevMode;
+	msp_led_direction_t currDirection, prevDirection;
+	int isInInitialPeriod;
+	
+	/* Read the shared memory into a temporary variable */
+	int pin = ledId % MSP_LED_NUM_DEVICE_PINS;
+	currLedReg = _msp_led_register[ledId];
+				
+	/* Check if the input direction has changed to output */
+	prevDirection = (msp_led_direction_t)
+				((private_msp_led_register[ledId] & MSP_LED_DIRECTION_MASK) >> 
+				   MSP_LED_DIRECTION_SHIFT);
+	currDirection = (msp_led_direction_t)
+				((currLedReg & MSP_LED_DIRECTION_MASK) >>
+				   MSP_LED_DIRECTION_SHIFT);
+	if ((prevDirection == MSP_LED_INPUT) && (currDirection != MSP_LED_OUTPUT))
+		return 0;
+
+	/* get the previous mode of the LED */
+	prevMode = (msp_led_mode_t)(private_msp_led_register[ledId] & MSP_LED_MODE_MASK);
+
+	if (prevMode == MSP_LED_ON)
+		*prevDataBitsPtr |= (1 << pin);
+
+	if (prevDirection == MSP_LED_INPUT)
+		*prevDirectionBitsPtr |= (1 << pin);
+
+
+	/* Update timer and obtain the current period */
+	isInInitialPeriod = sync_led_timer_with_polling_count(ledId, &currLedReg);
+
+	/* get the current mode of the LED */
+	currMode = (msp_led_mode_t)(currLedReg & MSP_LED_MODE_MASK);
+
+	switch (currMode) {
+		case MSP_LED_BLINK:
+			if (isInInitialPeriod) {
+				*currDataBitsPtr |= (1 << pin);
+				mode_bits_update(&currLedReg, MSP_LED_ON);
+			} else {
+				mode_bits_update(&currLedReg,MSP_LED_OFF);
+			}
+			break;
+		case MSP_LED_BLINK_INVERT:
+			if (!isInInitialPeriod) {
+				*currDataBitsPtr |= (1 << pin);
+				mode_bits_update(&currLedReg, MSP_LED_ON);
+			} else {
+				mode_bits_update(&currLedReg,MSP_LED_OFF);
+
+			}
+			break;
+		case MSP_LED_OFF:
+			/* Assuming that the led be turned off when set to output mode */
+			break;
+		case MSP_LED_ON:
+			*currDataBitsPtr |= (1 << pin);
+			break;
+	}
+
+	if (currDirection == MSP_LED_INPUT)
+		*currDirectionBitsPtr |= (1 << pin);
+
+	/* save the current mode */
+	private_msp_led_register[ledId] = currLedReg;
+	
+	return 1;
+}
+
+/**
+ * device_update - Updates led device(s) on GPIO
+ * @devId - id pertaining to the device that needs update
+ * 
+ * returns 1 - device exists
+ * 		   0 - device does not exist 
+ * 
+ * Every pin connected to the GPIO is updated if the state of the pin has changed
+ * from its previous value stored in the memory register.  A temporary variable,
+ * currLedReg is used to store the current value of the register corresponding to
+ * the pin under focus.  curLedReg gets its value from the global shared memory 
+ * registers for leds.  This value is compared with the previous value to determine
+ * if a change to the led pin is required.  The previous values are stored in the
+ * private led register, private_msp_led_register.
+ * 
+ **/
+inline int device_update( int devId )
+{
+	int pin;
+	u8 currDirectionBits, currDataBits, prevDataBits, prevDirectionBits;
+	currDirectionBits = currDataBits = prevDataBits = prevDirectionBits = 0;
+	
+	/* if the device wasn't detected */
+	if (pmctwiled_device[devId] == NULL)
+		return 0;					
+
+	/* iterate through each pin of the device and update register as necessary */
+	for (pin=0; pin < MSP_LED_NUM_DEVICE_PINS; pin++) {
+		int ledId = MSP_LED_DEVPIN(devId, pin);	
+		led_update(ledId, &prevDirectionBits, &prevDataBits,
+					&currDirectionBits, &currDataBits);
+	}
+	
+	/* BUS OPERATIONS: if the previous state is different from the current state */
+	if (currDataBits != prevDataBits) {
+		i2c_smbus_write_byte_data(
+			pmctwiled_device[devId], PCA9554_OUTPUT,
+			~(currDataBits) );
+	}
+	if (currDirectionBits != prevDirectionBits) {
+		i2c_smbus_write_byte_data(
+			pmctwiled_device[devId], PCA9554_DIRECTION,
+			currDirectionBits );
+	}
+	
+	return 1;
+} 
+
+static int pmctwiled_poll( void *data )
+{
+	pmctwiled_running = 1;
+	current_period = 0;
+	
+	/* start the polling loop */
+	while( pmctwiled_running ) {
+		/* Starting Time */
+		unsigned long pollEnd;
+		unsigned long timeLeft;
+		unsigned int pollStart = jiffies;
+		
+		/* update every device in here for the current period */
+		int devId;
+		for (devId = 0; devId < MSP_LED_NUM_DEVICES; devId++)
+			device_update(devId);
+		
+		/* Ending Time */
+		pollEnd = jiffies;
+		if (pollEnd >= pollStart) {
+			timeLeft = POLL_PERIOD - (pollEnd - pollStart);
+		} else {
+			timeLeft = POLL_PERIOD - ((0xffffffff - pollStart) + pollEnd);
+			printk( "Warning: Delaying for %lu jiffies.  This may not be correct because of clock wrapping\n", timeLeft );
+		}
+		if (timeLeft > POLL_PERIOD) {
+			printk( "Warning: Delay of %lu jiffies requested, defaulting back to %lu\n", timeLeft, POLL_PERIOD );
+			timeLeft = POLL_PERIOD;
+		}
+		
+		/* reshedule next polling interval */
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(timeLeft);
+		current_period++;
+	}
+
+	return 0;
+}
+
+void __init pmctwiled_setup(void)
+{
+	static int called;
+	int dev;
+
+	/* check if already initialized */
+	if( called )
+		return;
+	
+	/* initialize LEDs to default state */
+	for( dev = 0; dev < MSP_LED_NUM_DEVICES; dev++ ) {
+		int pin;
+		pmctwiled_device[dev] = NULL;
+		
+		for( pin = 0; pin < 8; pin++ ) {
+			int led = MSP_LED_DEVPIN(dev,pin);
+			if (mspLedInitialInputState[dev] & (1 << pin)) {				
+				msp_led_disable(led);
+			} else {
+				msp_led_enable(led);
+				if (mspLedInitialPinState[dev] & (1 << pin))									
+					msp_led_turn_on(led);				
+				else			
+					msp_led_turn_off(led);
+			}
+			
+			/* Initialize the private led register memory */
+			private_msp_led_register[led] = 0;
+		}
+	}
+	
+	/* indicate initialised */
+	called++;
+}
+
+static int __init pmctwiled_init( void )
+{
+	/* setup twi led interface */
+	pmctwiled_setup();
+
+	/* start the polling thread */
+	pmctwiled_pollthread = kthread_run(pmctwiled_poll, NULL,
+			"PMCTwiLedPoller");
+	if (pmctwiled_pollthread == NULL) {
+		printk( "Could not start polling thread\n" );
+		return -ENOMEM;
+	}
+	
+	return i2c_add_driver( &pmctwiled_driver );
+}
+
+static void __exit pmctwiled_exit( void )
+{
+	/* stop the polling thread */
+	pmctwiled_running = 0;
+	kthread_stop( pmctwiled_pollthread );
+	
+	i2c_del_driver( &pmctwiled_driver );
+}
+
+MODULE_DESCRIPTION("PMC-TWI-LED driver");
+MODULE_LICENSE("GPL");
+
+module_init(pmctwiled_init);
+module_exit(pmctwiled_exit);
diff --git a/include/asm-mips/pmc-sierra/msp71xx/msp_led_macros.h b/include/asm-mips/pmc-sierra/msp71xx/msp_led_macros.h
new file mode 100644
index 0000000..7f4de2f
--- /dev/null
+++ b/include/asm-mips/pmc-sierra/msp71xx/msp_led_macros.h
@@ -0,0 +1,282 @@
+/*
+ * $Id: msp_led_macros.h,v 1.3 2006/12/18 18:16:19 stjeanma Exp $
+ *
+ * Macros for external SMP-safe access to the PMC Athena (MSP7120) reference
+ * board LEDs (over TWI)
+ *
+ * Copyright 2005 PMC-Sierra, Inc.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __MSP_LED_MACROS_H__
+#define __MSP_LED_MACROS_H__
+
+/* For ll/sc macros */
+#include <asm/regops.h>
+
+/* Generic macros for board setup */
+#define MSP_LED_DEVPIN(DEVICE,PIN)	( (DEVICE * 8) + PIN )
+
+/* ----- Per-board configuration ----- */
+
+/* TODO: Maybe break this out into one file per board? */
+
+#ifdef CONFIG_PMC_MSP7120_GW
+/* Specific LEDs and PINs which can be controlled on the Garibaldi board: */
+#define MSP_LED_PWRSTANDBY_RED 		MSP_LED_DEVPIN(2,0)
+#define MSP_LED_PWRSTANDBY_GREEN	MSP_LED_DEVPIN(2,1) 
+#define MSP_LED_LAN1_10			MSP_LED_DEVPIN(2,2)
+#define MSP_LED_LAN1_100		MSP_LED_DEVPIN(2,3)
+#define MSP_LED_LAN2_10			MSP_LED_DEVPIN(2,4)
+#define MSP_LED_LAN2_100		MSP_LED_DEVPIN(2,5)
+#define MSP_LED_LAN3_10			MSP_LED_DEVPIN(2,6)
+#define MSP_LED_LAN3_100		MSP_LED_DEVPIN(2,7)
+#define MSP_LED_LAN4_10			MSP_LED_DEVPIN(3,0)
+#define MSP_LED_LAN4_100		MSP_LED_DEVPIN(3,1)
+#define MSP_LED_LAN5_10			MSP_LED_DEVPIN(3,2)
+#define MSP_LED_LAN5_100		MSP_LED_DEVPIN(3,3)
+#define MSP_LED_RFU_10			MSP_LED_LAN5_10
+#define MSP_LED_RFU_100			MSP_LED_LAN5_100
+#define MSP_PIN_FLASH_RESETB	MSP_LED_DEVPIN(3,4)
+#define MSP_LED_PSTN			MSP_LED_DEVPIN(3,5)
+#define MSP_PIN_FLASH_BANK		MSP_LED_DEVPIN(3,6)
+#define MSP_PIN_USB_HOST_DEV	MSP_LED_DEVPIN(3,7)
+#define MSP_LED_PHONE1			MSP_LED_DEVPIN(4,0)
+#define MSP_LED_PHONE2			MSP_LED_DEVPIN(4,1)
+#define MSP_LED_USB				MSP_LED_DEVPIN(4,2)
+#define MSP_LED_WIRELESS		MSP_LED_DEVPIN(4,3)
+#define MSP_LED_DSL_RED			MSP_LED_DEVPIN(4,4)
+#define MSP_LED_DSL_GREEN		MSP_LED_DEVPIN(4,5)
+#define MSP_LED_INTERNET_RED	MSP_LED_DEVPIN(4,6)
+#define MSP_LED_INTERNET_GREEN	MSP_LED_DEVPIN(4,7)
+
+#define MSP_LED_NUM_DEVICES		5
+#define MSP_LED_NUM_DEVICE_PINS	8
+#define MSP_LED_COUNT			(MSP_LED_NUM_DEVICE_PINS * MSP_LED_NUM_DEVICES)
+#define MSP_LED_INPUT_MODE		0xff
+#define MSP_LED_OUTPUT_MODE 	0x00
+ 
+/* For each device, which pins will be in "input" mode:
+ * One byte per device:
+ *  0 = Output
+ *  1 = Input
+ */
+static const u8 mspLedInitialInputState[] = {
+	/* No outputs on device 0 or 1, these are inputs only */
+	MSP_LED_INPUT_MODE, MSP_LED_INPUT_MODE,
+	/* All outputs on device 2 through 4 */
+	MSP_LED_OUTPUT_MODE, MSP_LED_OUTPUT_MODE, MSP_LED_OUTPUT_MODE,
+};
+
+/* For each device, which output pins should start on and off:
+ * One byte per device:
+ *  0 = OFF = HI
+ *  1 = ON  = Lo
+ */
+static const u8 mspLedInitialPinState[] = {
+	0, 0, 	/* No initial state, these are input only */
+	(1 << 1),	/* PWR_GREEN LED on, all others off */
+	0,	/* All off */
+	0,	/* All off */
+};
+#endif /* CONFIG_PMC_MSP7120_GW */
+
+/* ----- End of Per-board configuration ----- */
+
+/* Definitions for LED blink rate value */
+#define MSP_LED_RATE_MAX	0xff
+
+/* -- The actual LED register list -- */
+extern u32 _msp_led_register[];
+
+/* Each 'register' has the following format:
+ *
+ * +-------+-----------------------------+
+ * | BITS  | DESCRIPTION                 |
+ * +-------+-----------------------------+
+ * | 31:24 | Watchdog timer              |
+ * |       |   Set to non-zero to start  |
+ * |       |   or to kick, this number   |
+ * |       |   will be decremented every |
+ * |       |   125ms, if it reaches zero |
+ * |       |   the LED will be turned off|
+ * +-------+-----------------------------+
+ * | 23:16 | Initial Period              |
+ * |       |   125ms increments          |
+ * +-------+-----------------------------+
+ * |  15:8 | Final Period                |
+ * |       |   125ms increments          |
+ * +-------+-----------------------------+
+ * |  7:7  | Direction                   |
+ * |       |   See msp_led_direction_t   |
+ * +-------+-----------------------------+
+ * |  6:0  | Mode                        |
+ * |       |   See msp_led_mode_t        |
+ * +-------+-----------------------------+
+ *
+ * Note: You should probably not affect these registers directly but use the
+ * macros in this file.  That said, if you need to touch them, be sure to use
+ * ll/sc instructions (or the macros in regops.h) so that values are preserved
+ * safely.
+ */
+
+/* Direction modes */
+typedef enum {
+	MSP_LED_INPUT = 0,
+	MSP_LED_OUTPUT,
+} msp_led_direction_t;
+
+/* Output modes */
+typedef enum {
+	MSP_LED_OFF = 0,		/* Off steady */
+	MSP_LED_ON,				/* On steady */
+	MSP_LED_BLINK,			/* On for initialPeriod, off for finalPeriod */
+	MSP_LED_BLINK_INVERT,	/* Off for initialPeriod, on for finalPeriod */
+} msp_led_mode_t;
+
+#define MSP_LED_MODE_MASK			0x7f
+#define MSP_LED_DIRECTION_MASK		0x80
+#define MSP_LED_DIRECTION_SHIFT		7
+#define MSP_LED_INITIALPERIOD_SHIFT	8
+#define MSP_LED_FINALPERIOD_SHIFT	16
+#define MSP_LED_WATCHDOG_SHIFT		24
+
+/* -- Public API functions -- */
+
+/* Low-level macro, explicitly sets the specified LED with the values */
+static inline void msp_led_set_mode( u16 led,
+					msp_led_mode_t mode, u8 initialPeriod,
+					u8 finalPeriod, u8 watchdogTimeout )
+{
+	set_value_reg32( &_msp_led_register[led],
+			0xffffff7f,
+			watchdogTimeout << MSP_LED_WATCHDOG_SHIFT |
+			initialPeriod << MSP_LED_INITIALPERIOD_SHIFT |
+			finalPeriod << MSP_LED_FINALPERIOD_SHIFT | 
+			((u8)mode & MSP_LED_MODE_MASK)
+		);
+}
+
+static inline void msp_led_set_direction( u16 led,
+					msp_led_direction_t direction )
+{
+	set_value_reg32( &_msp_led_register[led],
+			0x00000080,
+			((u8)direction << MSP_LED_DIRECTION_SHIFT)
+		);
+}
+
+/* Turns the LED on */
+static inline void msp_led_turn_on( u16 led )
+{
+	msp_led_set_mode( led, MSP_LED_ON, 0, 0, 0 );
+}
+
+/* Turns the LED off */
+static inline void msp_led_turn_off( u16 led )
+{
+	msp_led_set_mode( led, MSP_LED_OFF, 0, 0, 0 );
+}
+
+/* For non-LED pins, these macros set HI and LO accordingly */
+#define msp_led_pin_hi	msp_led_turn_off
+#define msp_led_pin_lo	msp_led_turn_on
+
+/* Blinks a single LED
+ * Period is specified in 125ms chunks */
+static inline void msp_led_blink( u16 led, u8 initialPeriod, u8 finalPeriod )
+{
+	msp_led_set_mode( led, MSP_LED_BLINK, initialPeriod, 
+				finalPeriod, 0 );
+}
+
+static inline void msp_led_blink_2Hz( u16 led)
+{
+	msp_led_set_mode( led, MSP_LED_BLINK, 2, 2, 0 );
+}
+
+static inline void msp_led_blink_4Hz( u16 led)
+{
+	msp_led_set_mode( led, MSP_LED_BLINK, 1, 1, 0 );
+}
+
+/* Blinks one LED, then the other
+ * Period is specified in 125ms chunks */
+static inline void msp_led_alternate( u16 led1, u16 led2,
+			u8 led1Period, u8 led2Period )
+{
+	msp_led_set_mode( led1, MSP_LED_BLINK, led1Period, 
+				led2Period, 0 );
+	msp_led_set_mode( led2, MSP_LED_BLINK_INVERT, led1Period, 
+				led2Period, 0 );
+}
+
+/* Stops both alternating LEDs from blinking, leaving 'onLed' on and 'offLed'
+ * off */
+static inline void msp_led_alternate_stop( u16 onLed, u16 offLed )
+{
+	msp_led_turn_on( onLed );
+	msp_led_turn_off( offLed );
+}
+
+/* Starts the LED blinking at the specified rate until the watchdogTimeout
+ * (specified in 125ms increments) expires, when the LED is turned off.
+ *
+ * This can also be used to kick the watchdog.
+ *
+ * Calling any other 'msp_led_...' macro will disable the watchdog, as will
+ * kicking this watchdog with a watchdogtimeout value of 0.  When the watchdog
+ * is disabled, the LED will blink forever.
+ */
+static inline void msp_led_watchdog_init( u16 led, u8 initialPeriod,
+					  u8 finalPeriod, u8 watchdogTimeout )
+{
+	msp_led_set_mode( led, MSP_LED_BLINK, initialPeriod, 
+				finalPeriod, watchdogTimeout );
+}
+
+/* Kicks a 'watchdog' LED.  If the LED is already blinking or on,
+ * it will start the watchdog countdown.  If the LED is already off or the
+ * wathdog timeout given is 0, it will ensure the LED is off and the watchdog
+ * timer has stopped.
+ */
+static inline void msp_led_watchdog_kick( u16 led, u8 watchdogTimeout )
+{
+	set_value_reg32( &_msp_led_register[led],
+		0xff << MSP_LED_WATCHDOG_SHIFT,
+		watchdogTimeout << MSP_LED_WATCHDOG_SHIFT );
+}
+
+/* 
+ * Set the direction of the led pins.
+ */
+static inline void msp_led_enable( u16 led )
+{
+	msp_led_set_direction( led, MSP_LED_OUTPUT );
+} 
+
+static inline void msp_led_disable( u16 led )
+{
+	msp_led_set_direction( led, MSP_LED_INPUT );
+}
+  
+#endif /* __MSP_LED_MACROS_H__ */
