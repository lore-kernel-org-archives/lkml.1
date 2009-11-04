Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbZKDReK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbZKDReK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932194AbZKDReG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:34:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbZKDReC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:34:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=NjmYlXnX17XCwRqFOAPY17ql5TKcowi6mbikRX3gQMQwg9xvgXa0y82CEWbMtwf+wt
         b09SfgNS0D9Gs86DRKvS3eW9JTWIEkyYGkQYB9xmcM/Pb8aoWBcKEEZKsIYbsCVBRV/R
         DoEqS3RoY/9xOGrdgfg54mo4b1/p6pehids9Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:33:41 +0100
Message-Id: <20091104173341.28463.11122.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/41] rt2800pci: add rt2800_regbusy_read() wrapper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800pci: add rt2800_regbusy_read() wrapper

Part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   12 ++++++------
 drivers/net/wireless/rt2x00/rt2800pci.h |    8 ++++++++
 2 files changed, 14 insertions(+), 6 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -69,14 +69,14 @@ MODULE_PARM_DESC(nohwcrypt, "Disable har
  * The _lock versions must be used if you already hold the csr_mutex
  */
 #define WAIT_FOR_BBP(__dev, __reg) \
-	rt2x00pci_regbusy_read((__dev), BBP_CSR_CFG, BBP_CSR_CFG_BUSY, (__reg))
+	rt2800_regbusy_read((__dev), BBP_CSR_CFG, BBP_CSR_CFG_BUSY, (__reg))
 #define WAIT_FOR_RFCSR(__dev, __reg) \
-	rt2x00pci_regbusy_read((__dev), RF_CSR_CFG, RF_CSR_CFG_BUSY, (__reg))
+	rt2800_regbusy_read((__dev), RF_CSR_CFG, RF_CSR_CFG_BUSY, (__reg))
 #define WAIT_FOR_RF(__dev, __reg) \
-	rt2x00pci_regbusy_read((__dev), RF_CSR_CFG0, RF_CSR_CFG0_BUSY, (__reg))
+	rt2800_regbusy_read((__dev), RF_CSR_CFG0, RF_CSR_CFG0_BUSY, (__reg))
 #define WAIT_FOR_MCU(__dev, __reg) \
-	rt2x00pci_regbusy_read((__dev), H2M_MAILBOX_CSR, \
-			       H2M_MAILBOX_CSR_OWNER, (__reg))
+	rt2800_regbusy_read((__dev), H2M_MAILBOX_CSR, \
+			    H2M_MAILBOX_CSR_OWNER, (__reg))
 
 static void rt2800pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 				const unsigned int word, const u8 value)
@@ -350,7 +350,7 @@ static void rt2800pci_efuse_read(struct 
 	rt2800_register_write(rt2x00dev, EFUSE_CTRL, reg);
 
 	/* Wait until the EEPROM has been loaded */
-	rt2x00pci_regbusy_read(rt2x00dev, EFUSE_CTRL, EFUSE_CTRL_KICK, &reg);
+	rt2800_regbusy_read(rt2x00dev, EFUSE_CTRL, EFUSE_CTRL_KICK, &reg);
 
 	/* Apparently the data is read from end to start */
 	rt2800_register_read(rt2x00dev, EFUSE_DATA3,
Index: b/drivers/net/wireless/rt2x00/rt2800pci.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.h
+++ b/drivers/net/wireless/rt2x00/rt2800pci.h
@@ -63,6 +63,14 @@ static inline void rt2800_register_multi
 	rt2x00pci_register_multiwrite(rt2x00dev, offset, value, length);
 }
 
+static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
+				      const unsigned int offset,
+				      const struct rt2x00_field32 field,
+				      u32 *reg)
+{
+	return rt2x00pci_regbusy_read(rt2x00dev, offset, field, reg);
+}
+
 /*
  * RF chip defines.
  *
