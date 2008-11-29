Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbYK2BBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbYK2BBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 20:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYK2BBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 20:01:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54247 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbYK2BBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 20:01:32 -0500
Message-Id: <200811290056.mAT0uTuk028924@terminus.zytor.com>
MIME-Version: 1.0
content-class: 
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: RE: [PATCH 1/1] edac x38: new MC driver module
Date: Fri, 28 Nov 2008 16:56:39 -0800
Importance: normal
X-Priority: 3
To: Hitoshi Mitake <h.mitake@gmail.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>, <dougthompson@xmission.com>,
       <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cast is unnecessary; one can argue for a cast to (u32) for clarity, but personally I think writel() is a clear enough especialy given the context.

-- 
Sent from my mobile phone (pardon any lack of formatting)


-----Original Message-----
From: Hitoshi Mitake <h.mitake@gmail.com>
Sent: Friday, November 28, 2008 16:11
To: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>; H. Peter Anvin <hpa@zytor.com>; Luck, Tony <tony.luck@intel.com>; Russell King <rmk+lkml@arm.linux.org.uk>; Ralf Baechle <ralf@linux-mips.org>; Andrew Morton <akpm@linux-foundation.org>; Doug Thompson <norsk5@yahoo.com>; dougthompson@xmission.com <dougthompson@xmission.com>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; linux-arch@vger.kernel.org <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/1] edac x38: new MC driver module

On Wed, 26 Nov 2008 01:10:59 +0900
Hitoshi Mitake <h.mitake@gmail.com> wrote:

> On Tue, 25 Nov 2008 16:46:18 +0100 (CET)
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> > On Wed, 26 Nov 2008, Hitoshi Mitake wrote:
> > > On Mon, 24 Nov 2008 21:13:58 -0800
> > > "H. Peter Anvin" <hpa@zytor.com> wrote:
> > > > Are you planning to add writeq() as well?
> > > 
> > > Yes, I want to add writeq().
> > > But there's a problem that
> > > I don't have a plan to use writeq() now, so I can't test writeq() soon.
> > > 
> > > How is this? I think it isn't bad. I want to hear your opinion.
> > > 
> > > static inline void writeq(__u64 val, volatile void __iomem *addr)
> > > {
> > > 	writel((unsigned int)val, addr);
> > > 	writel((unsigned int)(val >> 32), addr+1);
> >                                                ^
> > 					       4
> > 
> > > }
> > 
> 
> Thanks, I missed about void pointer...
> 

I rewrote the patch. I think newest version is good enough.
Could you please review this?

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
index ac2abc8..ac15d0e 100644
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
+	writel((unsigned int)val, addr);
+	writel((unsigned int)(val >> 32), addr+4);
+}
+
+#define readq readq
+#define writeq writeq
+
 #endif
 
 extern int iommu_bio_merge;
-- 
1.5.6.5


