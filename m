Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbZKXBjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbZKXBjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757799AbZKXBjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:39:51 -0500
Received: from relay2.sgi.com ([192.48.179.30]:51456 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757796AbZKXBjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:39:48 -0500
Message-Id: <20091124013954.748260000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 23 Nov 2009 19:39:44 -0600
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@vger.kernel.org
Subject: [patch 7/8] X86: UV - xpc_make_first_contact hang due to not accepting ACTIVE state.
References: <20091124013937.354595000@alcatraz.americas.sgi.com>
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

To: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@vger.kernel.org

---

 drivers/misc/sgi-xp/xpc_uv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


Index: pv1000000/drivers/misc/sgi-xp/xpc_uv.c
===================================================================
--- pv1000000.orig/drivers/misc/sgi-xp/xpc_uv.c	2009-11-23 18:41:31.000000000 -0600
+++ pv1000000/drivers/misc/sgi-xp/xpc_uv.c	2009-11-23 18:41:47.000000000 -0600
@@ -1023,7 +1023,8 @@ xpc_make_first_contact_uv(struct xpc_par
 	xpc_send_activate_IRQ_part_uv(part, &msg, sizeof(msg),
 				      XPC_ACTIVATE_MQ_MSG_SYNC_ACT_STATE_UV);
 
-	while (part->sn.uv.remote_act_state != XPC_P_AS_ACTIVATING) {
+	while (!((part->sn.uv.remote_act_state == XPC_P_AS_ACTIVATING) ||
+		 (part->sn.uv.remote_act_state == XPC_P_AS_ACTIVE))) {
 
 		dev_dbg(xpc_part, "waiting to make first contact with "
 			"partition %d\n", XPC_PARTID(part));

