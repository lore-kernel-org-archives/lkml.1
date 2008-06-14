Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbYFNW6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbYFNW6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 18:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbYFNW6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 18:58:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:19919 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbYFNW6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 18:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=rqD6crLUI+Kr/YnbU5o/x7MOyuq1G/E4giHPpvCyhBB3y1yleCib/QwJFkvK/LSgD4
         a2ezNWqEudWVWTjEMXjd48h7J8Rhjbx9JAaRYPf61BtEaHVTSS94/9L0BJzBiMpvgnm+
         QJdDqoHLzD1+Iv2alq1/jX3xx8/CIx+9H6LtU=
Date: Sun, 15 Jun 2008 00:58:26 +0200
To: Thomas Gleixner <tglx@linutronix.de>,
       Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH] debugobjects: fix lockdep warning
Message-ID: <20080614225826.GA8211@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't know whether this is truly the Right Fix; if it isn't, feel free
to re-use my commit template for when the RF appears... ;-)

Daniel, is there any chance you can try it out? Thanks.


Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sun, 15 Jun 2008 00:47:36 +0200
Subject: [PATCH] debugobjects: fix lockdep warning

Daniel J Blueman reported:
| =======================================================
| [ INFO: possible circular locking dependency detected ]
| 2.6.26-rc5-201c #1
| -------------------------------------------------------
| nscd/3669 is trying to acquire lock:
|  (&n->list_lock){.+..}, at: [<ffffffff802bab03>] deactivate_slab+0x173/0x1e0
|
| but task is already holding lock:
|  (&obj_hash[i].lock){++..}, at: [<ffffffff803fa56f>]
| __debug_object_init+0x2f/0x350
|
| which lock already depends on the new lock.

There are two locks involved here; the first is a SLUB-local lock, and
the second is a debugobjects-local lock. They are basically taken in two
different orders:

1. SLUB { debugobjects { ... } }
2. debugobjects { SLUB { ... } }

This patch changes pattern #2 by trying to fill the memory pool (e.g.
the call into SLUB/kmalloc()) outside the debugobjects lock, so now the
two patterns look like this:

1. SLUB { debugobjects { ... } }
2. SLUB { } debugobjects { ... }

Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 lib/debugobjects.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index a76a5e1..19acf8c 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -110,16 +110,13 @@ static struct debug_obj *lookup_object(void *addr, struct debug_bucket *b)
 }
 
 /*
- * Allocate a new object. If the pool is empty and no refill possible,
- * switch off the debugger.
+ * Allocate a new object. If the pool is empty, switch off the debugger.
  */
 static struct debug_obj *
 alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
 {
 	struct debug_obj *obj = NULL;
-	int retry = 0;
 
-repeat:
 	spin_lock(&pool_lock);
 	if (obj_pool.first) {
 		obj	    = hlist_entry(obj_pool.first, typeof(*obj), node);
@@ -141,9 +138,6 @@ repeat:
 	}
 	spin_unlock(&pool_lock);
 
-	if (fill_pool() && !obj && !retry++)
-		goto repeat;
-
 	return obj;
 }
 
@@ -261,6 +255,8 @@ __debug_object_init(void *addr, struct debug_obj_descr *descr, int onstack)
 	struct debug_obj *obj;
 	unsigned long flags;
 
+	fill_pool();
+
 	db = get_bucket((unsigned long) addr);
 
 	spin_lock_irqsave(&db->lock, flags);
-- 
1.5.4.1

