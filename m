Return-Path: <linux-kernel-owner+w=401wt.eu-S932334AbZKDRf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbZKDRf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932288AbZKDRf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:35:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5665 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbZKDRfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:35:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mN5wVH46yGCmMb+3oWr2LYnfa7LvGgzp7JP83d/O82K3cmSHpVaJhufVDALsRFVGpN
         hIQMVZI22OgGYdMAYebm8BKoDl2Nl+45Jr+YibmyaW/GvVz3QVt9Y4TlTi8TE6jpMGZx
         21v0qqpANcJwKl6LZRFGpSbSg9LuKVhFf0tsU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:35:00 +0100
Message-Id: <20091104173500.28463.89800.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 25/41] rt2800pci: convert to use struct rt2800_ops methods
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800pci: convert to use struct rt2800_ops methods

Add chipset registers access abstraction layer and prepare for later
code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   13 +++++++++
 drivers/net/wireless/rt2x00/rt2800pci.h |   44 +++++++++++++++++++++++++++-----
 2 files changed, 51 insertions(+), 6 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -2988,10 +2988,23 @@ static int rt2800pci_probe_hw_mode(struc
 	return 0;
 }
 
+static const struct rt2800_ops rt2800pci_rt2800_ops = {
+	.register_read		= rt2x00pci_register_read,
+	.register_write		= rt2x00pci_register_write,
+	.register_write_lock	= rt2x00pci_register_write, /* same for PCI */
+
+	.register_multiread	= rt2x00pci_register_multiread,
+	.register_multiwrite	= rt2x00pci_register_multiwrite,
+
+	.regbusy_read		= rt2x00pci_regbusy_read,
+};
+
 static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
+	rt2x00dev->priv = (void *)&rt2800pci_rt2800_ops;
+
 	/*
 	 * Allocate eeprom data.
 	 */
Index: b/drivers/net/wireless/rt2x00/rt2800pci.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.h
+++ b/drivers/net/wireless/rt2x00/rt2800pci.h
@@ -27,32 +27,60 @@
 #ifndef RT2800PCI_H
 #define RT2800PCI_H
 
+struct rt2800_ops {
+	void (*register_read)(struct rt2x00_dev *rt2x00dev,
+			      const unsigned int offset, u32 *value);
+	void (*register_write)(struct rt2x00_dev *rt2x00dev,
+			       const unsigned int offset, u32 value);
+	void (*register_write_lock)(struct rt2x00_dev *rt2x00dev,
+				    const unsigned int offset, u32 value);
+
+	void (*register_multiread)(struct rt2x00_dev *rt2x00dev,
+				   const unsigned int offset,
+				   void *value, const u16 length);
+	void (*register_multiwrite)(struct rt2x00_dev *rt2x00dev,
+				    const unsigned int offset,
+				    const void *value, const u16 length);
+
+	int (*regbusy_read)(struct rt2x00_dev *rt2x00dev,
+			    const unsigned int offset,
+			    const struct rt2x00_field32 field, u32 *reg);
+};
+
 static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
 					const unsigned int offset,
 					u32 *value)
 {
-	rt2x00pci_register_read(rt2x00dev, offset, value);
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_read(rt2x00dev, offset, value);
 }
 
 static inline void rt2800_register_write(struct rt2x00_dev *rt2x00dev,
 					 const unsigned int offset,
 					 u32 value)
 {
-	rt2x00pci_register_write(rt2x00dev, offset, value);
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_write(rt2x00dev, offset, value);
 }
 
 static inline void rt2800_register_write_lock(struct rt2x00_dev *rt2x00dev,
 					      const unsigned int offset,
 					      u32 value)
 {
-	rt2x00pci_register_write(rt2x00dev, offset, value);
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_write_lock(rt2x00dev, offset, value);
 }
 
 static inline void rt2800_register_multiread(struct rt2x00_dev *rt2x00dev,
 					     const unsigned int offset,
 					     void *value, const u16 length)
 {
-	rt2x00pci_register_multiread(rt2x00dev, offset, value, length);
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_multiread(rt2x00dev, offset, value, length);
 }
 
 static inline void rt2800_register_multiwrite(struct rt2x00_dev *rt2x00dev,
@@ -60,7 +88,9 @@ static inline void rt2800_register_multi
 					      const void *value,
 					      const u16 length)
 {
-	rt2x00pci_register_multiwrite(rt2x00dev, offset, value, length);
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_multiwrite(rt2x00dev, offset, value, length);
 }
 
 static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
@@ -68,7 +98,9 @@ static inline int rt2800_regbusy_read(st
 				      const struct rt2x00_field32 field,
 				      u32 *reg)
 {
-	return rt2x00pci_regbusy_read(rt2x00dev, offset, field, reg);
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	return rt2800ops->regbusy_read(rt2x00dev, offset, field, reg);
 }
 
 /*
