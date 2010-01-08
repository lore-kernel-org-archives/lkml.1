Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234Ab0AVX0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0AVX0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113Ab0AVX0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:26:12 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:33266 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab0AVX0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:26:07 -0500
Message-Id: <c4afddbc4700ff0df16dc832c59f191e42684e76.1264201408.git.jan.kiszka@web.de>
In-Reply-To: <cover.1264201406.git.jan.kiszka@web.de>
References: <cover.1264201406.git.jan.kiszka@web.de>
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org
Date: Fri, 8 Jan 2010 12:57:25 +0100
Subject: [PATCH 25/31] CAPI: Drop capiminor's unused inbytes counter
X-Provags-ID: V01U2FsdGVkX181feyfLEaH3qli+fqDJaFhvYXU34KEddHuoBfU
	kls17kfHtvY6Xq1TG6sn4zP7ogajlgrhIIvZkXk9IgpWj4ckTy
	jE/ZRa24A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inbytes counter was only updated but never read.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 drivers/isdn/capi/capi.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 6ab496c..40468ac 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -100,7 +100,6 @@ struct capiminor {
 	struct sk_buff    *ttyskb;
 
 	struct sk_buff_head inqueue;
-	int                 inbytes;
 	struct sk_buff_head outqueue;
 	int                 outbytes;
 
@@ -481,15 +480,12 @@ keep:
 static void handle_minor_recv(struct capiminor *mp)
 {
 	struct sk_buff *skb;
-	while ((skb = skb_dequeue(&mp->inqueue)) != NULL) {
-		unsigned int len = skb->len;
-		mp->inbytes -= len;
+
+	while ((skb = skb_dequeue(&mp->inqueue)) != NULL)
 		if (handle_recv_skb(mp, skb) < 0) {
 			skb_queue_head(&mp->inqueue, skb);
-			mp->inbytes += len;
 			return;
 		}
-	}
 }
 
 static int handle_minor_send(struct capiminor *mp)
@@ -611,7 +607,7 @@ static void capi_recv_message(struct capi20_appl *ap, struct sk_buff *skb)
 				datahandle, skb->len-CAPIMSG_LEN(skb->data));
 #endif
 		skb_queue_tail(&mp->inqueue, skb);
-		mp->inbytes += skb->len;
+
 		handle_minor_recv(mp);
 
 	} else if (CAPIMSG_SUBCOMMAND(skb->data) == CAPI_CONF) {
-- 
1.6.0.2

