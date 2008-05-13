Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbYEMIKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbYEMIKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYEMIJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:09:52 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:15858 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbYEMIJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:09:51 -0400
X-IronPort-AV: E=Sophos;i="4.27,478,1204520400"; 
   d="scan'208";a="53447595"
From: Bryan Wu <cooloney@kernel.org>
To: marcel@holtmann.org, davem@davemloft.net
Cc: irda-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       samuel@sortiz.org, Graf Yang <graf.yang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] [net/irda]: Fix a misalign access issue. (v2)
Date: Tue, 13 May 2008 16:09:47 +0800
Message-Id: <1210666187-739-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Replace u16ho with put/get_unaligned functions

Signed-off-by: Graf Yang <graf.yang@analog.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 include/net/irda/discovery.h |    3 ---
 net/irda/discovery.c         |    8 +++++---
 net/irda/irlmp.c             |    5 +++--
 net/irda/irnet/irnet_irda.c  |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/irda/discovery.h b/include/net/irda/discovery.h
index e4efad1..0ce9339 100644
--- a/include/net/irda/discovery.h
+++ b/include/net/irda/discovery.h
@@ -57,9 +57,6 @@ typedef union {
 	__u8  byte[2];
 } __u16_host_order;
 
-/* Same purpose, different application */
-#define u16ho(array) (* ((__u16 *) array))
-
 /* Types of discovery */
 typedef enum {
 	DISCOVERY_LOG,		/* What's in our discovery log */
diff --git a/net/irda/discovery.c b/net/irda/discovery.c
index bfacef8..a6f99b5 100644
--- a/net/irda/discovery.c
+++ b/net/irda/discovery.c
@@ -40,6 +40,8 @@
 
 #include <net/irda/discovery.h>
 
+#include <asm/unaligned.h>
+
 /*
  * Function irlmp_add_discovery (cachelog, discovery)
  *
@@ -87,7 +89,7 @@ void irlmp_add_discovery(hashbin_t *cachelog, discovery_t *new)
 			 */
 			hashbin_remove_this(cachelog, (irda_queue_t *) node);
 			/* Check if hints bits are unchanged */
-			if(u16ho(node->data.hints) == u16ho(new->data.hints))
+			if (get_unaligned((__u16 *)node->data.hints) == get_unaligned((__u16 *)new->data.hints))
 				/* Set time of first discovery for this node */
 				new->firststamp = node->firststamp;
 			kfree(node);
@@ -281,9 +283,9 @@ struct irda_device_info *irlmp_copy_discoveries(hashbin_t *log, int *pn,
 		/* Mask out the ones we don't want :
 		 * We want to match the discovery mask, and to get only
 		 * the most recent one (unless we want old ones) */
-		if ((u16ho(discovery->data.hints) & mask) &&
+		if ((get_unaligned((__u16 *)discovery->data.hints) & mask) &&
 		    ((old_entries) ||
-		     ((jiffies - discovery->firststamp) < j_timeout)) ) {
+		     ((jiffies - discovery->firststamp) < j_timeout))) {
 			/* Create buffer as needed.
 			 * As this function get called a lot and most time
 			 * we don't have anything to put in the log (we are
diff --git a/net/irda/irlmp.c b/net/irda/irlmp.c
index 1f81f8e..7bf5b91 100644
--- a/net/irda/irlmp.c
+++ b/net/irda/irlmp.c
@@ -1062,7 +1062,8 @@ void irlmp_discovery_expiry(discinfo_t *expiries, int number)
 		for(i = 0; i < number; i++) {
 			/* Check if we should notify client */
 			if ((client->expir_callback) &&
-			    (client->hint_mask.word & u16ho(expiries[i].hints)
+			    (client->hint_mask.word &
+			     get_unaligned((__u16 *)expiries[i].hints)
 			     & 0x7f7f) )
 				client->expir_callback(&(expiries[i]),
 						       EXPIRY_TIMEOUT,
@@ -1086,7 +1087,7 @@ discovery_t *irlmp_get_discovery_response(void)
 
 	IRDA_ASSERT(irlmp != NULL, return NULL;);
 
-	u16ho(irlmp->discovery_rsp.data.hints) = irlmp->hints.word;
+	put_unaligned(irlmp->hints.word, (__u16 *)irlmp->discovery_rsp.data.hints);
 
 	/*
 	 *  Set character set for device name (we use ASCII), and
diff --git a/net/irda/irnet/irnet_irda.c b/net/irda/irnet/irnet_irda.c
index 75497e5..a3ec002 100644
--- a/net/irda/irnet/irnet_irda.c
+++ b/net/irda/irnet/irnet_irda.c
@@ -1673,7 +1673,7 @@ irnet_discovery_indication(discinfo_t *		discovery,
   /* Notify the control channel */
   irnet_post_event(NULL, IRNET_DISCOVER,
 		   discovery->saddr, discovery->daddr, discovery->info,
-		   u16ho(discovery->hints));
+		   get_unaligned((__u16 *)discovery->hints));
 
   DEXIT(IRDA_OCB_TRACE, "\n");
 }
@@ -1704,7 +1704,7 @@ irnet_expiry_indication(discinfo_t *	expiry,
   /* Notify the control channel */
   irnet_post_event(NULL, IRNET_EXPIRE,
 		   expiry->saddr, expiry->daddr, expiry->info,
-		   u16ho(expiry->hints));
+		   get_unaligned((__u16 *)expiry->hints));
 
   DEXIT(IRDA_OCB_TRACE, "\n");
 }
-- 
1.5.5
