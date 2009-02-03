Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbZBCSXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbZBCSXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbZBCSXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:23:41 -0500
Received: from relay2.sgi.com ([192.48.179.30]:48938 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751384AbZBCSXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:23:40 -0500
Date: Tue, 3 Feb 2009 12:23:38 -0600
From: Dean Nelson <dcn@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sgi-xp: add type cast to kzalloc()'d space to avoid slab corruption
Message-ID: <20090203182338.GA1770@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A missing type cast results in writing way beyond the end of a kzalloc()'d
memory segment resulting in slab corruption.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: stable <stable@kernel.org>

---

 drivers/misc/sgi-xp/xpc_uv.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/drivers/misc/sgi-xp/xpc_uv.c
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xpc_uv.c	2009-01-27 10:53:26.000000000 -0600
+++ linux/drivers/misc/sgi-xp/xpc_uv.c	2009-01-28 08:51:57.000000000 -0600
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2008-2009 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 /*
@@ -1129,8 +1129,8 @@ xpc_allocate_recv_msg_slot_uv(struct xpc
 			continue;
 
 		for (entry = 0; entry < nentries; entry++) {
-			msg_slot = ch_uv->recv_msg_slots + entry *
-			    ch->entry_size;
+			msg_slot = (struct xpc_notify_mq_msg_uv *)((u8 *)
+			    ch_uv->recv_msg_slots + entry * ch->entry_size);
 
 			msg_slot->hdr.msg_slot_number = entry;
 		}
@@ -1438,7 +1438,7 @@ xpc_handle_notify_mq_msg_uv(struct xpc_p
 	/* we're dealing with a normal message sent via the notify_mq */
 	ch_uv = &ch->sn.uv;
 
-	msg_slot = (struct xpc_notify_mq_msg_uv *)((u64)ch_uv->recv_msg_slots +
+	msg_slot = (struct xpc_notify_mq_msg_uv *)((u8 *)ch_uv->recv_msg_slots +
 		    (msg->hdr.msg_slot_number % ch->remote_nentries) *
 		    ch->entry_size);
 
