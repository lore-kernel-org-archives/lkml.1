Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbXDZQ6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbXDZQ6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbXDZQ6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:58:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35001 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbXDZQ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:58:28 -0400
Date: Thu, 26 Apr 2007 09:55:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 05/33] KVM: MMU: Fix host memory corruption on i386 with >=
	4GB ram
Message-ID: <20070426165516.GF1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-mmu-fix-host-memory-corruption-on-i386-with-4gb-ram.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@qumranet.com>

PAGE_MASK is an unsigned long, so using it to mask physical addresses on
i386 (which are 64-bit wide) leads to truncation.  This can result in
page->private of unrelated memory pages being modified, with disasterous
results.

Fix by not using PAGE_MASK for physical addresses; instead calculate
the correct value directly from PAGE_SIZE.  Also fix a similar BUG_ON().

Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/kvm/mmu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -131,7 +131,7 @@ static int dbg = 1;
 	(((address) >> PT32_LEVEL_SHIFT(level)) & ((1 << PT32_LEVEL_BITS) - 1))
 
 
-#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & PAGE_MASK)
+#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
 #define PT64_DIR_BASE_ADDR_MASK \
 	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + PT64_LEVEL_BITS)) - 1))
 
@@ -406,8 +406,8 @@ static void rmap_write_protect(struct kv
 			spte = desc->shadow_ptes[0];
 		}
 		BUG_ON(!spte);
-		BUG_ON((*spte & PT64_BASE_ADDR_MASK) !=
-		       page_to_pfn(page) << PAGE_SHIFT);
+		BUG_ON((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT
+		       != page_to_pfn(page));
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		BUG_ON(!(*spte & PT_WRITABLE_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);

-- 
