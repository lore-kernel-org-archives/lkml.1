Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbXE0K0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbXE0K0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 06:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbXE0K0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 06:26:35 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:38619
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751311AbXE0K0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 06:26:34 -0400
Date: Sun, 27 May 2007 12:28:24 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Christoph Hellwig <hch@infradead.org>, j@w1.fi, hostap@shmoo.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 1/2] use list_for_each_entry() for iteration in hostap_ap.c
Message-ID: <20070527102824.GJ31790@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Christoph Hellwig <hch@infradead.org>, j@w1.fi, hostap@shmoo.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070525125630.GE31790@traven> <20070525130308.GF31790@traven> <20070525143005.GB10669@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525143005.GB10669@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, May 25, 2007 at 03:30:05PM +0100 Christoph Hellwig ha dit:

> On Fri, May 25, 2007 at 03:03:08PM +0200, Matthias Kaehlcke wrote:
> > Use list_for_each() in the Host AP driver to iterate over the MAC
> > restrictions and the STA info lists
> 
> please go all the way to a proper list_for_each_entry.  

thanks for your comment, here's a patch that uses
list_for_each_entry(), additionally to the initial patch it
substitutes some list_for_each() loops by list_for_each_entry()

> Then again now that we have mac80211 shouldn't hostap be ported over
> to it and this code go away completely?

i hope the patch can be useful in the meantime, otherwise just ignore
it

--

hostap_ap.c: Use list_for_each_entry() instead of manual iteration and
substitute some list_for_each() loops with list_for_each_entry()

--

diff --git a/drivers/net/wireless/hostap/hostap_ap.c b/drivers/net/wireless/hostap/hostap_ap.c
index 5b3abd5..120bc9b 100644
--- a/drivers/net/wireless/hostap/hostap_ap.c
+++ b/drivers/net/wireless/hostap/hostap_ap.c
@@ -326,7 +326,6 @@ static int ap_control_proc_read(char *page, char **start, off_t off,
 	char *p = page;
 	struct ap_data *ap = (struct ap_data *) data;
 	char *policy_txt;
-	struct list_head *ptr;
 	struct mac_entry *entry;
 
 	if (off != 0) {
@@ -352,14 +351,12 @@ static int ap_control_proc_read(char *page, char **start, off_t off,
 	p += sprintf(p, "MAC entries: %u\n", ap->mac_restrictions.entries);
 	p += sprintf(p, "MAC list:\n");
 	spin_lock_bh(&ap->mac_restrictions.lock);
-	for (ptr = ap->mac_restrictions.mac_list.next;
-	     ptr != &ap->mac_restrictions.mac_list; ptr = ptr->next) {
+	list_for_each_entry(entry, &ap->mac_restrictions.mac_list, list) {
 		if (p - page > PAGE_SIZE - 80) {
 			p += sprintf(p, "All entries did not fit one page.\n");
 			break;
 		}
 
-		entry = list_entry(ptr, struct mac_entry, list);
 		p += sprintf(p, MACSTR "\n", MAC2STR(entry->addr));
 	}
 	spin_unlock_bh(&ap->mac_restrictions.lock);
@@ -410,10 +407,10 @@ int ap_control_del_mac(struct mac_restrictions *mac_restrictions, u8 *mac)
 }
 
 
+
 static int ap_control_mac_deny(struct mac_restrictions *mac_restrictions,
 			       u8 *mac)
 {
-	struct list_head *ptr;
 	struct mac_entry *entry;
 	int found = 0;
 
@@ -421,10 +418,7 @@ static int ap_control_mac_deny(struct mac_restrictions *mac_restrictions,
 		return 0;
 
 	spin_lock_bh(&mac_restrictions->lock);
-	for (ptr = mac_restrictions->mac_list.next;
-	     ptr != &mac_restrictions->mac_list; ptr = ptr->next) {
-		entry = list_entry(ptr, struct mac_entry, list);
-
+	list_for_each_entry(entry, &mac_restrictions->mac_list, list) {
 		if (memcmp(entry->addr, mac, ETH_ALEN) == 0) {
 			found = 1;
 			break;
@@ -519,7 +513,7 @@ static int prism2_ap_proc_read(char *page, char **start, off_t off,
 {
 	char *p = page;
 	struct ap_data *ap = (struct ap_data *) data;
-	struct list_head *ptr;
+	struct sta_info *sta;
 	int i;
 
 	if (off > PROC_LIMIT) {
@@ -529,9 +523,7 @@ static int prism2_ap_proc_read(char *page, char **start, off_t off,
 
 	p += sprintf(p, "# BSSID CHAN SIGNAL NOISE RATE SSID FLAGS\n");
 	spin_lock_bh(&ap->sta_table_lock);
-	for (ptr = ap->sta_list.next; ptr != &ap->sta_list; ptr = ptr->next) {
-		struct sta_info *sta = (struct sta_info *) ptr;
-
+	list_for_each_entry(sta, &ap->sta_list, list) {
 		if (!sta->ap)
 			continue;
 
@@ -861,7 +853,7 @@ void hostap_init_ap_proc(local_info_t *local)
 
 void hostap_free_data(struct ap_data *ap)
 {
-	struct list_head *n, *ptr;
+	struct sta_info *n, *sta;
 
 	if (ap == NULL || !ap->initialized) {
 		printk(KERN_DEBUG "hostap_free_data: ap has not yet been "
@@ -875,8 +867,7 @@ void hostap_free_data(struct ap_data *ap)
 	ap->crypt = ap->crypt_priv = NULL;
 #endif /* PRISM2_NO_KERNEL_IEEE80211_MGMT */
 
-	list_for_each_safe(ptr, n, &ap->sta_list) {
-		struct sta_info *sta = list_entry(ptr, struct sta_info, list);
+	list_for_each_entry_safe(sta, n, &ap->sta_list, list) {
 		ap_sta_hash_del(ap, sta);
 		list_del(&sta->list);
 		if ((sta->flags & WLAN_STA_ASSOC) && !sta->ap && sta->local)
@@ -3198,15 +3189,14 @@ int hostap_update_rx_stats(struct ap_data *ap,
 
 void hostap_update_rates(local_info_t *local)
 {
-	struct list_head *ptr;
+	struct sta_info *sta;
 	struct ap_data *ap = local->ap;
 
 	if (!ap)
 		return;
 
 	spin_lock_bh(&ap->sta_table_lock);
-	for (ptr = ap->sta_list.next; ptr != &ap->sta_list; ptr = ptr->next) {
-		struct sta_info *sta = (struct sta_info *) ptr;
+	list_for_each_entry(sta, &ap->sta_list, list) {
 		prism2_check_tx_rates(sta);
 	}
 	spin_unlock_bh(&ap->sta_table_lock);
@@ -3242,11 +3232,10 @@ void * ap_crypt_get_ptrs(struct ap_data *ap, u8 *addr, int permanent,
 void hostap_add_wds_links(local_info_t *local)
 {
 	struct ap_data *ap = local->ap;
-	struct list_head *ptr;
+	struct sta_info *sta;
 
 	spin_lock_bh(&ap->sta_table_lock);
-	list_for_each(ptr, &ap->sta_list) {
-		struct sta_info *sta = list_entry(ptr, struct sta_info, list);
+	list_for_each_entry(sta, &ap->sta_list, list) {
 		if (sta->ap)
 			hostap_wds_link_oper(local, sta->addr, WDS_ADD);
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
