Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZAJHEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZAJHEl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 02:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbZAJHEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 02:04:32 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61343 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbZAJHEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 02:04:32 -0500
Subject: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
From: David Moore <dcm@MIT.EDU>
Reply-To: dcm@acm.org
To: linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 23:04:20 -0800
Message-Id: <1231571060.3538.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Moore <dcm@acm.org>

The idr_remove_all() function returns unused slabs to the kmem cache,
but needs to zero them first or else they will be uninitialized upon
next use.  This fixes crashes which have been observed in the firewire
subsystem.

Signed-off-by: David Moore <dcm@acm.org>
---
 lib/idr.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 1c4f928..69c3455 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -65,6 +65,20 @@ static inline void free_layer(struct idr_layer *p)
 	call_rcu(&p->rcu_head, idr_layer_rcu_free);
 }
 
+static void idr_layer_rcu_free_zero(struct rcu_head *head)
+{
+	struct idr_layer *layer;
+
+	layer = container_of(head, struct idr_layer, rcu_head);
+	memset(layer, 0, sizeof(struct idr_layer));
+	kmem_cache_free(idr_layer_cache, layer);
+}
+
+static inline void free_layer_zero(struct idr_layer *p)
+{
+	call_rcu(&p->rcu_head, idr_layer_rcu_free_zero);
+}
+
 /* only called when idp->lock is held */
 static void __move_to_free_list(struct idr *idp, struct idr_layer *p)
 {
@@ -462,7 +476,7 @@ void idr_remove_all(struct idr *idp)
 		id += 1 << n;
 		while (n < fls(id)) {
 			if (p)
-				free_layer(p);
+				free_layer_zero(p);
 			n += IDR_BITS;
 			p = *--paa;
 		}
-- 
1.6.0.6



