Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbZAUPxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbZAUPxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZAUPxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:53:01 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39453 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753117AbZAUPxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:53:00 -0500
Message-Id: <20090121155258.412067880@attica.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Wed, 21 Jan 2009 09:52:06 -0600
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dean Nelson <dcn@sgi.com>
Subject: [patch 3/3] V2 sgi-xpc: Fixup stale DBUG_ON statements.
References: <20090121155203.050238642@attica.americas.sgi.com>
Content-Disposition: inline; filename=xpc_fixup_dbug_on
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Holt <holt@sgi.com>

Clean up the stale DBUG_ON checks and add a couple new ones.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 drivers/misc/sgi-xp/xpc_channel.c |    3 ---
 drivers/misc/sgi-xp/xpc_sn2.c     |   15 +++++++++++----
 2 files changed, 11 insertions(+), 7 deletions(-)
Index: xpc-fixes-20090115/drivers/misc/sgi-xp/xpc_sn2.c
===================================================================
--- xpc-fixes-20090115.orig/drivers/misc/sgi-xp/xpc_sn2.c	2009-01-15 11:26:22.593544076 -0600
+++ xpc-fixes-20090115/drivers/misc/sgi-xp/xpc_sn2.c	2009-01-15 11:26:22.629548577 -0600
@@ -1106,8 +1106,6 @@ xpc_process_activate_IRQ_rcvd_sn2(void)
 	int n_IRQs_expected;
 	int n_IRQs_detected;
 
-	DBUG_ON(xpc_activate_IRQ_rcvd == 0);
-
 	spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
 	n_IRQs_expected = xpc_activate_IRQ_rcvd;
 	xpc_activate_IRQ_rcvd = 0;
@@ -1726,6 +1724,7 @@ xpc_clear_local_msgqueue_flags_sn2(struc
 		msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->local_msgqueue +
 					     (get % ch->local_nentries) *
 					     ch->entry_size);
+		DBUG_ON(!(msg->flags & XPC_M_SN2_READY));
 		msg->flags = 0;
 	} while (++get < ch_sn2->remote_GP.get);
 }
@@ -1740,11 +1739,18 @@ xpc_clear_remote_msgqueue_flags_sn2(stru
 	struct xpc_msg_sn2 *msg;
 	s64 put;
 
-	put = ch_sn2->w_remote_GP.put;
+	/* flags are zeroed when the buffer is allocated */
+	if (ch_sn2->remote_GP.put < ch->remote_nentries)
+		return;
+
+	put = max(ch_sn2->w_remote_GP.put, ch->remote_nentries);
 	do {
 		msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->remote_msgqueue +
 					     (put % ch->remote_nentries) *
 					     ch->entry_size);
+		DBUG_ON(!(msg->flags & XPC_M_SN2_READY));
+		DBUG_ON(!(msg->flags & XPC_M_SN2_DONE));
+		DBUG_ON(msg->number != put - ch->remote_nentries);
 		msg->flags = 0;
 	} while (++put < ch_sn2->remote_GP.put);
 }
@@ -2280,8 +2286,9 @@ xpc_received_payload_sn2(struct xpc_chan
 	dev_dbg(xpc_chan, "msg=0x%p, msg_number=%ld, partid=%d, channel=%d\n",
 		(void *)msg, msg_number, ch->partid, ch->number);
 
-	DBUG_ON((((u64)msg - (u64)ch->remote_msgqueue) / ch->entry_size) !=
+	DBUG_ON((((u64)msg - (u64)ch->sn.sn2.remote_msgqueue) / ch->entry_size) !=
 		msg_number % ch->remote_nentries);
+	DBUG_ON(!(msg->flags & XPC_M_SN2_READY));
 	DBUG_ON(msg->flags & XPC_M_SN2_DONE);
 
 	msg->flags |= XPC_M_SN2_DONE;
Index: xpc-fixes-20090115/drivers/misc/sgi-xp/xpc_channel.c
===================================================================
--- xpc-fixes-20090115.orig/drivers/misc/sgi-xp/xpc_channel.c	2009-01-15 11:16:36.668299328 -0600
+++ xpc-fixes-20090115/drivers/misc/sgi-xp/xpc_channel.c	2009-01-15 11:26:22.649551078 -0600
@@ -49,9 +49,6 @@ xpc_process_connect(struct xpc_channel *
 
 		if (ch->flags & (XPC_C_CONNECTED | XPC_C_DISCONNECTING))
 			return;
-
-		DBUG_ON(ch->local_msgqueue == NULL);
-		DBUG_ON(ch->remote_msgqueue == NULL);
 	}
 
 	if (!(ch->flags & XPC_C_OPENREPLY)) {

