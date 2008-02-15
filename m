Return-Path: <linux-kernel-owner+w=401wt.eu-S1762089AbYBOT5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762089AbYBOT5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761621AbYBOT47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:56:59 -0500
Received: from mx1.riseup.net ([204.13.164.18]:54900 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761604AbYBOT46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:56:58 -0500
Date: Fri, 15 Feb 2008 20:57:07 +0100
From: matthias@kaehlcke.net
To: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Matthias Kaehlcke <matthias@kaehlcke.net>
Subject: [patch 3/3] Convert wpa_sem in a mutex
Message-ID: <20080215195707.GD22741@traven>
Mail-Followup-To: matthias@kaehlcke.net, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20080215195329.912560854@kaehlcke.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-wireless-prism54-wpa_sem-to-mutex.diff"
User-Agent: quilt/0.46-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semaphore wpa_sem is used as mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Index: linux-2.6/drivers/net/wireless/prism54/isl_ioctl.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/prism54/isl_ioctl.c	2008-02-15 20:44:03.000000000 +0100
+++ linux-2.6/drivers/net/wireless/prism54/isl_ioctl.c	2008-02-15 20:44:11.000000000 +0100
@@ -2114,7 +2114,7 @@
 	if (wpa_ie_len > MAX_WPA_IE_LEN)
 		wpa_ie_len = MAX_WPA_IE_LEN;
 
-	down(&priv->wpa_sem);
+	mutex_lock(&priv->wpa_lock);
 
 	/* try to use existing entry */
 	list_for_each(ptr, &priv->bss_wpa_list) {
@@ -2165,7 +2165,7 @@
 		kfree(bss);
 	}
 
-	up(&priv->wpa_sem);
+	mutex_unlock(&priv->wpa_lock);
 }
 
 static size_t
@@ -2175,7 +2175,7 @@
 	struct islpci_bss_wpa_ie *bss = NULL;
 	size_t len = 0;
 
-	down(&priv->wpa_sem);
+	mutex_lock(&priv->wpa_lock);
 
 	list_for_each(ptr, &priv->bss_wpa_list) {
 		bss = list_entry(ptr, struct islpci_bss_wpa_ie, list);
@@ -2187,7 +2187,7 @@
 		len = bss->wpa_ie_len;
 		memcpy(wpa_ie, bss->wpa_ie, len);
 	}
-	up(&priv->wpa_sem);
+	mutex_unlock(&priv->wpa_lock);
 
 	return len;
 }
@@ -2196,7 +2196,7 @@
 prism54_wpa_bss_ie_init(islpci_private *priv)
 {
 	INIT_LIST_HEAD(&priv->bss_wpa_list);
-	sema_init(&priv->wpa_sem, 1);
+	mutex_init(&priv->wpa_lock);
 }
 
 void
Index: linux-2.6/drivers/net/wireless/prism54/islpci_dev.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/prism54/islpci_dev.h	2008-02-15 20:44:03.000000000 +0100
+++ linux-2.6/drivers/net/wireless/prism54/islpci_dev.h	2008-02-15 20:44:11.000000000 +0100
@@ -178,7 +178,7 @@
 	int wpa; /* WPA mode enabled */
 	struct list_head bss_wpa_list;
 	int num_bss_wpa;
-	struct semaphore wpa_sem;
+	struct mutex wpa_lock;
 	u8 wpa_ie[MAX_WPA_IE_LEN];
 	size_t wpa_ie_len;
 

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
