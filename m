Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbZCOO5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbZCOO5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 10:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZCOO53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 10:57:29 -0400
Received: from waste.org ([66.93.16.53]:47367 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbZCOO53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 10:57:29 -0400
Subject: Re: SLOB lockup (was: Re: [tip:core/locking] lockdep: annotate
	reclaim context (__GFP_NOFS), fix SLOB)
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
In-Reply-To: <200903152006.21160.nickpiggin@yahoo.com.au>
References: <20090128135457.350751756@chello.nl>
	 <tip-bf722c9d324864b4256edaa330751b77f2a19861@git.kernel.org>
	 <20090315064818.GA1193@elte.hu>
	 <200903152006.21160.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Sun, 15 Mar 2009 09:56:00 -0500
Message-Id: <1237128960.3213.133.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-15 at 20:06 +1100, Nick Piggin wrote:
> On Sunday 15 March 2009 17:48:18 Ingo Molnar wrote:
> 
> > > Cc: Nick Piggin <npiggin@suse.de>
> > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > LKML-Reference: <20090128135457.350751756@chello.nl>
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >
> > and with this fixed, and with SLOB now being tested in -tip, the
> > new lockdep assert attached below (followed by a real lockup)
> > pops up.
> >
> > Seems like a genuine SLOB bug, probably present upstream as
> > well.
> 
> Hmmf. debugobjects calls back into the slab allocator from the page
> allocator. The following patch would improve SLOB, but I think it
> would be a good idea to avoid a dependency in that direction. Can
> debugobjects defer this freeing?

Yeah. I don't think any of the allocators are designed with recursion in
mind. That the others aren't (visibly) failing here is blind luck.

Nick, not really sure what your patch is accomplishing. It narrows the
lock window, but it doesn't eliminate it. But I think we can take the
page allocator case out from under the lock entirely, no?

diff -r 8e0f1cee0a71 mm/slob.c
--- a/mm/slob.c	Sat Jan 24 15:41:13 2009 -0600
+++ b/mm/slob.c	Sun Mar 15 09:50:42 2009 -0500
@@ -387,8 +387,6 @@
 	sp = (struct slob_page *)virt_to_page(block);
 	units = SLOB_UNITS(size);
 
-	spin_lock_irqsave(&slob_lock, flags);
-
 	if (sp->units + units == SLOB_UNITS(PAGE_SIZE)) {
 		/* Go directly to page allocator. Do not pass slob allocator */
 		if (slob_page_free(sp))
@@ -396,9 +394,11 @@
 		clear_slob_page(sp);
 		free_slob_page(sp);
 		free_page((unsigned long)b);
-		goto out;
+		return;
 	}
 
+	spin_lock_irqsave(&slob_lock, flags);
+
 	if (!slob_page_free(sp)) {
 		/* This slob page is about to become partially free. Easy! */
 		sp->units = units;

-- 
http://selenic.com : development and support for Mercurial and Linux


