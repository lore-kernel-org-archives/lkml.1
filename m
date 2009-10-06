Return-Path: <linux-kernel-owner+w=401wt.eu-S933539AbZJFWTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539AbZJFWTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933513AbZJFWTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:19:00 -0400
Received: from mail.pxnet.com ([195.227.45.7]:40993 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933508AbZJFWS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:18:58 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 3/4] isdn: avoid races in capidrv
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
CC: Karsten Keil <isdn@linux-pingi.de>, Karsten Keil <keil@b1-systems.de>,
       isdn4linux@listserv.isdn4linux.de, i4ldeveloper@listserv.isdn4linux.de
Message-ID: <20091006-patch-capi-3.tilman@imap.cc>
In-Reply-To: <20091006-patch-capi-0.tilman@imap.cc>
References: <20091006-patch-capi-0.tilman@imap.cc>
Date: Wed,  7 Oct 2009 00:18:10 +0200 (CEST)
X-Spam-Score: -2.145 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In several places, capidrv sends a CAPI message to the ISDN
device and then updates its internal state accordingly.
If the response message from the device arrives before the
state is updated, it may be rejected or processed incorrectly.
Avoid these races by updating the state before emitting the
message.

Impact: bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Acked-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/capi/capidrv.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index 6501202..4921eae 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -671,8 +671,8 @@ static void n0(capidrv_contr * card, capidrv_ncci * ncci)
 				 NULL,	/* Useruserdata */   /* $$$$ */
 				 NULL	/* Facilitydataarray */
 	);
-	send_message(card, &cmsg);
 	plci_change_state(card, ncci->plcip, EV_PLCI_DISCONNECT_REQ);
+	send_message(card, &cmsg);
 
 	cmd.command = ISDN_STAT_BHUP;
 	cmd.driver = card->myid;
@@ -924,8 +924,8 @@ static void handle_incoming_call(capidrv_contr * card, _cmsg * cmsg)
 		 */
 		capi_cmsg_answer(cmsg);
 		cmsg->Reject = 1;	/* ignore */
-		send_message(card, cmsg);
 		plci_change_state(card, plcip, EV_PLCI_CONNECT_REJECT);
+		send_message(card, cmsg);
 		printk(KERN_INFO "capidrv-%d: incoming call %s,%d,%d,%s ignored\n",
 			card->contrnr,
 			cmd.parm.setup.phone,
@@ -974,8 +974,8 @@ static void handle_incoming_call(capidrv_contr * card, _cmsg * cmsg)
 	case 2:		/* Call will be rejected. */
 		capi_cmsg_answer(cmsg);
 		cmsg->Reject = 2;	/* reject call, normal call clearing */
-		send_message(card, cmsg);
 		plci_change_state(card, plcip, EV_PLCI_CONNECT_REJECT);
+		send_message(card, cmsg);
 		break;
 
 	default:
@@ -983,8 +983,8 @@ static void handle_incoming_call(capidrv_contr * card, _cmsg * cmsg)
 		capi_cmsg_answer(cmsg);
 		cmsg->Reject = 8;	/* reject call,
 					   destination out of order */
-		send_message(card, cmsg);
 		plci_change_state(card, plcip, EV_PLCI_CONNECT_REJECT);
+		send_message(card, cmsg);
 		break;
 	}
 	return;
@@ -1020,8 +1020,8 @@ static void handle_plci(_cmsg * cmsg)
 		card->bchans[plcip->chan].disconnecting = 1;
 		plci_change_state(card, plcip, EV_PLCI_DISCONNECT_IND);
 		capi_cmsg_answer(cmsg);
-		send_message(card, cmsg);
 		plci_change_state(card, plcip, EV_PLCI_DISCONNECT_RESP);
+		send_message(card, cmsg);
 		break;
 
 	case CAPI_DISCONNECT_CONF:	/* plci */
@@ -1078,8 +1078,8 @@ static void handle_plci(_cmsg * cmsg)
 
 		if (card->bchans[plcip->chan].incoming) {
 			capi_cmsg_answer(cmsg);
-			send_message(card, cmsg);
 			plci_change_state(card, plcip, EV_PLCI_CONNECT_ACTIVE_IND);
+			send_message(card, cmsg);
 		} else {
 			capidrv_ncci *nccip;
 			capi_cmsg_answer(cmsg);
@@ -1098,13 +1098,14 @@ static void handle_plci(_cmsg * cmsg)
 						 NULL	/* NCPI */
 			);
 			nccip->msgid = cmsg->Messagenumber;
+			plci_change_state(card, plcip,
+					  EV_PLCI_CONNECT_ACTIVE_IND);
+			ncci_change_state(card, nccip, EV_NCCI_CONNECT_B3_REQ);
 			send_message(card, cmsg);
 			cmd.command = ISDN_STAT_DCONN;
 			cmd.driver = card->myid;
 			cmd.arg = plcip->chan;
 			card->interface.statcallb(&cmd);
-			plci_change_state(card, plcip, EV_PLCI_CONNECT_ACTIVE_IND);
-			ncci_change_state(card, nccip, EV_NCCI_CONNECT_B3_REQ);
 		}
 		break;
 
@@ -1193,8 +1194,8 @@ static void handle_ncci(_cmsg * cmsg)
 			goto notfound;
 
 		capi_cmsg_answer(cmsg);
-		send_message(card, cmsg);
 		ncci_change_state(card, nccip, EV_NCCI_CONNECT_B3_ACTIVE_IND);
+		send_message(card, cmsg);
 
 		cmd.command = ISDN_STAT_BCONN;
 		cmd.driver = card->myid;
@@ -1222,8 +1223,8 @@ static void handle_ncci(_cmsg * cmsg)
 							  0,	/* Reject */
 							  NULL	/* NCPI */
 				);
-				send_message(card, cmsg);
 				ncci_change_state(card, nccip, EV_NCCI_CONNECT_B3_RESP);
+				send_message(card, cmsg);
 				break;
 			}
 			printk(KERN_ERR "capidrv-%d: no mem for ncci, sorry\n",							card->contrnr);
@@ -1299,8 +1300,8 @@ static void handle_ncci(_cmsg * cmsg)
 		card->bchans[nccip->chan].disconnecting = 1;
 		ncci_change_state(card, nccip, EV_NCCI_DISCONNECT_B3_IND);
 		capi_cmsg_answer(cmsg);
-		send_message(card, cmsg);
 		ncci_change_state(card, nccip, EV_NCCI_DISCONNECT_B3_RESP);
+		send_message(card, cmsg);
 		break;
 
 	case CAPI_DISCONNECT_B3_CONF:	/* ncci */
@@ -2014,8 +2015,8 @@ static void send_listen(capidrv_contr *card)
 			     card->cipmask,
 			     card->cipmask2,
 			     NULL, NULL);
-	send_message(card, &cmdcmsg);
 	listen_change_state(card, EV_LISTEN_REQ);
+	send_message(card, &cmdcmsg);
 }
 
 static void listentimerfunc(unsigned long x)
-- 
1.6.2.1.214.ge986c

