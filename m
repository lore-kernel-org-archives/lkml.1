Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753794AbYLRKqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbYLRKqp (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYLRKox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:44:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35880 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751575AbYLRKot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:44:49 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 6/6] mfd: Add WM8351 support
Date: Thu, 18 Dec 2008 10:44:44 +0000
Message-Id: <1229597084-12727-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1229597084-12727-5-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081218104301.GA12649@rakim.wolfsonmicro.main>
 <1229597084-12727-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1229597084-12727-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1229597084-12727-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1229597084-12727-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1229597084-12727-5-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8351 is a WM8350 variant. As well as register default changes the
WM8351 has fewer voltage and current regulators than the WM8350.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig             |   16 +
 drivers/mfd/wm8350-core.c       |   47 ++
 drivers/mfd/wm8350-i2c.c        |    1 +
 drivers/mfd/wm8350-regmap.c     | 1044 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm8350/core.h |    4 +
 5 files changed, 1112 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 76a482d..781a279 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -143,6 +143,22 @@ config MFD_WM8350_CONFIG_MODE_3
 	bool
 	depends on MFD_WM8350
 
+config MFD_WM8351_CONFIG_MODE_0
+	bool
+	depends on MFD_WM8350
+
+config MFD_WM8351_CONFIG_MODE_1
+	bool
+	depends on MFD_WM8350
+
+config MFD_WM8351_CONFIG_MODE_2
+	bool
+	depends on MFD_WM8350
+
+config MFD_WM8351_CONFIG_MODE_3
+	bool
+	depends on MFD_WM8350
+
 config MFD_WM8352_CONFIG_MODE_0
 	bool
 	depends on MFD_WM8350
diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 56c363c..e03fe60 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1169,6 +1169,36 @@ static int wm8350_create_cache(struct wm8350 *wm8350, int type, int mode)
 			return -EINVAL;
 		}
 
+	case 1:
+		switch (mode) {
+#ifdef CONFIG_MFD_WM8351_CONFIG_MODE_0
+		case 0:
+			reg_map = wm8351_mode0_defaults;
+			break;
+#endif
+#ifdef CONFIG_MFD_WM8351_CONFIG_MODE_1
+		case 1:
+			reg_map = wm8351_mode1_defaults;
+			break;
+#endif
+#ifdef CONFIG_MFD_WM8351_CONFIG_MODE_2
+		case 2:
+			reg_map = wm8351_mode2_defaults;
+			break;
+#endif
+#ifdef CONFIG_MFD_WM8351_CONFIG_MODE_3
+		case 3:
+			reg_map = wm8351_mode3_defaults;
+			break;
+#endif
+		default:
+			dev_err(wm8350->dev,
+				"WM8351 configuration mode %d not supported\n",
+				mode);
+			return -EINVAL;
+		}
+		break;
+
 	case 2:
 		switch (mode) {
 #ifdef CONFIG_MFD_WM8352_CONFIG_MODE_0
@@ -1327,6 +1357,23 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 		}
 		break;
 
+	case 1:
+		wm8350->pmic.max_dcdc = WM8350_DCDC_4;
+		wm8350->pmic.max_isink = WM8350_ISINK_A;
+
+		switch (chip_rev) {
+		case 0:
+			dev_info(wm8350->dev, "WM8351 Rev A\n");
+			wm8350->power.rev_g_coeff = 1;
+			break;
+
+		default:
+			dev_err(wm8350->dev, "Unknown WM8351 CHIP_REV\n");
+			ret = -ENODEV;
+			goto err;
+		}
+		break;
+
 	case 2:
 		wm8350->pmic.max_dcdc = WM8350_DCDC_6;
 		wm8350->pmic.max_isink = WM8350_ISINK_B;
diff --git a/drivers/mfd/wm8350-i2c.c b/drivers/mfd/wm8350-i2c.c
index 8780512..8d8c932 100644
--- a/drivers/mfd/wm8350-i2c.c
+++ b/drivers/mfd/wm8350-i2c.c
@@ -97,6 +97,7 @@ static int wm8350_i2c_remove(struct i2c_client *i2c)
 
 static const struct i2c_device_id wm8350_i2c_id[] = {
        { "wm8350", 0 },
+       { "wm8351", 0 },
        { "wm8352", 0 },
        { }
 };
diff --git a/drivers/mfd/wm8350-regmap.c b/drivers/mfd/wm8350-regmap.c
index 3e2cc37..68887b8 100644
--- a/drivers/mfd/wm8350-regmap.c
+++ b/drivers/mfd/wm8350-regmap.c
@@ -1074,6 +1074,1050 @@ const u16 wm8350_mode3_defaults[] = {
 };
 #endif
 
