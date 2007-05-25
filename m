Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbXEYNBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbXEYNBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbXEYNBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:01:07 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:37786
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751730AbXEYNBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:01:04 -0400
Date: Fri, 25 May 2007 15:03:08 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: j@w1.fi, hostap@shmoo.com, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/2] use list_for_each() for iteration in Host AP driver
Message-ID: <20070525130308.GF31790@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>, j@w1.fi,
	hostap@shmoo.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070525125630.GE31790@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525125630.GE31790@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_for_each() in the Host AP driver to iterate over the MAC
restrictions and the STA info lists

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/net/wireless/hostap/hostap_ap.c b/drivers/net/wireless/hostap/hostap_ap.c
index 5b3abd5..0718eeb 100644
--- a/drivers/net/wireless/hostap/hostap_ap.c
+++ b/drivers/net/wireless/hostap/hostap_ap.c
@@ -352,8 +352,7 @@ static int ap_control_proc_read(char *page, char **start, off_t off,
 	p += sprintf(p, "MAC entries: %u\n", ap->mac_restrictions.entries);
 	p += sprintf(p, "MAC list:\n");
 	spin_lock_bh(&ap->mac_restrictions.lock);
-	for (ptr = ap->mac_restrictions.mac_list.next;
-	     ptr != &ap->mac_restrictions.mac_list; ptr = ptr->next) {
+	list_for_each(ptr, &ap->mac_restrictions.mac_list) {
 		if (p - page > PAGE_SIZE - 80) {
 			p += sprintf(p, "All entries did not fit one page.\n");
 			break;
@@ -393,8 +392,7 @@ int ap_control_del_mac(struct mac_restrictions *mac_restrictions, u8 *mac)
 	struct mac_entry *entry;
 
 	spin_lock_bh(&mac_restrictions->lock);
-	for (ptr = mac_restrictions->mac_list.next;
-	     ptr != &mac_restrictions->mac_list; ptr = ptr->next) {
+	list_for_each(ptr, &mac_restrictions->mac_list) {
 		entry = list_entry(ptr, struct mac_entry, list);
 
 		if (memcmp(entry->addr, mac, ETH_ALEN) == 0) {
@@ -421,8 +419,7 @@ static int ap_control_mac_deny(struct mac_restrictions *mac_restrictions,
 		return 0;
 
 	spin_lock_bh(&mac_restrictions->lock);
-	for (ptr = mac_restrictions->mac_list.next;
-	     ptr != &mac_restrictions->mac_list; ptr = ptr->next) {
+	list_for_each(ptr, &mac_restrictions->mac_list) {
 		entry = list_entry(ptr, struct mac_entry, list);
 
 		if (memcmp(entry->addr, mac, ETH_ALEN) == 0) {
@@ -529,7 +526,7 @@ static int prism2_ap_proc_read(char *page, char **start, off_t off,
 
 	p += sprintf(p, "# BSSID CHAN SIGNAL NOISE RATE SSID FLAGS\n");
 	spin_lock_bh(&ap->sta_table_lock);
-	for (ptr = ap->sta_list.next; ptr != &ap->sta_list; ptr = ptr->next) {
+	list_for_each(ptr, &ap->sta_list) {
 		struct sta_info *sta = (struct sta_info *) ptr;
 
 		if (!sta->ap)
@@ -3205,7 +3202,7 @@ void hostap_update_rates(local_info_t *local)
 		return;
 
 	spin_lock_bh(&ap->sta_table_lock);
-	for (ptr = ap->sta_list.next; ptr != &ap->sta_list; ptr = ptr->next) {
+	list_for_each(ptr, &ap->sta_list) {
 		struct sta_info *sta = (struct sta_info *) ptr;
 		prism2_check_tx_rates(sta);
 	}

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

            You can chain me, you can torture me, you can even
          destroy this body, but you will never imprison my mind
                            (Mahatma Gandhi)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
