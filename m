Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbZECUqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbZECUqG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 16:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbZECUpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 16:45:50 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41767 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbZECUpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 16:45:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=g73FeWwvp7QK+MuTL1KAD1ntKCr0kGKEWwSYkXBvEECPKmkGaQSNiIma4yBmGvbN7G
         zT/ox6Ruo4lvpMjzOYflZ5UgE4EGBr+JIRoQeUnKOOA5cUgoxLtvx7Xunj9w5H4R28SI
         WTY+eCeUgJx2kNkrh8Z26kh0pkGMDAc/mYLKs=
Date: Mon, 4 May 2009 00:45:42 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: introducing __GFP_PANIC
Message-ID: <20090503204542.GJ4615@lenovo>
References: <20090501203123.GA10878@sgi.com> <20090503084847.GA20394@elte.hu> <alpine.DEB.2.00.0905030203520.16287@chino.kir.corp.google.com> <84144f020905030259i59ea304ftdc9224e6a9b5c285@mail.gmail.com> <20090503121228.GC4615@lenovo> <1241353621.27683.3.camel@penberg-laptop> <20090503143824.GF4615@lenovo> <84144f020905030954m434d0550l3ed7ef7436c803df@mail.gmail.com> <20090503172338.GG4615@lenovo> <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Sun, May 03, 2009 at 08:38:01PM +0300]
| On Sun, May 3, 2009 at 8:23 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > | > Hi Pekka,
| > | >
| > | > ufortunatelly __alloc_pages_internal is not the only place where
| > | > we do return NULL from kmalloc. As example - failslab facility
| > | > (in slab_alloc call). Anyway -- I'll take a closer look.
| > |
| > | Right. I think failslab needs some fixing _not_ to return NULL if
| > | __GFP_PANIC is set.
| > |
| >
| > Ok, as a first raw draft (_not_ covering all the cases) it could
| > be something like this. It touches only __alloc_pages_internal
| > and we have to bespread as well:
| >
| > 1) alloc_pages with order >= MAX_ORDER (gfp.h)
| > 2) the same for alloc_pages_node (both used by SLOB)
| > 3) all __kmalloc should be explored as well.
| > 4) ???
| >
| > Anyway -- take a look on __alloc_pages_internal part :)
| >
| >        -- Cyrill
| >
| > ---
| >  include/linux/gfp.h |    4 +++-
| >  mm/page_alloc.c     |    8 +++++---
| >  2 files changed, 8 insertions(+), 4 deletions(-)
| >
| > Index: linux-2.6.git/include/linux/gfp.h
| > =====================================================================
| > --- linux-2.6.git.orig/include/linux/gfp.h
| > +++ linux-2.6.git/include/linux/gfp.h
| > @@ -58,7 +58,9 @@ struct vm_area_struct;
| >  #define __GFP_NOTRACK  ((__force gfp_t)0)
| >  #endif
| >
| > -#define __GFP_BITS_SHIFT 22    /* Room for 22 __GFP_FOO bits */
| > +#define __GFP_PANIC    ((__force gfp_t)0x400000u) /* Panic on page alloction failure */
| > +
| > +#define __GFP_BITS_SHIFT 23    /* Room for 23 __GFP_FOO bits */
| >  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
| >
| >  /* This equals 0, but use constants in case they ever change */
| > Index: linux-2.6.git/mm/page_alloc.c
| > =====================================================================
| > --- linux-2.6.git.orig/mm/page_alloc.c
| > +++ linux-2.6.git/mm/page_alloc.c
| > @@ -1496,7 +1496,7 @@ __alloc_pages_internal(gfp_t gfp_mask, u
| >        might_sleep_if(wait);
| >
| >        if (should_fail_alloc_page(gfp_mask, order))
| > -               return NULL;
| > +               goto nopage;
| 
| The point of fault injection is to increase coverage out-of-memory
| error handling code. So this doesn't make much sense to me. Why would
| you want to cause a __GFP_PANIC call-sites to panic()? It doesn't help
| testing one bit.
| 
| So I still think you should just fix up should_fail_alloc_page() _not_
| to return true if __GFP_PANIC is set.
| 

Just before I get some sleep. Here is an another attempt.

Not covered cases I know of:

1) SLAB with builtin constant as size and we don't find appropriate
   cache for it do return NULL
2) alloc_pages_node and alloc_pages do check for MAX_ORDER which
   could be exceeded as well and return NULL then.

ok, here is a preliminary patch just to hear some complains :)

	-- Cyrill
---
 include/linux/gfp.h |    4 +++-
 mm/failslab.c       |    3 +++
 mm/page_alloc.c     |    8 ++++++--
 3 files changed, 12 insertions(+), 3 deletions(-)

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
@@ -1685,7 +1687,9 @@ nopage:
 		dump_stack();
 		show_mem();
 	}
-	return page;
+	if (unlikely(gfp_mask & __GFP_PANIC))
+		panic("Out of memory: panic due to __GFP_PANIC\n");
+	return NULL;
 got_pg:
 	if (kmemcheck_enabled)
 		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
