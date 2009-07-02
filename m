Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbZGBXWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbZGBXWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZGBXWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:22:23 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:58016 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbZGBXWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:22:22 -0400
Date: Fri, 3 Jul 2009 00:22:05 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org,
       Pavel Machek <pavel@ucw.cz>, Wu Zhangjin <wuzj@lemote.com>
Subject: Re: [PATCH] [MIPS] Hibernation: only save pages in system ram
Message-ID: <20090702232205.GE14804@linux-mips.org>
References: <1246373570-21090-1-git-send-email-wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246373570-21090-1-git-send-email-wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 10:52:50PM +0800, Wu Zhangjin wrote:

> From: Wu Zhangjin <wuzj@lemote.com>
> 
> when using hibernation(STD) with CONFIG_FLATMEM in linux-mips-64bit, it
> fails for the current mips-specific hibernation implementation save the
> pages in all of the memory space(except the nosave section) and make
> there will be not enough memory left to the STD task itself, and then
> fail. in reality, we only need to save the pages in system rams.
> 
> here is the reason why it fail:
> 
> kernel/power/snapshot.c:
> 
> static void mark_nosave_pages(struct memory_bitmap *bm)
> {
> 		...
> 		if (pfn_valid(pfn)) {
> 			...
> 		}
> }
> 
> arch/mips/include/asm/page.h:
> 
> 	...
> 	#ifdef CONFIG_FLATMEM
> 
> 	#define pfn_valid(pfn)		((pfn) >= ARCH_PFN_OFFSET && (pfn) < max_mapnr)
> 
> 	#elif defined(CONFIG_SPARSEMEM)
> 
> 	/* pfn_valid is defined in linux/mmzone.h */
> 	...
> 
> we can rewrite pfn_valid(pfn) to fix this problem, but I really do not
> want to touch such a widely-used macro, so, I used another solution:
> 
> static struct page *saveable_page(struct zone *zone, unsigned long pfn)
> {
> 	...
> 	if ( .... pfn_is_nosave(pfn)
> 		return NULL;
> 	...
> }
> 
> and pfn_is_nosave is implemented in arch/mips/power/cpu.c, so, hacking
> this one is better.

No - pfn_valid() is broken, so it should be fixed.  Commit
752fbeb2e3555c0d236e992f1195fd7ce30e728d introduced the breakage.  It
seemed to assume that the valid range for PFNs doesn't start at 0 but
some higher number but got that entirely wrong..

#define ARCH_PFN_OFFSET         PFN_UP(PHYS_OFFSET)
#define pfn_valid(pfn)         ((pfn) >= ARCH_PFN_OFFSET && (pfn) < max_mapnr)

works nicely when PHYS_OFFSET is 0 - as for most MIPS systems and goes
horribly wrong otherwise.  So I suggest below patch.

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/mips/include/asm/page.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index dc0eaa7..96a14a4 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -165,7 +165,14 @@ typedef struct { unsigned long pgprot; } pgprot_t;
 
 #ifdef CONFIG_FLATMEM
 
-#define pfn_valid(pfn)		((pfn) >= ARCH_PFN_OFFSET && (pfn) < max_mapnr)
+#define pfn_valid(pfn)							\
+({									\
+	unsigned long __pfn = (pfn);					\
+	/* avoid <linux/bootmem.h> include hell */			\
+	extern unsigned long min_low_pfn;				\
+									\
+	__pfn >= min_low_pfn && __pfn < max_mapnr;			\
+})
 
 #elif defined(CONFIG_SPARSEMEM)
 
