Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbZEDJIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbZEDJIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 05:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbZEDJIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 05:08:30 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:34708 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZEDJI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 05:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RcMENpGk4zChydt3ScZ0a5whhV/MN49MToiD5GhxZQS6UXETe7xUGi8nKZanChqSzc
         v1nhdIUdonmb9uwQsCbdioPbN00Pea30UOODTK69xAPs3ZEDzCIbAhM2xKy55h3ENJ+k
         Kw54GeLdrtLNNPOx/s3S9q/E01BPNqaKOhALQ=
Date: Mon, 4 May 2009 13:08:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: introducing __GFP_PANIC
Message-ID: <20090504090825.GC4173@lenovo>
References: <20090503121228.GC4615@lenovo> <1241353621.27683.3.camel@penberg-laptop> <20090503143824.GF4615@lenovo> <84144f020905030954m434d0550l3ed7ef7436c803df@mail.gmail.com> <20090503172338.GG4615@lenovo> <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com> <20090503204542.GJ4615@lenovo> <alpine.DEB.2.00.0905031357140.17811@chino.kir.corp.google.com> <20090504081454.GA4173@lenovo> <1241425941.21088.19.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241425941.21088.19.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Mon, May 04, 2009 at 11:32:21AM +0300]
...
| > Index: linux-2.6.git/include/linux/slab_def.h
| > =====================================================================
| > --- linux-2.6.git.orig/include/linux/slab_def.h
| > +++ linux-2.6.git/include/linux/slab_def.h
| > @@ -143,6 +143,7 @@ static __always_inline void *kmalloc(siz
| >  			i++;
| >  #include <linux/kmalloc_sizes.h>
| >  #undef CACHE
| > +		oom_panic(flags, get_order(size));
| 
| ...and this look fishy. They're static inlines that get expanded
| everywhere and they're known to be performance sensitive paths. I don't
| see much point in checking for >= MAX_ORDER at all because we will get a
| nice oops anyway for that.
| 
| __GFP_PANIC is an annotation saying that it's okay for a particular
| call-site not to check for NULL because we never expect to run out of
| memory at that point. But we don't really need to panic() for all the
| possible *errors*, just for the out-of-memory case.
| 
| 			Pekka
| 

A new one. Take a look please. I decided to put oom_panic
to oom_kill.c, since it seems to be appropriate.

	-- Cyrill

---
 include/linux/gfp.h |    4 +++-
 include/linux/oom.h |    1 +
 mm/failslab.c       |    3 +++
 mm/oom_kill.c       |   10 ++++++++++
 mm/page_alloc.c     |    7 +++++--
 5 files changed, 22 insertions(+), 3 deletions(-)

Index: linux-2.6.git/include/linux/gfp.h
=====================================================================
--- linux-2.6.git.orig/include/linux/gfp.h
+++ linux-2.6.git/include/linux/gfp.h
@@ -58,7 +58,9 @@ struct vm_area_struct;
 #define __GFP_NOTRACK	((__force gfp_t)0)
 #endif
 
-#define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
+#define __GFP_PANIC	((__force gfp_t)0x400000u) /* Panic on page alloction failure */
+
+#define __GFP_BITS_SHIFT 23	/* Room for 23 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /* This equals 0, but use constants in case they ever change */
Index: linux-2.6.git/include/linux/oom.h
=====================================================================
--- linux-2.6.git.orig/include/linux/oom.h
+++ linux-2.6.git/include/linux/oom.h
@@ -29,6 +29,7 @@ extern void clear_zonelist_oom(struct zo
 extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order);
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
+extern void oom_panic(gfp_t gfp_mask, unsigned int order);
 
 #endif /* __KERNEL__*/
 #endif /* _INCLUDE_LINUX_OOM_H */
Index: linux-2.6.git/mm/failslab.c
=====================================================================
--- linux-2.6.git.orig/mm/failslab.c
+++ linux-2.6.git/mm/failslab.c
@@ -17,6 +17,9 @@ bool should_failslab(size_t size, gfp_t 
 	if (gfpflags & __GFP_NOFAIL)
 		return false;
 
+	if (gfpflags & __GFP_PANIC)
+		return false;
+
         if (failslab.ignore_gfp_wait && (gfpflags & __GFP_WAIT))
 		return false;
 
Index: linux-2.6.git/mm/oom_kill.c
=====================================================================
--- linux-2.6.git.orig/mm/oom_kill.c
+++ linux-2.6.git/mm/oom_kill.c
@@ -422,6 +422,16 @@ static int oom_kill_process(struct task_
 	return oom_kill_task(p);
 }
 
+void oom_panic(gfp_t gfp_mask, unsigned int order)
+{
+	if (likely(!(gfp_mask & __GFP_PANIC)))
+		return;
+
+	panic("Out of memory: panic due to __GFP_PANIC.\n"
+		"%s order:%d, mode:0x%x\n", current->comm,
+		order, gfp_mask);
+}
+
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
 {
Index: linux-2.6.git/mm/page_alloc.c
=====================================================================
--- linux-2.6.git.orig/mm/page_alloc.c
+++ linux-2.6.git/mm/page_alloc.c
@@ -1185,6 +1185,8 @@ static int should_fail_alloc_page(gfp_t 
 		return 0;
 	if (gfp_mask & __GFP_NOFAIL)
 		return 0;
+	if (gfp_mask & __GFP_PANIC)
+		return 0;
 	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
 		return 0;
 	if (fail_page_alloc.ignore_gfp_wait && (gfp_mask & __GFP_WAIT))
@@ -1506,7 +1508,7 @@ restart:
 		 * Happens if we have an empty zonelist as a result of
 		 * GFP_THISNODE being used on a memoryless node
 		 */
-		return NULL;
+		goto nopage;
 	}
 
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
@@ -1685,7 +1687,8 @@ nopage:
 		dump_stack();
 		show_mem();
 	}
-	return page;
+	oom_panic(gfp_mask, order);
+	return NULL;
 got_pg:
 	if (kmemcheck_enabled)
 		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
