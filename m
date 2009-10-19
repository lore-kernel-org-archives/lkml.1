Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbZJSMLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbZJSMLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 08:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbZJSMLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 08:11:21 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49883 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbZJSMLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 08:11:18 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: sameo@linux.intel.com, linux-omap@vger.kernel.org
Subject: [PATCH 3/5] mfd: twl4030-power: Move power-related data closer together in the header file
Date: Mon, 19 Oct 2009 15:10:52 +0300
Message-Id: <1255954252-29017-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255954211-28496-1-git-send-email-amit.kucheria@verdurent.com>
References: <1255954211-28496-1-git-send-email-amit.kucheria@verdurent.com>
X-OriginalArrivalTime: 19 Oct 2009 12:10:52.0567 (UTC) FILETIME=[34073270:01CA50B5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring together all the TWL power-related data in the header file

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: sameo@linux.intel.com
Cc: linux-omap@vger.kernel.org
---
 include/linux/i2c/twl4030.h |  154 ++++++++++++++++++++++---------------------
 1 files changed, 78 insertions(+), 76 deletions(-)

diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
index 508824e..4bc2836 100644
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -221,13 +221,89 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 
 /*----------------------------------------------------------------------*/
 
+struct twl4030_bci_platform_data {
+	int *battery_tmp_tbl;
+	unsigned int tblsize;
+};
+
+/* TWL4030_GPIO_MAX (18) GPIOs, with interrupts */
+struct twl4030_gpio_platform_data {
+	int		gpio_base;
+	unsigned	irq_base, irq_end;
+
+	/* package the two LED signals as output-only GPIOs? */
+	bool		use_leds;
+
+	/* gpio-n should control VMMC(n+1) if BIT(n) in mmc_cd is set */
+	u8		mmc_cd;
+
+	/* if BIT(N) is set, or VMMC(n+1) is linked, debounce GPIO-N */
+	u32		debounce;
+
+	/* For gpio-N, bit (1 << N) in "pullups" is set if that pullup
+	 * should be enabled.  Else, if that bit is set in "pulldowns",
+	 * that pulldown is enabled.  Don't waste power by letting any
+	 * digital inputs float...
+	 */
+	u32		pullups;
+	u32		pulldowns;
+
+	int		(*setup)(struct device *dev,
+				unsigned gpio, unsigned ngpio);
+	int		(*teardown)(struct device *dev,
+				unsigned gpio, unsigned ngpio);
+};
+
+struct twl4030_madc_platform_data {
+	int		irq_line;
+};
+
+/* Boards have uniqe mappings of {row, col} --> keycode.
+ * Column and row are 8 bits each, but range only from 0..7.
+ * a PERSISTENT_KEY is "always on" and never reported.
+ */
+#define PERSISTENT_KEY(r, c)	KEY((r), (c), KEY_RESERVED)
+
+struct twl4030_keypad_data {
+	const struct matrix_keymap_data *keymap_data;
+	unsigned rows;
+	unsigned cols;
+	bool rep;
+};
+
+enum twl4030_usb_mode {
+	T2_USB_MODE_ULPI = 1,
+	T2_USB_MODE_CEA2011_3PIN = 2,
+};
+
+struct twl4030_usb_data {
+	enum twl4030_usb_mode	usb_mode;
+};
+
+struct twl4030_ins {
+	u16 pmb_message;
+	u8 delay;
+};
+
+struct twl4030_script {
+	struct twl4030_ins *script;
+	unsigned size;
+	u8 flags;
+#define TWL4030_WRST_SCRIPT	(1<<0)
+#define TWL4030_WAKEUP12_SCRIPT	(1<<1)
+#define TWL4030_WAKEUP3_SCRIPT	(1<<2)
+#define TWL4030_SLEEP_SCRIPT	(1<<3)
+};
+
+/*----------------------------------------------------------------------*/
+
 /* Power bus message definitions */
 
 /* The TWL4030/5030 splits its power-management resources (the various
  * regulators, clock and reset lines) into 3 processor groups - P1, P2 and
  * P3. These groups can then be configured to transition between sleep, wait-on
- * and active states by sending messages to the power bus.  See Section 5.4.2
- * Power Resources of TWL4030 TRM
+ * (OFF) and active states by sending messages to the power bus.  See Section
+ * 5.4.2 Power Resources of TWL4030 TRM
  */
 
 /* Processor groups */
@@ -312,80 +388,6 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 
 /*----------------------------------------------------------------------*/
 
-struct twl4030_bci_platform_data {
-	int *battery_tmp_tbl;
-	unsigned int tblsize;
-};
-
-/* TWL4030_GPIO_MAX (18) GPIOs, with interrupts */
-struct twl4030_gpio_platform_data {
-	int		gpio_base;
-	unsigned	irq_base, irq_end;
-
-	/* package the two LED signals as output-only GPIOs? */
-	bool		use_leds;
-
-	/* gpio-n should control VMMC(n+1) if BIT(n) in mmc_cd is set */
-	u8		mmc_cd;
-
-	/* if BIT(N) is set, or VMMC(n+1) is linked, debounce GPIO-N */
-	u32		debounce;
-
-	/* For gpio-N, bit (1 << N) in "pullups" is set if that pullup
-	 * should be enabled.  Else, if that bit is set in "pulldowns",
-	 * that pulldown is enabled.  Don't waste power by letting any
-	 * digital inputs float...
-	 */
-	u32		pullups;
-	u32		pulldowns;
-
-	int		(*setup)(struct device *dev,
-				unsigned gpio, unsigned ngpio);
-	int		(*teardown)(struct device *dev,
-				unsigned gpio, unsigned ngpio);
-};
-
-struct twl4030_madc_platform_data {
-	int		irq_line;
-};
-
-/* Boards have uniqe mappings of {row, col} --> keycode.
- * Column and row are 8 bits each, but range only from 0..7.
- * a PERSISTENT_KEY is "always on" and never reported.
- */
-#define PERSISTENT_KEY(r, c)	KEY((r), (c), KEY_RESERVED)
-
-struct twl4030_keypad_data {
-	const struct matrix_keymap_data *keymap_data;
-	unsigned rows;
-	unsigned cols;
-	bool rep;
-};
-
-enum twl4030_usb_mode {
-	T2_USB_MODE_ULPI = 1,
-	T2_USB_MODE_CEA2011_3PIN = 2,
-};
-
-struct twl4030_usb_data {
-	enum twl4030_usb_mode	usb_mode;
-};
-
-struct twl4030_ins {
-	u16 pmb_message;
-	u8 delay;
-};
-
-struct twl4030_script {
-	struct twl4030_ins *script;
-	unsigned size;
-	u8 flags;
-#define TWL4030_WRST_SCRIPT	(1<<0)
-#define TWL4030_WAKEUP12_SCRIPT	(1<<1)
-#define TWL4030_WAKEUP3_SCRIPT	(1<<2)
-#define TWL4030_SLEEP_SCRIPT	(1<<3)
-};
-
 struct twl4030_resconfig {
 	u8 resource;
 	u8 devgroup;	/* Processor group that Power resource belongs to */
-- 
1.6.3.3

