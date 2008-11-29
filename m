Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYK2Hr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYK2Hr5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 02:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYK2Hrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 02:47:49 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:42033 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYK2Hrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 02:47:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=hLLBywDG4dC3OH3kJ1ISQRxZ8QK/rLMCs287skk0bvX6tQOf3p4X0KjVgHY/rFhee8
         0lgcFmfr7iTmr+tJYdX46X3YQpuXRF/cKxD5ebyNpxBml45HZnsvjXoF9f/DGDywQ/Hx
         UiRqLgxYRpCFAmF0y3wSzpPv8tRU+CPcVbAFw=
Date: Sat, 29 Nov 2008 16:47:36 +0900
From: Hitoshi Mitake <h.mitake@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>, <dougthompson@xmission.com>,
       <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20081129164736.0b5a71db.h.mitake@gmail.com>
In-Reply-To: <200811290056.mAT0uTuk028924@terminus.zytor.com>
References: <200811290056.mAT0uTuk028924@terminus.zytor.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008 16:56:39 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> The cast is unnecessary; one can argue for a cast to (u32) for clarity, but personally I think writel() is a clear enough especialy given the context.
> 

Thanks for your advice. I removed redundant cat. How is this?

description of this patch
Adding implementation of readq/writeq to x86_32,
and adding config value to x86 architecture to determine existence of readq/writeq

Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
---
 arch/x86/Kconfig          |    4 ++++
 arch/x86/include/asm/io.h |   24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac22bb7..10bd84c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -11,9 +11,13 @@ config 64BIT
 
 config X86_32
 	def_bool !64BIT
+	select ARCH_HAS_READQ
+	select ARCH_HAS_WRITEQ
 
 config X86_64
 	def_bool 64BIT
+	select ARCH_HAS_READQ
+	select ARCH_HAS_WRITEQ
 
 ### Arch settings
 config X86
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

