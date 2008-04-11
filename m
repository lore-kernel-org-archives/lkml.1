Return-Path: <linux-kernel-owner+w=401wt.eu-S1761878AbYDKQWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761878AbYDKQWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760883AbYDKQUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:20:42 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34376 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760849AbYDKQUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:20:40 -0400
Message-Id: <20080411162001.141840000@bull.net>
References: <20080411161702.460410000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 11 Apr 2008 18:17:10 +0200
From: Nadia.Derbey@bull.net
To: efault@gmx.de
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       peterz@infradead.org, xemul@openvz.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 08/13] Fix ridr_get_new_above_int()
Content-Disposition: inline; filename=ridr_get_new.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 08/13]

This patch only fixes the ridr_get_new_above_int() portion of ridr.c, to make
it RCU based.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 lib/ridr.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6.25-rc8-mm1/lib/ridr.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/lib/ridr.c	2008-04-11 17:55:37.000000000 +0200
+++ linux-2.6.25-rc8-mm1/lib/ridr.c	2008-04-11 17:58:41.000000000 +0200
@@ -256,7 +256,8 @@ static int ridr_get_new_above_int(struct
 		 * Successfully found an empty slot.  Install the user
 		 * pointer and mark the slot full.
 		 */
-		pa[0]->ary[id & IDR_MASK] = (struct ridr_layer *)ptr;
+		rcu_assign_pointer(pa[0]->ary[id & IDR_MASK],
+						(struct ridr_layer *)ptr);
 		pa[0]->count++;
 		ridr_mark_full(pa, id);
 	}
@@ -273,9 +274,9 @@ static int ridr_get_new_above_int(struct
  * This is the allocate id function.  It should be called with any
  * required locks.
  *
- * If memory is required, it will return -EAGAIN, you should unlock
- * and go back to the ridr_pre_get() call.  If the ridr is full, it will
- * return -ENOSPC.
+ * If memory is required, it will return -EAGAIN, you should unlock, enable
+ * preemption and go back to the ridr_pre_get() call.
+ * If the ridr is full, it will return -ENOSPC.
  *
  * @id returns a value in the range 0 ... 0x7fffffff
  */

--
