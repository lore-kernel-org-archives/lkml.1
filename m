Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbYGJP22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbYGJP22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759152AbYGJP1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:27:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45146 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759127AbYGJP1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:27:00 -0400
Subject: [PATCH 10/15] regulator: documentation - consumer interface
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 16:26:58 +0100
Message-Id: <1215703618.13431.66.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds documentation describing the consumer device interface.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 Documentation/power/regulator/consumer.txt |  182 ++++++++++++++++++++++++++++
 1 files changed, 182 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/power/regulator/consumer.txt

diff --git a/Documentation/power/regulator/consumer.txt b/Documentation/power/regulator/consumer.txt
new file mode 100644
index 0000000..9ea688d
--- /dev/null
+++ b/Documentation/power/regulator/consumer.txt
@@ -0,0 +1,182 @@
+Regulator Consumer Driver Interface
+===================================
+
+This text describes the regulator interface for consumer device drivers.
+Please see overview.txt for a description of the terms used in this text.
+
+
+1. Consumer Regulator Access (static & dynamic drivers)
+=======================================================
+
+A consumer driver can get access to it's supply regulator by calling :-
+
+regulator = regulator_get(dev, "Vcc");
+
+The consumer passes in it's struct device pointer and power supply ID. The core
+then finds the correct regulator by consulting a machine specific lookup table.
+If the lookup is successful then this call will return a pointer to the struct
+regulator that supplies this consumer.
+
+To release the regulator the consumer driver should call :-
+
+regulator_put(regulator);
+
+Consumers can be supplied by more than one regulator e.g. codec consumer with
+analog and digital supplies :-
+
+digital = regulator_get(dev, "Vcc");  /* digital core */
+analog = regulator_get(dev, "Avdd");  /* analog */
+
+The regulator access functions regulator_get() and regulator_put() will
+usually be called in your device drivers probe() and remove() respectively.
+
+
+2. Regulator Output Enable & Disable (static & dynamic drivers)
+====================================================================
+
+A consumer can enable it's power supply by calling:-
+
+int regulator_enable(regulator);
+
+NOTE: The supply may already be enabled before regulator_enabled() is called.
+This may happen if the consumer shares the regulator or the regulator has been
+previously enabled by bootloader or kernel board initialisation code.
+
+A consumer can determine if a regulator is enabled by calling :-
+
+int regulator_is_enabled(regulator);
+
+This will return > zero when the regulator is enabled.
+
+
+A consumer can disable it's supply when no longer needed by calling :-
+
+int regulator_disable(regulator);
+
+NOTE: This may not disable the supply if it's shared with other consumers. The
+regulator will only be disabled when the enabled reference count is zero.
+
+Finally, a regulator can be forcefully disabled in the case of an emergency :-
+
+int regulator_force_disable(regulator);
+
+NOTE: this will immediately and forcefully shutdown the regulator output. All
+consumers will be powered off.
+
+
+3. Regulator Voltage Control & Status (dynamic drivers)
+======================================================
+
+Some consumer drivers need to be able to dynamically change their supply
+voltage to match system operating points. e.g. CPUfreq drivers can scale
+voltage along with frequency to save power, SD drivers may need to select the
+correct card voltage, etc.
+
+Consumers can control their supply voltage by calling :-
+
+int regulator_set_voltage(regulator, min_uV, max_uV);
+
+Where min_uV and max_uV are the minimum and maximum acceptable voltages in
+microvolts.
+
+NOTE: this can be called when the regulator is enabled or disabled. If called
+when enabled, then the voltage changes instantly, otherwise the voltage
+configuration changes and the voltage is physically set when the regulator is
+next enabled.
+
+The regulators configured voltage output can be found by calling :-
+
+int regulator_get_voltage(regulator);
+
+NOTE: get_voltage() will return the configured output voltage whether the
+regulator is enabled or disabled and should NOT be used to determine regulator
+output state. However this can be used in conjunction with is_enabled() to
+determind the regulator physical output voltage.
+
+
+4. Regulator Current Limit Control & Status (dynamic drivers)
+===========================================================
+
+Some consumer drivers need to be able to dynamically change their supply
+current limit to match system operating points. e.g. LCD backlight driver can
+change the current limit to vary the backlight brightness, USB drivers may want
+to set the limit to 500mA when supplying power.
+
+Consumers can control their supply current limit by calling :-
+
+int regulator_set_current_limit(regulator, min_uV, max_uV);
+
+Where min_uA and max_uA are the minimum and maximum acceptable current limit in
+microamps.
+
+NOTE: this can be called when the regulator is enabled or disabled. If called
+when enabled, then the current limit changes instantly, otherwise the current
+limit configuration changes and the current limit is physically set when the
+regulator is next enabled.
+
+A regulators current limit can be found by calling :-
+
+int regulator_get_current_limit(regulator);
+
+NOTE: get_current_limit() will return the current limit whether the regulator
+is enabled or disabled and should not be used to determine regulator current
+load.
+
+
+5. Regulator Operating Mode Control & Status (dynamic drivers)
+=============================================================
+
+Some consumers can further save system power by changing the operating mode of
+their supply regulator to be more efficient when the consumers operating state
+changes. e.g. consumer driver is idle and subsequently draws less current
+
+Regulator operating mode can be changed indirectly or directly.
+
+Indirect operating mode control.
+--------------------------------
+Consumer drivers can request a change in their supply regulator operating mode
+by calling :-
+
+int regulator_set_optimum_mode(struct regulator *regulator, int load_uA);
+
+This will cause the core to recalculate the total load on the regulator (based
+on all it's consumers) and change operating mode (if necessary and permitted)
+to best match the current operating load.
+
+The load_uA value can be determined from the consumers datasheet. e.g.most
+datasheets have tables showing the max current consumed in certain situations.
+
+Most consumers will use indirect operating mode control since they have no
+knowledge of the regulator or whether the regulator is shared with other
+consumers.
+
+Direct operating mode control.
+------------------------------
+Bespoke or tightly coupled drivers may want to directly control regulator
+operating mode depending on their operating point. This can be achieved by
+calling :-
+
+int regulator_set_mode(struct regulator *regulator, unsigned int mode);
+unsigned int regulator_get_mode(struct regulator *regulator);
+
+Direct mode will only be used by consumers that *know* about the regulator and
+are not sharing the regulator with other consumers.
+
+
+6. Regulator Events
+===================
+Regulators can notify consumers of external events. Events could be received by
+consumers under regulator stress or failure conditions.
+
+Consumers can register interest in regulator events by calling :-
+
+int regulator_register_notifier(struct regulator *regulator,
+			      struct notifier_block *nb);
+
+Consumers can uregister interest by calling :-
+
+int regulator_unregister_notifier(struct regulator *regulator,
+				struct notifier_block *nb);
+
+Regulators use the kernel notifier framework to send event to thier interested
+consumers.
-- 
1.5.4.3



