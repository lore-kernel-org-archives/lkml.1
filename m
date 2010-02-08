Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab0BHUOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:14:35 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:43481 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab0BHUNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:13:16 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH v2 38/41] CAPI: Drop return value of handle_minor_send
Date: Mon,  8 Feb 2010 21:12:42 +0100
Message-Id: <ae256c0384e050532e4a0bd134115cef180dd1eb.1265659937.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX19AI14sCvpCwq+qjzxJVxlG/qxWfLfzF2+oqClR
	BjRh4ioxNkkkUimL6K3JQoY3jGIOgcy53CxJ2a4d/7Cw/VbOPx
	fXMcUSkaE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We did not evaluate handle_minor_send's return value, just (void)'ed it
away. Time for a cleanup.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 drivers/isdn/capi/capi.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 40b81b4..ee58375 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -516,25 +516,24 @@ static void handle_minor_recv(struct capiminor *mp)
 		}
 }
 
-static int handle_minor_send(struct capiminor *mp)
+static void handle_minor_send(struct capiminor *mp)
 {
 	struct tty_struct *tty;
 	struct sk_buff *skb;
 	u16 len;
-	int count = 0;
 	u16 errcode;
 	u16 datahandle;
 
 	tty = tty_port_tty_get(&mp->port);
 	if (!tty)
-		return 0;
+		return;
 
 	if (mp->ttyoutstop) {
 #if defined(_DEBUG_DATAFLOW) || defined(_DEBUG_TTYFUNCS)
 		printk(KERN_DEBUG "capi: send: tty stopped\n");
 #endif
 		tty_kref_put(tty);
-		return 0;
+		return;
 	}
 
 	while (1) {
@@ -570,12 +569,10 @@ static int handle_minor_send(struct capiminor *mp)
 			mp->outbytes += len;
 			spin_unlock_bh(&mp->outlock);
 
-			tty_kref_put(tty);
-			return count;
+			break;
 		}
 		errcode = capi20_put_message(mp->ap, skb);
 		if (errcode == CAPI_NOERROR) {
-			count++;
 #ifdef _DEBUG_DATAFLOW
 			printk(KERN_DEBUG "capi: DATA_B3_REQ %u len=%u\n",
 							datahandle, len);
@@ -600,7 +597,6 @@ static int handle_minor_send(struct capiminor *mp)
 		kfree_skb(skb);
 	}
 	tty_kref_put(tty);
-	return count;
 }
 
 #endif /* CONFIG_ISDN_CAPI_MIDDLEWARE */
@@ -677,7 +673,7 @@ static void capi_recv_message(struct capi20_appl *ap, struct sk_buff *skb)
 			tty_wakeup(tty);
 			tty_kref_put(tty);
 		}
-		(void)handle_minor_send(mp);
+		handle_minor_send(mp);
 
 	} else {
 		/* ups, let capi application handle it :-) */
@@ -1114,7 +1110,7 @@ static int capinc_tty_write(struct tty_struct *tty,
 	mp->outbytes += skb->len;
 	spin_unlock_bh(&mp->outlock);
 
-	(void)handle_minor_send(mp);
+	handle_minor_send(mp);
 
 	return count;
 }
@@ -1157,7 +1153,7 @@ unlock_out:
 	spin_unlock_bh(&mp->outlock);
 
 	if (invoke_send)
-		(void)handle_minor_send(mp);
+		handle_minor_send(mp);
 
 	return ret;
 }
@@ -1179,7 +1175,7 @@ static void capinc_tty_flush_chars(struct tty_struct *tty)
 		mp->outbytes += skb->len;
 		spin_unlock_bh(&mp->outlock);
 
-		(void)handle_minor_send(mp);
+		handle_minor_send(mp);
 	} else
 		spin_unlock_bh(&mp->outlock);
 
@@ -1269,7 +1265,7 @@ static void capinc_tty_start(struct tty_struct *tty)
 	printk(KERN_DEBUG "capinc_tty_start\n");
 #endif
 	mp->ttyoutstop = 0;
-	(void)handle_minor_send(mp);
+	handle_minor_send(mp);
 }
 
 static void capinc_tty_hangup(struct tty_struct *tty)
-- 
1.6.0.2

