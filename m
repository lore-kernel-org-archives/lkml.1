Return-Path: <linux-kernel-owner+w=401wt.eu-S933982AbXEKVb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982AbXEKVb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 17:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761087AbXEKVbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 17:31:18 -0400
Received: from mailrelay1.nijmegen.internl.net ([217.149.192.44]:44316 "EHLO
	hatert.nijmegen.internl.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760637AbXEKVbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 17:31:17 -0400
Message-Id: <20070511172441.343908560@caffeinetrip.com>
References: <20070511172326.008944330@caffeinetrip.com>
User-Agent: quilt/0.46-1
Date: Fri, 11 May 2007 19:23:27 +0200
From: Giel de Nijs <giel@caffeinetrip.com>
To: linux-kernel@vger.kernel.org
Cc: Vojtech Pavlik <vojtech@suse.cz>,
       Dimitry Torokhov <dmitry.torokhov@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Matt Domsch <matt_domsch@dell.com>,
       Rezwanul Kabir <rezwanul_kabir@dell.com>,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: [patch 1/2] input: add soft release key mask to keyboard driver
Content-Disposition: inline; filename=add-keyboard-soft-release-mask.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add keysrlmask to input_dev and add soft release handling in atkbd.c

Signed-off-by: Giel de Nijs <giel@caffeinetrip.com>
---

Index: linux-2.6.21.1/drivers/input/keyboard/atkbd.c
===================================================================
--- linux-2.6.21.1.orig/drivers/input/keyboard/atkbd.c	2007-05-10 18:34:48.000000000 +0200
+++ linux-2.6.21.1/drivers/input/keyboard/atkbd.c	2007-05-11 19:21:03.000000000 +0200
@@ -201,6 +201,7 @@
 
 	unsigned short id;
 	unsigned char keycode[512];
+	unsigned long keysrlmask[NBITS(512)];
 	unsigned char set;
 	unsigned char translated;
 	unsigned char extra;
@@ -412,14 +413,6 @@
 			       "Some program might be trying access hardware directly.\n",
 			       data == ATKBD_RET_ACK ? "ACK" : "NAK", serio->phys);
 			goto out;
-		case ATKBD_RET_HANGEUL:
-		case ATKBD_RET_HANJA:
-			/*
-			 * These keys do not report release and thus need to be
-			 * flagged properly
-			 */
-			add_release_event = 1;
-			break;
 		case ATKBD_RET_ERR:
 			atkbd->err_count++;
 #ifdef ATKBD_DEBUG
@@ -438,6 +431,9 @@
 	if (keycode != ATKBD_KEY_NULL)
 		input_event(dev, EV_MSC, MSC_SCAN, code);
 
+	if (test_bit(code, atkbd->keysrlmask))
+		add_release_event = 1;
+
 	switch (keycode) {
 		case ATKBD_KEY_NULL:
 			break;
@@ -832,6 +828,7 @@
 	int i, j;
 
 	memset(atkbd->keycode, 0, sizeof(atkbd->keycode));
+	bitmap_zero(atkbd->keysrlmask, 512);
 
 	if (atkbd->translated) {
 		for (i = 0; i < 128; i++) {
@@ -854,6 +851,11 @@
 
 	atkbd->keycode[atkbd_compat_scancode(atkbd, ATKBD_RET_HANGEUL)] = KEY_HANGUEL;
 	atkbd->keycode[atkbd_compat_scancode(atkbd, ATKBD_RET_HANJA)] = KEY_HANJA;
+
+	set_bit(atkbd_compat_scancode(atkbd, ATKBD_RET_HANGEUL),
+		atkbd->keysrlmask);
+	set_bit(atkbd_compat_scancode(atkbd, ATKBD_RET_HANJA),
+		atkbd->keysrlmask);
 }
 
 /*
@@ -911,6 +913,7 @@
 	}
 
 	input_dev->keycode = atkbd->keycode;
+	input_dev->keysrlmask = atkbd->keysrlmask;
 	input_dev->keycodesize = sizeof(unsigned char);
 	input_dev->keycodemax = ARRAY_SIZE(atkbd_set2_keycode);
 
Index: linux-2.6.21.1/include/linux/input.h
===================================================================
--- linux-2.6.21.1.orig/include/linux/input.h	2007-05-10 18:32:39.000000000 +0200
+++ linux-2.6.21.1/include/linux/input.h	2007-05-10 18:56:50.000000000 +0200
@@ -962,6 +962,7 @@
 	unsigned int keycodemax;
 	unsigned int keycodesize;
 	void *keycode;
+	unsigned long *keysrlmask; /* soft-release scancodes key mask */
 
 	struct ff_device *ff;
 

-- 

