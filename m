Return-Path: <linux-kernel-owner+w=401wt.eu-S1762660AbXEKRAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762660AbXEKRAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 13:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759277AbXEKQ7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 12:59:48 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54842 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755051AbXEKQ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 12:59:46 -0400
Message-Id: <20070511165945.913632068@sgi.com>
References: <20070511165749.026947116@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 11 May 2007 09:57:50 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [patch 1/2] From: Paul Mundt <lethal@linux-sh.org>
Content-Disposition: inline; filename=drop_destruct
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I'll take a look at tidying up the PMB slab, getting rid of the dtor
> shouldn't be terribly painful. I simply opted to do the list management
> there since others were doing it for the PGD slab cache at the time that
> was written.

And here's the bit for dropping pmb_cache_dtor(), moving the list
management up to pmb_alloc() and pmb_free().

With this applied, we're all set for killing off slab destructors
from the kernel entirely.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

--

 arch/sh/mm/pmb.c |   79 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 38 insertions(+), 41 deletions(-)

Index: linux-2.6.21-mm2/arch/sh/mm/pmb.c
===================================================================
--- linux-2.6.21-mm2.orig/arch/sh/mm/pmb.c	2007-05-11 09:20:59.000000000 -0700
+++ linux-2.6.21-mm2/arch/sh/mm/pmb.c	2007-05-11 09:22:28.000000000 -0700
@@ -3,7 +3,7 @@
  *
  * Privileged Space Mapping Buffer (PMB) Support.
  *
- * Copyright (C) 2005, 2006 Paul Mundt
+ * Copyright (C) 2005, 2006, 2007 Paul Mundt
  *
  * P1/P2 Section mapping definitions from map32.h, which was:
  *
@@ -68,6 +68,32 @@ static inline unsigned long mk_pmb_data(
 	return mk_pmb_entry(entry) | PMB_DATA;
 }
 
+static DEFINE_SPINLOCK(pmb_list_lock);
+static struct pmb_entry *pmb_list;
+
+static inline void pmb_list_add(struct pmb_entry *pmbe)
+{
+	struct pmb_entry **p, *tmp;
+
+	p = &pmb_list;
+	while ((tmp = *p) != NULL)
+		p = &tmp->next;
+
+	pmbe->next = tmp;
+	*p = pmbe;
+}
+
+static inline void pmb_list_del(struct pmb_entry *pmbe)
+{
+	struct pmb_entry **p, *tmp;
+
+	for (p = &pmb_list; (tmp = *p); p = &tmp->next)
+		if (tmp == pmbe) {
+			*p = tmp->next;
+			return;
+		}
+}
+
 struct pmb_entry *pmb_alloc(unsigned long vpn, unsigned long ppn,
 			    unsigned long flags)
 {
@@ -81,11 +107,19 @@ struct pmb_entry *pmb_alloc(unsigned lon
 	pmbe->ppn	= ppn;
 	pmbe->flags	= flags;
 
+	spin_lock_irq(&pmb_list_lock);
+	pmb_list_add(pmbe);
+	spin_unlock_irq(&pmb_list_lock);
+
 	return pmbe;
 }
 
 void pmb_free(struct pmb_entry *pmbe)
 {
+	spin_lock_irq(&pmb_list_lock);
+	pmb_list_del(pmbe);
+	spin_unlock_irq(&pmb_list_lock);
+
 	kmem_cache_free(pmb_cache, pmbe);
 }
 
@@ -167,31 +201,6 @@ void clear_pmb_entry(struct pmb_entry *p
 	clear_bit(entry, &pmb_map);
 }
 
-static DEFINE_SPINLOCK(pmb_list_lock);
-static struct pmb_entry *pmb_list;
-
-static inline void pmb_list_add(struct pmb_entry *pmbe)
-{
-	struct pmb_entry **p, *tmp;
-
-	p = &pmb_list;
-	while ((tmp = *p) != NULL)
-		p = &tmp->next;
-
-	pmbe->next = tmp;
-	*p = pmbe;
-}
-
-static inline void pmb_list_del(struct pmb_entry *pmbe)
-{
-	struct pmb_entry **p, *tmp;
-
-	for (p = &pmb_list; (tmp = *p); p = &tmp->next)
-		if (tmp == pmbe) {
-			*p = tmp->next;
-			return;
-		}
-}
 
 static struct {
 	unsigned long size;
@@ -283,25 +292,14 @@ void pmb_unmap(unsigned long addr)
 	} while (pmbe);
 }
 
-static void pmb_cache_ctor(void *pmb, struct kmem_cache *cachep, unsigned long flags)
+static void pmb_cache_ctor(void *pmb, struct kmem_cache *cachep,
+			   unsigned long flags)
 {
 	struct pmb_entry *pmbe = pmb;
 
 	memset(pmb, 0, sizeof(struct pmb_entry));
 
-	spin_lock_irq(&pmb_list_lock);
-
 	pmbe->entry = PMB_NO_ENTRY;
-	pmb_list_add(pmbe);
-
-	spin_unlock_irq(&pmb_list_lock);
-}
-
-static void pmb_cache_dtor(void *pmb, struct kmem_cache *cachep, unsigned long flags)
-{
-	spin_lock_irq(&pmb_list_lock);
-	pmb_list_del(pmb);
-	spin_unlock_irq(&pmb_list_lock);
 }
 
 static int __init pmb_init(void)
@@ -312,8 +310,7 @@ static int __init pmb_init(void)
 	BUG_ON(unlikely(nr_entries >= NR_PMB_ENTRIES));
 
 	pmb_cache = kmem_cache_create("pmb", sizeof(struct pmb_entry), 0,
-				      SLAB_PANIC, pmb_cache_ctor,
-				      pmb_cache_dtor);
+				      SLAB_PANIC, pmb_cache_ctor, NULL);
 
 	jump_to_P2();
 

-- 
