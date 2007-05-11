Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbXEKCWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbXEKCWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 22:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbXEKCV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 22:21:57 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:32889 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbXEKCV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 22:21:56 -0400
Date: Fri, 11 May 2007 11:21:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [RFC] Slab allocators: Drop support for destructors
Message-ID: <20070511022124.GA24196@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
	Pekka Enberg <penberg@cs.helsinki.fi>
References: <Pine.LNX.4.64.0705101156190.10663@schroedinger.engr.sgi.com> <20070510233527.GA19597@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510233527.GA19597@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 08:35:27AM +0900, Paul Mundt wrote:
> On Thu, May 10, 2007 at 12:00:08PM -0700, Christoph Lameter wrote:
> > As far as I can tell there is only a single slab destructor left (there 
> > is currently another in i386 but its going to go as soon as Andi merges 
> > i386s support for quicklists).
> > 
> > I wonder how difficult it would be to remove it? If we have no need for 
> > destructors anymore then maybe we could remove destructor support from the 
> > slab allocators? There is no point in checking for destructor uses in 
> > the slab allocators if there are none.
> > 
> > Or are there valid reason to keep them around? It seems they were mainly 
> > used for list management which required them to take a spinlock. Taking a 
> > spinlock in a destructor is a bit risky since the slab allocators may run 
> > the destructors anytime they decide a slab is no longer needed.
> > 
> > Or do we want to continue support destructors? If so why?
> > 
> [snip pmb stuff]
> 
> I'll take a look at tidying up the PMB slab, getting rid of the dtor
> shouldn't be terribly painful. I simply opted to do the list management
> there since others were doing it for the PGD slab cache at the time that
> was written.

And here's the bit for dropping pmb_cache_dtor(), moving the list
management up to pmb_alloc() and pmb_free().

With this applied, we're all set for killing off slab destructors
from the kernel entirely.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 arch/sh/mm/pmb.c |   79 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 38 insertions(+), 41 deletions(-)

diff --git a/arch/sh/mm/pmb.c b/arch/sh/mm/pmb.c
index 02aae06..b6a5a33 100644
--- a/arch/sh/mm/pmb.c
+++ b/arch/sh/mm/pmb.c
@@ -3,7 +3,7 @@
  *
  * Privileged Space Mapping Buffer (PMB) Support.
  *
- * Copyright (C) 2005, 2006 Paul Mundt
+ * Copyright (C) 2005, 2006, 2007 Paul Mundt
  *
  * P1/P2 Section mapping definitions from map32.h, which was:
  *
@@ -68,6 +68,32 @@ static inline unsigned long mk_pmb_data(unsigned int entry)
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
@@ -81,11 +107,19 @@ struct pmb_entry *pmb_alloc(unsigned long vpn, unsigned long ppn,
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
 
@@ -167,31 +201,6 @@ void clear_pmb_entry(struct pmb_entry *pmbe)
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
 
