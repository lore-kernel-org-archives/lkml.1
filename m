Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbXCLTBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbXCLTBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXCLTBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:01:32 -0400
Received: from mother.pmc-sierra.com ([216.241.224.12]:53631 "HELO
	mother.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752173AbXCLTBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:01:30 -0400
From: Marc St-Jean <stjeanma@pmc-sierra.com>
Date: Mon, 12 Mar 2007 12:50:28 -0600
Message-Id: <200703121850.l2CIoSgq002420@pasqua.pmc-sierra.bc.ca>
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
Re-posting patch with recommended changes:
-Cleanup on style and formatting for comments, macros, etc.
-Removed unnecessary memset.
-Removed unnecessary inlines.
-Moved some driver private data structures from .h to .c.
-Made use of schedule_timeout_interruptible() call instead
of multiple calls.
-Added calls to kthread_should_stop and try_to_freeze().

 drivers/i2c/chips/Kconfig                            |    9 
 drivers/i2c/chips/Makefile                           |    1 
 drivers/i2c/chips/pmctwiled.c                        |  524 +++++++++++++++++++
 include/asm-mips/pmc-sierra/msp71xx/msp_led_macros.h |  273 +++++++++
 4 files changed, 807 insertions(+)

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
index 0000000..69845a5
--- /dev/null
+++ b/drivers/i2c/chips/pmctwiled.c
@@ -0,0 +1,524 @@
+/*
+ * Special LED-over-TWI-PCA9554 driver for the PMC Sierra
+ * Residential Gateway demo board (and potentially others).
+ *
+ * Based on pca9539.c Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
+ * Modified by Copyright 2006-2007 PMC-Sierra, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kthread.h>
+#include <linux/i2c.h>
+#include <linux/freezer.h>
+
+#include <msp_led_macros.h>
+
+/*
+ * The externally available "registers"
+ * 
+ * TODO: We must ensure these are in "shared memory" for the other VPE
+ *       to access
+ */
+u32 msp_led_register[MSP_LED_COUNT];
+ 
+#ifdef CONFIG_PMC_MSP7120_GW
+/*
+ * For each device, which pins will be in "input" mode:
+ * One byte per device:
+ *  0 = Output
+ *  1 = Input
+ */
+static const u8 msp_led_initial_input_state[] = {
+	/* No outputs on device 0 or 1, these are inputs only */
+	MSP_LED_INPUT_MODE, MSP_LED_INPUT_MODE,
+	/* All outputs on device 2 through 4 */
+	MSP_LED_OUTPUT_MODE, MSP_LED_OUTPUT_MODE, MSP_LED_OUTPUT_MODE,
+};
+
+/*
+ * For each device, which output pins should start on and off:
+ * One byte per device:
+ *  0 = OFF = HI
+ *  1 = ON  = Lo
+ */
+static const u8 msp_led_initial_pin_state[] = {
+	0, 0, 	/* No initial state, these are input only */
+	1 << 1,	/* PWR_GREEN LED on, all others off */
+	0,	/* All off */
+	0,	/* All off */
+};
+#endif /* CONFIG_PMC_MSP7120_GW */
+
+/* Internal polling data */
+#define POLL_PERIOD msecs_to_jiffies(125) /* Poll at 125ms */
+
+static struct i2c_client *pmctwiled_device[MSP_LED_NUM_DEVICES];
+static struct task_struct *pmctwiled_pollthread;
+static u32 private_msp_led_register[MSP_LED_COUNT];
+static u16 current_period;
+
+/* Addresses to scan */
+#define PMCTWILED_BASEADDRESS	0x38
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
+static int pmctwiled_detect(struct i2c_adapter *adapter,
+				int address, int kind);
+static int pmctwiled_detach_client(struct i2c_client *client);
+
+/* This is the driver that will be inserted */
+static struct i2c_driver pmctwiled_driver = {
+	.driver = {
+		.name	= "pmctwiled",
+	},
+	.attach_adapter	= pmctwiled_attach_adapter,
+	.detach_client	= pmctwiled_detach_client,
+};
+
+struct pmctwiled_data {
+	struct i2c_client client;
+};
+
+static int pmctwiled_attach_adapter(struct i2c_adapter *adapter)
+{
+	return i2c_probe(adapter, &addr_data, pmctwiled_detect);
+}
+
+/* This function is called by i2c_probe */
+static int pmctwiled_detect(struct i2c_adapter *adapter,
+				int address, int kind)
+{
+	struct i2c_client *new_client = NULL;	/* client structure */
+	struct pmctwiled_data *data = NULL;	/* local data structure */
+	int err = 0;
+	int dev_id = address - PMCTWILED_BASEADDRESS;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		goto exit;
+
+	/*
+	 * For now, we presume we have a valid client. We now create the
+	 * client structure, even though we cannot fill it completely yet.
+	 */
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	new_client = &data->client;
+	i2c_set_clientdata(new_client, data);
+	new_client->addr = address;
+	new_client->adapter = adapter;
+	new_client->driver = &pmctwiled_driver;
+	new_client->flags = 0;
+
+	/*
+	 * Detection:
+	 *   The pca9554 only has 4 registers (0-3).
+	 * All other reads should fail.
+	 */
+	if (i2c_smbus_read_byte_data(new_client, 3) < 0 ||
+	    i2c_smbus_read_byte_data(new_client, 4) >= 0)
+		goto exit_kfree;
+
+	/* Found PCA9554 (probably) */
+	strlcpy(new_client->name, "pca9554", I2C_NAME_SIZE);
+	printk(KERN_WARNING
+		"Detected PCA9554 I/O chip (device %d) at 0x%02x\n",
+		dev_id, address);
+
+	/* Tell the I2C layer a new client has arrived */
+	err = i2c_attach_client(new_client);
+	if (err)
+		goto exit_kfree;
+
+	/*
+	 * Register this in the list of available devices, and set up the
+	 * initial state
+	 */
+	i2c_smbus_write_byte_data(new_client, PCA9554_OUTPUT,
+			i2c_smbus_read_byte_data(new_client, PCA9554_INPUT));
+	i2c_smbus_write_byte_data(new_client, PCA9554_DIRECTION,
+			msp_led_initial_input_state[dev_id]);
+	pmctwiled_device[dev_id] = new_client;
+
+	return 0;
+
+exit_kfree:
+	kfree(data);
+exit:
+	return err;
+}
+
+static int pmctwiled_detach_client(struct i2c_client *client)
+{
+	int err;
+	int dev_id = client->addr - PMCTWILED_BASEADDRESS;
+
+	/* Clear reference so poll thread doesn't use while detaching */
+	pmctwiled_device[dev_id] = NULL;
+
+	/* Remove this device from the list of devices */
+	err = i2c_detach_client(client);
+	if (err)
+		return err;
+
+	kfree(i2c_get_clientdata(client));
+
+	return 0;
+}
+
+/*
+ * mode_bits_update - Sets the mode bits of the given led register
+ * @led_reg_ptr: Pointer to the led register value that needs to be updated
+ * 		with the given mode.
+ * @mode: new mode value to be set to the register
+ *
+ * Sets the given mode value to the given led register.
+ */
+inline void mode_bits_update(u32 *led_reg_ptr, enum msp_led_mode mode)
+{
+	/* TODO: validate mode */
+	*led_reg_ptr |= MSP_LED_MODE_MASK;
+	*led_reg_ptr &= (~((u32) MSP_LED_MODE_MASK) | mode);
+}
+
+/*
+ * sync_led_timer_with_polling_count - Synchronizes the led timer with
+ * 	polling thread count
+ * @led_id: Index for the private led register used to obtain timer
+ * 	information
+ * @led_reg_ptr: Pointer to the new led register value
+ *  
+ * returns 0: If led is in its final period
+ * returns 1: If led is in its initial period
+ * 
+ * This function determines if the led timer is in its initial period or
+ * the final, relative to the TWI-polling thread count (current_period)
+ * and updates the previous timer value in the private led register.  If
+ * the state of the led needs to be turned off (i.e. when the led has
+ * timed out) then the mode bits in the current led register pointer is
+ * set to MSP_LED_OFF and the other data bits are set to 0.
+ */
+int sync_led_timer_with_polling_count(int led_id, u32 *led_reg_ptr)
+{
+	/* Timer variables */
+	int is_in_initial_period = 0;
+	u8 timer, led_timeout, initial_period, final_period;
+	u16 total_period;
+
+	/* 
+	 * Determine the progress into the current cycle, relative to
+	 * the POLL_PERIOD
+	 */
+	initial_period = *led_reg_ptr >> MSP_LED_INITIALPERIOD_SHIFT;
+	final_period = *led_reg_ptr >> MSP_LED_FINALPERIOD_SHIFT;
+	led_timeout = *led_reg_ptr >> MSP_LED_WATCHDOG_SHIFT;
+	timer = private_msp_led_register[led_id] >> MSP_LED_WATCHDOG_SHIFT;
+
+	total_period = initial_period + final_period;
+	if (total_period != 0)
+		is_in_initial_period = (current_period % total_period) <
+					initial_period;
+
+	/*
+	 * if the led_timeout is set, adjust the current state to be either
+	 * ON or OFF
+	 */
+	if (led_timeout > 0) {
+		if (timer >= led_timeout) {
+			/* set the register to OFF state */
+			mode_bits_update(led_reg_ptr, MSP_LED_OFF);
+			timer = 0;
+
+			/*
+			 * TODO:
+			 * This introduces a race condition with other
+			 * thread using shared memory and must be fixed.
+			 */
+			msp_led_turn_off(led_id);
+		} else
+			timer += 1;
+
+		/* update timer */
+		*led_reg_ptr &= ~(0xff << MSP_LED_WATCHDOG_SHIFT);
+		*led_reg_ptr |= (timer << MSP_LED_WATCHDOG_SHIFT);
+	}
+
+	return is_in_initial_period;
+}
+
+/*
+ * led_update - Sets the mode bits of the given led register
+ * @led_id - id pertaining to the led that needs update
+ * @prev_direction_bits_ptr - points to the previous direction bits on the bus
+ * @prev_data_bits_ptr - points to the previous data bits on the bus
+ * @curr_direction_bits_ptr - points to the new direction bits for bus update
+ * @curr_data_bits_ptr - points to the new data bits for bus update
+ * 
+ * returns 1 - led is in output mode
+ *         0 - led is in input mode and hasn't been updated
+ * 
+ * Sets the given mode value to the given led register.
+ */
+int led_update(int led_id,
+		u8 *prev_direction_bits_ptr, u8 *prev_data_bits_ptr,
+		u8 *curr_direction_bits_ptr, u8 *curr_data_bits_ptr)
+{
+	u32 curr_led_reg;
+	enum msp_led_mode curr_mode, prev_mode;
+	enum msp_led_direction curr_direction, prev_direction;
+	int is_in_initial_period;
+
+	/* Read the shared memory into a temporary variable */
+	int pin = led_id % MSP_LED_NUM_DEVICE_PINS;
+	curr_led_reg = msp_led_register[led_id];
+
+	/* Check if the input direction has changed to output */
+	prev_direction = (enum msp_led_direction)
+			((private_msp_led_register[led_id] &
+			MSP_LED_DIRECTION_MASK) >> MSP_LED_DIRECTION_SHIFT);
+	curr_direction = (enum msp_led_direction)((curr_led_reg &
+			MSP_LED_DIRECTION_MASK) >> MSP_LED_DIRECTION_SHIFT);
+	if ((prev_direction == MSP_LED_INPUT) &&
+	    (curr_direction != MSP_LED_OUTPUT))
+		return 0;
+
+	/* get the previous mode of the LED */
+	prev_mode = (enum msp_led_mode)(private_msp_led_register[led_id] &
+			MSP_LED_MODE_MASK);
+
+	if (prev_mode == MSP_LED_ON)
+		*prev_data_bits_ptr |= 1 << pin;
+
+	if (prev_direction == MSP_LED_INPUT)
+		*prev_direction_bits_ptr |= 1 << pin;
+
+	/* Update timer and obtain the current period */
+	is_in_initial_period = sync_led_timer_with_polling_count(
+					led_id, &curr_led_reg);
+
+	/* get the current mode of the LED */
+	curr_mode = (enum msp_led_mode)(curr_led_reg & MSP_LED_MODE_MASK);
+
+	switch (curr_mode) {
+	case MSP_LED_BLINK:
+		if (is_in_initial_period) {
+			*curr_data_bits_ptr |= 1 << pin;
+			mode_bits_update(&curr_led_reg, MSP_LED_ON);
+		} else
+			mode_bits_update(&curr_led_reg,MSP_LED_OFF);
+		break;
+	case MSP_LED_BLINK_INVERT:
+		if (!is_in_initial_period) {
+			*curr_data_bits_ptr |= 1 << pin;
+			mode_bits_update(&curr_led_reg, MSP_LED_ON);
+		} else
+			mode_bits_update(&curr_led_reg,MSP_LED_OFF);
+		break;
+	case MSP_LED_OFF:
+		/*
+		 * Assuming that the led be turned off when set to
+		 * output mode
+		 */
+		break;
+	case MSP_LED_ON:
+		*curr_data_bits_ptr |= 1 << pin;
+		break;
+	}
+
+	if (curr_direction == MSP_LED_INPUT)
+		*curr_direction_bits_ptr |= 1 << pin;
+
+	/* save the current mode */
+	private_msp_led_register[led_id] = curr_led_reg;
+
+	return 1;
+}
+
+/*
+ * device_update - Updates led device(s) on GPIO
+ * @dev_id - id pertaining to the device that needs update
+ * 
+ * returns 1 - device exists
+ * 		   0 - device does not exist 
+ * 
+ * Every pin connected to the GPIO is updated if the state of the pin has
+ * changed from its previous value stored in the memory register.  A temporary
+ * variable, curr_led_reg is used to store the current value of the register
+ * corresponding to the pin under focus.  curLedReg gets its value from the
+ * global shared memory registers for leds.  This value is compared with the
+ * previous value to determine if a change to the led pin is required.  The
+ * previous values are stored in the private led register,
+ * private_msp_led_register.
+ */
+int device_update(int dev_id)
+{
+	int pin;
+	u8 curr_direction_bits = 0;
+	u8 curr_data_bits = 0;
+	u8 prev_data_bits = 0;
+	u8 prev_direction_bits = 0;
+
+	/* if the device wasn't detected */
+	if (pmctwiled_device[dev_id] == NULL)
+		return 0;
+
+	/* iterate through each pin of the device and update as necessary */
+	for (pin = 0; pin < MSP_LED_NUM_DEVICE_PINS; pin++) {
+		int led_id = MSP_LED_DEVPIN(dev_id, pin);
+		led_update(led_id, &prev_direction_bits, &prev_data_bits,
+				&curr_direction_bits, &curr_data_bits);
+	}
+
+	/*
+	 * BUS OPERATIONS: if the previous state is different from the
+	 * current state
+	 */
+	if (curr_data_bits != prev_data_bits)
+		i2c_smbus_write_byte_data(pmctwiled_device[dev_id],
+				PCA9554_OUTPUT, ~(curr_data_bits));
+
+	if (curr_direction_bits != prev_direction_bits)
+		i2c_smbus_write_byte_data(pmctwiled_device[dev_id],
+				PCA9554_DIRECTION, curr_direction_bits);
+
+	return 1;
+}
+
+static int pmctwiled_poll(void *data)
+{
+	current_period = 0;
+
+	/* start the polling loop */
+	do {
+		/* Starting Time */
+		unsigned long poll_end;
+		unsigned long time_left;
+		unsigned int poll_start = jiffies;
+
+		/* update every device in here for the current period */
+		int dev_id;
+		for (dev_id = 0; dev_id < MSP_LED_NUM_DEVICES; dev_id++)
+			device_update(dev_id);
+
+		/* Ending Time */
+		poll_end = jiffies;
+		if (poll_end >= poll_start) {
+			time_left = POLL_PERIOD - (poll_end - poll_start);
+		} else {
+			time_left = POLL_PERIOD - ((0xffffffff - poll_start) +
+					poll_end);
+			printk(KERN_WARNING
+				"Warning: Delaying for %lu jiffies. This may "
+				"not be correct because of clock wrapping\n",
+				time_left);
+		}
+		if (time_left > POLL_PERIOD) {
+			printk(KERN_WARNING
+				"Warning: Delay of %lu jiffies requested, "
+				"defaulting back to %lu\n",
+				time_left, POLL_PERIOD);
+			time_left = POLL_PERIOD;
+		}
+
+		/* reshedule next polling interval */
+		schedule_timeout_interruptible(time_left);
+
+		/* make swsusp happy with our thread */
+		try_to_freeze();
+
+		current_period++;
+	} while (!kthread_should_stop());
+
+	return 0;
+}
+
+void __init pmctwiled_setup(void)
+{
+	static int called;
+	int dev;
+
+	/* check if already initialized from platform initialization */
+	if (called)
+		return;
+
+	/* initialize LEDs to default state */
+	for (dev = 0; dev < MSP_LED_NUM_DEVICES; dev++) {
+		int pin;
+		pmctwiled_device[dev] = NULL;
+
+		for (pin = 0; pin < 8; pin++) {
+			int led = MSP_LED_DEVPIN(dev, pin);
+			if (msp_led_initial_input_state[dev] & (1 << pin)) {
+				msp_led_disable(led);
+			} else {
+				msp_led_enable(led);
+				if (msp_led_initial_pin_state[dev] & (1 << pin))
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
+static int __init pmctwiled_init(void)
+{
+	/* setup twi led interface */
+	pmctwiled_setup();
+
+	/* start the polling thread */
+	pmctwiled_pollthread = kthread_run(pmctwiled_poll, NULL,
+					"PMCTwiLedPoller");
+	if (pmctwiled_pollthread == NULL) {
+		printk(KERN_ERR "Could not start polling thread\n");
+		return -ENOMEM;
+	}
+
+	return i2c_add_driver(&pmctwiled_driver);
+}
+
+static void __exit pmctwiled_exit(void)
+{
+	/* stop the polling thread */
+	kthread_stop(pmctwiled_pollthread);
+
+	i2c_del_driver(&pmctwiled_driver);
+}
+
+MODULE_DESCRIPTION("PMC TWI-LED driver");
+MODULE_LICENSE("GPL");
+
+module_init(pmctwiled_init);
+module_exit(pmctwiled_exit);
diff --git a/include/asm-mips/pmc-sierra/msp71xx/msp_led_macros.h b/include/asm-mips/pmc-sierra/msp71xx/msp_led_macros.h
new file mode 100644
index 0000000..b5fb683
--- /dev/null
+++ b/include/asm-mips/pmc-sierra/msp71xx/msp_led_macros.h
@@ -0,0 +1,273 @@
+/*
+ * Macros for external SMP-safe access to the PMC MSP7120
+ * Residential Gateway demo board LEDs (over TWI)
+ *
+ * Copyright 2006-2007 PMC-Sierra, Inc.
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
+#define MSP_LED_DEVPIN(DEVICE, PIN)	((DEVICE * 8) + PIN)
+
+/* ----- Per-board configuration ----- */
+
+/* TODO: Maybe break this out into one file per board? */
+
+#ifdef CONFIG_PMC_MSP7120_GW
+/* Specific LEDs and PINs which can be controlled on the RG demo board: */
+#define MSP_LED_PWRSTANDBY_RED 		MSP_LED_DEVPIN(2, 0)
+#define MSP_LED_PWRSTANDBY_GREEN	MSP_LED_DEVPIN(2, 1) 
+#define MSP_LED_LAN1_10			MSP_LED_DEVPIN(2, 2)
+#define MSP_LED_LAN1_100		MSP_LED_DEVPIN(2, 3)
+#define MSP_LED_LAN2_10			MSP_LED_DEVPIN(2, 4)
+#define MSP_LED_LAN2_100		MSP_LED_DEVPIN(2, 5)
+#define MSP_LED_LAN3_10			MSP_LED_DEVPIN(2, 6)
+#define MSP_LED_LAN3_100		MSP_LED_DEVPIN(2, 7)
+#define MSP_LED_LAN4_10			MSP_LED_DEVPIN(3, 0)
+#define MSP_LED_LAN4_100		MSP_LED_DEVPIN(3, 1)
+#define MSP_LED_LAN5_10			MSP_LED_DEVPIN(3, 2)
+#define MSP_LED_LAN5_100		MSP_LED_DEVPIN(3, 3)
+#define MSP_LED_RFU_10			MSP_LED_LAN5_10
+#define MSP_LED_RFU_100			MSP_LED_LAN5_100
+#define MSP_PIN_FLASH_RESETB		MSP_LED_DEVPIN(3, 4)
+#define MSP_LED_PSTN			MSP_LED_DEVPIN(3, 5)
+#define MSP_PIN_FLASH_BANK		MSP_LED_DEVPIN(3, 6)
+#define MSP_PIN_USB_HOST_DEV		MSP_LED_DEVPIN(3, 7)
+#define MSP_LED_PHONE1			MSP_LED_DEVPIN(4, 0)
+#define MSP_LED_PHONE2			MSP_LED_DEVPIN(4, 1)
+#define MSP_LED_USB			MSP_LED_DEVPIN(4, 2)
+#define MSP_LED_WIRELESS		MSP_LED_DEVPIN(4, 3)
+#define MSP_LED_DSL_RED			MSP_LED_DEVPIN(4, 4)
+#define MSP_LED_DSL_GREEN		MSP_LED_DEVPIN(4, 5)
+#define MSP_LED_INTERNET_RED		MSP_LED_DEVPIN(4, 6)
+#define MSP_LED_INTERNET_GREEN		MSP_LED_DEVPIN(4, 7)
+
+#define MSP_LED_NUM_DEVICES		5
+#define MSP_LED_NUM_DEVICE_PINS		8
+#define MSP_LED_COUNT			(MSP_LED_NUM_DEVICE_PINS * \
+					 MSP_LED_NUM_DEVICES)
+#define MSP_LED_INPUT_MODE		0xff
+#define MSP_LED_OUTPUT_MODE		0x00
+#endif /* CONFIG_PMC_MSP7120_GW */
+
+/* ----- End of Per-board configuration ----- */
+
+/* Definitions for LED blink rate value */
+#define MSP_LED_RATE_MAX	0xff
+
+/* -- The actual LED register list -- */
+extern u32 msp_led_register[];
+
+/*
+ * Each 'register' has the following format:
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
+ * |       |   See msp_led_direction     |
+ * +-------+-----------------------------+
+ * |  6:0  | Mode                        |
+ * |       |   See msp_led_mode          |
+ * +-------+-----------------------------+
+ *
+ * NOTE: You should probably not affect these registers directly but use
+ * the macros in this file.  That said, if you need to touch them, be sure
+ * to use ll/sc instructions (or the macros in regops.h) so that values are
+ * preserved safely.
+ */
+
+/* Direction modes */
+enum msp_led_direction {
+	MSP_LED_INPUT = 0,
+	MSP_LED_OUTPUT,
+};
+
+/* Output modes */
+enum msp_led_mode {
+	MSP_LED_OFF = 0,/* Off steady */
+	MSP_LED_ON,	/* On steady */
+	MSP_LED_BLINK,	/* On for initial_period, off for final_period */
+	MSP_LED_BLINK_INVERT,
+			/* Off for initial_period, on for final_period */
+};
+
+#define MSP_LED_MODE_MASK		0x7f
+#define MSP_LED_DIRECTION_MASK		0x80
+#define MSP_LED_DIRECTION_SHIFT		7
+#define MSP_LED_INITIALPERIOD_SHIFT	8
+#define MSP_LED_FINALPERIOD_SHIFT	16
+#define MSP_LED_WATCHDOG_SHIFT		24
+
+/* -- Public API functions -- */
+
+/* Low-level macro, explicitly sets the specified LED with the values */
+static inline void msp_led_set_mode(u16 led,
+				    enum msp_led_mode mode, u8 initial_period,
+				    u8 final_period, u8 watchdog_timeout)
+{
+	set_value_reg32(&msp_led_register[led],
+			0xffffff7f,
+			watchdog_timeout << MSP_LED_WATCHDOG_SHIFT |
+			initial_period << MSP_LED_INITIALPERIOD_SHIFT |
+			final_period << MSP_LED_FINALPERIOD_SHIFT | 
+			((u8)mode & MSP_LED_MODE_MASK));
+}
+
+static inline void msp_led_set_direction(u16 led,
+					 enum msp_led_direction direction)
+{
+	set_value_reg32(&msp_led_register[led],
+			0x00000080,
+			((u8)direction << MSP_LED_DIRECTION_SHIFT));
+}
+
+/* Turns the LED on */
+static inline void msp_led_turn_on(u16 led)
+{
+	msp_led_set_mode(led, MSP_LED_ON, 0, 0, 0);
+}
+
+/* Set pin LO */
+static inline void msp_led_pin_lo(u16 pin)
+{
+	msp_led_set_mode(pin, MSP_LED_ON, 0, 0, 0);
+}
+
+/* Turns the LED off */
+static inline void msp_led_turn_off(u16 led)
+{
+	msp_led_set_mode(led, MSP_LED_OFF, 0, 0, 0);
+}
+
+/* Set pin HI */
+static inline void msp_led_pin_hi(u16 pin)
+{
+	msp_led_set_mode(pin, MSP_LED_OFF, 0, 0, 0);
+}
+
+/*
+ * Blinks a single LED
+ * Period is specified in 125ms chunks
+ */
+static inline void msp_led_blink(u16 led, u8 initial_period, u8 final_period)
+{
+	msp_led_set_mode(led, MSP_LED_BLINK, initial_period, 
+			 final_period, 0);
+}
+
+static inline void msp_led_blink_2Hz(u16 led)
+{
+	msp_led_set_mode(led, MSP_LED_BLINK, 2, 2, 0);
+}
+
+static inline void msp_led_blink_4Hz(u16 led)
+{
+	msp_led_set_mode(led, MSP_LED_BLINK, 1, 1, 0);
+}
+
+/*
+ * Blinks one LED, then the other
+ * Period is specified in 125ms chunks
+ */
+static inline void msp_led_alternate(u16 led1, u16 led2,
+				     u8 led1_period, u8 led2_period)
+{
+	msp_led_set_mode(led1, MSP_LED_BLINK, led1_period, 
+				led2_period, 0);
+	msp_led_set_mode(led2, MSP_LED_BLINK_INVERT, led1_period, 
+				led2_period, 0);
+}
+
+/*
+ * Stops both alternating LEDs from blinking, leaving 'on_led' on
+ * and 'off_led' off.
+ */
+static inline void msp_led_alternate_stop(u16 on_led, u16 off_led)
+{
+	msp_led_turn_on(on_led);
+	msp_led_turn_off(off_led);
+}
+
+/*
+ * Starts the LED blinking at the specified rate until the watchdog_timeout
+ * (specified in 125ms increments) expires, when the LED is turned off.
+ *
+ * This can also be used to kick the watchdog.
+ *
+ * Calling any other 'msp_led_...' macro will disable the watchdog,
+ * as will kicking this watchdog with a watchdogtimeout value of 0.
+ * When the watchdog is disabled, the LED will blink forever.
+ */
+static inline void msp_led_watchdog_init(u16 led, u8 initial_period,
+					 u8 final_period, u8 watchdog_timeout)
+{
+	msp_led_set_mode(led, MSP_LED_BLINK, initial_period,
+			 final_period, watchdog_timeout);
+}
+
+/*
+ * Kicks a 'watchdog' LED.  If the LED is already blinking or on,
+ * it will start the watchdog countdown.  If the LED is already off or
+ * the wathdog timeout given is 0, it will ensure the LED is off and
+ * the watchdog timer has stopped.
+ */
+static inline void msp_led_watchdog_kick(u16 led, u8 watchdog_timeout)
+{
+	set_value_reg32(&msp_led_register[led],
+			0xff << MSP_LED_WATCHDOG_SHIFT,
+			watchdog_timeout << MSP_LED_WATCHDOG_SHIFT);
+}
+
+/* 
+ * Set the direction of the led pins.
+ */
+static inline void msp_led_enable(u16 led)
+{
+	msp_led_set_direction(led, MSP_LED_OUTPUT);
+} 
+
+static inline void msp_led_disable(u16 led)
+{
+	msp_led_set_direction(led, MSP_LED_INPUT);
+}
+  
+#endif /* !__MSP_LED_MACROS_H__ */
