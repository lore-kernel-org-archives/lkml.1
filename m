Return-Path: <linux-kernel-owner+w=401wt.eu-S932490AbZKDRgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbZKDRgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932470AbZKDRgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:36:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:57630 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399AbZKDRgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:36:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=KqOlYNmHEzziZiJo/CGbndznHGuLFrxSg2kTk05cJqpFVvMgbCuzKebd/x8mNfZ4Jx
         0M1qRlEl2AisWts3LPLNjs1LU94wHH2u1Iz1HTFvv96+2o7P7Lh2MM0x9SWkp5ZuWQia
         1hkVEw/vjXMOv/wTU4qz5L4Z9Vsuihnfzhc28=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:36:24 +0100
Message-Id: <20091104173624.28463.78147.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 36/41] rt2800: add rt2800lib (part one)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800: add rt2800lib (part one)

Code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig     |    5 
 drivers/net/wireless/rt2x00/Makefile    |    1 
 drivers/net/wireless/rt2x00/rt2800lib.c |  244 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h |   14 +
 drivers/net/wireless/rt2x00/rt2800pci.c |  236 ------------------------------
 drivers/net/wireless/rt2x00/rt2800usb.c |  223 -----------------------------
 6 files changed, 264 insertions(+), 459 deletions(-)

Index: b/drivers/net/wireless/rt2x00/Kconfig
===================================================================
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -66,6 +66,7 @@ config RT2800PCI_SOC
 config RT2800PCI
 	tristate "Ralink rt2800 (PCI/PCMCIA) support (VERY EXPERIMENTAL)"
 	depends on (RT2800PCI_PCI || RT2800PCI_SOC) && EXPERIMENTAL
+	select RT2800_LIB
 	select RT2X00_LIB_PCI if RT2800PCI_PCI
 	select RT2X00_LIB_SOC if RT2800PCI_SOC
 	select RT2X00_LIB_HT
@@ -109,6 +110,7 @@ config RT73USB
 config RT2800USB
 	tristate "Ralink rt2800 (USB) support (EXPERIMENTAL)"
 	depends on USB && EXPERIMENTAL
+	select RT2800_LIB
 	select RT2X00_LIB_USB
 	select RT2X00_LIB_HT
 	select RT2X00_LIB_FIRMWARE
@@ -124,6 +126,9 @@ config RT2800USB
 
 	  When compiled as a module, this driver will be called "rt2800usb.ko".
 
+config RT2800_LIB
+	tristate
+
 config RT2X00_LIB_PCI
 	tristate
 	select RT2X00_LIB
Index: b/drivers/net/wireless/rt2x00/Makefile
===================================================================
--- a/drivers/net/wireless/rt2x00/Makefile
+++ b/drivers/net/wireless/rt2x00/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_RT2X00_LIB)		+= rt2x00lib.o
 obj-$(CONFIG_RT2X00_LIB_PCI)		+= rt2x00pci.o
 obj-$(CONFIG_RT2X00_LIB_SOC)		+= rt2x00soc.o
 obj-$(CONFIG_RT2X00_LIB_USB)		+= rt2x00usb.o
+obj-$(CONFIG_RT2800_LIB)		+= rt2800lib.o
 obj-$(CONFIG_RT2400PCI)			+= rt2400pci.o
 obj-$(CONFIG_RT2500PCI)			+= rt2500pci.o
 obj-$(CONFIG_RT61PCI)			+= rt61pci.o
