Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbYK3JYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbYK3JYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 04:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYK3JYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 04:24:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48110 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbYK3JYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 04:24:36 -0500
Date: Sun, 30 Nov 2008 10:24:07 +0100
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
Message-ID: <20081130092407.GA10802@elte.hu>
References: <200811290056.mAT0uTuk028924@terminus.zytor.com> <20081129164736.0b5a71db.h.mitake@gmail.com> <20081129093858.GC26691@elte.hu> <20081129192610.716a2d57.h.mitake@gmail.com> <20081129105229.GA9643@uranus.ravnborg.org> <20081129222449.e341f028.h.mitake@gmail.com> <20081129180144.GA15533@uranus.ravnborg.org> <20081130171604.dc3c8715.h.mitake@gmail.com> <20081130083700.GA31644@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081130083700.GA31644@elte.hu>
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


the 32-bit build broke promptly - readq/writeq is a family of APIs that 
has to be either fully provided or not provided at all. The fix is below.

	Ingo

--------------->
>From 16ebd68883e3583a66733d8b12ba55c8985af3f6 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 30 Nov 2008 10:20:20 +0100
Subject: [PATCH] x86: provide readq()/writeq() on 32-bit too, complete

if HAVE_READQ/HAVE_WRITEQ are defined, the full range of readq/writeq
APIs has to be provided to drivers:

 drivers/infiniband/hw/amso1100/c2.c: In function 'c2_tx_ring_alloc':
 drivers/infiniband/hw/amso1100/c2.c:133: error: implicit declaration of function '__raw_writeq'

So provide them on 32-bit as well. Also, map all the APIs to the
strongest ordering variant. It's way too easy to mess such details
up in drivers and the difference between "memory" and "" constrained
asm() constructs is in the noise range.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/io.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 3ccfaf6..9036156 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -46,16 +46,11 @@ build_mmio_write(__writel, "l", unsigned int, "r", )
 #define mmiowb() barrier()
 
 #ifdef CONFIG_X86_64
+
 build_mmio_read(readq, "q", unsigned long, "=r", :"memory")
-build_mmio_read(__readq, "q", unsigned long, "=r", )
 build_mmio_write(writeq, "q", unsigned long, "r", :"memory")
-build_mmio_write(__writeq, "q", unsigned long, "r", )
-
-#define readq_relaxed(a) __readq(a)
-#define __raw_readq __readq
-#define __raw_writeq writeq
 
-#else  /* CONFIG_X86_32 from here */
+#else
 
 static inline __u64 readq(const volatile void __iomem *addr)
 {
@@ -76,9 +71,14 @@ static inline void writeq(__u64 val, volatile void __iomem *addr)
 
 #endif
 
+#define readq_relaxed(a)	readq(a)
+
+#define __raw_readq(a)		readq(a)
+#define __raw_writeq(a)		writeq(a)
+
 /* Let people know that we have them */
-#define readq		readq
-#define writeq		writeq
+#define readq			readq
+#define writeq			writeq
 
 extern int iommu_bio_merge;
 