+#ifdef CONFIG_MFD_WM8351_CONFIG_MODE_0
+
+#undef WM8350_HAVE_CONFIG_MODE
+#define WM8350_HAVE_CONFIG_MODE
+
+const u16 wm8351_mode0_defaults[] = {
+	0x6143,     /* R0   - Reset/ID */
+	0x0000,     /* R1   - ID */
+	0x0001,     /* R2   - Revision */
+	0x1C02,     /* R3   - System Control 1 */
+	0x0004,     /* R4   - System Control 2 */
+	0x0000,     /* R5   - System Hibernate */
+	0x8A00,     /* R6   - Interface Control */
+	0x0000,     /* R7 */
+	0x8000,     /* R8   - Power mgmt (1) */
+	0x0000,     /* R9   - Power mgmt (2) */
+	0x0000,     /* R10  - Power mgmt (3) */
+	0x2000,     /* R11  - Power mgmt (4) */
+	0x0E00,     /* R12  - Power mgmt (5) */
+	0x0000,     /* R13  - Power mgmt (6) */
+	0x0000,     /* R14  - Power mgmt (7) */
+	0x0000,     /* R15 */
+	0x0000,     /* R16  - RTC Seconds/Minutes */
+	0x0100,     /* R17  - RTC Hours/Day */
+	0x0101,     /* R18  - RTC Date/Month */
+	0x1400,     /* R19  - RTC Year */
+	0x0000,     /* R20  - Alarm Seconds/Minutes */
+	0x0000,     /* R21  - Alarm Hours/Day */
+	0x0000,     /* R22  - Alarm Date/Month */
+	0x0320,     /* R23  - RTC Time Control */
+	0x0000,     /* R24  - System Interrupts */
+	0x0000,     /* R25  - Interrupt Status 1 */
+	0x0000,     /* R26  - Interrupt Status 2 */
+	0x0000,     /* R27 */
+	0x0000,     /* R28  - Under Voltage Interrupt status */
+	0x0000,     /* R29  - Over Current Interrupt status */
+	0x0000,     /* R30  - GPIO Interrupt Status */
+	0x0000,     /* R31  - Comparator Interrupt Status */
+	0x3FFF,     /* R32  - System Interrupts Mask */
+	0x0000,     /* R33  - Interrupt Status 1 Mask */
+	0x0000,     /* R34  - Interrupt Status 2 Mask */
+	0x0000,     /* R35 */
+	0x0000,     /* R36  - Under Voltage Interrupt status Mask */
+	0x0000,     /* R37  - Over Current Interrupt status Mask */
+	0x0000,     /* R38  - GPIO Interrupt Status Mask */
+	0x0000,     /* R39  - Comparator Interrupt Status Mask */
+	0x0040,     /* R40  - Clock Control 1 */
+	0x0000,     /* R41  - Clock Control 2 */
+	0x3A00,     /* R42  - FLL Control 1 */
+	0x7086,     /* R43  - FLL Control 2 */
+	0xC226,     /* R44  - FLL Control 3 */
+	0x0000,     /* R45  - FLL Control 4 */
+	0x0000,     /* R46 */
+	0x0000,     /* R47 */
+	0x0000,     /* R48  - DAC Control */
+	0x0000,     /* R49 */
+	0x00C0,     /* R50  - DAC Digital Volume L */
+	0x00C0,     /* R51  - DAC Digital Volume R */
+	0x0000,     /* R52 */
+	0x0040,     /* R53  - DAC LR Rate */
+	0x0000,     /* R54  - DAC Clock Control */
+	0x0000,     /* R55 */
+	0x0000,     /* R56 */
+	0x0000,     /* R57 */
+	0x4000,     /* R58  - DAC Mute */
+	0x0000,     /* R59  - DAC Mute Volume */
+	0x0000,     /* R60  - DAC Side */
+	0x0000,     /* R61 */
+	0x0000,     /* R62 */
+	0x0000,     /* R63 */
+	0x8000,     /* R64  - ADC Control */
+	0x0000,     /* R65 */
+	0x00C0,     /* R66  - ADC Digital Volume L */
+	0x00C0,     /* R67  - ADC Digital Volume R */
+	0x0000,     /* R68  - ADC Divider */
+	0x0000,     /* R69 */
+	0x0040,     /* R70  - ADC LR Rate */
+	0x0000,     /* R71 */
+	0x0303,     /* R72  - Input Control */
+	0x0000,     /* R73  - IN3 Input Control */
+	0x0000,     /* R74  - Mic Bias Control */
+	0x0000,     /* R75 */
+	0x0000,     /* R76  - Output Control */
+	0x0000,     /* R77  - Jack Detect */
+	0x0000,     /* R78  - Anti Pop Control */
+	0x0000,     /* R79 */
+	0x0040,     /* R80  - Left Input Volume */
+	0x0040,     /* R81  - Right Input Volume */
+	0x0000,     /* R82 */
+	0x0000,     /* R83 */
+	0x0000,     /* R84 */
+	0x0000,     /* R85 */
+	0x0000,     /* R86 */
+	0x0000,     /* R87 */
+	0x0800,     /* R88  - Left Mixer Control */
+	0x1000,     /* R89  - Right Mixer Control */
+	0x0000,     /* R90 */
+	0x0000,     /* R91 */
+	0x0000,     /* R92  - OUT3 Mixer Control */
+	0x0000,     /* R93  - OUT4 Mixer Control */
+	0x0000,     /* R94 */
+	0x0000,     /* R95 */
+	0x0000,     /* R96  - Output Left Mixer Volume */
+	0x0000,     /* R97  - Output Right Mixer Volume */
+	0x0000,     /* R98  - Input Mixer Volume L */
+	0x0000,     /* R99  - Input Mixer Volume R */
+	0x0000,     /* R100 - Input Mixer Volume */
+	0x0000,     /* R101 */
+	0x0000,     /* R102 */
+	0x0000,     /* R103 */
+	0x00E4,     /* R104 - OUT1L Volume */
+	0x00E4,     /* R105 - OUT1R Volume */
+	0x00E4,     /* R106 - OUT2L Volume */
+	0x02E4,     /* R107 - OUT2R Volume */
+	0x0000,     /* R108 */
+	0x0000,     /* R109 */
+	0x0000,     /* R110 */
+	0x0000,     /* R111 - BEEP Volume */
+	0x0A00,     /* R112 - AI Formating */
+	0x0000,     /* R113 - ADC DAC COMP */
+	0x0020,     /* R114 - AI ADC Control */
+	0x0020,     /* R115 - AI DAC Control */
+	0x0000,     /* R116 */
+	0x0000,     /* R117 */
+	0x0000,     /* R118 */
+	0x0000,     /* R119 */
+	0x0000,     /* R120 */
+	0x0000,     /* R121 */
+	0x0000,     /* R122 */
+	0x0000,     /* R123 */
+	0x0000,     /* R124 */
+	0x0000,     /* R125 */
+	0x0000,     /* R126 */
+	0x0000,     /* R127 */
+	0x1FFF,     /* R128 - GPIO Debounce */
+	0x0000,     /* R129 - GPIO Pin pull up Control */
+	0x0000,     /* R130 - GPIO Pull down Control */
+	0x0000,     /* R131 - GPIO Interrupt Mode */
+	0x0000,     /* R132 */
+	0x0000,     /* R133 - GPIO Control */
+	0x0FFC,     /* R134 - GPIO Configuration (i/o) */
+	0x0FFC,     /* R135 - GPIO Pin Polarity / Type */
+	0x0000,     /* R136 */
+	0x0000,     /* R137 */
+	0x0000,     /* R138 */
+	0x0000,     /* R139 */
+	0x0013,     /* R140 - GPIO Function Select 1 */
+	0x0000,     /* R141 - GPIO Function Select 2 */
+	0x0000,     /* R142 - GPIO Function Select 3 */
+	0x0003,     /* R143 - GPIO Function Select 4 */
+	0x0000,     /* R144 - Digitiser Control (1) */
+	0x0002,     /* R145 - Digitiser Control (2) */
+	0x0000,     /* R146 */
+	0x0000,     /* R147 */
+	0x0000,     /* R148 */
+	0x0000,     /* R149 */
+	0x0000,     /* R150 */
+	0x0000,     /* R151 */
+	0x7000,     /* R152 - AUX1 Readback */
+	0x7000,     /* R153 - AUX2 Readback */
+	0x7000,     /* R154 - AUX3 Readback */
+	0x7000,     /* R155 - AUX4 Readback */
+	0x0000,     /* R156 - USB Voltage Readback */
+	0x0000,     /* R157 - LINE Voltage Readback */
+	0x0000,     /* R158 - BATT Voltage Readback */
+	0x0000,     /* R159 - Chip Temp Readback */
+	0x0000,     /* R160 */
+	0x0000,     /* R161 */
+	0x0000,     /* R162 */
+	0x0000,     /* R163 - Generic Comparator Control */
+	0x0000,     /* R164 - Generic comparator 1 */
+	0x0000,     /* R165 - Generic comparator 2 */
+	0x0000,     /* R166 - Generic comparator 3 */
+	0x0000,     /* R167 - Generic comparator 4 */
+	0xA00F,     /* R168 - Battery Charger Control 1 */
+	0x0B06,     /* R169 - Battery Charger Control 2 */
+	0x0000,     /* R170 - Battery Charger Control 3 */
+	0x0000,     /* R171 */
+	0x0000,     /* R172 - Current Sink Driver A */
+	0x0000,     /* R173 - CSA Flash control */
+	0x0000,     /* R174 */
+	0x0000,     /* R175 */
+	0x0000,     /* R176 - DCDC/LDO requested */
+	0x032D,     /* R177 - DCDC Active options */
+	0x0000,     /* R178 - DCDC Sleep options */
+	0x0025,     /* R179 - Power-check comparator */
+	0x000E,     /* R180 - DCDC1 Control */
+	0x0000,     /* R181 - DCDC1 Timeouts */
+	0x1006,     /* R182 - DCDC1 Low Power */
+	0x0018,     /* R183 - DCDC2 Control */
+	0x0000,     /* R184 - DCDC2 Timeouts */
+	0x0000,     /* R185 */
+	0x0000,     /* R186 - DCDC3 Control */
+	0x0000,     /* R187 - DCDC3 Timeouts */
+	0x0006,     /* R188 - DCDC3 Low Power */
+	0x0000,     /* R189 - DCDC4 Control */
+	0x0000,     /* R190 - DCDC4 Timeouts */
+	0x0006,     /* R191 - DCDC4 Low Power */
+	0x0008,     /* R192 */
+	0x0000,     /* R193 */
+	0x0000,     /* R194 */
+	0x0000,     /* R195 */
+	0x0000,     /* R196 */
+	0x0006,     /* R197 */
+	0x0000,     /* R198 */
+	0x0003,     /* R199 - Limit Switch Control */
+	0x001C,     /* R200 - LDO1 Control */
+	0x0000,     /* R201 - LDO1 Timeouts */
+	0x001C,     /* R202 - LDO1 Low Power */
+	0x001B,     /* R203 - LDO2 Control */
+	0x0000,     /* R204 - LDO2 Timeouts */
+	0x001C,     /* R205 - LDO2 Low Power */
+	0x001B,     /* R206 - LDO3 Control */
+	0x0000,     /* R207 - LDO3 Timeouts */
+	0x001C,     /* R208 - LDO3 Low Power */
+	0x001B,     /* R209 - LDO4 Control */
+	0x0000,     /* R210 - LDO4 Timeouts */
+	0x001C,     /* R211 - LDO4 Low Power */
+	0x0000,     /* R212 */
+	0x0000,     /* R213 */
+	0x0000,     /* R214 */
+	0x0000,     /* R215 - VCC_FAULT Masks */
+	0x001F,     /* R216 - Main Bandgap Control */
+	0x0000,     /* R217 - OSC Control */
+	0x9000,     /* R218 - RTC Tick Control */
+	0x0000,     /* R219 - Security1 */
+	0x4000,     /* R220 */
+	0x0000,     /* R221 */
+	0x0000,     /* R222 */
+	0x0000,     /* R223 */
+	0x0000,     /* R224 - Signal overrides */
+	0x0000,     /* R225 - DCDC/LDO status */
+	0x0000,     /* R226 - Charger Overides/status */
+	0x0000,     /* R227 - misc overrides */
+	0x0000,     /* R228 - Supply overrides/status 1 */
+	0x0000,     /* R229 - Supply overrides/status 2 */
+	0xE000,     /* R230 - GPIO Pin Status */
+	0x0000,     /* R231 - comparotor overrides */
+	0x0000,     /* R232 */
+	0x0000,     /* R233 - State Machine status */
+	0x1200,     /* R234 - FLL Test 1 */
+	0x0000,     /* R235 */
+	0x8000,     /* R236 */
+	0x0000,     /* R237 */
+	0x0000,     /* R238 */
+	0x0000,     /* R239 */
+	0x0003,     /* R240 */
+	0x0000,     /* R241 */
+	0x0000,     /* R242 */
+	0x0004,     /* R243 */
+	0x0300,     /* R244 */
+	0x0000,     /* R245 */
+	0x0200,     /* R246 */
+	0x0000,     /* R247 */
+	0x1000,     /* R248 - DCDC1 Test Controls */
+	0x1000,     /* R249 */
+	0x1000,     /* R250 - DCDC3 Test Controls */
+	0x1000,     /* R251 - DCDC4 Test Controls */
+};
+#endif
+
+#ifdef CONFIG_MFD_WM8351_CONFIG_MODE_1
+
+#undef WM8350_HAVE_CONFIG_MODE
+#define WM8350_HAVE_CONFIG_MODE
+
+const u16 wm8351_mode1_defaults[] = {
+	0x6143,     /* R0   - Reset/ID */
+	0x0000,     /* R1   - ID */
+	0x0001,     /* R2   - Revision */
+	0x1C02,     /* R3   - System Control 1 */
+	0x0204,     /* R4   - System Control 2 */
+	0x0000,     /* R5   - System Hibernate */
+	0x8A00,     /* R6   - Interface Control */
+	0x0000,     /* R7 */
+	0x8000,     /* R8   - Power mgmt (1) */
+	0x0000,     /* R9   - Power mgmt (2) */
+	0x0000,     /* R10  - Power mgmt (3) */
+	0x2000,     /* R11  - Power mgmt (4) */
+	0x0E00,     /* R12  - Power mgmt (5) */
+	0x0000,     /* R13  - Power mgmt (6) */
+	0x0000,     /* R14  - Power mgmt (7) */
+	0x0000,     /* R15 */
+	0x0000,     /* R16  - RTC Seconds/Minutes */
+	0x0100,     /* R17  - RTC Hours/Day */
+	0x0101,     /* R18  - RTC Date/Month */
+	0x1400,     /* R19  - RTC Year */
+	0x0000,     /* R20  - Alarm Seconds/Minutes */
+	0x0000,     /* R21  - Alarm Hours/Day */
+	0x0000,     /* R22  - Alarm Date/Month */
+	0x0320,     /* R23  - RTC Time Control */
+	0x0000,     /* R24  - System Interrupts */
+	0x0000,     /* R25  - Interrupt Status 1 */
+	0x0000,     /* R26  - Interrupt Status 2 */
+	0x0000,     /* R27 */
+	0x0000,     /* R28  - Under Voltage Interrupt status */
+	0x0000,     /* R29  - Over Current Interrupt status */
+	0x0000,     /* R30  - GPIO Interrupt Status */
+	0x0000,     /* R31  - Comparator Interrupt Status */
+	0x3FFF,     /* R32  - System Interrupts Mask */
+	0x0000,     /* R33  - Interrupt Status 1 Mask */
+	0x0000,     /* R34  - Interrupt Status 2 Mask */
+	0x0000,     /* R35 */
+	0x0000,     /* R36  - Under Voltage Interrupt status Mask */
+	0x0000,     /* R37  - Over Current Interrupt status Mask */
+	0x0000,     /* R38  - GPIO Interrupt Status Mask */
+	0x0000,     /* R39  - Comparator Interrupt Status Mask */
+	0x0040,     /* R40  - Clock Control 1 */
+	0x0000,     /* R41  - Clock Control 2 */
+	0x3A00,     /* R42  - FLL Control 1 */
+	0x7086,     /* R43  - FLL Control 2 */
+	0xC226,     /* R44  - FLL Control 3 */
+	0x0000,     /* R45  - FLL Control 4 */
+	0x0000,     /* R46 */
+	0x0000,     /* R47 */
+	0x0000,     /* R48  - DAC Control */
+	0x0000,     /* R49 */
+	0x00C0,     /* R50  - DAC Digital Volume L */
+	0x00C0,     /* R51  - DAC Digital Volume R */
+	0x0000,     /* R52 */
+	0x0040,     /* R53  - DAC LR Rate */
+	0x0000,     /* R54  - DAC Clock Control */
+	0x0000,     /* R55 */
+	0x0000,     /* R56 */
+	0x0000,     /* R57 */
+	0x4000,     /* R58  - DAC Mute */
+	0x0000,     /* R59  - DAC Mute Volume */
+	0x0000,     /* R60  - DAC Side */
+	0x0000,     /* R61 */
+	0x0000,     /* R62 */
+	0x0000,     /* R63 */
+	0x8000,     /* R64  - ADC Control */
+	0x0000,     /* R65 */
+	0x00C0,     /* R66  - ADC Digital Volume L */
+	0x00C0,     /* R67  - ADC Digital Volume R */
+	0x0000,     /* R68  - ADC Divider */
+	0x0000,     /* R69 */
+	0x0040,     /* R70  - ADC LR Rate */
+	0x0000,     /* R71 */
+	0x0303,     /* R72  - Input Control */
+	0x0000,     /* R73  - IN3 Input Control */
+	0x0000,     /* R74  - Mic Bias Control */
+	0x0000,     /* R75 */
+	0x0000,     /* R76  - Output Control */
+	0x0000,     /* R77  - Jack Detect */
+	0x0000,     /* R78  - Anti Pop Control */
+	0x0000,     /* R79 */
+	0x0040,     /* R80  - Left Input Volume */
+	0x0040,     /* R81  - Right Input Volume */
+	0x0000,     /* R82 */
+	0x0000,     /* R83 */
+	0x0000,     /* R84 */
+	0x0000,     /* R85 */
+	0x0000,     /* R86 */
+	0x0000,     /* R87 */
+	0x0800,     /* R88  - Left Mixer Control */
+	0x1000,     /* R89  - Right Mixer Control */
+	0x0000,     /* R90 */
+	0x0000,     /* R91 */
+	0x0000,     /* R92  - OUT3 Mixer Control */
+	0x0000,     /* R93  - OUT4 Mixer Control */
+	0x0000,     /* R94 */
+	0x0000,     /* R95 */
+	0x0000,     /* R96  - Output Left Mixer Volume */
+	0x0000,     /* R97  - Output Right Mixer Volume */
+	0x0000,     /* R98  - Input Mixer Volume L */
+	0x0000,     /* R99  - Input Mixer Volume R */
+	0x0000,     /* R100 - Input Mixer Volume */
+	0x0000,     /* R101 */
+	0x0000,     /* R102 */
+	0x0000,     /* R103 */
+	0x00E4,     /* R104 - OUT1L Volume */
+	0x00E4,     /* R105 - OUT1R Volume */
+	0x00E4,     /* R106 - OUT2L Volume */
+	0x02E4,     /* R107 - OUT2R Volume */
+	0x0000,     /* R108 */
+	0x0000,     /* R109 */
+	0x0000,     /* R110 */
+	0x0000,     /* R111 - BEEP Volume */
+	0x0A00,     /* R112 - AI Formating */
+	0x0000,     /* R113 - ADC DAC COMP */
+	0x0020,     /* R114 - AI ADC Control */
+	0x0020,     /* R115 - AI DAC Control */
+	0x0000,     /* R116 */
+	0x0000,     /* R117 */
+	0x0000,     /* R118 */
+	0x0000,     /* R119 */
+	0x0000,     /* R120 */
+	0x0000,     /* R121 */
+	0x0000,     /* R122 */
+	0x0000,     /* R123 */
+	0x0000,     /* R124 */
+	0x0000,     /* R125 */
+	0x0000,     /* R126 */
+	0x0000,     /* R127 */
+	0x1FFF,     /* R128 - GPIO Debounce */
+	0x0000,     /* R129 - GPIO Pin pull up Control */
+	0x0000,     /* R130 - GPIO Pull down Control */
+	0x0000,     /* R131 - GPIO Interrupt Mode */
+	0x0000,     /* R132 */
+	0x0000,     /* R133 - GPIO Control */
+	0x0CFB,     /* R134 - GPIO Configuration (i/o) */
+	0x0C1F,     /* R135 - GPIO Pin Polarity / Type */
+	0x0000,     /* R136 */
+	0x0000,     /* R137 */
+	0x0000,     /* R138 */
+	0x0000,     /* R139 */
+	0x0300,     /* R140 - GPIO Function Select 1 */
+	0x1110,     /* R141 - GPIO Function Select 2 */
+	0x0013,     /* R142 - GPIO Function Select 3 */
+	0x0003,     /* R143 - GPIO Function Select 4 */
+	0x0000,     /* R144 - Digitiser Control (1) */
+	0x0002,     /* R145 - Digitiser Control (2) */
+	0x0000,     /* R146 */
+	0x0000,     /* R147 */
+	0x0000,     /* R148 */
+	0x0000,     /* R149 */
+	0x0000,     /* R150 */
+	0x0000,     /* R151 */
+	0x7000,     /* R152 - AUX1 Readback */
+	0x7000,     /* R153 - AUX2 Readback */
+	0x7000,     /* R154 - AUX3 Readback */
+	0x7000,     /* R155 - AUX4 Readback */
+	0x0000,     /* R156 - USB Voltage Readback */
+	0x0000,     /* R157 - LINE Voltage Readback */
+	0x0000,     /* R158 - BATT Voltage Readback */
+	0x0000,     /* R159 - Chip Temp Readback */
+	0x0000,     /* R160 */
+	0x0000,     /* R161 */
+	0x0000,     /* R162 */
+	0x0000,     /* R163 - Generic Comparator Control */
+	0x0000,     /* R164 - Generic comparator 1 */
+	0x0000,     /* R165 - Generic comparator 2 */
+	0x0000,     /* R166 - Generic comparator 3 */
+	0x0000,     /* R167 - Generic comparator 4 */
+	0xA00F,     /* R168 - Battery Charger Control 1 */
+	0x0B06,     /* R169 - Battery Charger Control 2 */
+	0x0000,     /* R170 - Battery Charger Control 3 */
+	0x0000,     /* R171 */
+	0x0000,     /* R172 - Current Sink Driver A */
+	0x0000,     /* R173 - CSA Flash control */
+	0x0000,     /* R174 */
+	0x0000,     /* R175 */
+	0x0000,     /* R176 - DCDC/LDO requested */
+	0x032D,     /* R177 - DCDC Active options */
+	0x0000,     /* R178 - DCDC Sleep options */
+	0x0025,     /* R179 - Power-check comparator */
+	0x000E,     /* R180 - DCDC1 Control */
+	0x0C00,     /* R181 - DCDC1 Timeouts */
+	0x1006,     /* R182 - DCDC1 Low Power */
+	0x0018,     /* R183 - DCDC2 Control */
+	0x0000,     /* R184 - DCDC2 Timeouts */
+	0x0000,     /* R185 */
+	0x0026,     /* R186 - DCDC3 Control */
+	0x0400,     /* R187 - DCDC3 Timeouts */
+	0x0006,     /* R188 - DCDC3 Low Power */
+	0x0062,     /* R189 - DCDC4 Control */
+	0x0800,     /* R190 - DCDC4 Timeouts */
+	0x0006,     /* R191 - DCDC4 Low Power */
+	0x0008,     /* R192 */
+	0x0000,     /* R193 */
+	0x0000,     /* R194 */
+	0x000A,     /* R195 */
+	0x1000,     /* R196 */
+	0x0006,     /* R197 */
+	0x0000,     /* R198 */
+	0x0003,     /* R199 - Limit Switch Control */
+	0x0006,     /* R200 - LDO1 Control */
+	0x0000,     /* R201 - LDO1 Timeouts */
+	0x001C,     /* R202 - LDO1 Low Power */
+	0x0010,     /* R203 - LDO2 Control */
+	0x0C00,     /* R204 - LDO2 Timeouts */
+	0x001C,     /* R205 - LDO2 Low Power */
+	0x001F,     /* R206 - LDO3 Control */
+	0x0800,     /* R207 - LDO3 Timeouts */
+	0x001C,     /* R208 - LDO3 Low Power */
+	0x000A,     /* R209 - LDO4 Control */
+	0x0800,     /* R210 - LDO4 Timeouts */
+	0x001C,     /* R211 - LDO4 Low Power */
+	0x0000,     /* R212 */
+	0x0000,     /* R213 */
+	0x0000,     /* R214 */
+	0x0000,     /* R215 - VCC_FAULT Masks */
+	0x001F,     /* R216 - Main Bandgap Control */
+	0x0000,     /* R217 - OSC Control */
+	0x9000,     /* R218 - RTC Tick Control */
+	0x0000,     /* R219 - Security1 */
+	0x4000,     /* R220 */
+	0x0000,     /* R221 */
+	0x0000,     /* R222 */
+	0x0000,     /* R223 */
+	0x0000,     /* R224 - Signal overrides */
+	0x0000,     /* R225 - DCDC/LDO status */
+	0x0000,     /* R226 - Charger Overides/status */
+	0x0000,     /* R227 - misc overrides */
+	0x0000,     /* R228 - Supply overrides/status 1 */
+	0x0000,     /* R229 - Supply overrides/status 2 */
+	0xE000,     /* R230 - GPIO Pin Status */
+	0x0000,     /* R231 - comparotor overrides */
+	0x0000,     /* R232 */
+	0x0000,     /* R233 - State Machine status */
+	0x1200,     /* R234 - FLL Test 1 */
+	0x0000,     /* R235 */
+	0x8000,     /* R236 */
+	0x0000,     /* R237 */
+	0x0000,     /* R238 */
+	0x0000,     /* R239 */
+	0x0003,     /* R240 */
+	0x0000,     /* R241 */
+	0x0000,     /* R242 */
+	0x0004,     /* R243 */
+	0x0300,     /* R244 */
+	0x0000,     /* R245 */
+	0x0200,     /* R246 */
+	0x1000,     /* R247 */
+	0x1000,     /* R248 - DCDC1 Test Controls */
+	0x1000,     /* R249 */
+	0x1000,     /* R250 - DCDC3 Test Controls */
+	0x1000,     /* R251 - DCDC4 Test Controls */
+};
+#endif
+
+#ifdef CONFIG_MFD_WM8351_CONFIG_MODE_2
+
+#undef WM8350_HAVE_CONFIG_MODE
+#define WM8350_HAVE_CONFIG_MODE
+
+const u16 wm8351_mode2_defaults[] = {
+	0x6143,     /* R0   - Reset/ID */
+	0x0000,     /* R1   - ID */
+	0x0001,     /* R2   - Revision */
+	0x1C02,     /* R3   - System Control 1 */
+	0x0214,     /* R4   - System Control 2 */
+	0x0000,     /* R5   - System Hibernate */
+	0x8A00,     /* R6   - Interface Control */
+	0x0000,     /* R7 */
+	0x8000,     /* R8   - Power mgmt (1) */
+	0x0000,     /* R9   - Power mgmt (2) */
+	0x0000,     /* R10  - Power mgmt (3) */
+	0x2000,     /* R11  - Power mgmt (4) */
+	0x0E00,     /* R12  - Power mgmt (5) */
+	0x0000,     /* R13  - Power mgmt (6) */
+	0x0000,     /* R14  - Power mgmt (7) */
+	0x0000,     /* R15 */
+	0x0000,     /* R16  - RTC Seconds/Minutes */
+	0x0100,     /* R17  - RTC Hours/Day */
+	0x0101,     /* R18  - RTC Date/Month */
+	0x1400,     /* R19  - RTC Year */
+	0x0000,     /* R20  - Alarm Seconds/Minutes */
+	0x0000,     /* R21  - Alarm Hours/Day */
+	0x0000,     /* R22  - Alarm Date/Month */
+	0x0320,     /* R23  - RTC Time Control */
+	0x0000,     /* R24  - System Interrupts */
+	0x0000,     /* R25  - Interrupt Status 1 */
+	0x0000,     /* R26  - Interrupt Status 2 */
+	0x0000,     /* R27 */
+	0x0000,     /* R28  - Under Voltage Interrupt status */
+	0x0000,     /* R29  - Over Current Interrupt status */
+	0x0000,     /* R30  - GPIO Interrupt Status */
+	0x0000,     /* R31  - Comparator Interrupt Status */
+	0x3FFF,     /* R32  - System Interrupts Mask */
+	0x0000,     /* R33  - Interrupt Status 1 Mask */
+	0x0000,     /* R34  - Interrupt Status 2 Mask */
+	0x0000,     /* R35 */
+	0x0000,     /* R36  - Under Voltage Interrupt status Mask */
+	0x0000,     /* R37  - Over Current Interrupt status Mask */
+	0x0000,     /* R38  - GPIO Interrupt Status Mask */
+	0x0000,     /* R39  - Comparator Interrupt Status Mask */
+	0x0040,     /* R40  - Clock Control 1 */
+	0x0000,     /* R41  - Clock Control 2 */
+	0x3A00,     /* R42  - FLL Control 1 */
+	0x7086,     /* R43  - FLL Control 2 */
+	0xC226,     /* R44  - FLL Control 3 */
+	0x0000,     /* R45  - FLL Control 4 */
+	0x0000,     /* R46 */
+	0x0000,     /* R47 */
+	0x0000,     /* R48  - DAC Control */
+	0x0000,     /* R49 */
+	0x00C0,     /* R50  - DAC Digital Volume L */
+	0x00C0,     /* R51  - DAC Digital Volume R */
+	0x0000,     /* R52 */
+	0x0040,     /* R53  - DAC LR Rate */
+	0x0000,     /* R54  - DAC Clock Control */
+	0x0000,     /* R55 */
+	0x0000,     /* R56 */
+	0x0000,     /* R57 */
+	0x4000,     /* R58  - DAC Mute */
+	0x0000,     /* R59  - DAC Mute Volume */
+	0x0000,     /* R60  - DAC Side */
+	0x0000,     /* R61 */
+	0x0000,     /* R62 */
+	0x0000,     /* R63 */
+	0x8000,     /* R64  - ADC Control */
+	0x0000,     /* R65 */
+	0x00C0,     /* R66  - ADC Digital Volume L */
+	0x00C0,     /* R67  - ADC Digital Volume R */
+	0x0000,     /* R68  - ADC Divider */
+	0x0000,     /* R69 */
+	0x0040,     /* R70  - ADC LR Rate */
+	0x0000,     /* R71 */
+	0x0303,     /* R72  - Input Control */
+	0x0000,     /* R73  - IN3 Input Control */
+	0x0000,     /* R74  - Mic Bias Control */
+	0x0000,     /* R75 */
+	0x0000,     /* R76  - Output Control */
+	0x0000,     /* R77  - Jack Detect */
+	0x0000,     /* R78  - Anti Pop Control */
+	0x0000,     /* R79 */
+	0x0040,     /* R80  - Left Input Volume */
+	0x0040,     /* R81  - Right Input Volume */
+	0x0000,     /* R82 */
+	0x0000,     /* R83 */
+	0x0000,     /* R84 */
+	0x0000,     /* R85 */
+	0x0000,     /* R86 */
+	0x0000,     /* R87 */
+	0x0800,     /* R88  - Left Mixer Control */
+	0x1000,     /* R89  - Right Mixer Control */
+	0x0000,     /* R90 */
+	0x0000,     /* R91 */
+	0x0000,     /* R92  - OUT3 Mixer Control */
+	0x0000,     /* R93  - OUT4 Mixer Control */
+	0x0000,     /* R94 */
+	0x0000,     /* R95 */
+	0x0000,     /* R96  - Output Left Mixer Volume */
+	0x0000,     /* R97  - Output Right Mixer Volume */
+	0x0000,     /* R98  - Input Mixer Volume L */
+	0x0000,     /* R99  - Input Mixer Volume R */
+	0x0000,     /* R100 - Input Mixer Volume */
+	0x0000,     /* R101 */
+	0x0000,     /* R102 */
+	0x0000,     /* R103 */
+	0x00E4,     /* R104 - OUT1L Volume */
+	0x00E4,     /* R105 - OUT1R Volume */
+	0x00E4,     /* R106 - OUT2L Volume */
+	0x02E4,     /* R107 - OUT2R Volume */
+	0x0000,     /* R108 */
+	0x0000,     /* R109 */
+	0x0000,     /* R110 */
+	0x0000,     /* R111 - BEEP Volume */
+	0x0A00,     /* R112 - AI Formating */
+	0x0000,     /* R113 - ADC DAC COMP */
+	0x0020,     /* R114 - AI ADC Control */
+	0x0020,     /* R115 - AI DAC Control */
+	0x0000,     /* R116 */
+	0x0000,     /* R117 */
+	0x0000,     /* R118 */
+	0x0000,     /* R119 */
+	0x0000,     /* R120 */
+	0x0000,     /* R121 */
+	0x0000,     /* R122 */
+	0x0000,     /* R123 */
+	0x0000,     /* R124 */
+	0x0000,     /* R125 */
+	0x0000,     /* R126 */
+	0x0000,     /* R127 */
+	0x1FFF,     /* R128 - GPIO Debounce */
+	0x0000,     /* R129 - GPIO Pin pull up Control */
+	0x0110,     /* R130 - GPIO Pull down Control */
+	0x0000,     /* R131 - GPIO Interrupt Mode */
+	0x0000,     /* R132 */
+	0x0000,     /* R133 - GPIO Control */
+	0x09FA,     /* R134 - GPIO Configuration (i/o) */
+	0x0DF6,     /* R135 - GPIO Pin Polarity / Type */
+	0x0000,     /* R136 */
+	0x0000,     /* R137 */
+	0x0000,     /* R138 */
+	0x0000,     /* R139 */
+	0x1310,     /* R140 - GPIO Function Select 1 */
+	0x0003,     /* R141 - GPIO Function Select 2 */
+	0x2000,     /* R142 - GPIO Function Select 3 */
+	0x0000,     /* R143 - GPIO Function Select 4 */
+	0x0000,     /* R144 - Digitiser Control (1) */
+	0x0002,     /* R145 - Digitiser Control (2) */
+	0x0000,     /* R146 */
+	0x0000,     /* R147 */
+	0x0000,     /* R148 */
+	0x0000,     /* R149 */
+	0x0000,     /* R150 */
+	0x0000,     /* R151 */
+	0x7000,     /* R152 - AUX1 Readback */
+	0x7000,     /* R153 - AUX2 Readback */
+	0x7000,     /* R154 - AUX3 Readback */
+	0x7000,     /* R155 - AUX4 Readback */
+	0x0000,     /* R156 - USB Voltage Readback */
+	0x0000,     /* R157 - LINE Voltage Readback */
+	0x0000,     /* R158 - BATT Voltage Readback */
+	0x0000,     /* R159 - Chip Temp Readback */
+	0x0000,     /* R160 */
+	0x0000,     /* R161 */
+	0x0000,     /* R162 */
+	0x0000,     /* R163 - Generic Comparator Control */
+	0x0000,     /* R164 - Generic comparator 1 */
+	0x0000,     /* R165 - Generic comparator 2 */
+	0x0000,     /* R166 - Generic comparator 3 */
+	0x0000,     /* R167 - Generic comparator 4 */
+	0xA00F,     /* R168 - Battery Charger Control 1 */
+	0x0B06,     /* R169 - Battery Charger Control 2 */
+	0x0000,     /* R170 - Battery Charger Control 3 */
+	0x0000,     /* R171 */
+	0x0000,     /* R172 - Current Sink Driver A */
+	0x0000,     /* R173 - CSA Flash control */
+	0x0000,     /* R174 */
+	0x0000,     /* R175 */
+	0x0000,     /* R176 - DCDC/LDO requested */
+	0x032D,     /* R177 - DCDC Active options */
+	0x0000,     /* R178 - DCDC Sleep options */
+	0x0025,     /* R179 - Power-check comparator */
+	0x001A,     /* R180 - DCDC1 Control */
+	0x0800,     /* R181 - DCDC1 Timeouts */
+	0x1006,     /* R182 - DCDC1 Low Power */
+	0x0018,     /* R183 - DCDC2 Control */
+	0x0000,     /* R184 - DCDC2 Timeouts */
+	0x0000,     /* R185 */
+	0x0056,     /* R186 - DCDC3 Control */
+	0x0400,     /* R187 - DCDC3 Timeouts */
+	0x0006,     /* R188 - DCDC3 Low Power */
+	0x0026,     /* R189 - DCDC4 Control */
+	0x0C00,     /* R190 - DCDC4 Timeouts */
+	0x0006,     /* R191 - DCDC4 Low Power */
+	0x0008,     /* R192 */
+	0x0000,     /* R193 */
+	0x0000,     /* R194 */
+	0x0026,     /* R195 */
+	0x0C00,     /* R196 */
+	0x0006,     /* R197 */
+	0x0000,     /* R198 */
+	0x0003,     /* R199 - Limit Switch Control */
+	0x001C,     /* R200 - LDO1 Control */
+	0x0400,     /* R201 - LDO1 Timeouts */
+	0x001C,     /* R202 - LDO1 Low Power */
+	0x0010,     /* R203 - LDO2 Control */
+	0x0C00,     /* R204 - LDO2 Timeouts */
+	0x001C,     /* R205 - LDO2 Low Power */
+	0x0015,     /* R206 - LDO3 Control */
+	0x0000,     /* R207 - LDO3 Timeouts */
+	0x001C,     /* R208 - LDO3 Low Power */
+	0x001A,     /* R209 - LDO4 Control */
+	0x0000,     /* R210 - LDO4 Timeouts */
+	0x001C,     /* R211 - LDO4 Low Power */
+	0x0000,     /* R212 */
+	0x0000,     /* R213 */
+	0x0000,     /* R214 */
+	0x0000,     /* R215 - VCC_FAULT Masks */
+	0x001F,     /* R216 - Main Bandgap Control */
+	0x0000,     /* R217 - OSC Control */
+	0x9000,     /* R218 - RTC Tick Control */
+	0x0000,     /* R219 - Security1 */
+	0x4000,     /* R220 */
+	0x0000,     /* R221 */
+	0x0000,     /* R222 */
+	0x0000,     /* R223 */
+	0x0000,     /* R224 - Signal overrides */
+	0x0000,     /* R225 - DCDC/LDO status */
+	0x0000,     /* R226 - Charger Overides/status */
+	0x0000,     /* R227 - misc overrides */
+	0x0000,     /* R228 - Supply overrides/status 1 */
+	0x0000,     /* R229 - Supply overrides/status 2 */
+	0xE000,     /* R230 - GPIO Pin Status */
+	0x0000,     /* R231 - comparotor overrides */
+	0x0000,     /* R232 */
+	0x0000,     /* R233 - State Machine status */
+	0x1200,     /* R234 - FLL Test 1 */
+	0x0000,     /* R235 */
+	0x8000,     /* R236 */
+	0x0000,     /* R237 */
+	0x0000,     /* R238 */
+	0x0000,     /* R239 */
+	0x0003,     /* R240 */
+	0x0000,     /* R241 */
+	0x0000,     /* R242 */
+	0x0004,     /* R243 */
+	0x0300,     /* R244 */
+	0x0000,     /* R245 */
+	0x0200,     /* R246 */
+	0x0000,     /* R247 */
+	0x1000,     /* R248 - DCDC1 Test Controls */
+	0x1000,     /* R249 */
+	0x1000,     /* R250 - DCDC3 Test Controls */
+	0x1000,     /* R251 - DCDC4 Test Controls */
+};
+#endif
+
+#ifdef CONFIG_MFD_WM8351_CONFIG_MODE_3
+
+#undef WM8350_HAVE_CONFIG_MODE
+#define WM8350_HAVE_CONFIG_MODE
+
+const u16 wm8351_mode3_defaults[] = {
+	0x6143,     /* R0   - Reset/ID */
+	0x0000,     /* R1   - ID */
+	0x0001,     /* R2   - Revision */
+	0x1C02,     /* R3   - System Control 1 */
+	0x0204,     /* R4   - System Control 2 */
+	0x0000,     /* R5   - System Hibernate */
+	0x8A00,     /* R6   - Interface Control */
+	0x0000,     /* R7 */
+	0x8000,     /* R8   - Power mgmt (1) */
+	0x0000,     /* R9   - Power mgmt (2) */
+	0x0000,     /* R10  - Power mgmt (3) */
+	0x2000,     /* R11  - Power mgmt (4) */
+	0x0E00,     /* R12  - Power mgmt (5) */
+	0x0000,     /* R13  - Power mgmt (6) */
+	0x0000,     /* R14  - Power mgmt (7) */
+	0x0000,     /* R15 */
+	0x0000,     /* R16  - RTC Seconds/Minutes */
+	0x0100,     /* R17  - RTC Hours/Day */
+	0x0101,     /* R18  - RTC Date/Month */
+	0x1400,     /* R19  - RTC Year */
+	0x0000,     /* R20  - Alarm Seconds/Minutes */
+	0x0000,     /* R21  - Alarm Hours/Day */
+	0x0000,     /* R22  - Alarm Date/Month */
+	0x0320,     /* R23  - RTC Time Control */
+	0x0000,     /* R24  - System Interrupts */
+	0x0000,     /* R25  - Interrupt Status 1 */
+	0x0000,     /* R26  - Interrupt Status 2 */
+	0x0000,     /* R27 */
+	0x0000,     /* R28  - Under Voltage Interrupt status */
+	0x0000,     /* R29  - Over Current Interrupt status */
+	0x0000,     /* R30  - GPIO Interrupt Status */
+	0x0000,     /* R31  - Comparator Interrupt Status */
+	0x3FFF,     /* R32  - System Interrupts Mask */
+	0x0000,     /* R33  - Interrupt Status 1 Mask */
+	0x0000,     /* R34  - Interrupt Status 2 Mask */
+	0x0000,     /* R35 */
+	0x0000,     /* R36  - Under Voltage Interrupt status Mask */
+	0x0000,     /* R37  - Over Current Interrupt status Mask */
+	0x0000,     /* R38  - GPIO Interrupt Status Mask */
+	0x0000,     /* R39  - Comparator Interrupt Status Mask */
+	0x0040,     /* R40  - Clock Control 1 */
+	0x0000,     /* R41  - Clock Control 2 */
+	0x3A00,     /* R42  - FLL Control 1 */
+	0x7086,     /* R43  - FLL Control 2 */
+	0xC226,     /* R44  - FLL Control 3 */
+	0x0000,     /* R45  - FLL Control 4 */
+	0x0000,     /* R46 */
+	0x0000,     /* R47 */
+	0x0000,     /* R48  - DAC Control */
+	0x0000,     /* R49 */
+	0x00C0,     /* R50  - DAC Digital Volume L */
+	0x00C0,     /* R51  - DAC Digital Volume R */
+	0x0000,     /* R52 */
+	0x0040,     /* R53  - DAC LR Rate */
+	0x0000,     /* R54  - DAC Clock Control */
+	0x0000,     /* R55 */
+	0x0000,     /* R56 */
+	0x0000,     /* R57 */
+	0x4000,     /* R58  - DAC Mute */
+	0x0000,     /* R59  - DAC Mute Volume */
+	0x0000,     /* R60  - DAC Side */
+	0x0000,     /* R61 */
+	0x0000,     /* R62 */
+	0x0000,     /* R63 */
+	0x8000,     /* R64  - ADC Control */
+	0x0000,     /* R65 */
+	0x00C0,     /* R66  - ADC Digital Volume L */
+	0x00C0,     /* R67  - ADC Digital Volume R */
+	0x0000,     /* R68  - ADC Divider */
+	0x0000,     /* R69 */
+	0x0040,     /* R70  - ADC LR Rate */
+	0x0000,     /* R71 */
+	0x0303,     /* R72  - Input Control */
+	0x0000,     /* R73  - IN3 Input Control */
+	0x0000,     /* R74  - Mic Bias Control */
+	0x0000,     /* R75 */
+	0x0000,     /* R76  - Output Control */
+	0x0000,     /* R77  - Jack Detect */
+	0x0000,     /* R78  - Anti Pop Control */
+	0x0000,     /* R79 */
+	0x0040,     /* R80  - Left Input Volume */
+	0x0040,     /* R81  - Right Input Volume */
+	0x0000,     /* R82 */
+	0x0000,     /* R83 */
+	0x0000,     /* R84 */
+	0x0000,     /* R85 */
+	0x0000,     /* R86 */
+	0x0000,     /* R87 */
+	0x0800,     /* R88  - Left Mixer Control */
+	0x1000,     /* R89  - Right Mixer Control */
+	0x0000,     /* R90 */
+	0x0000,     /* R91 */
+	0x0000,     /* R92  - OUT3 Mixer Control */
+	0x0000,     /* R93  - OUT4 Mixer Control */
+	0x0000,     /* R94 */
+	0x0000,     /* R95 */
+	0x0000,     /* R96  - Output Left Mixer Volume */
+	0x0000,     /* R97  - Output Right Mixer Volume */
+	0x0000,     /* R98  - Input Mixer Volume L */
+	0x0000,     /* R99  - Input Mixer Volume R */
+	0x0000,     /* R100 - Input Mixer Volume */
+	0x0000,     /* R101 */
+	0x0000,     /* R102 */
+	0x0000,     /* R103 */
+	0x00E4,     /* R104 - OUT1L Volume */
+	0x00E4,     /* R105 - OUT1R Volume */
+	0x00E4,     /* R106 - OUT2L Volume */
+	0x02E4,     /* R107 - OUT2R Volume */
+	0x0000,     /* R108 */
+	0x0000,     /* R109 */
+	0x0000,     /* R110 */
+	0x0000,     /* R111 - BEEP Volume */
+	0x0A00,     /* R112 - AI Formating */
+	0x0000,     /* R113 - ADC DAC COMP */
+	0x0020,     /* R114 - AI ADC Control */
+	0x0020,     /* R115 - AI DAC Control */
+	0x0000,     /* R116 */
+	0x0000,     /* R117 */
+	0x0000,     /* R118 */
+	0x0000,     /* R119 */
+	0x0000,     /* R120 */
+	0x0000,     /* R121 */
+	0x0000,     /* R122 */
+	0x0000,     /* R123 */
+	0x0000,     /* R124 */
+	0x0000,     /* R125 */
+	0x0000,     /* R126 */
+	0x0000,     /* R127 */
+	0x1FFF,     /* R128 - GPIO Debounce */
+	0x0010,     /* R129 - GPIO Pin pull up Control */
+	0x0000,     /* R130 - GPIO Pull down Control */
+	0x0000,     /* R131 - GPIO Interrupt Mode */
+	0x0000,     /* R132 */
+	0x0000,     /* R133 - GPIO Control */
+	0x0BFB,     /* R134 - GPIO Configuration (i/o) */
+	0x0FFD,     /* R135 - GPIO Pin Polarity / Type */
+	0x0000,     /* R136 */
+	0x0000,     /* R137 */
+	0x0000,     /* R138 */
+	0x0000,     /* R139 */
+	0x0310,     /* R140 - GPIO Function Select 1 */
+	0x0001,     /* R141 - GPIO Function Select 2 */
+	0x2300,     /* R142 - GPIO Function Select 3 */
+	0x0003,     /* R143 - GPIO Function Select 4 */
+	0x0000,     /* R144 - Digitiser Control (1) */
+	0x0002,     /* R145 - Digitiser Control (2) */
+	0x0000,     /* R146 */
+	0x0000,     /* R147 */
+	0x0000,     /* R148 */
+	0x0000,     /* R149 */
+	0x0000,     /* R150 */
+	0x0000,     /* R151 */
+	0x7000,     /* R152 - AUX1 Readback */
+	0x7000,     /* R153 - AUX2 Readback */
+	0x7000,     /* R154 - AUX3 Readback */
+	0x7000,     /* R155 - AUX4 Readback */
+	0x0000,     /* R156 - USB Voltage Readback */
+	0x0000,     /* R157 - LINE Voltage Readback */
+	0x0000,     /* R158 - BATT Voltage Readback */
+	0x0000,     /* R159 - Chip Temp Readback */
+	0x0000,     /* R160 */
+	0x0000,     /* R161 */
+	0x0000,     /* R162 */
+	0x0000,     /* R163 - Generic Comparator Control */
+	0x0000,     /* R164 - Generic comparator 1 */
+	0x0000,     /* R165 - Generic comparator 2 */
+	0x0000,     /* R166 - Generic comparator 3 */
+	0x0000,     /* R167 - Generic comparator 4 */
+	0xA00F,     /* R168 - Battery Charger Control 1 */
+	0x0B06,     /* R169 - Battery Charger Control 2 */
+	0x0000,     /* R170 - Battery Charger Control 3 */
+	0x0000,     /* R171 */
+	0x0000,     /* R172 - Current Sink Driver A */
+	0x0000,     /* R173 - CSA Flash control */
+	0x0000,     /* R174 */
+	0x0000,     /* R175 */
+	0x0000,     /* R176 - DCDC/LDO requested */
+	0x032D,     /* R177 - DCDC Active options */
+	0x0000,     /* R178 - DCDC Sleep options */
+	0x0025,     /* R179 - Power-check comparator */
+	0x000E,     /* R180 - DCDC1 Control */
+	0x0400,     /* R181 - DCDC1 Timeouts */
+	0x1006,     /* R182 - DCDC1 Low Power */
+	0x0018,     /* R183 - DCDC2 Control */
+	0x0000,     /* R184 - DCDC2 Timeouts */
+	0x0000,     /* R185 */
+	0x0026,     /* R186 - DCDC3 Control */
+	0x0800,     /* R187 - DCDC3 Timeouts */
+	0x0006,     /* R188 - DCDC3 Low Power */
+	0x0062,     /* R189 - DCDC4 Control */
+	0x1400,     /* R190 - DCDC4 Timeouts */
+	0x0006,     /* R191 - DCDC4 Low Power */
+	0x0008,     /* R192 */
+	0x0000,     /* R193 */
+	0x0000,     /* R194 */
+	0x0026,     /* R195 */
+	0x0400,     /* R196 */
+	0x0006,     /* R197 */
+	0x0000,     /* R198 */
+	0x0003,     /* R199 - Limit Switch Control */
+	0x0006,     /* R200 - LDO1 Control */
+	0x0C00,     /* R201 - LDO1 Timeouts */
+	0x001C,     /* R202 - LDO1 Low Power */
+	0x0016,     /* R203 - LDO2 Control */
+	0x0000,     /* R204 - LDO2 Timeouts */
+	0x001C,     /* R205 - LDO2 Low Power */
+	0x0019,     /* R206 - LDO3 Control */
+	0x0000,     /* R207 - LDO3 Timeouts */
+	0x001C,     /* R208 - LDO3 Low Power */
+	0x001A,     /* R209 - LDO4 Control */
+	0x1000,     /* R210 - LDO4 Timeouts */
+	0x001C,     /* R211 - LDO4 Low Power */
+	0x0000,     /* R212 */
+	0x0000,     /* R213 */
+	0x0000,     /* R214 */
+	0x0000,     /* R215 - VCC_FAULT Masks */
+	0x001F,     /* R216 - Main Bandgap Control */
+	0x0000,     /* R217 - OSC Control */
+	0x9000,     /* R218 - RTC Tick Control */
+	0x0000,     /* R219 - Security1 */
+	0x4000,     /* R220 */
+	0x0000,     /* R221 */
+	0x0000,     /* R222 */
+	0x0000,     /* R223 */
+	0x0000,     /* R224 - Signal overrides */
+	0x0000,     /* R225 - DCDC/LDO status */
+	0x0000,     /* R226 - Charger Overides/status */
+	0x0000,     /* R227 - misc overrides */
+	0x0000,     /* R228 - Supply overrides/status 1 */
+	0x0000,     /* R229 - Supply overrides/status 2 */
+	0xE000,     /* R230 - GPIO Pin Status */
+	0x0000,     /* R231 - comparotor overrides */
+	0x0000,     /* R232 */
+	0x0000,     /* R233 - State Machine status */
+	0x1200,     /* R234 - FLL Test 1 */
+	0x0000,     /* R235 */
+	0x8000,     /* R236 */
+	0x0000,     /* R237 */
+	0x0000,     /* R238 */
+	0x0000,     /* R239 */
+	0x0003,     /* R240 */
+	0x0000,     /* R241 */
+	0x0000,     /* R242 */
+	0x0004,     /* R243 */
+	0x0300,     /* R244 */
+	0x0000,     /* R245 */
+	0x0200,     /* R246 */
+	0x0000,     /* R247 */
+	0x1000,     /* R248 - DCDC1 Test Controls */
+	0x1000,     /* R249 */
+	0x1000,     /* R250 - DCDC3 Test Controls */
+	0x1000,     /* R251 - DCDC4 Test Controls */
+};
+#endif
+
 #ifdef CONFIG_MFD_WM8352_CONFIG_MODE_0
 
 #undef WM8350_HAVE_CONFIG_MODE
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 7375790..980669d 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -589,6 +589,10 @@ extern const u16 wm8350_mode0_defaults[];
 extern const u16 wm8350_mode1_defaults[];
 extern const u16 wm8350_mode2_defaults[];
 extern const u16 wm8350_mode3_defaults[];
+extern const u16 wm8351_mode0_defaults[];
+extern const u16 wm8351_mode1_defaults[];
+extern const u16 wm8351_mode2_defaults[];
+extern const u16 wm8351_mode3_defaults[];
 extern const u16 wm8352_mode0_defaults[];
 extern const u16 wm8352_mode1_defaults[];
 extern const u16 wm8352_mode2_defaults[];
-- 
1.5.6.5

