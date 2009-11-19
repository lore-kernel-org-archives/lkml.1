Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbZKSRc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbZKSRc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZKSRcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:32:17 -0500
Received: from relay1.sgi.com ([192.48.179.29]:53347 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753297AbZKSRcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:32:08 -0500
From: Robin Holt <holt@sgi.com>
Message-Id: <20091119173212.542566000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 19 Nov 2009 11:32:05 -0600
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch 8/8] X86: UV - XPC receive message reuse triggers invalid BUG_ON().
References: <20091119173157.337874000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=xpc_recv_msg_slots_wrap
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This was a difficult bug to trip.  XPC was in the middle of sending an
acknowledgement for a received message.

In xpc_received_payload_uv():
..
        ret = xpc_send_gru_msg(ch->sn.uv.cached_notify_gru_mq_desc, msg,
                               sizeof(struct xpc_notify_mq_msghdr_uv));
        if (ret != xpSuccess)
                XPC_DEACTIVATE_PARTITION(&xpc_partitions[ch->partid], ret);

        msg->hdr.msg_slot_number += ch->remote_nentries;

at the point in xpc_send_gru_msg() where the hardware has dispatched the
acknowledgement, the remote side is able to reuse the message structure
and send a message with a different slot number.  This problem is made
worse by interrupts.

The adjustment of msg_slot_number and the BUG_ON in
xpc_handle_notify_mq_msg_uv() which verifies the msg_slot_number is
consistent are only used for debug purposes.  Since a fix for this that
preserves the debug functionality would either have to infringe upon
the payload or allocate another structure just for debug, I decided to
remove it entirely.

To: Ingo Molnar <mingo@elte.hu>
To: tglx@linutronix.de
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org

---
 drivers/misc/sgi-xp/xpc_uv.c |    3 ---
 1 file changed, 3 deletions(-)
Index: linux-x86/drivers/misc/sgi-xp/xpc_uv.c
===================================================================
--- linux-x86.orig/drivers/misc/sgi-xp/xpc_uv.c	2009-11-18 22:16:45.000000000 -0600
+++ linux-x86/drivers/misc/sgi-xp/xpc_uv.c	2009-11-18 22:16:45.000000000 -0600
@@ -1428,7 +1428,6 @@ xpc_handle_notify_mq_msg_uv(struct xpc_p
 	msg_slot = ch_uv->recv_msg_slots +
 	    (msg->hdr.msg_slot_number % ch->remote_nentries) * ch->entry_size;
 
-	BUG_ON(msg->hdr.msg_slot_number != msg_slot->hdr.msg_slot_number);
 	BUG_ON(msg_slot->hdr.size != 0);
 
 	memcpy(msg_slot, msg, msg->hdr.size);
@@ -1652,8 +1651,6 @@ xpc_received_payload_uv(struct xpc_chann
 			       sizeof(struct xpc_notify_mq_msghdr_uv));
 	if (ret != xpSuccess)
 		XPC_DEACTIVATE_PARTITION(&xpc_partitions[ch->partid], ret);
-
-	msg->hdr.msg_slot_number += ch->remote_nentries;
 }
 
 static struct xpc_arch_operations xpc_arch_ops_uv = {

