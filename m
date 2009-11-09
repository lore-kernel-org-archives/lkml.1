Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbZKIRJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbZKIRJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbZKIRJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:09:09 -0500
Received: from relay2.sgi.com ([192.48.179.30]:44986 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755130AbZKIRJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:09:01 -0500
From: Robin Holt <holt@sgi.com>
Message-Id: <20091109170907.059143000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 09 Nov 2009 11:08:59 -0600
To: Ingo Molnar <mingo@elte.hu>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch 5/6] x86: UV - XPC NULL deref when mesq becomes empty.
References: <20091109170854.161447000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=xpc_fix_xpc_get_fifo_entry_uv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Under heavy load conditions, our set of xpc messages may become exhausted.
The code handles this correctly with the exception of the management code.

To: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>

---

 drivers/misc/sgi-xp/xpc_uv.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)
Index: linux-2.6.27/drivers/misc/sgi-xp/xpc_uv.c
===================================================================
--- linux-2.6.27.orig/drivers/misc/sgi-xp/xpc_uv.c	2009-10-29 10:43:23.000000000 -0500
+++ linux-2.6.27/drivers/misc/sgi-xp/xpc_uv.c	2009-10-29 13:23:19.000000000 -0500
@@ -947,11 +947,13 @@ xpc_get_fifo_entry_uv(struct xpc_fifo_he
 		head->first = first->next;
 		if (head->first == NULL)
 			head->last = NULL;
+
+		head->n_entries--;
+		BUG_ON(head->n_entries < 0);
+
+		first->next = NULL;
 	}
-	head->n_entries--;
-	BUG_ON(head->n_entries < 0);
 	spin_unlock_irqrestore(&head->lock, irq_flags);
-	first->next = NULL;
 	return first;
 }
 

