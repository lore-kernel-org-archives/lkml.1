Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbXLUVOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbXLUVOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbXLUVNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:13:52 -0500
Received: from homer.mvista.com ([63.81.120.158]:45106 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753421AbXLUVNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:13:51 -0500
Message-Id: <20071221205858.857235223@mvista.com>
References: <20071221205854.408865412@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 21 Dec 2007 00:00:02 -0800
Subject: [PATCH 2/4] prism54: remove questionable down_interruptible usage
References: <20071221205848.989157559@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com
Content-Disposition: inline; filename=wireless-prism54-fix-down_interruptible-usage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewing the semaphore usage I noticed these down_interruptible
calls. Most of these aren't returning anything, so a caller can't
tell if the operation completed or not. prism54_wpa_bss_ie_get()
returns zero, but it's treated as the function failing which doesn't
seem correct.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
---
 drivers/net/wireless/prism54/isl_ioctl.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

Index: linux-2.6.23/drivers/net/wireless/prism54/isl_ioctl.c
===================================================================
--- linux-2.6.23.orig/drivers/net/wireless/prism54/isl_ioctl.c
+++ linux-2.6.23/drivers/net/wireless/prism54/isl_ioctl.c
@@ -165,8 +165,7 @@ prism54_update_stats(struct work_struct 
 	struct obj_bss bss, *bss2;
 	union oid_res_t r;
 
-	if (down_interruptible(&priv->stats_sem))
-		return;
+	down(&priv->stats_sem);
 
 /* Noise floor.
  * I'm not sure if the unit is dBm.
@@ -1793,8 +1792,7 @@ prism54_clear_mac(struct islpci_acl *acl
 	struct list_head *ptr, *next;
 	struct mac_entry *entry;
 
-	if (down_interruptible(&acl->sem))
-		return;
+	down(&acl->sem);
 
 	if (acl->size == 0) {
 		up(&acl->sem);
@@ -2116,8 +2114,7 @@ prism54_wpa_bss_ie_add(islpci_private *p
 	if (wpa_ie_len > MAX_WPA_IE_LEN)
 		wpa_ie_len = MAX_WPA_IE_LEN;
 
-	if (down_interruptible(&priv->wpa_sem))
-		return;
+	down(&priv->wpa_sem);
 
 	/* try to use existing entry */
 	list_for_each(ptr, &priv->bss_wpa_list) {
@@ -2178,8 +2175,7 @@ prism54_wpa_bss_ie_get(islpci_private *p
 	struct islpci_bss_wpa_ie *bss = NULL;
 	size_t len = 0;
 
-	if (down_interruptible(&priv->wpa_sem))
-		return 0;
+	down(&priv->wpa_sem);
 
 	list_for_each(ptr, &priv->bss_wpa_list) {
 		bss = list_entry(ptr, struct islpci_bss_wpa_ie, list);

-- 
