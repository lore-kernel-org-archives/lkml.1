Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZFES0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZFES0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZFES0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:26:31 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54968 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbZFES0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:26:30 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: Paul Mackerras <paulus@samba.org>, Greg KH <greg@kroah.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Michael Ellerman <michael@ellerman.id.au>
Date: Fri, 05 Jun 2009 13:26:25 -0500
Message-Id: <20090605182625.24093.7808.sendpatchset@elm3a191.beaverton.ibm.com>
Subject: Re: [BUILD FAILURE 01/04] Next June 04:PPC64 randconfig [drivers/staging/comedi/drivers.o]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Thu, 2009-06-04 at 22:40 +0200, Geert Uytterhoeven wrote:
>On Thu, Jun 4, 2009 at 20:07, Greg KH <greg@kroah.com> wrote:
> > On Thu, Jun 04, 2009 at 07:01:32PM +0530, Subrata Modak wrote:
> >> CC [M]  drivers/staging/comedi/drivers.o
> >> drivers/staging/comedi/drivers.c: In function ‘comedi_buf_alloc’:
> >> drivers/staging/comedi/drivers.c:496: error: ‘PAGE_KERNEL_NOCACHE’ undeclared (first use in this function)
> >> drivers/staging/comedi/drivers.c:496: error: (Each undeclared identifier is reported only once
> >> drivers/staging/comedi/drivers.c:496: error: for each function it appears in.)
> >> make[3]: *** [drivers/staging/comedi/drivers.o] Error 1
> >> make[2]: *** [drivers/staging/comedi] Error 2
> >> make[1]: *** [drivers/staging] Error 2
> >> make: *** [drivers] Error 2
> >>
> >> Is it still normal to expect this failure ?
> >
> > No.
> >
> >> I reported them long back during April:
> >> http://www.gossamer-threads.com/lists/linux/kernel/1065227,
> >
> > Yes, and I took some patches that were supposed to fix this.  I can't
> > duplicate this here, care to send a patch that would fix it?

I tried this. But, with some catch. ‘PAGE_KERNEL_NOCACHE’ seems to be the
choice for majority of architectures like frv, m32r, sh, x86, etc, as Geert
mentions below. However, i believe POWERPC defines it as ‘PAGE_KERNEL_NC‘
found at arch/powerpc/include/asm/pte-common.h.

Paul/Banjamin,
Can you please confirm this ?

The below patch fixes the build error.

Signed-off-by: Subrata Modak <subrata@linux.vnet.ibm.com>
---

--- linux-2.6.30-rc8/drivers/staging/comedi/drivers.c.orig	2009-06-05 12:46:35.000000000 -0500
+++ linux-2.6.30-rc8/drivers/staging/comedi/drivers.c	2009-06-05 13:03:31.000000000 -0500
@@ -43,9 +43,13 @@
 #include <linux/vmalloc.h>
 #include <linux/cdev.h>
 #include <linux/dma-mapping.h>
-
 #include <asm/io.h>
 #include <asm/system.h>
+#ifdef __powerpc64__
+#include <asm/pte-common.h>
+#else
+#include <asm/pgtable.h>
+#endif
 
 static int postconfig(struct comedi_device *dev);
 static int insn_rw_emulate_bits(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -492,8 +496,13 @@ int comedi_buf_alloc(struct comedi_devic
 		}
 		if (i == n_pages) {
 			async->prealloc_buf =
+#ifdef __powerpc64__
+				vmap(pages, n_pages, VM_MAP,
+				PAGE_KERNEL_NC);
+#else
 				vmap(pages, n_pages, VM_MAP,
 				PAGE_KERNEL_NOCACHE);
+#endif
 		}
 		if (pages) {
 			vfree(pages);

---
Regards--
Subrata

> PAGE_KERNEL_NOCACHE is defined on a few architectures only, namely
> frv, m32r, mn10300, sh, and x86[*]. On all others, it will fail.
> 
> [*] Interestingly, sparc refers to it in one of its include files,
> without providing a
>     definition, Probably that code is unused.
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
