Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349Ab0AVX2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab0AVX2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941Ab0AVX2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:28:15 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:50614 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341Ab0AVX2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:28:10 -0500
Message-Id: <bc3f0c47fbd9937251ba8f3fae0c01fba4b668d0.1264201408.git.jan.kiszka@web.de>
In-Reply-To: <cover.1264201406.git.jan.kiszka@web.de>
References: <cover.1264201406.git.jan.kiszka@web.de>
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org
Date: Sun, 10 Jan 2010 14:07:38 +0100
Subject: [PATCH 29/31] CAPI: Drop special controller lookup from capi20_put_message
X-Provags-ID: V01U2FsdGVkX1+/vk337V356C1CgDk4lDcWOpHjVmJcaCpdyCT/
	tqJT3J2aMOUPk5c2kHJ0W/MzY3ppeyVB9QsSjFoOpiZtfca257
	kV4VYu1/c=
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
index 2c5d1b8..0e00028 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -770,11 +770,8 @@ u16 capi20_put_message(struct capi20_appl *ap, struct sk_buff *skb)
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

