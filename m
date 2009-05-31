Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbZEaCAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbZEaCAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 22:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZEaCA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 22:00:27 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:58901 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZEaCA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 22:00:27 -0400
Date: Sat, 30 May 2009 18:58:01 -0700
From: "Larry H." <research@subreption.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@osdl.org>
Subject: [PATCH] Use kzfree in mac80211 key handling to enforce data
	sanitization
Message-ID: <20090531015801.GB8941@oblivion.subreption.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] Use kzfree in mac80211 key handling to enforce data sanitization

This patch replaces the kfree() calls within the mac80211 WEP RC4 key
handling and ieee80211 management APIs with kzfree(), to enforce
sanitization of the key buffer contents.

This prevents the keys from persisting on memory, potentially
leaking to other kernel users after re-allocation of the memory by
the LIFO allocators, or in coldboot attack scenarios. Information can be
leaked as well due to use of uninitialized variables, or other bugs.

This patch doesn't affect fastpaths.

Signed-off-by: Larry Highsmith <research@subreption.com>

Index: linux-2.6/net/mac80211/key.c
===================================================================
--- linux-2.6.orig/net/mac80211/key.c
+++ linux-2.6/net/mac80211/key.c
@@ -304,7 +304,7 @@ struct ieee80211_key *ieee80211_key_allo
 		 */
 		key->u.ccmp.tfm = ieee80211_aes_key_setup_encrypt(key_data);
 		if (!key->u.ccmp.tfm) {
-			kfree(key);
+			kzfree(key);
 			return NULL;
 		}
 	}
@@ -404,7 +404,7 @@ void ieee80211_key_free(struct ieee80211
 		 * and don't Oops */
 		if (key->conf.alg == ALG_CCMP)
 			ieee80211_aes_key_free(key->u.ccmp.tfm);
-		kfree(key);
+		kzfree(key);
 		return;
 	}
 
@@ -464,7 +464,7 @@ static void __ieee80211_key_destroy(stru
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
 	ieee80211_debugfs_key_remove(key);
 
-	kfree(key);
+	kzfree(key);
 }
 
 static void __ieee80211_key_todo(void)
Index: linux-2.6/net/mac80211/wep.c
===================================================================
--- linux-2.6.orig/net/mac80211/wep.c
+++ linux-2.6/net/mac80211/wep.c
@@ -161,7 +161,7 @@ int ieee80211_wep_encrypt(struct ieee802
 
 	iv = ieee80211_wep_add_iv(local, skb, key);
 	if (!iv) {
-		kfree(rc4key);
+		kzfree(rc4key);
 		return -1;
 	}
 
@@ -179,7 +179,7 @@ int ieee80211_wep_encrypt(struct ieee802
 	ieee80211_wep_encrypt_data(local->wep_tx_tfm, rc4key, klen,
 				   iv + WEP_IV_LEN, len);
 
-	kfree(rc4key);
+	kzfree(rc4key);
 
 	return 0;
 }
@@ -258,7 +258,7 @@ int ieee80211_wep_decrypt(struct ieee802
 				       len))
 		ret = -1;
 
-	kfree(rc4key);
+	kzfree(rc4key);
 
 	/* Trim ICV */
 	skb_trim(skb, skb->len - WEP_ICV_LEN);
