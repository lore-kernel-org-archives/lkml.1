Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbZBKAc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbZBKAc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbZBKA2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:15 -0500
Received: from kroah.org ([198.145.64.141]:51050 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756424AbZBKA2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:13 -0500
Date: Tue, 10 Feb 2009 16:24:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dean Nelson <dcn@sgi.com>
Subject: [patch 12/56] sgi-xp: fix writing past the end of kzalloc()d space
Message-ID: <20090211002439.GM14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sgi-xp-fix-writing-past-the-end-of-kzalloc-d-space.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Dean Nelson <dcn@sgi.com>

commit 361916a943cd9dbda1c0b00879d0225cc919d868 upstream.

A missing type cast results in writing way beyond the end of a kzalloc()'d
memory segment resulting in slab corruption. But it seems like the better
solution is to define ->recv_msg_slots as a 'void *' rather than a
'struct xpc_notify_mq_msg_uv *' and add the type cast.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/sgi-xp/xpc.h    |    5 +++--
 drivers/misc/sgi-xp/xpc_uv.c |   11 +++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/misc/sgi-xp/xpc.h
+++ b/drivers/misc/sgi-xp/xpc.h
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2004-2009 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 /*
@@ -502,7 +502,8 @@ struct xpc_channel_uv {
 						/* partition's notify mq */
 
 	struct xpc_send_msg_slot_uv *send_msg_slots;
-	struct xpc_notify_mq_msg_uv *recv_msg_slots;
+	void *recv_msg_slots;	/* each slot will hold a xpc_notify_mq_msg_uv */
+				/* structure plus the user's payload */
 
 	struct xpc_fifo_head_uv msg_slot_free_list;
 	struct xpc_fifo_head_uv recv_msg_list;	/* deliverable payloads */
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2008-2009 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 /*
@@ -825,8 +825,8 @@ xpc_allocate_recv_msg_slot_uv(struct xpc
 			continue;
 
 		for (entry = 0; entry < nentries; entry++) {
-			msg_slot = ch_uv->recv_msg_slots + entry *
-			    ch->entry_size;
+			msg_slot = ch_uv->recv_msg_slots +
+			    entry * ch->entry_size;
 
 			msg_slot->hdr.msg_slot_number = entry;
 		}
@@ -1123,9 +1123,8 @@ xpc_handle_notify_mq_msg_uv(struct xpc_p
 	/* we're dealing with a normal message sent via the notify_mq */
 	ch_uv = &ch->sn.uv;
 
-	msg_slot = (struct xpc_notify_mq_msg_uv *)((u64)ch_uv->recv_msg_slots +
-		    (msg->hdr.msg_slot_number % ch->remote_nentries) *
-		    ch->entry_size);
+	msg_slot = ch_uv->recv_msg_slots +
+	    (msg->hdr.msg_slot_number % ch->remote_nentries) * ch->entry_size;
 
 	BUG_ON(msg->hdr.msg_slot_number != msg_slot->hdr.msg_slot_number);
 	BUG_ON(msg_slot->hdr.size != 0);

