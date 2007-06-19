Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbXFSH4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbXFSH4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 03:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbXFSH4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 03:56:41 -0400
Received: from verein.lst.de ([213.95.11.210]:38501 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbXFSH4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 03:56:40 -0400
From: Olaf Kirch <okir@lst.de>
To: netdev@vger.kernel.org
Subject: [PATCH] net: Make skb_seq_read unmap the last fragment
Date: Tue, 19 Jun 2007 09:56:24 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706190956.26252.okir@lst.de>
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Kirch <olaf.kirch@oracle.com>

Make skb_seq_read unmap the last fragment

Having walked through the entire skbuff, skb_seq_read would leave the
last fragment mapped.  As a consequence, the unwary caller would leak
kmaps, and proceed with preempt_count off by one. The only (kind of
non-intuitive) workaround is to use skb_seq_read_abort.

This patch makes sure skb_seq_read always unmaps frag_data after having
cycled through the skb's paged part.

Signed-off-by: olaf.kirch@oracle.com
---
 net/core/skbuff.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: build-2.6/net/core/skbuff.c
===================================================================
--- build-2.6.orig/net/core/skbuff.c
+++ build-2.6/net/core/skbuff.c
@@ -1706,6 +1706,11 @@ next_skb:
 		st->stepped_offset += frag->size;
 	}
 
+	if (st->frag_data) {
+		kunmap_skb_frag(st->frag_data);
+		st->frag_data = NULL;
+	}
+
 	if (st->cur_skb->next) {
 		st->cur_skb = st->cur_skb->next;
 		st->frag_idx = 0;

-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
