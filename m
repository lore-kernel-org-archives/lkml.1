Return-Path: <linux-kernel-owner+w=401wt.eu-S1761158AbZB0Wvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761158AbZB0Wvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758586AbZB0WvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:51:21 -0500
Received: from kroah.org ([198.145.64.141]:53518 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758340AbZB0WvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:51:20 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: leandro Costantino <lcostantino@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/5] Staging: rtl8187se: Fix oops and memory poison caused by builtin ieee80211.
Date: Fri, 27 Feb 2009 14:49:19 -0800
Message-Id: <1235774963-19732-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <20090227224555.GB19545@kroah.com>
References: <20090227224555.GB19545@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: leandro Costantino <lcostantino@gmail.com>

when modprobe and removing rtl8187se ( just for testing, i do not have
that card , and oops and a memory poison error happens on the builtin
ieee80211 of that driver.  I dont know if they will port it to the
current ieeee80221 instead of the builtin ones, but just in case i
attach a proposed fix for that problem.

- Change for loop on ieee80211_crypto_deinit for list_for_each_safe to
  remove items. Is there an spinlock needed here?
- Call ieee80211_crypto_deinit after exiting all registerd crypto protocols.


Signed-off-by: Costantino Leandro <lcostantino@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |   19 ++++++++++---------
 drivers/staging/rtl8187se/r8180_core.c             |    2 +-
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
index af64cfb..7370296 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
@@ -234,20 +234,21 @@ out:
 void ieee80211_crypto_deinit(void)
 {
 	struct list_head *ptr, *n;
+	struct ieee80211_crypto_alg *alg = NULL;
 
 	if (hcrypt == NULL)
 		return;
 
-	for (ptr = hcrypt->algs.next, n = ptr->next; ptr != &hcrypt->algs;
-	     ptr = n, n = ptr->next) {
-		struct ieee80211_crypto_alg *alg =
-			(struct ieee80211_crypto_alg *) ptr;
-		list_del(ptr);
-		printk(KERN_DEBUG "ieee80211_crypt: unregistered algorithm "
-		       "'%s' (deinit)\n", alg->ops->name);
-		kfree(alg);
+	list_for_each_safe(ptr, n, &hcrypt->algs) {
+		alg = list_entry(ptr, struct ieee80211_crypto_alg, list);
+		if (alg) {
+			list_del(ptr);
+			printk(KERN_DEBUG
+			       "ieee80211_crypt: unregistered algorithm '%s' (deinit)\n",
+			       alg->ops->name);
+			kfree(alg);
+		}
 	}
-
 	kfree(hcrypt);
 }
 
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 9453495..66de5cc 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -6161,10 +6161,10 @@ static void __exit rtl8180_pci_module_exit(void)
 {
 	pci_unregister_driver (&rtl8180_pci_driver);
 	rtl8180_proc_module_remove();
-	ieee80211_crypto_deinit();
 	ieee80211_crypto_tkip_exit();
 	ieee80211_crypto_ccmp_exit();
 	ieee80211_crypto_wep_exit();
+	ieee80211_crypto_deinit();
 	DMESG("Exiting");
 }
 
-- 
1.6.0.2

