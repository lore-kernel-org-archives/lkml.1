Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbXJSKtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbXJSKtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 06:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbXJSKtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 06:49:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37901 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389AbXJSKtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 06:49:16 -0400
Date: Fri, 19 Oct 2007 12:48:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: [git pull] x86: fix global_flush_tlb() bug
Message-ID: <20071019104855.GA6621@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


find a fix for a pretty serious global_flush_tlb() x86-64 bug below, 
-stable candidate too i think.

Linus, please pull this fix from the x86 git tree:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-x86.git
  |
  |  Ingo Molnar (1):
  |           x86: fix global_flush_tlb() bug

thanks,

	Ingo

------------------>
Subject: x86: fix global_flush_tlb() bug
From: Ingo Molnar <mingo@elte.hu>

While we were reviewing pageattr_32/64.c for unification,
Thomas Gleixner noticed the following serious SMP bug in
global_flush_tlb():

	down_read(&init_mm.mmap_sem);
	list_replace_init(&deferred_pages, &l);
	up_read(&init_mm.mmap_sem);

this is SMP-unsafe because list_replace_init() done on two CPUs in
parallel can corrupt the list.

This bug has been introduced about a year ago in the 64-bit tree:

       commit ea7322decb974a4a3e804f96a0201e893ff88ce3
       Author: Andi Kleen <ak@suse.de>
       Date:   Thu Dec 7 02:14:05 2006 +0100

       [PATCH] x86-64: Speed and clean up cache flushing in change_page_attr

                down_read(&init_mm.mmap_sem);
        -       dpage = xchg(&deferred_pages, NULL);
        +       list_replace_init(&deferred_pages, &l);
                up_read(&init_mm.mmap_sem);

the xchg() based version was SMP-safe, but list_replace_init() is not.
So this "cleanup" introduced a nasty bug.

why this bug never become prominent is a mystery - it can probably be
explained with the (still) relative obscurity of the x86_64 architecture.

the safe fix for now is to write-lock init_mm.mmap_sem.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/pageattr_64.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -255,9 +255,14 @@ void global_flush_tlb(void)
 	struct page *pg, *next;
 	struct list_head l;
 
-	down_read(&init_mm.mmap_sem);
+	/*
+	 * Write-protect the semaphore, to exclude two contexts
+	 * doing a list_replace_init() call in parallel and to
+	 * exclude new additions to the deferred_pages list:
+	 */
+	down_write(&init_mm.mmap_sem);
 	list_replace_init(&deferred_pages, &l);
-	up_read(&init_mm.mmap_sem);
+	up_write(&init_mm.mmap_sem);
 
 	flush_map(&l);
 
