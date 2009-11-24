Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbZKXBlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbZKXBlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757816AbZKXBjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:39:52 -0500
Received: from relay3.sgi.com ([192.48.152.1]:34569 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757795AbZKXBjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:39:48 -0500
Message-Id: <20091124013954.388525000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 23 Nov 2009 19:39:43 -0600
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@vger.kernel.org
Subject: [patch 6/8] x86: UV - XPC NULL deref when mesq becomes empty.
References: <20091124013937.354595000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=xpc_fix_xpc_get_fifo_entry_uv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Under heavy load conditions, our set of xpc messages may become exhausted.
The code handles this correctly with the exception of the management
code which hits a NULL pointer dereference.

To: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@vger.kernel.org

---

 drivers/misc/sgi-xp/xpc_uv.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


Index: pv1000000/drivers/misc/sgi-xp/xpc_uv.c
===================================================================
--- pv1000000.orig/drivers/misc/sgi-xp/xpc_uv.c	2009-11-23 18:41:22.000000000 -0600
+++ pv1000000/drivers/misc/sgi-xp/xpc_uv.c	2009-11-23 18:41:31.000000000 -0600
@@ -948,11 +948,13 @@ xpc_get_fifo_entry_uv(struct xpc_fifo_he
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
 

