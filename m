Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbXEaEen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbXEaEen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbXEaEeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:34:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:57608 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbXEaEef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ne05wgQpRw3CzTDmZdPjvRmTT7JsTd4NS0IGvYq+1ZWpYR92I6NE8dedKYRQlvYUgNBNcqCb1AZblWI3QgJ7Iz6A5x9+kM5AhYBP2ahMrC41Nw9jonUR8xcIfhMQMWOplZhsu3dJUDIfZxH5IjSCbuZe153mmUZ/dU8mD86WFaI=
Message-ID: <86802c440705302134l637df0fbm9a3b99eff19201@mail.gmail.com>
Date: Wed, 30 May 2007 21:34:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] serial: convert early_uart to earlycon for 8250
Cc: "Andi Kleen" <ak@suse.de>, "Russell King" <rmk@arm.linux.org.uk>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070530201335.94f73eb9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705291844.00308.yinghai.lu@sun.com>
	 <20070530201335.94f73eb9.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 29 May 2007 18:43:59 -0700 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
>
> > [PATCH 4/5] serial: convert early_uart to earlycon for 8250
>
> drivers/serial/8250_early.c: In function 'parse_options':
> drivers/serial/8250_early.c:143: error: 'FIX_EARLYCON_MEM_BASE' undeclared (first use in this function)
> drivers/serial/8250_early.c:143: error: (Each undeclared identifier is reported only once
>
> That was with http://userweb.kernel.org/~akpm/config-sony.txt, but this is
> going to break a whole pile of architectures (alpha, powerpc, others).

alpha, powerpc, others may need sth like ia64, if they do not support fixmap.

diff --git a/include/asm-ia64/io.h b/include/asm-ia64/io.h
index eb17a86..e29eaf8 100644
--- a/include/asm-ia64/io.h
+++ b/include/asm-ia64/io.h
@@ -423,6 +423,10 @@ extern void __iomem * ioremap(unsigned long
offset, unsigned long size);
 extern void __iomem * ioremap_nocache (unsigned long offset, unsigned
long size);
 extern void iounmap (volatile void __iomem *addr);

+/* for console=uart8250,mmio,0xffe5000,9600n8 */
+#define FIX_EARLYCON_MEM_BASE 1
+#define fix_ioremap(idx, phys) ioremap(phys, 64)
+
 /* Use normal IO mappings for DMI */
 #define dmi_ioremap ioremap
 #define dmi_iounmap(x,l) iounmap(x)


$ find . -name "fixmap.h"
./asm-sh/fixmap.h
./asm-um/fixmap.h
./asm-parisc/fixmap.h
./asm-x86_64/fixmap.h
./asm-sparc/fixmap.h
./asm-i386/fixmap.h
./asm-mips/fixmap.h

they will need
diff --git a/include/asm-x86_64/io.h b/include/asm-x86_64/io.h
index de2cd9a..e2d66de 100644
--- a/include/asm-x86_64/io.h
+++ b/include/asm-x86_64/io.h
@@ -145,6 +145,19 @@ extern void early_iounmap(void *addr, unsigned long size);
 extern void __iomem * ioremap_nocache (unsigned long offset, unsigned
long size);
 extern void iounmap(volatile void __iomem *addr);

+#include <asm/pgtable.h>
+#include <asm/fixmap.h>
+
+static inline void __iomem * fix_ioremap (unsigned idx, unsigned long phys)
+{
+       void __iomem * vaddr;
+       set_fixmap_nocache(idx, phys & PAGE_MASK);
+       vaddr = (void __iomem *)__fix_to_virt(idx);
+       vaddr += phys & ~PAGE_MASK;
+
+       return vaddr;
+}
+
 /*
 * ISA I/O bus memory addresses are 1:1 with the physical address.
 */

YH