Index: b/drivers/net/wireless/rt2x00/rt2800lib.c
===================================================================
--- /dev/null
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -0,0 +1,244 @@
+/*
+	Copyright (C) 2009 Bartlomiej Zolnierkiewicz
+
+	Based on the original rt2800pci.c and rt2800usb.c:
+
+	  Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
+	  <http://rt2x00.serialmonkey.com>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the
+	Free Software Foundation, Inc.,
+	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*
+	Module: rt2800lib
+	Abstract: rt2800 generic device routines.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "rt2x00.h"
+#include "rt2800lib.h"
+#include "rt2800.h"
+
+MODULE_AUTHOR("Bartlomiej Zolnierkiewicz");
+MODULE_DESCRIPTION("rt2800 library");
+MODULE_LICENSE("GPL");
+
+/*
+ * Register access.
+ * All access to the CSR registers will go through the methods
+ * rt2800_register_read and rt2800_register_write.
+ * BBP and RF register require indirect register access,
+ * and use the CSR registers BBPCSR and RFCSR to achieve this.
+ * These indirect registers work with busy bits,
+ * and we will try maximal REGISTER_BUSY_COUNT times to access
+ * the register while taking a REGISTER_BUSY_DELAY us delay
+ * between each attampt. When the busy bit is still set at that time,
+ * the access attempt is considered to have failed,
+ * and we will print an error.
+ * The _lock versions must be used if you already hold the csr_mutex
+ */
+#define WAIT_FOR_BBP(__dev, __reg) \
+	rt2800_regbusy_read((__dev), BBP_CSR_CFG, BBP_CSR_CFG_BUSY, (__reg))
+#define WAIT_FOR_RFCSR(__dev, __reg) \
+	rt2800_regbusy_read((__dev), RF_CSR_CFG, RF_CSR_CFG_BUSY, (__reg))
+#define WAIT_FOR_RF(__dev, __reg) \
+	rt2800_regbusy_read((__dev), RF_CSR_CFG0, RF_CSR_CFG0_BUSY, (__reg))
+#define WAIT_FOR_MCU(__dev, __reg) \
+	rt2800_regbusy_read((__dev), H2M_MAILBOX_CSR, \
+			    H2M_MAILBOX_CSR_OWNER, (__reg))
+
+void rt2800_bbp_write(struct rt2x00_dev *rt2x00dev,
+		      const unsigned int word, const u8 value)
+{
+	u32 reg;
+
+	mutex_lock(&rt2x00dev->csr_mutex);
+
+	/*
+	 * Wait until the BBP becomes available, afterwards we
+	 * can safely write the new data into the register.
+	 */
+	if (WAIT_FOR_BBP(rt2x00dev, &reg)) {
+		reg = 0;
+		rt2x00_set_field32(&reg, BBP_CSR_CFG_VALUE, value);
+		rt2x00_set_field32(&reg, BBP_CSR_CFG_REGNUM, word);
+		rt2x00_set_field32(&reg, BBP_CSR_CFG_BUSY, 1);
+		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 0);
+		if (rt2x00_intf_is_pci(rt2x00dev))
+			rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
+
+		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
+	}
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
+}
+EXPORT_SYMBOL_GPL(rt2800_bbp_write);
+
+void rt2800_bbp_read(struct rt2x00_dev *rt2x00dev,
+		     const unsigned int word, u8 *value)
+{
+	u32 reg;
+
+	mutex_lock(&rt2x00dev->csr_mutex);
+
+	/*
+	 * Wait until the BBP becomes available, afterwards we
+	 * can safely write the read request into the register.
+	 * After the data has been written, we wait until hardware
+	 * returns the correct value, if at any time the register
+	 * doesn't become available in time, reg will be 0xffffffff
+	 * which means we return 0xff to the caller.
+	 */
+	if (WAIT_FOR_BBP(rt2x00dev, &reg)) {
+		reg = 0;
+		rt2x00_set_field32(&reg, BBP_CSR_CFG_REGNUM, word);
+		rt2x00_set_field32(&reg, BBP_CSR_CFG_BUSY, 1);
+		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 1);
+		if (rt2x00_intf_is_pci(rt2x00dev))
+			rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
+
+		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
+
+		WAIT_FOR_BBP(rt2x00dev, &reg);
+	}
+
+	*value = rt2x00_get_field32(reg, BBP_CSR_CFG_VALUE);
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
+}
+EXPORT_SYMBOL_GPL(rt2800_bbp_read);
+
+void rt2800_rfcsr_write(struct rt2x00_dev *rt2x00dev,
+			const unsigned int word, const u8 value)
+{
+	u32 reg;
+
+	mutex_lock(&rt2x00dev->csr_mutex);
+
+	/*
+	 * Wait until the RFCSR becomes available, afterwards we
+	 * can safely write the new data into the register.
+	 */
+	if (WAIT_FOR_RFCSR(rt2x00dev, &reg)) {
+		reg = 0;
+		rt2x00_set_field32(&reg, RF_CSR_CFG_DATA, value);
+		rt2x00_set_field32(&reg, RF_CSR_CFG_REGNUM, word);
+		rt2x00_set_field32(&reg, RF_CSR_CFG_WRITE, 1);
+		rt2x00_set_field32(&reg, RF_CSR_CFG_BUSY, 1);
+
+		rt2800_register_write_lock(rt2x00dev, RF_CSR_CFG, reg);
+	}
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
+}
+EXPORT_SYMBOL_GPL(rt2800_rfcsr_write);
+
+void rt2800_rfcsr_read(struct rt2x00_dev *rt2x00dev,
+		       const unsigned int word, u8 *value)
+{
+	u32 reg;
+
+	mutex_lock(&rt2x00dev->csr_mutex);
+
+	/*
+	 * Wait until the RFCSR becomes available, afterwards we
+	 * can safely write the read request into the register.
+	 * After the data has been written, we wait until hardware
+	 * returns the correct value, if at any time the register
+	 * doesn't become available in time, reg will be 0xffffffff
+	 * which means we return 0xff to the caller.
+	 */
+	if (WAIT_FOR_RFCSR(rt2x00dev, &reg)) {
+		reg = 0;
+		rt2x00_set_field32(&reg, RF_CSR_CFG_REGNUM, word);
+		rt2x00_set_field32(&reg, RF_CSR_CFG_WRITE, 0);
+		rt2x00_set_field32(&reg, RF_CSR_CFG_BUSY, 1);
+
+		rt2800_register_write_lock(rt2x00dev, RF_CSR_CFG, reg);
+
+		WAIT_FOR_RFCSR(rt2x00dev, &reg);
+	}
+
+	*value = rt2x00_get_field32(reg, RF_CSR_CFG_DATA);
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
+}
+EXPORT_SYMBOL_GPL(rt2800_rfcsr_read);
+
+void rt2800_rf_write(struct rt2x00_dev *rt2x00dev,
+		     const unsigned int word, const u32 value)
+{
+	u32 reg;
+
+	mutex_lock(&rt2x00dev->csr_mutex);
+
+	/*
+	 * Wait until the RF becomes available, afterwards we
+	 * can safely write the new data into the register.
+	 */
+	if (WAIT_FOR_RF(rt2x00dev, &reg)) {
+		reg = 0;
+		rt2x00_set_field32(&reg, RF_CSR_CFG0_REG_VALUE_BW, value);
+		rt2x00_set_field32(&reg, RF_CSR_CFG0_STANDBYMODE, 0);
+		rt2x00_set_field32(&reg, RF_CSR_CFG0_SEL, 0);
+		rt2x00_set_field32(&reg, RF_CSR_CFG0_BUSY, 1);
+
+		rt2800_register_write_lock(rt2x00dev, RF_CSR_CFG0, reg);
+		rt2x00_rf_write(rt2x00dev, word, value);
+	}
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
+}
+EXPORT_SYMBOL_GPL(rt2800_rf_write);
+
+void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
+			const u8 command, const u8 token,
+			const u8 arg0, const u8 arg1)
+{
+	u32 reg;
+
+	if (rt2x00_intf_is_pci(rt2x00dev)) {
+		/*
+		* RT2880 and RT3052 don't support MCU requests.
+		*/
+		if (rt2x00_rt(&rt2x00dev->chip, RT2880) ||
+		    rt2x00_rt(&rt2x00dev->chip, RT3052))
+			return;
+	}
+
+	mutex_lock(&rt2x00dev->csr_mutex);
+
+	/*
+	 * Wait until the MCU becomes available, afterwards we
+	 * can safely write the new data into the register.
+	 */
+	if (WAIT_FOR_MCU(rt2x00dev, &reg)) {
+		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_OWNER, 1);
+		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_CMD_TOKEN, token);
+		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_ARG0, arg0);
+		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_ARG1, arg1);
+		rt2800_register_write_lock(rt2x00dev, H2M_MAILBOX_CSR, reg);
+
+		reg = 0;
+		rt2x00_set_field32(&reg, HOST_CMD_CSR_HOST_COMMAND, command);
+		rt2800_register_write_lock(rt2x00dev, HOST_CMD_CSR, reg);
+	}
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
+}
+EXPORT_SYMBOL_GPL(rt2800_mcu_request);
Index: b/drivers/net/wireless/rt2x00/rt2800lib.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -96,4 +96,18 @@ static inline int rt2800_regbusy_read(st
 	return rt2800ops->regbusy_read(rt2x00dev, offset, field, reg);
 }
 
