Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbZAaDB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbZAaDB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbZAaCrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:22 -0500
Received: from kroah.org ([198.145.64.141]:55207 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756456AbZAaCrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:13 -0500
Date: Fri, 30 Jan 2009 18:42:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Peter Zijlstra <a.p.zijlsta@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 07/43] x86, mm: fix pte_free()
Message-ID: <20090131024227.GH12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-mm-fix-pte_free.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 42ef73fe134732b2e91c0326df5fd568da17c4b2 upstream.

On -rt we were seeing spurious bad page states like:

Bad page state in process 'firefox'
page:c1bc2380 flags:0x40000000 mapping:c1bc2390 mapcount:0 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
Pid: 503, comm: firefox Not tainted 2.6.26.8-rt13 #3
[<c043d0f3>] ? printk+0x14/0x19
[<c0272d4e>] bad_page+0x4e/0x79
[<c0273831>] free_hot_cold_page+0x5b/0x1d3
[<c02739f6>] free_hot_page+0xf/0x11
[<c0273a18>] __free_pages+0x20/0x2b
[<c027d170>] __pte_alloc+0x87/0x91
[<c027d25e>] handle_mm_fault+0xe4/0x733
[<c043f680>] ? rt_mutex_down_read_trylock+0x57/0x63
[<c043f680>] ? rt_mutex_down_read_trylock+0x57/0x63
[<c0218875>] do_page_fault+0x36f/0x88a

This is the case where a concurrent fault already installed the PTE and
we get to free the newly allocated one.

This is due to pgtable_page_ctor() doing the spin_lock_init(&page->ptl)
which is overlaid with the {private, mapping} struct.

union {
    struct {
        unsigned long private;
        struct address_space *mapping;
    };
    spinlock_t ptl;
    struct kmem_cache *slab;
    struct page *first_page;
};

Normally the spinlock is small enough to not stomp on page->mapping, but
PREEMPT_RT=y has huge 'spin'locks.

But lockdep kernels should also be able to trigger this splat, as the
lock tracking code grows the spinlock to cover page->mapping.

The obvious fix is calling pgtable_page_dtor() like the regular pte free
path __pte_free_tlb() does.

It seems all architectures except x86 and nm10300 already do this, and
nm10300 doesn't seem to use pgtable_page_ctor(), which suggests it
doesn't do SMP or simply doesnt do MMU at all or something.

Signed-off-by: Peter Zijlstra <a.p.zijlsta@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/pgalloc.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -42,6 +42,7 @@ static inline void pte_free_kernel(struc
 
 static inline void pte_free(struct mm_struct *mm, struct page *pte)
 {
+	pgtable_page_dtor(pte);
 	__free_page(pte);
 }
 

