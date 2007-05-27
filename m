Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbXE0KiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbXE0KiH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 06:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXE0Kh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 06:37:56 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:38334
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751154AbXE0Khz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 06:37:55 -0400
Date: Sun, 27 May 2007 12:39:51 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: developers@islsm.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/2] use list_for_each_entry() for iteration in Prism 54 driver
Message-ID: <20070527103951.GK31790@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	developers@islsm.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070525125630.GE31790@traven> <20070525130444.GG31790@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525130444.GG31790@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, May 25, 2007 at 03:04:44PM +0200 Matthias Kaehlcke ha dit:

> Use list_for_each() in the Prism54 driver to iterate over the MAC list

In response to a similar patch Christoph Hellwig suggests the use of
list_for_each_entry() instead of list_for_each(). Here is a evolution
of the patch that takes into account Christophs' suggestion

--

Prism54 driver: Use list_for_each_entry() instead of manual iteration
and substitute a list_for_each_safe() loop with
list_for_each_entry_safe()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 283be4a..585f599 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1853,7 +1853,6 @@ prism54_del_mac(struct net_device *ndev, struct iw_request_info *info,
 	islpci_private *priv = netdev_priv(ndev);
 	struct islpci_acl *acl = &priv->acl;
 	struct mac_entry *entry;
-	struct list_head *ptr;
 	struct sockaddr *addr = (struct sockaddr *) extra;
 
 	if (addr->sa_family != ARPHRD_ETHER)
@@ -1861,11 +1860,9 @@ prism54_del_mac(struct net_device *ndev, struct iw_request_info *info,
 
 	if (down_interruptible(&acl->sem))
 		return -ERESTARTSYS;
-	for (ptr = acl->mac_list.next; ptr != &acl->mac_list; ptr = ptr->next) {
-		entry = list_entry(ptr, struct mac_entry, _list);
-
+	list_for_each_entry(entry, &acl->mac_list, _list) {
 		if (memcmp(entry->addr, addr->sa_data, ETH_ALEN) == 0) {
-			list_del(ptr);
+			list_del(&entry->_list);
 			acl->size--;
 			kfree(entry);
 			up(&acl->sem);
@@ -1883,7 +1880,6 @@ prism54_get_mac(struct net_device *ndev, struct iw_request_info *info,
 	islpci_private *priv = netdev_priv(ndev);
 	struct islpci_acl *acl = &priv->acl;
 	struct mac_entry *entry;
-	struct list_head *ptr;
 	struct sockaddr *dst = (struct sockaddr *) extra;
 
 	dwrq->length = 0;
@@ -1891,9 +1887,7 @@ prism54_get_mac(struct net_device *ndev, struct iw_request_info *info,
 	if (down_interruptible(&acl->sem))
 		return -ERESTARTSYS;
 
-	for (ptr = acl->mac_list.next; ptr != &acl->mac_list; ptr = ptr->next) {
-		entry = list_entry(ptr, struct mac_entry, _list);
-
+	list_for_each_entry(entry, &acl->mac_list, _list) {
 		memcpy(dst->sa_data, entry->addr, ETH_ALEN);
 		dst->sa_family = ARPHRD_ETHER;
 		dwrq->length++;
@@ -1960,7 +1954,6 @@ prism54_get_policy(struct net_device *ndev, struct iw_request_info *info,
 static int
 prism54_mac_accept(struct islpci_acl *acl, char *mac)
 {
-	struct list_head *ptr;
 	struct mac_entry *entry;
 	int res = 0;
 
@@ -1972,8 +1965,7 @@ prism54_mac_accept(struct islpci_acl *acl, char *mac)
 		return 1;
 	}
 
-	for (ptr = acl->mac_list.next; ptr != &acl->mac_list; ptr = ptr->next) {
-		entry = list_entry(ptr, struct mac_entry, _list);
+	list_for_each_entry(entry, &acl->mac_list, _list) {
 		if (memcmp(entry->addr, mac, ETH_ALEN) == 0) {
 			res = 1;
 			break;
@@ -2216,11 +2208,9 @@ prism54_wpa_bss_ie_init(islpci_private *priv)
 void
 prism54_wpa_bss_ie_clean(islpci_private *priv)
 {
-	struct list_head *ptr, *n;
+	struct islpci_bss_wpa_ie *bss, *n;
 
-	list_for_each_safe(ptr, n, &priv->bss_wpa_list) {
-		struct islpci_bss_wpa_ie *bss;
-		bss = list_entry(ptr, struct islpci_bss_wpa_ie, list);
+	list_for_each_entry_safe(bss, n, &priv->bss_wpa_list, list) {
 		kfree(bss);
 	}
 }

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    I am incapable of conceiving infinity, and yet I do not accept finity
                          (Simone de Beauvoir)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
