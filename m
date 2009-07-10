Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbZGJTwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbZGJTwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZGJTwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:52:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57074 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbZGJTwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:52:14 -0400
Date: Fri, 10 Jul 2009 21:51:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] dma-debug: Fix the overlap() function to be correct and
	readable
Message-ID: <20090710195157.GA31361@elte.hu>
References: <20090710162848.GA26862@elte.hu> <alpine.LFD.2.01.0907101206120.3352@localhost.localdomain> <20090710193110.GA28281@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710193110.GA28281@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > IOW, I think this whole function is just total crap, apparently 
> > put together by randomly assembling characters until it 
> > compiles. Somebody should put more effort into looking at it, 
> > but I think it should be something like
> > 
> > 	static inline int overlap(void *addr, unsigned long len, void *start, void *end)
> > 	{
> > 		unsigned long a1 = (unsigned long) addr;
> > 		unsigned long b1 = a1 + len;
> > 		unsigned long a2 = (unsigned long) start;
> > 		unsigned long b2 = (unsigned long) end;
> 
> At least some arguments have unsigned long natural types (they come 
> out of page_address() for example) so the function parameters could 
> perhaps be changed to unsigned long too as well.
> 
> > 	#ifdef WE_CARE_DEEPLY
> > 		/* Overflow? */
> > 		if (b1 < a1)
> > 			return 1;
> > 	#ifdef AND_ARE_ANAL
> > 		if (b2 < a2)
> > 			return 1;
> > 	#endif
> > 	#endif
> > 		return !(b1 <= a2 || a1 >= b2);
> > 	}
> > 
> > but I really migth have done soemthing wrong there. It's a 
> > simple function, but somebody needs to double-check that I 
> > haven't made it worse.
> 
> Looks correct to me.

How about the patch below? Lightly tested.

	Ingo

------------>
>From 35c89da82e969a2fd157478940e7ecde1e19ccc4 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 10 Jul 2009 21:38:02 +0200
Subject: [PATCH] dma-debug: Fix the overlap() function to be correct and readable

Linus noticed how unclean and buggy the overlap() function is:

 - It uses convoluted (and bug-causing) positive checks for
   range overlap - instead of using a more natural negative
   check.

 - Even the positive checks are buggy: a positive intersection
   check has four natural cases while we checked only for three,
   missing the (addr < start && addr2 == end) case for example.

 - The variables are mis-named, making it non-obvious how the
   check was done.

 - It needlessly uses u64 instead of unsigned long. Since these
   are kernel memory pointers and we explicitly exclude highmem
   ranges anyway we cannot ever overflow 32 bits, even if we
   could. (and on 64-bit it doesnt matter anyway)

All in one, this function needs a total revamp. I used Linus's
suggestions minus the paranoid checks (we cannot overflow really
because if we get totally bad DMA ranges passed far more things
break in the systems than just DMA debugging). I also fixed a
few other small details i noticed.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/dma-debug.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index c9187fe..02fed52 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -856,22 +856,21 @@ static void check_for_stack(struct device *dev, void *addr)
 				"stack [addr=%p]\n", addr);
 }
 
-static inline bool overlap(void *addr, u64 size, void *start, void *end)
+static inline bool overlap(void *addr, unsigned long len, void *start, void *end)
 {
-	void *addr2 = (char *)addr + size;
+	unsigned long a1 = (unsigned long)addr;
+	unsigned long b1 = a1 + len;
+	unsigned long a2 = (unsigned long)start;
+	unsigned long b2 = (unsigned long)end;
 
-	return ((addr >= start && addr < end) ||
-		(addr2 >= start && addr2 < end) ||
-		((addr < start) && (addr2 > end)));
+	return !(b1 <= a2 || a1 >= b2);
 }
 
-static void check_for_illegal_area(struct device *dev, void *addr, u64 size)
+static void check_for_illegal_area(struct device *dev, void *addr, unsigned long len)
 {
-	if (overlap(addr, size, _text, _etext) ||
-	    overlap(addr, size, __start_rodata, __end_rodata))
-		err_printk(dev, NULL, "DMA-API: device driver maps "
-				"memory from kernel text or rodata "
-				"[addr=%p] [size=%llu]\n", addr, size);
+	if (overlap(addr, len, _text, _etext) ||
+	    overlap(addr, len, __start_rodata, __end_rodata))
+		err_printk(dev, NULL, "DMA-API: device driver maps memory from kernel text or rodata [addr=%p] [len=%lu]\n", addr, len);
 }
 
 static void check_sync(struct device *dev,
@@ -969,7 +968,8 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 		entry->type = dma_debug_single;
 
 	if (!PageHighMem(page)) {
-		void *addr = ((char *)page_address(page)) + offset;
+		void *addr = (void *)page_address(page) + offset;
+
 		check_for_stack(dev, addr);
 		check_for_illegal_area(dev, addr, size);
 	}
