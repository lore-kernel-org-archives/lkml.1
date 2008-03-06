Return-Path: <linux-kernel-owner+w=401wt.eu-S935709AbYCFSLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935709AbYCFSLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935587AbYCFSLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:11:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42915 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935573AbYCFSK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:10:59 -0500
Subject: [UPDATED v3][PATCH 1/7] regulator: consumer interface
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 18:10:56 +0000
Message-Id: <1204827056.15360.147.camel@a10323.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator framework provides voltage and current power control to
consumer drivers. This allows consumers to control their supply voltages and
current levels.

The framework is similar to the kernel clock interface in that client or
consumer drivers can get() and put() a regulator (like they can with clocks
atm).

Consumers can also get() or set() :- voltage, current, operating mode.
Consumers can also enable and disable regulators.

The framework also compiles out if not in use so drivers can be reused in
systems with no software PMIC power control.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 include/linux/regulator/regulator.h |  264 +++++++++++++++++++++++++++++++++++
 1 files changed, 264 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/regulator/regulator.h

diff --git a/include/linux/regulator/regulator.h b/include/linux/regulator/regulator.h
new file mode 100644
index 0000000..13a93e9
--- /dev/null
+++ b/include/linux/regulator/regulator.h
@@ -0,0 +1,264 @@
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
+ *   idling. Regulator r has > 90% efficiency in NORMAL mode at loads > 100mA
+ *   but this drops rapidly to 60% when below 100mA. Regulator r has > 90%
+ *   efficiency in IDLE mode at loads < 10mA. Thus regulator r will operate
+ *   in normal mode for loads > 10mA and in IDLE mode for load <= 10mA.
+ *
+ *   Dynamic Regulator Voltage Selection (DRVS). Selects the lowest voltage
+ *   output (within system constraints) for a regulator shared between several
+ *   devices. This allows all devices to operate within their voltage range and
+ *   will dynamically change the voltage when devices disable() their supply
+ *   to the next best level (thus saving power). This is based on an idea
+ *   by Amit Kucheria in an RFC to lakml.
+ *
+ *   e.g. devices x,y,z share regulator r. device x and y can operate between
+ *   1800mV and 1900mV, whilst device z can only operate at 1900mV. Regulator
+ *   r will output 1900mV when all devices are in use and 1800mV when devices
+ *   x and y are in use and device z is disabled.
+ */
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
+ *             load can quickly increase with CPU frequency increases.
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
+ *
+ * These modes can be OR'ed together to make up a mask of valid register modes.
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
+ * UNDER_VOLTAGE  Regulator output is under voltage.
+ * OVER_CURRENT   Regulator output current is too high.
+ * POWER_ON       Regulator power ON event.
+ * POWER_OFF      Regulator power OFF event.
+ * REGULATION_OUT Regulator output is out of regulation.
+ * FAIL           Regulator output has failed.
+ * OVER_TEMP      Regulator over temp.
+ *
+ * NOTE: These events can be OR'ed together when passed into handler.
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
+static inline int mV_to_uV(int mV) { return mV * 1000; }
+static inline int uV_to_mV(int uV) { return uV / 1000; }
+static inline int V_to_uV(int V) { return V * 1000000; }
+static inline int uV_to_V(int uV) { return uV / 1000000; }
+static inline int mA_to_uA(int mA) { return mA * 1000; }
+static inline int uA_to_mA(int uA)  {return uA / 1000; }
+static inline int A_to_uA(int A) { return A * 1000000; }
+static inline int uA_to_A(int uA) { return uA / 1000000; }
+
+struct regulator;
+
+#if defined(CONFIG_REGULATOR)
+
+/* regulator get and put */
+struct regulator *__must_check regulator_get(struct device *dev,
+					     const char *id);
+void regulator_put(struct regulator *regulator);
+
+/* regulator output control and status */
+int regulator_enable(struct regulator *regulator);
+int regulator_disable(struct regulator *regulator);
+int regulator_is_enabled(struct regulator *regulator);
+
+int regulator_set_voltage(struct regulator *regulator, int uV);
+int regulator_get_voltage(struct regulator *regulator);
+int regulator_set_current(struct regulator *regulator, int uA);
+int regulator_get_current(struct regulator *regulator);
+
+int regulator_set_mode(struct regulator *regulator, unsigned int mode);
+unsigned int regulator_get_mode(struct regulator *regulator);
+unsigned int regulator_get_optimum_mode(struct regulator *regulator,
+					int input_uV, int output_uV,
+					int load_uA);
+
+/* regulator notifier block */
+int regulator_register_client(struct regulator *regulator,
+			      struct notifier_block *nb);
+int regulator_unregister_client(struct regulator *regulator,
+				struct notifier_block *nb);
+
+/* notify core of likely current draw */
+void regulator_drms_notify_load(struct regulator *regulator, int uA);
+
+/* driver data - core doesn't touch */
+void *regulator_get_drvdata(struct regulator *regulator);
+void regulator_set_drvdata(struct regulator *regulator, void *data);
+
+#else
+
+/*
+ * Make sure client drivers will still build on systems with no software
+ * controllable voltage or current regulators.
+ */
+static inline struct regulator *__must_check regulator_get(struct device *dev,
+	const char *id)
+{
+	return NULL;
+}
+static inline void regulator_put(struct regulator *regulator)
+{
+}
+
+static inline int regulator_enable(struct regulator *regulator)
+{
+	return 0;
+}
+
+static inline int regulator_disable(struct regulator *regulator)
+{
+	return 0;
+}
+
+static inline int regulator_is_enabled(struct regulator *regulator)
+{
+	return 1;
+}
+
+static inline int regulator_set_voltage(struct regulator *regulator, int uV)
+{
+	return 0;
+}
+
+static inline int regulator_get_voltage(struct regulator *regulator)
+{
+	return 0;
+}
+
+static inline int regulator_set_current(struct regulator *regulator, int uA)
+{
+	return 0;
+}
+
+static inline int regulator_get_current(struct regulator *regulator)
+{
+	return 0;
+}
+
+static inline int regulator_set_mode(struct regulator *regulator,
+	unsigned int mode)
+{
+	return 0;
+}
+
+static inline unsigned int regulator_get_mode(struct regulator *regulator)
+{
+	return REGULATOR_MODE_NORMAL;
+}
+
+static inline unsigned int regulator_get_optimum_mode(
+					struct regulator *regulator,
+					int input_uV, int output_uV,
+					int load_uA)
+{
+	return REGULATOR_MODE_NORMAL;
+}
+
+static inline int regulator_register_client(struct regulator *regulator,
+			      struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline int regulator_unregister_client(struct regulator *regulator,
+				struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline void regulator_drms_notify_load(struct regulator *regulator,
+	int uA)
+{
+}
+
+static inline void *regulator_get_drvdata(struct regulator *regulator)
+{
+	return NULL;
+}
+
+static inline void regulator_set_drvdata(struct regulator *regulator,
+	void *data)
+{
+}
+
+#endif
+
+#endif
-- 
1.5.4.3



