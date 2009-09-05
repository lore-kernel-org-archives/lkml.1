Return-Path: <linux-kernel-owner+w=401wt.eu-S934701AbZIEApR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934701AbZIEApR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933858AbZIEApJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:45:09 -0400
Received: from mail.atheros.com ([12.36.123.2]:31880 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934489AbZIEAo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:44:58 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <catalin.marinas@arm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
       <penberg@cs.helsinki.fi>, <mcgrof@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 4/5] kmemleak: fix sparse warning over overshadowed flags
Date: Fri, 4 Sep 2009 17:44:53 -0700
Message-ID: <1252111494-7593-5-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252111494-7593-1-git-send-email-lrodriguez@atheros.com>
References: <1252111494-7593-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A secondary irq_save is not required as a locking before it was
already disabling irqs.

This fixes this sparse warning:
mm/kmemleak.c:512:31: warning: symbol 'flags' shadows an earlier one
mm/kmemleak.c:448:23: originally declared here

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 mm/kmemleak.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 18dfd62..d078621 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -552,6 +552,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 	object->tree_node.last = ptr + size - 1;
 
 	write_lock_irqsave(&kmemleak_lock, flags);
+
 	min_addr = min(min_addr, ptr);
 	max_addr = max(max_addr, ptr + size);
 	node = prio_tree_insert(&object_tree_root, &object->tree_node);
@@ -562,14 +563,12 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 	 * random memory blocks.
 	 */
 	if (node != &object->tree_node) {
-		unsigned long flags;
-
 		kmemleak_stop("Cannot insert 0x%lx into the object search tree "
 			      "(already existing)\n", ptr);
 		object = lookup_object(ptr, 1);
-		spin_lock_irqsave(&object->lock, flags);
+		spin_lock(&object->lock);
 		dump_object_info(object);
-		spin_unlock_irqrestore(&object->lock, flags);
+		spin_unlock(&object->lock);
 
 		goto out;
 	}
-- 
1.6.3.3

