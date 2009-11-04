Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbZKDRk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbZKDRk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbZKDRk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:40:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbZKDRfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:35:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vHV7AZWaOf9/DRcO6SvNzKkP2Pl+PMbQT48sntSYPZtM4kkST33oOIgPaXgoXgf7CY
         AgGCTaAXhoJLbPC2tMxAuwg/wJvTveFSrl8oLpZ7mf1yqMUW2kq3aaXM66jAaoTPomb9
         iftXp473lyHQhqLm3hlX81KN/pxH/DTJt0+WM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:34:53 +0100
Message-Id: <20091104173453.28463.94062.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 24/41] rt2800usb: convert to use struct rt2800_ops methods
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: convert to use struct rt2800_ops methods

Add chipset registers access abstraction layer and prepare for later
code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   13 +++++++++
 drivers/net/wireless/rt2x00/rt2800usb.h |   44 +++++++++++++++++++++++++++-----
 2 files changed, 51 insertions(+), 6 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -2627,10 +2627,23 @@ static int rt2800usb_probe_hw_mode(struc
 	return 0;
 }
 
+static const struct rt2800_ops rt2800usb_rt2800_ops = {
+	.register_read		= rt2x00usb_register_read,
+	.register_write		= rt2x00usb_register_write,
+	.register_write_lock	= rt2x00usb_register_write_lock,
+
+	.register_multiread	= rt2x00usb_register_multiread,
+	.register_multiwrite	= rt2x00usb_register_multiwrite,
+
+	.regbusy_read		= rt2x00usb_regbusy_read,
+};
+
 static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
+	rt2x00dev->priv = (void *)&rt2800usb_rt2800_ops;
+
 	/*
 	 * Allocate eeprom data.
 	 */
Index: b/drivers/net/wireless/rt2x00/rt2800usb.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -27,39 +27,69 @@
 #ifndef RT2800USB_H
 #define RT2800USB_H
 
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
+				   void *value, const u32 length);
+	void (*register_multiwrite)(struct rt2x00_dev *rt2x00dev,
+				    const unsigned int offset,
+				    void *value, const u32 length);
+
+	int (*regbusy_read)(struct rt2x00_dev *rt2x00dev,
+			    const unsigned int offset,
+			    struct rt2x00_field32 field, u32 *reg);
+};
+
 static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
 					const unsigned int offset,
 					u32 *value)
 {
-	rt2x00usb_register_read(rt2x00dev, offset, value);
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_read(rt2x00dev, offset, value);
 }
 
 static inline void rt2800_register_write(struct rt2x00_dev *rt2x00dev,
 					 const unsigned int offset,
 					 u32 value)
 {
-	rt2x00usb_register_write(rt2x00dev, offset, value);
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_write(rt2x00dev, offset, value);
 }
 
 static inline void rt2800_register_write_lock(struct rt2x00_dev *rt2x00dev,
 					      const unsigned int offset,
 					      u32 value)
 {
-	rt2x00usb_register_write_lock(rt2x00dev, offset, value);
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_write_lock(rt2x00dev, offset, value);
 }
 
 static inline void rt2800_register_multiread(struct rt2x00_dev *rt2x00dev,
 					     const unsigned int offset,
 					     void *value, const u32 length)
 {
-	rt2x00usb_register_multiread(rt2x00dev, offset, value, length);
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_multiread(rt2x00dev, offset, value, length);
 }
 
 static inline void rt2800_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 					      const unsigned int offset,
 					      void *value, const u32 length)
 {
-	rt2x00usb_register_multiwrite(rt2x00dev, offset, value, length);
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_multiwrite(rt2x00dev, offset, value, length);
 }
 
 static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
@@ -67,7 +97,9 @@ static inline int rt2800_regbusy_read(st
 				      struct rt2x00_field32 field,
 				      u32 *reg)
 {
-	return rt2x00usb_regbusy_read(rt2x00dev, offset, field, reg);
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	return rt2800ops->regbusy_read(rt2x00dev, offset, field, reg);
 }
 
 /*