+void rt2800_bbp_write(struct rt2x00_dev *rt2x00dev,
+		      const unsigned int word, const u8 value);
+void rt2800_bbp_read(struct rt2x00_dev *rt2x00dev,
+		     const unsigned int word, u8 *value);
+void rt2800_rfcsr_write(struct rt2x00_dev *rt2x00dev,
+			const unsigned int word, const u8 value);
+void rt2800_rfcsr_read(struct rt2x00_dev *rt2x00dev,
+		       const unsigned int word, u8 *value);
+void rt2800_rf_write(struct rt2x00_dev *rt2x00dev,
+		     const unsigned int word, const u32 value);
+void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
+			const u8 command, const u8 token,
+			const u8 arg0, const u8 arg1);
+
 #endif /* RT2800LIB_H */
Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -56,242 +56,6 @@ static int modparam_nohwcrypt = 1;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
-/*
- * Register access.
- * All access to the CSR registers will go through the methods
- * rt2800_register_read and rt2800_register_write.
- * BBP and RF register require indirect register access,
- * and use the CSR registers BBPCSR and RFCSR to achieve this.
- * These indirect registers work with busy bits,
- * and we will try maximal REGISTER_BUSY_COUNT times to access
- * the register while taking a REGISTER_BUSY_DELAY us delay
- * between each attampt. When the busy bit is still set at that time,
- * the access attempt is considered to have failed,
- * and we will print an error.
- * The _lock versions must be used if you already hold the csr_mutex
- */
-#define WAIT_FOR_BBP(__dev, __reg) \
-	rt2800_regbusy_read((__dev), BBP_CSR_CFG, BBP_CSR_CFG_BUSY, (__reg))
-#define WAIT_FOR_RFCSR(__dev, __reg) \
-	rt2800_regbusy_read((__dev), RF_CSR_CFG, RF_CSR_CFG_BUSY, (__reg))
-#define WAIT_FOR_RF(__dev, __reg) \
-	rt2800_regbusy_read((__dev), RF_CSR_CFG0, RF_CSR_CFG0_BUSY, (__reg))
-#define WAIT_FOR_MCU(__dev, __reg) \
-	rt2800_regbusy_read((__dev), H2M_MAILBOX_CSR, \
-			    H2M_MAILBOX_CSR_OWNER, (__reg))
-
-static void rt2800pci_bbp_write(struct rt2x00_dev *rt2x00dev,
-				const unsigned int word, const u8 value)
-{
-	u32 reg;
-
-	mutex_lock(&rt2x00dev->csr_mutex);
-
-	/*
-	 * Wait until the BBP becomes available, afterwards we
-	 * can safely write the new data into the register.
-	 */
-	if (WAIT_FOR_BBP(rt2x00dev, &reg)) {
-		reg = 0;
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_VALUE, value);
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_REGNUM, word);
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_BUSY, 1);
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 0);
-		if (rt2x00_intf_is_pci(rt2x00dev))
-			rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
-
-		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
-	}
-
-	mutex_unlock(&rt2x00dev->csr_mutex);
-}
-
-static void rt2800pci_bbp_read(struct rt2x00_dev *rt2x00dev,
-			       const unsigned int word, u8 *value)
-{
-	u32 reg;
-
-	mutex_lock(&rt2x00dev->csr_mutex);
-
-	/*
-	 * Wait until the BBP becomes available, afterwards we
-	 * can safely write the read request into the register.
-	 * After the data has been written, we wait until hardware
-	 * returns the correct value, if at any time the register
-	 * doesn't become available in time, reg will be 0xffffffff
-	 * which means we return 0xff to the caller.
-	 */
-	if (WAIT_FOR_BBP(rt2x00dev, &reg)) {
-		reg = 0;
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_REGNUM, word);
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_BUSY, 1);
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 1);
-		if (rt2x00_intf_is_pci(rt2x00dev))
-			rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
-
-		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
-
-		WAIT_FOR_BBP(rt2x00dev, &reg);
-	}
-
-	*value = rt2x00_get_field32(reg, BBP_CSR_CFG_VALUE);
-
-	mutex_unlock(&rt2x00dev->csr_mutex);
-}
-
-static inline void rt2800_bbp_write(struct rt2x00_dev *rt2x00dev,
-				    const unsigned int word, const u8 value)
-{
-	rt2800pci_bbp_write(rt2x00dev, word, value);
-}
-
-static inline void rt2800_bbp_read(struct rt2x00_dev *rt2x00dev,
-				   const unsigned int word, u8 *value)
-{
-	rt2800pci_bbp_read(rt2x00dev, word, value);
-}
-
-static void rt2800pci_rfcsr_write(struct rt2x00_dev *rt2x00dev,
-				  const unsigned int word, const u8 value)
-{
-	u32 reg;
-
-	mutex_lock(&rt2x00dev->csr_mutex);
-
-	/*
-	 * Wait until the RFCSR becomes available, afterwards we
-	 * can safely write the new data into the register.
-	 */
-	if (WAIT_FOR_RFCSR(rt2x00dev, &reg)) {
-		reg = 0;
-		rt2x00_set_field32(&reg, RF_CSR_CFG_DATA, value);
-		rt2x00_set_field32(&reg, RF_CSR_CFG_REGNUM, word);
-		rt2x00_set_field32(&reg, RF_CSR_CFG_WRITE, 1);
-		rt2x00_set_field32(&reg, RF_CSR_CFG_BUSY, 1);
-
-		rt2800_register_write_lock(rt2x00dev, RF_CSR_CFG, reg);
-	}
-
-	mutex_unlock(&rt2x00dev->csr_mutex);
-}
-
-static void rt2800pci_rfcsr_read(struct rt2x00_dev *rt2x00dev,
-				 const unsigned int word, u8 *value)
-{
-	u32 reg;
-
-	mutex_lock(&rt2x00dev->csr_mutex);
-
-	/*
-	 * Wait until the RFCSR becomes available, afterwards we
-	 * can safely write the read request into the register.
-	 * After the data has been written, we wait until hardware
-	 * returns the correct value, if at any time the register
-	 * doesn't become available in time, reg will be 0xffffffff
-	 * which means we return 0xff to the caller.
-	 */
-	if (WAIT_FOR_RFCSR(rt2x00dev, &reg)) {
-		reg = 0;
-		rt2x00_set_field32(&reg, RF_CSR_CFG_REGNUM, word);
-		rt2x00_set_field32(&reg, RF_CSR_CFG_WRITE, 0);
-		rt2x00_set_field32(&reg, RF_CSR_CFG_BUSY, 1);
-
-		rt2800_register_write_lock(rt2x00dev, RF_CSR_CFG, reg);
-
-		WAIT_FOR_RFCSR(rt2x00dev, &reg);
-	}
-
-	*value = rt2x00_get_field32(reg, RF_CSR_CFG_DATA);
-
-	mutex_unlock(&rt2x00dev->csr_mutex);
-}
-
-static inline void rt2800_rfcsr_write(struct rt2x00_dev *rt2x00dev,
-				      const unsigned int word, const u8 value)
-{
-	rt2800pci_rfcsr_write(rt2x00dev, word, value);
-}
-
-static inline void rt2800_rfcsr_read(struct rt2x00_dev *rt2x00dev,
-				     const unsigned int word, u8 *value)
-{
-	rt2800pci_rfcsr_read(rt2x00dev, word, value);
-}
-
-static void rt2800pci_rf_write(struct rt2x00_dev *rt2x00dev,
-			       const unsigned int word, const u32 value)
-{
-	u32 reg;
-
-	mutex_lock(&rt2x00dev->csr_mutex);
-
-	/*
-	 * Wait until the RF becomes available, afterwards we
-	 * can safely write the new data into the register.
-	 */
-	if (WAIT_FOR_RF(rt2x00dev, &reg)) {
-		reg = 0;
-		rt2x00_set_field32(&reg, RF_CSR_CFG0_REG_VALUE_BW, value);
-		rt2x00_set_field32(&reg, RF_CSR_CFG0_STANDBYMODE, 0);
-		rt2x00_set_field32(&reg, RF_CSR_CFG0_SEL, 0);
-		rt2x00_set_field32(&reg, RF_CSR_CFG0_BUSY, 1);
-
-		rt2800_register_write_lock(rt2x00dev, RF_CSR_CFG0, reg);
-		rt2x00_rf_write(rt2x00dev, word, value);
-	}
-
-	mutex_unlock(&rt2x00dev->csr_mutex);
-}
-
-static inline void rt2800_rf_write(struct rt2x00_dev *rt2x00dev,
-				   const unsigned int word, const u32 value)
-{
-	rt2800pci_rf_write(rt2x00dev, word, value);
-}
-
-static void rt2800pci_mcu_request(struct rt2x00_dev *rt2x00dev,
-				  const u8 command, const u8 token,
-				  const u8 arg0, const u8 arg1)
-{
-	u32 reg;
-
-	if (rt2x00_intf_is_pci(rt2x00dev)) {
-		/*
-		* RT2880 and RT3052 don't support MCU requests.
-		*/
-		if (rt2x00_rt(&rt2x00dev->chip, RT2880) ||
-		    rt2x00_rt(&rt2x00dev->chip, RT3052))
-			return;
-	}
-
-	mutex_lock(&rt2x00dev->csr_mutex);
-
-	/*
-	 * Wait until the MCU becomes available, afterwards we
-	 * can safely write the new data into the register.
-	 */
-	if (WAIT_FOR_MCU(rt2x00dev, &reg)) {
-		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_OWNER, 1);
-		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_CMD_TOKEN, token);
-		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_ARG0, arg0);
-		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_ARG1, arg1);
-		rt2800_register_write_lock(rt2x00dev, H2M_MAILBOX_CSR, reg);
-
-		reg = 0;
-		rt2x00_set_field32(&reg, HOST_CMD_CSR_HOST_COMMAND, command);
-		rt2800_register_write_lock(rt2x00dev, HOST_CMD_CSR, reg);
-	}
-
-	mutex_unlock(&rt2x00dev->csr_mutex);
-}
-
-static inline void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
-				      const u8 command, const u8 token,
-				      const u8 arg0, const u8 arg1)
-{
-	rt2800pci_mcu_request(rt2x00dev, command, token, arg0, arg1);
-}
-
 static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 {
 	unsigned int i;
Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -45,229 +45,6 @@ static int modparam_nohwcrypt = 1;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
-/*
- * Register access.
- * All access to the CSR registers will go through the methods
- * rt2800_register_read and rt2800_register_write.
- * BBP and RF register require indirect register access,
- * and use the CSR registers BBPCSR and RFCSR to achieve this.
- * These indirect registers work with busy bits,
- * and we will try maximal REGISTER_BUSY_COUNT times to access
- * the register while taking a REGISTER_BUSY_DELAY us delay
- * between each attampt. When the busy bit is still set at that time,
- * the access attempt is considered to have failed,
- * and we will print an error.
- * The _lock versions must be used if you already hold the csr_mutex
- */
-#define WAIT_FOR_BBP(__dev, __reg) \
-	rt2800_regbusy_read((__dev), BBP_CSR_CFG, BBP_CSR_CFG_BUSY, (__reg))
-#define WAIT_FOR_RFCSR(__dev, __reg) \
-	rt2800_regbusy_read((__dev), RF_CSR_CFG, RF_CSR_CFG_BUSY, (__reg))
-#define WAIT_FOR_RF(__dev, __reg) \
-	rt2800_regbusy_read((__dev), RF_CSR_CFG0, RF_CSR_CFG0_BUSY, (__reg))
-#define WAIT_FOR_MCU(__dev, __reg) \
-	rt2800_regbusy_read((__dev), H2M_MAILBOX_CSR, \
-			    H2M_MAILBOX_CSR_OWNER, (__reg))
-
-static void rt2800usb_bbp_write(struct rt2x00_dev *rt2x00dev,
-				const unsigned int word, const u8 value)
-{
-	u32 reg;
-
-	mutex_lock(&rt2x00dev->csr_mutex);
-
-	/*
-	 * Wait until the BBP becomes available, afterwards we
-	 * can safely write the new data into the register.
-	 */
-	if (WAIT_FOR_BBP(rt2x00dev, &reg)) {
-		reg = 0;
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_VALUE, value);
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_REGNUM, word);
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_BUSY, 1);
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 0);
-
-		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
-	}
-
-	mutex_unlock(&rt2x00dev->csr_mutex);
-}
-
-static void rt2800usb_bbp_read(struct rt2x00_dev *rt2x00dev,
-			       const unsigned int word, u8 *value)
-{
-	u32 reg;
-
-	mutex_lock(&rt2x00dev->csr_mutex);
-
-	/*
-	 * Wait until the BBP becomes available, afterwards we
-	 * can safely write the read request into the register.
-	 * After the data has been written, we wait until hardware
-	 * returns the correct value, if at any time the register
-	 * doesn't become available in time, reg will be 0xffffffff
-	 * which means we return 0xff to the caller.
-	 */
-	if (WAIT_FOR_BBP(rt2x00dev, &reg)) {
-		reg = 0;
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_REGNUM, word);
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_BUSY, 1);
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 1);
-
-		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
-
-		WAIT_FOR_BBP(rt2x00dev, &reg);
-	}
-
-	*value = rt2x00_get_field32(reg, BBP_CSR_CFG_VALUE);
-
-	mutex_unlock(&rt2x00dev->csr_mutex);
-}
-
-static inline void rt2800_bbp_write(struct rt2x00_dev *rt2x00dev,
-				    const unsigned int word, const u8 value)
-{
-	rt2800usb_bbp_write(rt2x00dev, word, value);
-}
-
-static inline void rt2800_bbp_read(struct rt2x00_dev *rt2x00dev,
-				   const unsigned int word, u8 *value)
-{
-	rt2800usb_bbp_read(rt2x00dev, word, value);
-}
-
-static void rt2800usb_rfcsr_write(struct rt2x00_dev *rt2x00dev,
-				  const unsigned int word, const u8 value)
-{
-	u32 reg;
-
-	mutex_lock(&rt2x00dev->csr_mutex);
-
-	/*
-	 * Wait until the RFCSR becomes available, afterwards we
-	 * can safely write the new data into the register.
-	 */
-	if (WAIT_FOR_RFCSR(rt2x00dev, &reg)) {
-		reg = 0;
-		rt2x00_set_field32(&reg, RF_CSR_CFG_DATA, value);
-		rt2x00_set_field32(&reg, RF_CSR_CFG_REGNUM, word);
-		rt2x00_set_field32(&reg, RF_CSR_CFG_WRITE, 1);
-		rt2x00_set_field32(&reg, RF_CSR_CFG_BUSY, 1);
-
-		rt2800_register_write_lock(rt2x00dev, RF_CSR_CFG, reg);
-	}
-
-	mutex_unlock(&rt2x00dev->csr_mutex);
-}
-
-static void rt2800usb_rfcsr_read(struct rt2x00_dev *rt2x00dev,
-				 const unsigned int word, u8 *value)
-{
-	u32 reg;
-
-	mutex_lock(&rt2x00dev->csr_mutex);
-
-	/*
-	 * Wait until the RFCSR becomes available, afterwards we
-	 * can safely write the read request into the register.
-	 * After the data has been written, we wait until hardware
-	 * returns the correct value, if at any time the register
-	 * doesn't become available in time, reg will be 0xffffffff
-	 * which means we return 0xff to the caller.
-	 */
-	if (WAIT_FOR_RFCSR(rt2x00dev, &reg)) {
-		reg = 0;
-		rt2x00_set_field32(&reg, RF_CSR_CFG_REGNUM, word);
-		rt2x00_set_field32(&reg, RF_CSR_CFG_WRITE, 0);
-		rt2x00_set_field32(&reg, RF_CSR_CFG_BUSY, 1);
-
-		rt2800_register_write_lock(rt2x00dev, RF_CSR_CFG, reg);
-
-		WAIT_FOR_RFCSR(rt2x00dev, &reg);
-	}
-
-	*value = rt2x00_get_field32(reg, RF_CSR_CFG_DATA);
-
-	mutex_unlock(&rt2x00dev->csr_mutex);
-}
-
-static inline void rt2800_rfcsr_write(struct rt2x00_dev *rt2x00dev,
-				      const unsigned int word, const u8 value)
-{
-	rt2800usb_rfcsr_write(rt2x00dev, word, value);
-}
-
-static inline void rt2800_rfcsr_read(struct rt2x00_dev *rt2x00dev,
-				     const unsigned int word, u8 *value)
-{
-	rt2800usb_rfcsr_read(rt2x00dev, word, value);
-}
-
-static void rt2800usb_rf_write(struct rt2x00_dev *rt2x00dev,
-			       const unsigned int word, const u32 value)
-{
-	u32 reg;
-
-	mutex_lock(&rt2x00dev->csr_mutex);
-
-	/*
-	 * Wait until the RF becomes available, afterwards we
-	 * can safely write the new data into the register.
-	 */
-	if (WAIT_FOR_RF(rt2x00dev, &reg)) {
-		reg = 0;
-		rt2x00_set_field32(&reg, RF_CSR_CFG0_REG_VALUE_BW, value);
-		rt2x00_set_field32(&reg, RF_CSR_CFG0_STANDBYMODE, 0);
-		rt2x00_set_field32(&reg, RF_CSR_CFG0_SEL, 0);
-		rt2x00_set_field32(&reg, RF_CSR_CFG0_BUSY, 1);
-
-		rt2800_register_write_lock(rt2x00dev, RF_CSR_CFG0, reg);
-		rt2x00_rf_write(rt2x00dev, word, value);
-	}
-
-	mutex_unlock(&rt2x00dev->csr_mutex);
-}
-
-static inline void rt2800_rf_write(struct rt2x00_dev *rt2x00dev,
-				   const unsigned int word, const u32 value)
-{
-	rt2800usb_rf_write(rt2x00dev, word, value);
-}
-
-static void rt2800usb_mcu_request(struct rt2x00_dev *rt2x00dev,
-				  const u8 command, const u8 token,
-				  const u8 arg0, const u8 arg1)
-{
-	u32 reg;
-
-	mutex_lock(&rt2x00dev->csr_mutex);
-
-	/*
-	 * Wait until the MCU becomes available, afterwards we
-	 * can safely write the new data into the register.
-	 */
-	if (WAIT_FOR_MCU(rt2x00dev, &reg)) {
-		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_OWNER, 1);
-		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_CMD_TOKEN, token);
-		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_ARG0, arg0);
-		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_ARG1, arg1);
-		rt2800_register_write_lock(rt2x00dev, H2M_MAILBOX_CSR, reg);
-
-		reg = 0;
-		rt2x00_set_field32(&reg, HOST_CMD_CSR_HOST_COMMAND, command);
-		rt2800_register_write_lock(rt2x00dev, HOST_CMD_CSR, reg);
-	}
-
-	mutex_unlock(&rt2x00dev->csr_mutex);
-}
-
-static inline void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
-				      const u8 command, const u8 token,
-				      const u8 arg0, const u8 arg1)
-{
-	rt2800usb_mcu_request(rt2x00dev, command, token, arg0, arg1);
-}
-
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 static const struct rt2x00debug rt2800usb_rt2x00debug = {
 	.owner	= THIS_MODULE,
