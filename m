Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab0BHUOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:14:33 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:43490 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab0BHUNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:13:16 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH v2 39/41] CAPI: Drop special controller lookup from capi20_put_message
Date: Mon,  8 Feb 2010 21:12:43 +0100
Message-Id: <721dec20fc415bbacdf9e8eef7dd3992e58ae4d8.1265659937.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX1+8MbT0PrgZhfCa2bd2FVN36r0p50EKdQU0Gdhz
	0qVABJ9P0F52GoWGiI81Q6tDBUerhp7CVyMBCJIKTgsSgRWnpP
	VznqYgEDQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This strange special rule to fall back to controller 1 cannot be derived
from the CAPI specs and looks a lot like it was once dedicated to some
out-of-tree driver, probably AVM's broken fcdsl2 (FRITZ!Card DSL v2.0).
I found no in-tree user that needs this check, and I'm now taking care
of the fcdsl2. So drop these bits from our stack.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 drivers/isdn/capi/kcapi.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index 0b4c8a7..ce9b05b 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -777,11 +777,8 @@ u16 capi20_put_message(struct capi20_appl *ap, struct sk_buff *skb)
 	 * synchronizes this service with capi20_release.
 	 */
 	ctr = get_capi_ctr_by_nr(CAPIMSG_CONTROLLER(skb->data));
-	if (!ctr || ctr->state != CAPI_CTR_RUNNING) {
-		ctr = get_capi_ctr_by_nr(1); /* XXX why? */
-		if (!ctr || ctr->state != CAPI_CTR_RUNNING)
-			return CAPI_REGNOTINSTALLED;
-	}
+	if (!ctr || ctr->state != CAPI_CTR_RUNNING)
+		return CAPI_REGNOTINSTALLED;
 	if (ctr->blocked)
 		return CAPI_SENDQUEUEFULL;
 
-- 
1.6.0.2

