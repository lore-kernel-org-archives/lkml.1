Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYC1StW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYC1StW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYC1StQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:49:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080AbYC1StP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:49:15 -0400
Date: Fri, 28 Mar 2008 11:47:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: penberg@cs.helsinki.fi, clameter@sgi.com, rjw@sisk.pl,
       pstaszewski@artcom.pl, linux-kernel@vger.kernel.org, bunk@kernel.org,
       protasnb@gmail.com
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Message-Id: <20080328114734.13607172.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803281116460.14670@woody.linux-foundation.org>
References: <200803272353.51901.rjw@sisk.pl>
	<alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>
	<Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>
	<alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
	<84144f020803281015s60370d9dpec0913c33004b6c2@mail.gmail.com>
	<alpine.LFD.1.00.0803281017500.14670@woody.linux-foundation.org>
	<84144f020803281108o178bf62cp48dcd4f43ec59b74@mail.gmail.com>
	<alpine.LFD.1.00.0803281116460.14670@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008 11:20:52 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> The code in question is __slab_alloc().

The bug we're discussing is http://bugzilla.kernel.org/show_bug.cgi?id=10318

It's a driver call stright into the page allocator - slab is not involved.

I was planning on plugging it this way:


From: Andrew Morton <akpm@linux-foundation.org>

I believe http://bugzilla.kernel.org/show_bug.cgi?id=10318 is a false
positive.  There's no way in which networking will be using highmem pages
here, so it won't be taking the KM_USER0 kmap slot, so there's no point in
performing these checks.

Cc: Pawel Staszewski <pstaszewski@artcom.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/highmem_32.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/highmem_32.c~x86-kmap_atomic-debugging-only-run-debug_kmap_atomic_prot-for-highmem-pages arch/x86/mm/highmem_32.c
--- a/arch/x86/mm/highmem_32.c~x86-kmap_atomic-debugging-only-run-debug_kmap_atomic_prot-for-highmem-pages
+++ a/arch/x86/mm/highmem_32.c
@@ -73,15 +73,15 @@ void *kmap_atomic_prot(struct page *page
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
-	/* even !CONFIG_PREEMPT needs this, for in_atomic in do_page_fault */
-
-	debug_kmap_atomic_prot(type);
 
+	/* even !CONFIG_PREEMPT needs this, for in_atomic in do_page_fault */
 	pagefault_disable();
 
 	if (!PageHighMem(page))
 		return page_address(page);
 
+	debug_kmap_atomic_prot(type);
+
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
_

