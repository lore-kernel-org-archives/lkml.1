Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbZKSRcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbZKSRcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbZKSRcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:32:09 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54936 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754064AbZKSRcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:32:06 -0500
From: Robin Holt <holt@sgi.com>
Message-Id: <20091119173211.273295000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 19 Nov 2009 11:32:04 -0600
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch 7/8] X86: UV - xpc_make_first_contact hang due to not accepting ACTIVE state.
References: <20091119173157.337874000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=xpc_first_contact_when_active
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Many times while the initial connection is being made, the
contacted partition will send back both the ACTIVATING and the ACTIVE
remote_act_state changes in very close succescion.  The 1/4 second delay
in the make first contact loop is large enough to nearly always miss
the ACTIVATING state change.

Since either state indicates the remote partition has acknowledged our
state change, accept either.

To: Ingo Molnar <mingo@elte.hu>
To: tglx@linutronix.de
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org

---
 drivers/misc/sgi-xp/xpc_uv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
Index: linux-x86/drivers/misc/sgi-xp/xpc_uv.c
===================================================================
--- linux-x86.orig/drivers/misc/sgi-xp/xpc_uv.c	2009-11-18 21:54:46.000000000 -0600
+++ linux-x86/drivers/misc/sgi-xp/xpc_uv.c	2009-11-18 21:55:18.000000000 -0600
@@ -1024,7 +1024,8 @@ xpc_make_first_contact_uv(struct xpc_par
 	xpc_send_activate_IRQ_part_uv(part, &msg, sizeof(msg),
 				      XPC_ACTIVATE_MQ_MSG_SYNC_ACT_STATE_UV);
 
-	while (part->sn.uv.remote_act_state != XPC_P_AS_ACTIVATING) {
+	while (!((part->sn.uv.remote_act_state == XPC_P_AS_ACTIVATING) ||
+		 (part->sn.uv.remote_act_state == XPC_P_AS_ACTIVE))) {
 
 		dev_dbg(xpc_part, "waiting to make first contact with "
 			"partition %d\n", XPC_PARTID(part));

