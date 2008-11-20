Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYKTQUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYKTQUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbYKTQTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:19:51 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:10885 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbYKTQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:19:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=bio9p5ePeCqoAwqCkYA75p5GR92GjkyDqSra/dpMBRZfTmhGTLkdofn7yi2XGn1VJS
         INLQ/wWZptqRSlZjqsDu4s1Wly+NBxelrMDwmIjzf4YlYsH6/w+/gbQHD47eZF/9pjJi
         nfB26g3efMSRi/aiBjcqdDRz5xmhDfhB8ysYk=
Date: Fri, 21 Nov 2008 01:19:41 +0900
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20081121011941.26e05a25.h.mitake@gmail.com>
In-Reply-To: <20081118123215.GB30509@flint.arm.linux.org.uk>
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
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 12:32:15 +0000
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Tue, Nov 18, 2008 at 12:16:20PM +0000, Ralf Baechle wrote:
> > On Sun, Nov 09, 2008 at 11:26:46AM -0800, Andrew Morton wrote:
> > 
> > > Perhaps it would be better to have a CONFIG_ARCH_HAS_READQ and to then
> > > disable these drivers on the architectures which don't provide
> > > readq/writeq support.
> > 
> > And we also need to define the exact semantics.  Questions coming to mind:
> > 
> >   o are implementations performing 2 32-bit accesses acceptable?
> >   o if so, what ordering for the two accesses is acceptable?
> 
> and don't forget to document the semantics.  If we're going to end up
> with CONFIG_ARCH_HAS_READQ which architectures can select, I suggest
> putting it in the help for that symbol.  Why not another random file
> in Documentation/ ?  Because it's a random file in Documentation/
> that'll be overlooked when someone decided to select ARCH_HAS_READQ.
> If it's along side the relevent config option, there is a higher
> chance it will be noticed.
> 

Sorry for my late response...

I knew that implementing architecture-independed readq/writeq is too hard.
To check that implementation is good for every architecture and test that readq/writeq are
difficult works.

So I wrote patch in Andrew's way.
This patch adds ARCH_HAS_READQ to X86_32 and X86_64, adds ARCH_HAS_WRITEQ to X86_64
and adds readq() to X86_32 (writeq is yet).

I want someone to review it. If this patch is good enough, I'll write help document and more patch
adding ARCH_HAS_READQ and ARCH_HAS_WRITEQ to other architectre which has readq/writeq.

description of this patch: Adding config value to x86 architecture to determine existence of readq/writeq


Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
---
 arch/x86/Kconfig          |    3 +++
 arch/x86/include/asm/io.h |    8 ++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

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
index ac2abc8..2a8fc26 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -57,6 +57,14 @@ build_mmio_write(__writeq, "q", unsigned long, "r", )
 /* Let people know we have them */
 #define readq readq
 #define writeq writeq
+
+#else  /* CONFIG_X86_32 */
+
+static inline unsigned long readq(const volatile void __iomem *addr)
+{
+	return readl(addr) | (((u64)readl(addr + 4)) << 32);
+}
+
 #endif
 
 extern int iommu_bio_merge;
-- 
1.5.6.5

