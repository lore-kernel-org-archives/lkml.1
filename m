Return-Path: <linux-kernel-owner+w=401wt.eu-S1751746AbYK3IQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbYK3IQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 03:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbYK3IQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 03:16:14 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:23346 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbYK3IQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 03:16:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=n4D4+uUHz27YTEsHnE+54s8xin65Ode7hzOBJOyjEeKEnyTRYWaho2Bf4Qf0ZuAwnP
         EZPjlDSgFznpcUVZf3bPd4myvPZLMqf3Xsc1TS0apTLQuC7AjSMqn4m/Dvijq/B5n1DL
         O7NIqtZwYe9BscUwfPRNqQTR/IU0t0qzk3+o0=
Date: Sun, 30 Nov 2008 17:16:04 +0900
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20081130171604.dc3c8715.h.mitake@gmail.com>
In-Reply-To: <20081129180144.GA15533@uranus.ravnborg.org>
References: <200811290056.mAT0uTuk028924@terminus.zytor.com>
	<20081129164736.0b5a71db.h.mitake@gmail.com>
	<20081129093858.GC26691@elte.hu>
	<20081129192610.716a2d57.h.mitake@gmail.com>
	<20081129105229.GA9643@uranus.ravnborg.org>
	<20081129222449.e341f028.h.mitake@gmail.com>
	<20081129180144.GA15533@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 19:01:44 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> I see both rationales and you combine them in your patch - OK.
> 
> And the reason why you cannot just add this to
> include/linux/io.h is that not all architectures
> provide a readl()/writel() I assume.
>
Yes, I can't say all architectures provide readl/writel.
And there may be some architecture depended problems,
so I can't decide to add my readq/writeq as architecture independent ones.

> Feel free to add my Acked-by: to the patch.

Thanks, I added your Acked-by to new patch.


description of this patch
Adding implementation of readq/writeq to x86_32,
and adding config value to x86 architecture to determine existence of readq/writeq

Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/Kconfig          |    2 ++
 arch/x86/include/asm/io.h |   24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac22bb7..75408fe 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -34,6 +34,8 @@ config X86
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select HAVE_READQ
+	select HAVE_WRITEQ
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index ac2abc8..ddc67aa 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -4,6 +4,7 @@
 #define ARCH_HAS_IOREMAP_WC
 
 #include <linux/compiler.h>
+#include <asm-generic/int-ll64.h>
 
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
@@ -57,6 +58,29 @@ build_mmio_write(__writeq, "q", unsigned long, "r", )
 /* Let people know we have them */
 #define readq readq
 #define writeq writeq
+
+#else  /* CONFIG_X86_32 from here */
+
+static inline __u64 readq(const volatile void __iomem *addr)
+{
+	const volatile u32 __iomem *p = addr;
+	u32 l, h;
+
+	l = readl(p);
+	h = readl(p+1);
+
+	return l + ((u64)h << 32);
+}
+
+static inline void writeq(__u64 val, volatile void __iomem *addr)
+{
+	writel(val, addr);
+	writel(val >> 32, addr+4);
+}
+
+#define readq readq
+#define writeq writeq
+
 #endif
 
 extern int iommu_bio_merge;
-- 
1.5.6.5

