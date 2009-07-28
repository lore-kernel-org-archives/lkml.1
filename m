Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbZG1XxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbZG1XxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbZG1Xu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:27 -0400
Received: from kroah.org ([198.145.64.141]:35902 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbZG1XuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:20 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:59 2009
Message-Id: <20090728234159.545268094@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Chris Wright <chrisw@sous-sol.org>, Nick Piggin <npiggin@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 52/71] x86: dont use access_ok() as a range check in get_user_pages_fast()
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=x86-don-t-use-access_ok-as-a-range-check-in-get_user_pages_fast.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 7f8189068726492950bf1a2dcfd9b51314560abf - modified
  for stable to not use the sloppy __VIRTUAL_MASK_SHIFT ]

It's really not right to use 'access_ok()', since that is meant for the
normal "get_user()" and "copy_from/to_user()" accesses, which are done
through the TLB, rather than through the page tables.

Why? access_ok() does both too few, and too many checks.  Too many,
because it is meant for regular kernel accesses that will not honor the
'user' bit in the page tables, and because it honors the USER_DS vs
KERNEL_DS distinction that we shouldn't care about in GUP.  And too few,
because it doesn't do the 'canonical' check on the address on x86-64,
since the TLB will do that for us.

So instead of using a function that isn't meant for this, and does
something else and much more complicated, just do the real rules: we
don't want the range to overflow, and on x86-64, we want it to be a
canonical low address (on 32-bit, all addresses are canonical).

Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/gup.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -247,10 +247,15 @@ int get_user_pages_fast(unsigned long st
 	start &= PAGE_MASK;
 	addr = start;
 	len = (unsigned long) nr_pages << PAGE_SHIFT;
+
 	end = start + len;
-	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
-					(void __user *)start, len)))
+	if (end < start)
+		goto slow_irqon;
+
+#ifdef CONFIG_X86_64
+	if (end >> 47)
 		goto slow_irqon;
+#endif
 
 	/*
 	 * XXX: batch / limit 'nr', to avoid large irq off latency


