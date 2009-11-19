Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbZKSRc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbZKSRc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbZKSRcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:32:54 -0500
Received: from relay3.sgi.com ([192.48.152.1]:43087 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753845AbZKSRcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:32:05 -0500
From: Robin Holt <holt@sgi.com>
Message-Id: <20091119173209.848367000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 19 Nov 2009 11:32:03 -0600
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch 6/8] x86: UV - XPC NULL deref when mesq becomes empty.
References: <20091119173157.337874000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=xpc_fix_xpc_get_fifo_entry_uv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Under heavy load conditions, our set of xpc messages may become exhausted.
The code handles this correctly with the exception of the management
code which hits a NULL pointer dereference.

To: Ingo Molnar <mingo@elte.hu>
To: tglx@linutronix.de
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org

---

 drivers/misc/sgi-xp/xpc_uv.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)
Index: linux-x86/drivers/misc/sgi-xp/xpc_uv.c
===================================================================
--- linux-x86.orig/drivers/misc/sgi-xp/xpc_uv.c	2009-11-18 21:41:23.000000000 -0600
+++ linux-x86/drivers/misc/sgi-xp/xpc_uv.c	2009-11-18 21:41:26.000000000 -0600
@@ -949,11 +949,13 @@ xpc_get_fifo_entry_uv(struct xpc_fifo_he
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
 

