Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbXKMB3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbXKMB3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 20:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbXKMB3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 20:29:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36982 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756528AbXKMB3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 20:29:46 -0500
Date: Mon, 12 Nov 2007 17:28:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] arch/x86/kernel/setup_64.c compile error
 (MMOTM-2007-11-10-19-05)
Message-Id: <20071112172841.b4dc21b5.akpm@linux-foundation.org>
In-Reply-To: <200711112234.lABMYo0n004269@agora.fsl.cs.sunysb.edu>
References: <200711112234.lABMYo0n004269@agora.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Nov 2007 17:34:50 -0500 Erez Zadok <ezk@cs.sunysb.edu> wrote:

> I'm using -mm (MMOTM-2007-11-10-19-05) and getting
> 
> $ make
>   CC      arch/x86/kernel/setup_64.o
> arch/x86/kernel/setup_64.c: In function 'setup_arch':
> arch/x86/kernel/setup_64.c:420: error: implicit declaration of function 'early_quirks'
> 
> That's because the externs for early_quirks() aren't on unless CONFIG_ACPI
> is on, but the code in setup_64.c calls early_quirks() if CONFIG_PCI is on
> (and early-quirks.c is compiled only if CONFIG_PCI=y).  I'm not sure if the
> small fix below is correct, hence no signed-off-by.  But it seems to get the
> kernel compiling and linking at least.  Someone should check.
> 
> Cheers,
> Erez.
> 
> 
> diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
> index 5a09161..64644d4 100644
> --- a/arch/x86/kernel/setup_64.c
> +++ b/arch/x86/kernel/setup_64.c
> @@ -416,7 +416,7 @@ void __init setup_arch(char **cmdline_p)
>  	reserve_crashkernel();
>  	paging_init();
>  
> -#ifdef CONFIG_PCI
> +#if defined(CONFIG_PCI) && defined(CONFIG_ACPI)
>  	early_quirks();
>  #endif
>  

hm, that doesn't seem right.  We want to run the early quirks on non-ACPI
kernel too, surely?

If so then the fix would be to move the early_quirks() declaration from
include/asm-x86/acpi_[32|64].h into, say, include/asm-x86/pci.h.  And while
we're there, do the config dependency in the correct way:


From: Andrew Morton <akpm@linux-foundation.org>

With CONFIG_ACPI=n:

arch/x86/kernel/setup_64.c: In function 'setup_arch':
arch/x86/kernel/setup_64.c:420: error: implicit declaration of function 'early_quirks'

because the early_quirks() declaraion is inside an ACPI header file.

Move it out of there and into include/asm-x86/pci.h and clean a few related
things up.

Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/early-quirks.c |    1 +
 arch/x86/kernel/setup_32.c     |    3 +--
 arch/x86/kernel/setup_64.c     |    2 --
 include/asm-x86/acpi_32.h      |    2 --
 include/asm-x86/acpi_64.h      |    2 --
 include/asm-x86/pci.h          |    4 ++++
 6 files changed, 6 insertions(+), 8 deletions(-)

diff -puN include/asm-x86/acpi_32.h~x86-early_quirks-fix-build include/asm-x86/acpi_32.h
--- a/include/asm-x86/acpi_32.h~x86-early_quirks-fix-build
+++ a/include/asm-x86/acpi_32.h
@@ -79,8 +79,6 @@ int __acpi_release_global_lock(unsigned 
         :"=r"(n_hi), "=r"(n_lo)     \
         :"0"(n_hi), "1"(n_lo))
 
-extern void early_quirks(void);
-
 #ifdef CONFIG_ACPI
 extern int acpi_lapic;
 extern int acpi_ioapic;
diff -puN include/asm-x86/acpi_64.h~x86-early_quirks-fix-build include/asm-x86/acpi_64.h
--- a/include/asm-x86/acpi_64.h~x86-early_quirks-fix-build
+++ a/include/asm-x86/acpi_64.h
@@ -78,8 +78,6 @@ int __acpi_release_global_lock(unsigned 
         :"=r"(n_hi), "=r"(n_lo)     \
         :"0"(n_hi), "1"(n_lo))
 
-extern void early_quirks(void);
-
 #ifdef CONFIG_ACPI
 extern int acpi_lapic;
 extern int acpi_ioapic;
diff -puN include/asm-x86/pci.h~x86-early_quirks-fix-build include/asm-x86/pci.h
--- a/include/asm-x86/pci.h~x86-early_quirks-fix-build
+++ a/include/asm-x86/pci.h
@@ -40,8 +40,12 @@ static inline int pci_proc_domain(struct
 
 #ifdef CONFIG_PCI
 extern unsigned int pcibios_assign_all_busses(void);
+extern void early_quirks(void);
 #else
 #define pcibios_assign_all_busses()	0
+static inline void early_quirks(void)
+{
+}
 #endif
 #define pcibios_scan_all_fns(a, b)	0
 
diff -puN arch/x86/kernel/setup_32.c~x86-early_quirks-fix-build arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~x86-early_quirks-fix-build
+++ a/arch/x86/kernel/setup_32.c
@@ -41,6 +41,7 @@
 #include <linux/edd.h>
 #include <linux/nodemask.h>
 #include <linux/kexec.h>
+#include <linux/pci.h>
 #include <linux/crash_dump.h>
 #include <linux/dmi.h>
 #include <linux/pfn.h>
@@ -732,9 +733,7 @@ void __init setup_arch(char **cmdline_p)
 	acpi_boot_table_init();
 #endif
 
-#ifdef CONFIG_PCI
 	early_quirks();
-#endif
 
 #ifdef CONFIG_ACPI
 	acpi_boot_init();
diff -puN arch/x86/kernel/setup_64.c~x86-early_quirks-fix-build arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~x86-early_quirks-fix-build
+++ a/arch/x86/kernel/setup_64.c
@@ -408,9 +408,7 @@ void __init setup_arch(char **cmdline_p)
 	reserve_crashkernel();
 	paging_init();
 
-#ifdef CONFIG_PCI
 	early_quirks();
-#endif
 
 	/*
 	 * set this early, so we dont allocate cpu0
diff -puN arch/x86/kernel/early-quirks.c~x86-early_quirks-fix-build arch/x86/kernel/early-quirks.c
--- a/arch/x86/kernel/early-quirks.c~x86-early_quirks-fix-build
+++ a/arch/x86/kernel/early-quirks.c
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/acpi.h>
 #include <linux/pci_ids.h>
+
 #include <asm/pci-direct.h>
 #include <asm/dma.h>
 #include <asm/io_apic.h>
_

