Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbZGTAmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbZGTAmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 20:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbZGTAmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 20:42:23 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:45317 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZGTAmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 20:42:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KXNabopavsIUSZUGxaWMTiJMxnUPoZbAI1EKBbxHnecKQaf29C0f2DAdp2m9XK9zSt
         7hCMrcTiwXPtwsS914EEKQZsLKkpA5EPMUyzggtNs8WT5B+3//C16KXPw0bbX74IHmfx
         bTCcywImUJk/vYIb6H6hgRw1bjiwwB81oEpw4=
MIME-Version: 1.0
Date: Sun, 19 Jul 2009 20:42:21 -0400
Message-ID: <817ecb6f0907191742i13df19afmc4e258a857c3b465@mail.gmail.com>
Subject: [PATCH] x86: Reducing footprint of BIOS32 service mappings
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com, Roland Dreier <rdreier@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to BIOS32 specification
(http://members.datafast.net.au/dft0802/specs/bios32.pdf), at most two
pages per BIOS32 service should be set executable and no pages need to
be writeable. This patch modifies bios32_service() to set proper page
access permissions at time of service discovery, as described in the
specification.
Further, hardcoded protection of memory area between 640k to 1Mb have
been removed from static_protections(), since only pages mentioned
above need to be executable, not whole BIOS region.

The patch have been developed for Linux 2.6.30 x86 by Siarhei Liakh
<sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.

---

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e17efed..9ce45d2 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -254,13 +254,6 @@ static inline pgprot_t
static_protections(pgprot_t prot, unsigned long address,
 	pgprot_t forbidden = __pgprot(0);

 	/*
-	 * The BIOS area between 640k and 1Mb needs to be executable for
-	 * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
-	 */
-	if (within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
-		pgprot_val(forbidden) |= _PAGE_NX;
-
-	/*
 	 * The kernel text needs to be executable for obvious reasons
 	 * Does not cover __inittext since that is gone later on. On
 	 * 64bit we do not enforce !NX on the low mapping
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index 1c975cc..31a2653 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -8,6 +8,7 @@
 #include <linux/uaccess.h>
 #include <asm/pci_x86.h>
 #include <asm/pci-functions.h>
+#include <asm/cacheflush.h>

 /* BIOS32 signature: "_32_" */
 #define BIOS32_SIGNATURE	(('_' << 0) + ('3' << 8) + ('2' << 16) + ('_' << 24))
@@ -69,6 +70,7 @@ static unsigned long bios32_service(unsigned long service)
 	unsigned long length;		/* %ecx */
 	unsigned long entry;		/* %edx */
 	unsigned long flags;
+	unsigned long pg_address;

 	local_irq_save(flags);
 	__asm__("lcall *(%%edi); cld"
@@ -82,15 +84,21 @@ static unsigned long bios32_service(unsigned long service)
 	local_irq_restore(flags);

 	switch (return_code) {
-		case 0:
-			return address + entry;
-		case 0x80:	/* Not present */
-			printk(KERN_WARNING "bios32_service(0x%lx): not present\n", service);
-			return 0;
-		default: /* Shouldn't happen */
-			printk(KERN_WARNING "bios32_service(0x%lx): returned 0x%x -- BIOS bug!\n",
-				service, return_code);
-			return 0;
+	case 0:	/* Service present, set proper page access */
+		address += entry;
+		pg_address = PFN_DOWN(address + PAGE_OFFSET) <<	PAGE_SHIFT;
+		set_memory_ro(pg_address, 2);
+		set_memory_x(pg_address, 2);
+		return address;
+	case 0x80: /* Not present */
+		printk(KERN_WARNING "bios32_service(0x%lx): not present\n",
+			service);
+		return 0;
+	default: /* Shouldn't happen */
+		printk(KERN_WARNING "bios32_service(0x%lx): "
+			"returned 0x%x -- BIOS bug!\n",
+			service, return_code);
+		return 0;
 	}
 }
