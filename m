Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbZBDSgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbZBDSgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZBDSgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:36:43 -0500
Received: from relay2.sgi.com ([192.48.179.30]:50108 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752673AbZBDSgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:36:42 -0500
Date: Wed, 4 Feb 2009 12:36:41 -0600
From: Dean Nelson <dcn@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sgi-xp: fix writing past the end of kzalloc()'d space (v.2)
Message-ID: <20090204183641.GA24632@sgi.com>
References: <20090203182338.GA1770@sgi.com> <20090203120147.dd079ffd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203120147.dd079ffd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A missing type cast results in writing way beyond the end of a kzalloc()'d
memory segment resulting in slab corruption. But it seems like the better
solution is to define ->recv_msg_slots as a 'void *' rather than a
'struct xpc_notify_mq_msg_uv *' and add the type cast.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: stable <stable@kernel.org>

---

On Tue, Feb 03, 2009 at 12:01:47PM -0800, Andrew Morton wrote:
> On Tue, 3 Feb 2009 12:23:38 -0600
> Dean Nelson <dcn@sgi.com> wrote:
> 
> > --- linux.orig/drivers/misc/sgi-xp/xpc_uv.c	2009-01-27 10:53:26.000000000 -0600
> > +++ linux/drivers/misc/sgi-xp/xpc_uv.c	2009-01-28 08:51:57.000000000 -0600
	:
> > @@ -1129,8 +1129,8 @@ xpc_allocate_recv_msg_slot_uv(struct xpc
> >  			continue;
> >  
> >  		for (entry = 0; entry < nentries; entry++) {
> > -			msg_slot = ch_uv->recv_msg_slots + entry *
> > -			    ch->entry_size;
> > +			msg_slot = (struct xpc_notify_mq_msg_uv *)((u8 *)
> > +			    ch_uv->recv_msg_slots + entry * ch->entry_size);
> 
> So..  ch->entry_size is not equal to sizeof(struct xpc_notify_mq_msg_uv)?

Correct. The value of ch->entry_size is defined at runtime by the user of
XPC (i.e., XPNET and XPMEM) when it calls xpc_connect(). It is always larger
than sizeof(struct xpc_notify_mq_msg_uv) which is defined as:

struct xpc_notify_mq_msg_uv {
        struct xpc_notify_mq_msghdr_uv hdr;
        unsigned long payload;
};

The payload field reflects the first eight bytes of the user's payload
which extends into the remainder of the messsge slot.

> Perhaps ->recv_msg_slots should never have had type struct
> xpc_notify_mq_msg_uv *?

Agreed. So I'm resubmitting the patch based on this recommendation.

Note that I'm using 'void *' instead of 'u8 *' to ->define recv_msg_slots.
Currently they are equivalent in terms of the math, but 'void *' has the
advantage of not needing to cast at all. Is this an appropriate choice?

Thanks,
Dean

 drivers/misc/sgi-xp/xpc.h    |    5 +++--
 drivers/misc/sgi-xp/xpc_uv.c |   11 +++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

Index: linux/drivers/misc/sgi-xp/xpc.h
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xpc.h	2009-02-04 09:30:24.000000000 -0600
+++ linux/drivers/misc/sgi-xp/xpc.h	2009-02-04 11:33:48.000000000 -0600
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2004-2009 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 /*
@@ -519,7 +519,8 @@ struct xpc_channel_uv {
 					 /* gru mq descriptor */
 
 	struct xpc_send_msg_slot_uv *send_msg_slots;
-	struct xpc_notify_mq_msg_uv *recv_msg_slots;
+	void *recv_msg_slots;	/* each slot will hold a xpc_notify_mq_msg_uv */
+				/* structure plus the user's payload */
 
 	struct xpc_fifo_head_uv msg_slot_free_list;
 	struct xpc_fifo_head_uv recv_msg_list;	/* deliverable payloads */
Index: linux/drivers/misc/sgi-xp/xpc_uv.c
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xpc_uv.c	2009-01-27 10:53:26.000000000 -0600
+++ linux/drivers/misc/sgi-xp/xpc_uv.c	2009-02-04 11:33:33.000000000 -0600
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
+			msg_slot = ch_uv->recv_msg_slots +
+			    entry * ch->entry_size;
 
 			msg_slot->hdr.msg_slot_number = entry;
 		}
@@ -1438,9 +1438,8 @@ xpc_handle_notify_mq_msg_uv(struct xpc_p
 	/* we're dealing with a normal message sent via the notify_mq */
 	ch_uv = &ch->sn.uv;
 
-	msg_slot = (struct xpc_notify_mq_msg_uv *)((u64)ch_uv->recv_msg_slots +
-		    (msg->hdr.msg_slot_number % ch->remote_nentries) *
-		    ch->entry_size);
+	msg_slot = ch_uv->recv_msg_slots +
+	    (msg->hdr.msg_slot_number % ch->remote_nentries) * ch->entry_size;
 
 	BUG_ON(msg->hdr.msg_slot_number != msg_slot->hdr.msg_slot_number);
 	BUG_ON(msg_slot->hdr.size != 0);
