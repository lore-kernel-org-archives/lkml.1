Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbZG2ACs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbZG2ACs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZG1Xtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:39 -0400
Received: from kroah.org ([198.145.64.141]:35641 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbZG1Xti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:52 2009
Message-Id: <20090728234152.302607706@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tilman Schmidt <tilman@imap.cc>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 07/71] gigaset: accept connection establishment messages in any order
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=gigaset-accept-connection-establishment-messages-in-any-order.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit bceb0f126f25184eaec3f3c8f00c92b0d899e5de upstream.

ISDN connection setup failed if the "connection active" and
"B channel up" messages from the device arrived in a different
order than expected. Modify the state machine to accept them in
any order.

Impact: bugfix

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/gigaset/ev-layer.c |   44 ++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

--- a/drivers/isdn/gigaset/ev-layer.c
+++ b/drivers/isdn/gigaset/ev-layer.c
@@ -294,32 +294,33 @@ struct reply_t gigaset_tab_cid_m10x[] = 
 	{RSP_OK,      604,604, -1,                605, 5, {ACT_CMD+AT_MSN}},
 	{RSP_OK,      605,605, -1,                606, 5, {ACT_CMD+AT_ISO}},
 	{RSP_NULL,    605,605, -1,                606, 5, {ACT_CMD+AT_ISO}},
-	{RSP_OK,      606,606, -1,                607, 5, {0},             "+VLS=17\r"}, /* set "Endgeraetemodus" */
+	{RSP_OK,      606,606, -1,                607, 5, {0}, "+VLS=17\r"},
 	{RSP_OK,      607,607, -1,                608,-1},
-	//{RSP_ZSAU,    608,608,ZSAU_PROCEEDING,    608, 0, {ACT_ERROR}},//DELETE
 	{RSP_ZSAU,    608,608,ZSAU_PROCEEDING,    609, 5, {ACT_CMD+AT_DIAL}},
 	{RSP_OK,      609,609, -1,                650, 0, {ACT_DIALING}},
 
-	{RSP_ZVLS,    608,608, 17,                 -1,-1, {ACT_DEBUG}},
-	{RSP_ZCTP,    609,609, -1,                 -1,-1, {ACT_DEBUG}},
-	{RSP_ZCPN,    609,609, -1,                 -1,-1, {ACT_DEBUG}},
 	{RSP_ERROR,   601,609, -1,                  0, 0, {ACT_ABORTDIAL}},
 	{EV_TIMEOUT,  601,609, -1,                  0, 0, {ACT_ABORTDIAL}},
 
-	/* dialing */
-	{RSP_ZCTP,    650,650, -1,                 -1,-1, {ACT_DEBUG}},
-	{RSP_ZCPN,    650,650, -1,                 -1,-1, {ACT_DEBUG}},
-	{RSP_ZSAU,    650,650,ZSAU_CALL_DELIVERED, -1,-1, {ACT_DEBUG}}, /* some devices don't send this */
-
-	/* connection established  */
-	{RSP_ZSAU,    650,650,ZSAU_ACTIVE,        800,-1, {ACT_CONNECT}}, //FIXME -> DLE1
-	{RSP_ZSAU,    750,750,ZSAU_ACTIVE,        800,-1, {ACT_CONNECT}}, //FIXME -> DLE1
-
-	{EV_BC_OPEN,  800,800, -1,                800,-1, {ACT_NOTIFY_BC_UP}}, //FIXME new constate + timeout
+	/* optional dialing responses */
+	{EV_BC_OPEN,  650,650, -1,                651,-1},
+	{RSP_ZVLS,    608,651, 17,                 -1,-1, {ACT_DEBUG}},
+	{RSP_ZCTP,    609,651, -1,                 -1,-1, {ACT_DEBUG}},
+	{RSP_ZCPN,    609,651, -1,                 -1,-1, {ACT_DEBUG}},
+	{RSP_ZSAU,    650,651,ZSAU_CALL_DELIVERED, -1,-1, {ACT_DEBUG}},
+
+	/* connect */
+	{RSP_ZSAU,    650,650,ZSAU_ACTIVE,        800,-1, {ACT_CONNECT}},
+	{RSP_ZSAU,    651,651,ZSAU_ACTIVE,        800,-1, {ACT_CONNECT,
+							   ACT_NOTIFY_BC_UP}},
+	{RSP_ZSAU,    750,750,ZSAU_ACTIVE,        800,-1, {ACT_CONNECT}},
+	{RSP_ZSAU,    751,751,ZSAU_ACTIVE,        800,-1, {ACT_CONNECT,
+							   ACT_NOTIFY_BC_UP}},
+	{EV_BC_OPEN,  800,800, -1,                800,-1, {ACT_NOTIFY_BC_UP}},
 
 	/* remote hangup */
-	{RSP_ZSAU,    650,650,ZSAU_DISCONNECT_IND,  0, 0, {ACT_REMOTEREJECT}},
-	{RSP_ZSAU,    750,750,ZSAU_DISCONNECT_IND,  0, 0, {ACT_REMOTEHUP}},
+	{RSP_ZSAU,    650,651,ZSAU_DISCONNECT_IND,  0, 0, {ACT_REMOTEREJECT}},
+	{RSP_ZSAU,    750,751,ZSAU_DISCONNECT_IND,  0, 0, {ACT_REMOTEHUP}},
 	{RSP_ZSAU,    800,800,ZSAU_DISCONNECT_IND,  0, 0, {ACT_REMOTEHUP}},
 
 	/* hangup */
@@ -358,7 +359,8 @@ struct reply_t gigaset_tab_cid_m10x[] = 
 	{RSP_ZSAU,    700,729,ZSAU_ACTIVE,          0, 0, {ACT_ABORTACCEPT}},
 	{RSP_ZSAU,    700,729,ZSAU_DISCONNECT_IND,  0, 0, {ACT_ABORTACCEPT}},
 
-	{EV_TIMEOUT,  750,750, -1,                  0, 0, {ACT_CONNTIMEOUT}},
+	{EV_BC_OPEN,  750,750, -1,                751,-1},
+	{EV_TIMEOUT,  750,751, -1,                  0, 0, {ACT_CONNTIMEOUT}},
 
 	/* B channel closed (general case) */
 	{EV_BC_CLOSED, -1, -1, -1,                 -1,-1, {ACT_NOTIFY_BC_DOWN}}, //FIXME
@@ -876,12 +878,6 @@ static void bchannel_down(struct bc_stat
 
 static void bchannel_up(struct bc_state *bcs)
 {
-	if (!(bcs->chstate & CHS_D_UP)) {
-		dev_notice(bcs->cs->dev, "%s: D channel not up\n", __func__);
-		bcs->chstate |= CHS_D_UP;
-		gigaset_i4l_channel_cmd(bcs, ISDN_STAT_DCONN);
-	}
-
 	if (bcs->chstate & CHS_B_UP) {
 		dev_notice(bcs->cs->dev, "%s: B channel already up\n",
 			   __func__);


