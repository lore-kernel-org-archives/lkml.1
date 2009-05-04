Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbZEDWYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbZEDWYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbZEDWYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:24:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44466 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957AbZEDWYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:24:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Tue, 5 May 2009 00:23:36 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-pm@lists.linux-foundation.org,
       pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905042151.07953.rjw@sisk.pl> <alpine.DEB.2.00.0905041253380.23036@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0905041253380.23036@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905050023.38064.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 May 2009, David Rientjes wrote:
> On Mon, 4 May 2009, Rafael J. Wysocki wrote:
> 
> > Index: linux-2.6/mm/page_alloc.c
> > ===================================================================
> > --- linux-2.6.orig/mm/page_alloc.c
> > +++ linux-2.6/mm/page_alloc.c
> > @@ -1599,7 +1599,8 @@ nofail_alloc:
> >  					zonelist, high_zoneidx, alloc_flags);
> >  		if (page)
> >  			goto got_pg;
> > -	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
> > +	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)
> > +			&& !(gfp_mask & __GFP_NO_OOM_KILL)) {
> >  		if (!try_set_zone_oom(zonelist, gfp_mask)) {
> >  			schedule_timeout_uninterruptible(1);
> >  			goto restart;
> > Index: linux-2.6/include/linux/gfp.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/gfp.h
> > +++ linux-2.6/include/linux/gfp.h
> > @@ -51,8 +51,9 @@ struct vm_area_struct;
> >  #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
> >  #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
> >  #define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
> > +#define __GFP_NO_OOM_KILL ((__force gfp_t)0x200000u)  /* Don't invoke out_of_memory() */
> >  
> > -#define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
> > +#define __GFP_BITS_SHIFT 22	/* Number of __GFP_FOO bits */
> >  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
> >  
> >  /* This equals 0, but use constants in case they ever change */
> > 
> 
> Yeah, that's much better, thanks.  There's currently concerns about adding 
> a new gfp flag in another thread (__GFP_PANIC), though, so you might find 
> some resistance in adding a flag with a very specific and limited use cae.

Oh great.  Andrew, what's your opinion?

> I think you might have better luck in doing
> 
> 	struct zone *z;
> 
> 	for_each_populated_zone(z)
> 		zone_set_flag(z, ZONE_OOM_LOCKED);
> 	
> if all other tasks are really in D state at this point since oom killer 
> serialization is done with try locks in the page allocator.

Not all of them, actually.  Some kernel threads are not freezable.

> This is equivalent to __GFP_NO_OOM_KILL.

In that case I think I'd go back to my initial idea with disabling the OOM
killer after freezing tasks.

Roughly, this.  [The idea is that the OOM killer is not really going to work
while tasks are frozen, so we can just give up calling it in that case.]

---
 include/linux/freezer.h |    2 ++
 kernel/power/process.c  |   12 ++++++++++++
 mm/page_alloc.c         |    4 +++-
 3 files changed, 17 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/power/process.c
===================================================================
--- linux-2.6.orig/kernel/power/process.c
+++ linux-2.6/kernel/power/process.c
@@ -19,6 +19,8 @@
  */
 #define TIMEOUT	(20 * HZ)
 
+static bool tasks_frozen;
+
 static inline int freezeable(struct task_struct * p)
 {
 	if ((p == current) ||
@@ -120,6 +122,10 @@ int freeze_processes(void)
  Exit:
 	BUG_ON(in_atomic());
 	printk("\n");
+
+	if (!error)
+		tasks_frozen = true;
+
 	return error;
 }
 
@@ -145,6 +151,8 @@ static void thaw_tasks(bool nosig_only)
 
 void thaw_processes(void)
 {
+	tasks_frozen = false;
+
 	printk("Restarting tasks ... ");
 	thaw_tasks(true);
 	thaw_tasks(false);
@@ -152,3 +160,7 @@ void thaw_processes(void)
 	printk("done.\n");
 }
 
+bool processes_are_frozen(void)
+{
+	return tasks_frozen;
+}
Index: linux-2.6/include/linux/freezer.h
===================================================================
--- linux-2.6.orig/include/linux/freezer.h
+++ linux-2.6/include/linux/freezer.h
@@ -50,6 +50,7 @@ extern int thaw_process(struct task_stru
 extern void refrigerator(void);
 extern int freeze_processes(void);
 extern void thaw_processes(void);
+extern bool processes_are_frozen(void);
 
 static inline int try_to_freeze(void)
 {
@@ -170,6 +171,7 @@ static inline int thaw_process(struct ta
 static inline void refrigerator(void) {}
 static inline int freeze_processes(void) { BUG(); return 0; }
 static inline void thaw_processes(void) {}
+static inline bool processes_are_frozen(void) { return false; }
 
 static inline int try_to_freeze(void) { return 0; }
 
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -46,6 +46,7 @@
 #include <linux/page-isolation.h>
 #include <linux/page_cgroup.h>
 #include <linux/debugobjects.h>
+#include <linux/freezer.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -1599,7 +1600,8 @@ nofail_alloc:
 					zonelist, high_zoneidx, alloc_flags);
 		if (page)
 			goto got_pg;
-	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
+	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)
+			&& !processes_are_frozen()) {
 		if (!try_set_zone_oom(zonelist, gfp_mask)) {
 			schedule_timeout_uninterruptible(1);
 			goto restart;
