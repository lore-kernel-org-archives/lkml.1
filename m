Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbYK3Ihf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbYK3Ihf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 03:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYK3IhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 03:37:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40825 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYK3IhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 03:37:24 -0500
Date: Sun, 30 Nov 2008 09:37:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-ID: <20081130083700.GA31644@elte.hu>
References: <200811290056.mAT0uTuk028924@terminus.zytor.com> <20081129164736.0b5a71db.h.mitake@gmail.com> <20081129093858.GC26691@elte.hu> <20081129192610.716a2d57.h.mitake@gmail.com> <20081129105229.GA9643@uranus.ravnborg.org> <20081129222449.e341f028.h.mitake@gmail.com> <20081129180144.GA15533@uranus.ravnborg.org> <20081130171604.dc3c8715.h.mitake@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081130171604.dc3c8715.h.mitake@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <h.mitake@gmail.com> wrote:

> On Sat, 29 Nov 2008 19:01:44 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > I see both rationales and you combine them in your patch - OK.
> > 
> > And the reason why you cannot just add this to
> > include/linux/io.h is that not all architectures
> > provide a readl()/writel() I assume.
> >
> Yes, I can't say all architectures provide readl/writel.
> And there may be some architecture depended problems,
> so I can't decide to add my readq/writeq as architecture independent ones.
> 
> > Feel free to add my Acked-by: to the patch.
> 
> Thanks, I added your Acked-by to new patch.

applied to tip/x86/io, thanks! I also did the small cleanup below.

	Ingo

------------>
>From 458102461ccedc3ab7847132b5db6a53782dc9a8 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 30 Nov 2008 09:33:55 +0100
Subject: [PATCH] x86: provide readq()/writeq() on 32-bit too, cleanup

Impact: cleanup

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/io.h |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 2594644..3ccfaf6 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -55,21 +55,17 @@ build_mmio_write(__writeq, "q", unsigned long, "r", )
 #define __raw_readq __readq
 #define __raw_writeq writeq
 
-/* Let people know we have them */
-#define readq readq
-#define writeq writeq
-
 #else  /* CONFIG_X86_32 from here */
 
 static inline __u64 readq(const volatile void __iomem *addr)
 {
 	const volatile u32 __iomem *p = addr;
-	u32 l, h;
+	u32 low, high;
 
-	l = readl(p);
-	h = readl(p + 1);
+	low = readl(p);
+	high = readl(p + 1);
 
-	return l + ((u64)h << 32);
+	return low + ((u64)high << 32);
 }
 
 static inline void writeq(__u64 val, volatile void __iomem *addr)
@@ -78,11 +74,12 @@ static inline void writeq(__u64 val, volatile void __iomem *addr)
 	writel(val >> 32, addr+4);
 }
 
+#endif
+
+/* Let people know that we have them */
 #define readq		readq
 #define writeq		writeq
 
-#endif
-
 extern int iommu_bio_merge;
 
 #ifdef CONFIG_X86_32
