Return-Path: <linux-kernel-owner+w=401wt.eu-S1761252AbZAUPyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252AbZAUPyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbZAUPxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:53:03 -0500
Received: from relay3.sgi.com ([192.48.171.31]:35404 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753524AbZAUPxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:53:01 -0500
Message-Id: <20090121155257.956118822@attica.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Wed, 21 Jan 2009 09:52:04 -0600
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dean Nelson <dcn@sgi.com>,
       <stable@kernel.org>
Subject: [patch 1/3] V2 sgi-xpc: ensure flags are updated before bte_copy
References: <20090121155203.050238642@attica.americas.sgi.com>
Content-Disposition: inline; filename=xpc-write-barrier
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Holt <holt@sgi.com>

The clearing of the msg->flags needs a barrier between it and the notify
of the channel threads that the messages are cleaned and ready for use.

I also modified all the *mb() operations to be prefixed with smp_ as
they all are really only needed when running with multiple cpus.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: <stable@kernel.org>

---

 drivers/misc/sgi-xp/xpc_sn2.c |    9 +++++----
 drivers/misc/sgi-xp/xpc_uv.c  |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)
Index: xpc-fixes-20090115/drivers/misc/sgi-xp/xpc_sn2.c
===================================================================
--- xpc-fixes-20090115.orig/drivers/misc/sgi-xp/xpc_sn2.c	2009-01-21 09:32:18.601506191 -0600
+++ xpc-fixes-20090115/drivers/misc/sgi-xp/xpc_sn2.c	2009-01-21 09:44:14.930207605 -0600
@@ -1836,6 +1836,7 @@ xpc_process_msg_chctl_flags_sn2(struct x
 		 */
 		xpc_clear_remote_msgqueue_flags_sn2(ch);
 
+		smp_wmb(); /* ensure flags have been cleared before bte_copy */
 		ch_sn2->w_remote_GP.put = ch_sn2->remote_GP.put;
 
 		dev_dbg(xpc_chan, "w_remote_GP.put changed to %ld, partid=%d, "
@@ -1934,7 +1935,7 @@ xpc_get_deliverable_payload_sn2(struct x
 			break;
 
 		get = ch_sn2->w_local_GP.get;
-		rmb();	/* guarantee that .get loads before .put */
+		smp_rmb();	/* guarantee that .get loads before .put */
 		if (get == ch_sn2->w_remote_GP.put)
 			break;
 
@@ -2053,7 +2054,7 @@ xpc_allocate_msg_sn2(struct xpc_channel 
 	while (1) {
 
 		put = ch_sn2->w_local_GP.put;
-		rmb();	/* guarantee that .put loads before .get */
+		smp_rmb();	/* guarantee that .put loads before .get */
 		if (put - ch_sn2->w_remote_GP.get < ch->local_nentries) {
 
 			/* There are available message entries. We need to try
@@ -2186,7 +2187,7 @@ xpc_send_payload_sn2(struct xpc_channel 
 	 * The preceding store of msg->flags must occur before the following
 	 * load of local_GP->put.
 	 */
-	mb();
+	smp_mb();
 
 	/* see if the message is next in line to be sent, if so send it */
 
@@ -2287,7 +2288,7 @@ xpc_received_payload_sn2(struct xpc_chan
 	 * The preceding store of msg->flags must occur before the following
 	 * load of local_GP->get.
 	 */
-	mb();
+	smp_mb();
 
 	/*
 	 * See if this message is next in line to be acknowledged as having
Index: xpc-fixes-20090115/drivers/misc/sgi-xp/xpc_uv.c
===================================================================
--- xpc-fixes-20090115.orig/drivers/misc/sgi-xp/xpc_uv.c	2009-01-15 09:55:59.000000000 -0600
+++ xpc-fixes-20090115/drivers/misc/sgi-xp/xpc_uv.c	2009-01-21 09:44:34.296607895 -0600
@@ -1423,7 +1423,7 @@ xpc_send_payload_uv(struct xpc_channel *
 		atomic_inc(&ch->n_to_notify);
 
 		msg_slot->key = key;
-		wmb(); /* a non-NULL func must hit memory after the key */
+		smp_wmb(); /* a non-NULL func must hit memory after the key */
 		msg_slot->func = func;
 
 		if (ch->flags & XPC_C_DISCONNECTING) {

