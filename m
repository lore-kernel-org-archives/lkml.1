Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYKYCz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYKYCz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 21:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYKYCzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 21:55:18 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:46201 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbYKYCzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 21:55:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=RI4RhTQDa/yJskO0R8h3EtwsqTjYwNn01an5Cw2tPBrXmtobs5jKMg1e7Ovtn9FxGg
         KQ4n0+JTylZ/t6MEu9ktRBOi6neudT109KuPguPFXFe5Qkw/q5tJHGXdG9K7bkFr2EKB
         IgHSmrT0rQ9pAJxbgvRSZ5zWKf9NZGmWPL+MY=
Date: Tue, 25 Nov 2008 11:55:10 +0900
From: Hitoshi Mitake <h.mitake@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>,
       "dougthompson@xmission.com" <dougthompson@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20081125115510.108fa886.h.mitake@gmail.com>
In-Reply-To: <492AEC40.5060009@zytor.com>
References: <20081105222911.d76e7e1c.mitake@clustcom.com>
	<413709.12821.qm@web50106.mail.re2.yahoo.com>
	<20081106164641.ed369060.akpm@linux-foundation.org>
	<20081107152830.a42766f3.mitake@clustcom.com>
	<20081106223122.8a255211.akpm@linux-foundation.org>
	<20081107153824.0ec934e6.mitake@clustcom.com>
	<20081106231102.aab83cd4.akpm@linux-foundation.org>
	<a6b9f31a0811090710y17e956bawf20675d6678b145e@mail.gmail.com>
	<20081109112646.97c594b5.akpm@linux-foundation.org>
	<20081118121620.GB8625@linux-mips.org>
	<20081118123215.GB30509@flint.arm.linux.org.uk>
	<20081121011941.26e05a25.h.mitake@gmail.com>
	<4929ECB7.8080108@zytor.com>
	<57C9024A16AD2D4C97DC78E552063EA35C517F42@orsmsx505.amr.corp.intel.com>
	<492AEC40.5060009@zytor.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008 10:02:40 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

Thanks for your reviews and advices, Peter and Tony.

> Luck, Tony wrote:
> >>       volatile u32 __iomem *__p = addr;
> >>       u32 __l, __h;
> > 
> > Do we really need all the "__" inside an inline function?  Why
> > not just call these "p", "l" and "h"?
> 
> Sorry, user space habit (in userspace, and in anything that can be
> included from userspace, one needs the __ to keep the namespace clean.)

I think which need __ is variable type name, not each variable name.
Name of each local variables can't effect namespace.
And I found this comment in asm-generic/int-ll64.h,
/*
 * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
 * header files exported to user space
 */

According to your advice, I rewrote the patch, how is this?

description of this patch: Adding config value to x86 architecture to determine existence of readq/writeq

Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
---
 arch/x86/Kconfig          |    3 +++
 arch/x86/include/asm/io.h |   17 +++++++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac22bb7..8f3c949 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -11,9 +11,12 @@ config 64BIT
 
 config X86_32
 	def_bool !64BIT
+	select ARCH_HAS_READQ
 
 config X86_64
 	def_bool 64BIT
+	select ARCH_HAS_READQ
+	select ARCH_HAS_WRITEQ
 
 ### Arch settings
 config X86
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index ac2abc8..5322d18 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -4,6 +4,7 @@
 #define ARCH_HAS_IOREMAP_WC
 
 #include <linux/compiler.h>
+#include <asm-generic/int-ll64.h>
 
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
@@ -57,6 +58,22 @@ build_mmio_write(__writeq, "q", unsigned long, "r", )
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
+#define readq readq
+
 #endif
 
 extern int iommu_bio_merge;
-- 
1.5.6.5

