Return-Path: <linux-kernel-owner+w=401wt.eu-S1765041AbYBTRJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765041AbYBTRJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765703AbYBTRI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:08:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35641 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1765619AbYBTRIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:08:55 -0500
Subject: [PATCH 1/6] regulator: consumer driver regulator control framework.
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 17:08:53 +0000
Message-Id: <1203527333.4071.89.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This framework provides voltage and current regulator control to allow
consumer drivers to control their supply voltages and current levels.

The framework is similar to the kernel clock interface in that client or
consumer drivers can get() and put() a regulator (like they can with clocks
atm).

Consumers can also get() or set() :- voltage, current, operating mode.
Consumers can also enable and disable regulators.

The framework also compiles out if not in use so drivers can be reused in
systems with no software PMIC power control.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 include/linux/regulator/regulator.h |  365 +++++++++++++++++++++++++++++++++++
 1 files changed, 365 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/regulator/regulator.h

diff --git a/include/linux/regulator/regulator.h b/include/linux/regulator/regulator.h
new file mode 100644
index 0000000..7494968
--- /dev/null
+++ b/include/linux/regulator/regulator.h
@@ -0,0 +1,365 @@
+/*
+ * regulator.h -- SoC Regulator support.
+ *
+ * Copyright (C) 2007, 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Liam Girdwood <lg@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Regulator Client Interface.
+ *
+ * A Power Management Regulator framework for SoC based devices.
+ * Features:-
+ *   o Voltage and current level control.
+ *   o Operating mode control.
+ *   o Regulator status.
+ *   o sysfs entries for showing client devices and status
+ *
+ * EXPERIMENTAL FEATURES:
+ *   Dynamic Regulator operating Mode Switching (DRMS) - allows regulators
+ *   to use most efficient operating mode depending upon voltage and load and
+ *   is transparent to client drivers.
+ *
+ *   e.g. Devices x,y,z share regulator r. Device x and y draw 20mA each during
+ *   IO and 1mA at idle. Device z draws 100mA when under load and 5mA when
+ *   idling. Regulator r has > 90% efficieny in NORMAL mode at loads > 100mA
+ *   but this drops rapidly to 60% when below 100mA. Regulator r has > 90%
+ *   efficiency in IDLE mode at loads < 10mA. Thus regulator r will operate
+ *   in normal mode for loads > 10mA and in IDLE mode for load <= 10mA.
+ *
+ *   Dynamic Regulator Voltage Selection (DRVS). Selects the lowest voltage
+ *   output (within system constraints) for a regulator shared between several
+ *   devices. This allows all devices to operate within their voltage range and
+ *   will dynamically change the voltage when devices disable() thier supply
+ *   to the next best level (thus saving power). This is based on an idea
+ *   by Amit Kucheria in an RFC to lakml.
+ *
+ *   e.g. devices x,y,z share regulator r. device x and y can operate between
+ *   1800mV and 1900mV, whilst device z can only operate at 1900mV. Regulator
+ *   r will output 1900mV when all devices are in use and 1800mV when devices
+ *   x and y are in use and device z is disabled.
+ */
+
+
+#ifndef __LINUX_REGULATOR_H_
+#define __LINUX_REGULATOR_H_
+
+/*
+ * Regulator operating modes.
+ *
+ * Regulators can run in a variety of different operating modes depending on
+ * output load. This allows further system power savings by selecting the
+ * best (and most efficient) regulator mode for a desired load.
+ *
+ * Most drivers will only care about NORMAL. The modes below are generic and
+ * will probably not match the naming convention of your regulator data sheet
+ * but should match the use cases in the datasheet.
+ *
+ * In order of power efficiency (least efficient at top).
+ *
+ *  Mode       Description
+ *  FAST       Regulator can handle fast changes in it's load.
+ *             e.g. useful in CPU voltage & frequency scaling where
+ *             load can quickly increase with CPU freqency increases.
+ *
+ *  NORMAL     Normal regulator power supply mode. Most drivers will
+ *             use this mode.
+ *
+ *  IDLE       Regulator runs in a more efficient mode for light
+ *             loads. Can be used for devices that have a low power
+ *             requirement during periods of inactivity. This mode
+ *             may be more noisy than NORMAL and may not be able
+ *             to handle fast load switching.
+ *
+ *  STANDBY    Regulator runs in the most efficient mode for very
+ *             light loads. Can be used by devices when they are
+ *             in a sleep/standby state. This mode is likely to be
+ *             the most noisy and may not be able to handle fast load
+ *             switching.
+ *
+ * NOTE: Most regulators will only support a subset of these modes. Some
+ * will only just support NORMAL.
+ */
+
+#define REGULATOR_MODE_FAST			0x1
+#define REGULATOR_MODE_NORMAL			0x2
+#define REGULATOR_MODE_IDLE			0x4
+#define REGULATOR_MODE_STANDBY			0x8
+
+/*
+ * Regulator notifier events.
+ *
+ * @UNDER_VOLTAGE:  Regulator output is under voltage.
+ * @OVER_CURRENT:   Regulator output current is too high.
+ * @POWER_ON:       Regulator power ON event.
+ * @POWER_OFF:      Regulator power OFF event.
+ * @REGULATION_OUT: Regulator output is out of regulation.
+ * @FAIL:           Regulator output has failed.
+ * @OVER_TEMP:      Regulator over temp.
+ */
+
+#define REGULATOR_EVENT_UNDER_VOLTAGE		0x1
+#define REGULATOR_EVENT_OVER_CURRENT		0x2
+#define REGULATOR_EVENT_POWER_ON		0x4
+#define REGULATOR_EVENT_POWER_OFF		0x8
+#define REGULATOR_EVENT_REGULATION_OUT		0x10
+#define REGULATOR_EVENT_FAIL			0x20
+#define REGULATOR_EVENT_OVER_TEMP		0x40
+
+/*
+ * Convenience conversion.
+ * Here atm, maybe there is somewhere better for this.
+ */
+#define mV_to_uV(mV)	(mV * 1000)
+#define uV_to_mV(uV)	(uV / 1000)
+#define V_to_uV(V)	(mV_to_uV(V * 1000))
+#define uV_to_V(uV)	(uV_to_mV(uV) / 1000)
+#define mA_to_uA(mA)	(mA * 1000)
+#define uA_to_mA(uA)	(uA / 1000)
+#define A_to_uA(A)	(mA_to_uA(A * 1000))
+#define uA_to_A(uA)	(uA_to_mA(uA) / 1000)
+
+struct regulator;
+
+#if defined (CONFIG_REGULATOR)
+
+/**
+ * regulator_get - lookup and obtain a reference to a regulator.
+ * @dev: device for regulator "consumer"
+ * @id: regulator ID
+ *
+ * Returns a struct regulator corresponding to the regulator producer, or
+ * IS_ERR() condition containing errno.
+ */
+struct regulator * __must_check regulator_get(struct device *dev,
+	const char *id);
+
+/**
+ * regulator_put - "free" the regulator source
+ * @regulator: regulator source
+ *
+ * Note: drivers must ensure that all regulator_enable calls made on this
+ * regulator source are balanced by regulator_disable calls prior to calling
+ * this function.
+ */
+void regulator_put(struct regulator *regulator);
+
+/**
+ * regulator_enable - enable regulator output
+ * @regulator: regulator source
+ *
+ * Enable the regulator output at the predefined voltage or current value.
+ * NOTE: the output value can be set by other drivers, bootloader or may be
+ * hardwired in the regulator.
+ */
+int regulator_enable(struct regulator *regulator);
+
+/**
+ * regulator_disable - disable regulator output
+ * @regulator: regulator source
+ *
+ * Disable the regulator output voltage or current.
+ * NOTE: this will only disable the regulator output iff no other consumer
+ * devices have it enabled.
+ */
+int regulator_disable(struct regulator *regulator);
+
+/**
+ * regulator_is_enabled - is the regulator output enabled
+ * @regulator: regulator source
+ *
+ * Returns zero for disabled otherwise return number of enable requests.
+ */
+int regulator_is_enabled(struct regulator *regulator);
+
+/**
+ * regulator_set_voltage - set regulator output voltage
+ * @regulator: regulator source
+ * @uV: voltage in uV
+ *
+ * Sets a voltage regulator to the desired output voltage. This can be set
+ * during any regulator state. IOW, regulator can be disabled or enabled.
+ *
+ * If the regulator is enabled then the voltage will change to the new value
+ * immediately otherwise if the regulator is disabled the regulator will
+ * output at the new voltage when enabled.
+ *
+ * NOTE: If the regulator is shared between several devices then the lowest
+ * request voltage that meets the system constraints will be used.
+ * NOTE: Regulator system constraints must be set for this regulator before
+ * calling this function otherwise this call will fail.
+ */
+int regulator_set_voltage(struct regulator *regulator, int uV);
+
+/**
+ * regulator_get_voltage - get regulator output voltage
+ * @regulator: regulator source
+ *
+ * This returns the current regulator voltage in uV.
+ *
+ * NOTE: If the regulator is disabled it will return the voltage value. This
+ * function should not be used to determine regulator state.
+ */
+int regulator_get_voltage(struct regulator *regulator);
+
+/**
+ * regulator_set_current - set regulator output current for a current sink
+ * @regulator: regulator source
+ * @uA: current in uA
+ *
+ * Sets current sink to the desired output current. This can be set during
+ * any regulator state. IOW, regulator can be disabled or enabled.
+ *
+ * If the regulator is enabled then the current will change to the new value
+ * immediately otherwise if the regulator is disabled the regulator will
+ * output at the new current when enabled.
+ *
+ * NOTE: Regulator system constraints must be set for this regulator before
+ * calling this function otherwise this call will fail.
+ */
+int regulator_set_current(struct regulator *regulator, int uA);
+
+/**
+ * regulator_get_current - get regulator output current
+ * @regulator: regulator source
+ *
+ * This returns the current supplied by the specified current sink in uA.
+ *
+ * NOTE: If the regulator is disabled it will return the current value. This
+ * function should not be used to determine regulator state.
+ */
+int regulator_get_current(struct regulator *regulator);
+
+/**
+ * regulator_set_mode - set regulator operating mode
+ * @regulator: regulator source
+ * @mode: operating mode - one of the REGULATOR_MODE constants
+ *
+ * Set regulator operating mode to increase regulator efficiency or improve
+ * regulation performance.
+ *
+ * NOTE: Regulator system constraints must be set for this regulator before
+ * calling this function otherwise this call will fail.
+ */
+int regulator_set_mode(struct regulator *regulator, unsigned int mode);
+
+/**
+ * regulator_get_mode - set regulator operating mode
+ * @regulator: regulator source
+ *
+ * Get the current regulator operating mode.
+ */
+unsigned int regulator_get_mode(struct regulator *regulator);
+
+/**
+ * regulator_get_optimum_mode - get regulator optimum operating mode
+ * @regulator: regulator source
+ * @input_uV: input voltage
+ * @output_uV: output voltage
+ * @load_uV: load current
+ *
+ * Get the most efficient regulator operating mode for the given input
+ * and output voltages at a specific load..
+ */
+unsigned int regulator_get_optimum_mode(struct regulator *regulator,
+	int input_uV, int output_uV, int load_uA);
+
+/**
+ * regulator_register_client - register regulator event notifier
+ * @regulator: regulator source
+ * @notifier_block: notifier block
+ *
+ * Register notifier block to receive regulator events.
+ */
+int regulator_register_client(struct regulator *regulator,
+	struct notifier_block *nb);
+
+/**
+ * regulator_unregister_client - unregister regulator event notifier
+ * @regulator: regulator source
+ * @notifier_block: notifier block
+ *
+ * Unregister regulator event notifier block.
+ */
+int regulator_unregister_client(struct regulator *regulator,
+	struct notifier_block *nb);
+
+/**
+ * regulator_notify_load - notify regulator of new device load
+ * @regulator: regulator
+ * @dev: device
+ * @uA: load
+ *
+ * Notifies the regulator core of a new device load. This is then used by
+ * DRMS (if enabled by constraints) to select the most efficient regulator
+ * operating mode for the new regulator loading.
+ *
+ * Client devices notify their supply regulator of the maximum power
+ * they will require (can be taken from device datasheet in the power
+ * consumption tables) when they change operational status and hence power
+ * state. Examples of operational state changes that can affect power
+ * consumption are :-
+ *
+ *    o Device is opened / closed.
+ *    o Device I/O is about to begin or has just finished.
+ *    o Device is idling in between work.
+ *
+ * This information is also exported via sysfs to userspace.
+ *
+ * DRMS would then sum the total requested load on the regulator and change
+ * to the most efficient operating mode if platform constraints allow.
+ */
+void regulator_drms_notify_load(struct regulator *regulator, int uA);
+
+/**
+ * regulator_get_drvdata - get regulator driver data
+ * @regulator: regulator
+ */
+void *regulator_get_drvdata(struct regulator *regulator);
+
+/**
+ * regulator_set_drvdata - get regulator driver data
+ * @regulator: regulator
+ * @data: data
+ */
+void regulator_set_drvdata(struct regulator *regulator, void *data);
+
+#else
+
+/*
+ * Make sure client drivers will still build on systems with no software
+ * controllable voltage or current regulators.
+ */
+#define regulator_get(dev, id)	({ (void)(dev); (void)(id); NULL; })
+#define regulator_put(regulator) do { (void)(regulator);} while (0)
+#define regulator_enable(regulator) ({ (void)(regulator); 0; })
+#define regulator_disable(regulator) ({ (void)(regulator); 0; })
+#define regulator_is_enabled(regulator) ({ (void)(regulator); 1; })
+#define regulator_set_voltage(regulator, uV) \
+	({ (void)(regulator); (void)(uV); 0; })
+#define regulator_get_voltage(regulator) ({ (void)(regulator); 0; })
+#define regulator_set_current(regulator, uA) \
+	({ (void)(regulator); (void)(uA); 0; })
+#define regulator_get_current(regulator) ({ (void)(regulator); 0; })
+#define regulator_set_mode(regulator, mode) \
+	({ (void)(regulator); (void)(mode); 0; })
+#define regulator_get_mode(regulator) ({ (void)(regulator); 0; })
+#define regulator_get_optimum_mode(regulator, input_uV, output_uV, load_uA) \
+	({ (void)(regulator); (void)(input_uV); (void)(output_uV);\
+		(void)(load_uA); 0; })
+#define regulator_register_client(regulator, nb) \
+	({ (void)(regulator); (void)(nb); 0; })
+#define regulator_unregister_client(regulator, nb) \
+	do { (void)(regulator); (void)(nb);} while (0)
+#define regulator_notify_load(regulator, dev, uA) \
+	do { (void)(regulator); (void)(dev); (void)(uA);} while (0)
+#define regulator_get_drvdata(regulator) ({ (void)(regulator); NULL; })
+#define regulator_set_drvdata(regulator, data) \
+	do { (void)(regulator); (void)(data);} while (0)
+
+#endif
+
+#endif
-- 
1.5.4.2



