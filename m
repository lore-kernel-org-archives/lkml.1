Return-Path: <linux-kernel-owner+w=401wt.eu-S1761038AbXKBSEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761038AbXKBSEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 14:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbXKBSEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 14:04:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46239 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbXKBSEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 14:04:32 -0400
Date: Fri, 2 Nov 2007 10:38:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>
Subject: [patch 7/9] x86: fix global_flush_tlb() bug
Message-ID: <20071102173808.GH6378@kroah.com>
References: <20071102173359.709442489@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-global_flush_tlb-bug.patch"
In-Reply-To: <20071102173733.GA6378@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ingo Molnar <mingo@elte.hu>

patch 9a24d04a3c26c223f22493492c5c9085b8773d4a upstream

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
Cc: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86_64/mm/pageattr.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86_64/mm/pageattr.c
+++ b/arch/x86_64/mm/pageattr.c
@@ -227,9 +227,14 @@ void global_flush_tlb(void)
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
 

-- 
