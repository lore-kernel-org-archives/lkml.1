Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbZKMXDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbZKMXDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932339AbZKMXC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:02:56 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51079 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327AbZKMXCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:02:55 -0500
Date: Fri, 13 Nov 2009 23:02:23 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: d451564 breakage
Message-ID: <20091113230223.GF27752@flint.arm.linux.org.uk>
References: <20091113151119.GA27752@flint.arm.linux.org.uk> <20091113224820.GB29657@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113224820.GB29657@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 11:48:20PM +0100, Ingo Molnar wrote:
> 
> * Russell King <rmk@arm.linux.org.uk> wrote:
> 
> > Change:
> > 
> > highmem: Fix debug_kmap_atomic() to also handle KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE
> > 
> > Appears to break ARM:
> > 
> > mm/highmem.c: In function ???debug_kmap_atomic???:
> > mm/highmem.c:436: error: ???KM_NMI??? undeclared (first use in this function)
> 
> indeed - sorry.
> 
> Note that debug_kmap_atomic() will be removed in v2.6.33 so i'd suggest 
> to just do the easy solution and add #ifndef dummy definitions to 
> mm/highmem.c to cover ARM - we'll remove the whole cruft for good.

Actually, the following patch is probably the simplest solution.

> Btw., testing sidenote: i test the ARM defconfig and it didnt break 
> there. Perhaps highmem is off in the ARM defconfig? It would be helpful 
> if the ARM defconfig enabled highmem.

Given that highmem on ARM is experimental, I'd rather not have it enabled
in too many machine defconfigs as standard just yet.

However, enabling highmem on itself is not enough to show this breakage,
you also need highmem debugging enabled.

 arch/arm/include/asm/kmap_types.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/kmap_types.h b/arch/arm/include/asm/kmap_types.h
index d16ec97..c019949 100644
--- a/arch/arm/include/asm/kmap_types.h
+++ b/arch/arm/include/asm/kmap_types.h
@@ -22,4 +22,10 @@ enum km_type {
 	KM_TYPE_NR
 };
 
+#ifdef CONFIG_DEBUG_HIGHMEM
+#define KM_NMI		(-1)
+#define KM_NMI_PTE	(-1)
+#define KM_IRQ_PTE	(-1)
+#endif
+
 #endif


-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
