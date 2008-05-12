Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbYELKfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbYELKfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759057AbYELKfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:35:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:33852 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953AbYELKfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:35:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=HIWCO2sWaEOHar/0QJJwLbSaUHNAh1PEye6pMsTNR7A+lb4GMumqGkcyA3a+TqO5Ai4s1R4dLl8mHWn9/tgdn1KcZV34c31iKxIsRAEcxbNe/5HDmab6iDXoqbSFEBsCm13/SrRDjpBnQkvew+HgQ6a4/yYpuKgnqpGiKdXo06Y=
From: Bryan Wu <cooloney@kernel.org>
To: samuel@sortiz.org
Cc: irda-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Graf Yang <graf.yang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] [net/irda]: Fix a misalign access issue.
Date: Mon, 12 May 2008 18:35:21 +0800
Message-Id: <1210588521-11508-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 net/irda/discovery.c |    8 +++++---
 net/irda/irlmp.c     |    2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

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
index 1f81f8e..7b95cd6 100644
--- a/net/irda/irlmp.c
+++ b/net/irda/irlmp.c
@@ -1086,7 +1086,7 @@ discovery_t *irlmp_get_discovery_response(void)
 
 	IRDA_ASSERT(irlmp != NULL, return NULL;);
 
-	u16ho(irlmp->discovery_rsp.data.hints) = irlmp->hints.word;
+	put_unaligned(irlmp->hints.word, (__u16 *)irlmp->discovery_rsp.data.hints);
 
 	/*
 	 *  Set character set for device name (we use ASCII), and
-- 
1.5.5

