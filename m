Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbYGSWrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbYGSWrh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 18:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbYGSWr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 18:47:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:52375 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbYGSWr3 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 18:47:29 -0400
Date: Sat, 19 Jul 2008 15:47:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "V.Radhakrishnan" <rk@atr-labs.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <Linux-kernel@vger.kernel.org>
Subject: Re: Patch [1/1] minor bugfix in 2.6.26/arch/x86/mm/pat.c - caused
 problems in mmap() of /dev/mem character file
Message-ID: <20080719154717.41068888@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0807171025110.2959@woody.linux-foundation.org>
References: <1216315516.2324.10.camel@atlas>
	<alpine.LFD.1.10.0807171025110.2959@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 10:27:03 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 17 Jul 2008, V.Radhakrishnan wrote:
> > 
> > The above #ifdef must be actually #ifndef and not #ifdef
> > The bug does not allow a valid user (root) from accessing /dev/mem
> > even though the CONFIG_PROMISC_DEVMEM is NOT selected.
> 
> The real bug is that we shouldn't have "double negatives", and
> certainly not negative config options. Making that
> "promiscuous /dev/mem" option a negated thing as a config option was
> bad.
> 
> Ingo, over to you..
> 

patch below clears the double-negative and adds the "PAT also causes
this" explenation



From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] x86: rename CONFIG_NONPROMISC_DEVMEM to not be a double negative

CONFIG_NONPROMISC_DEVMEM is a rather confusing name; this patch
renames it to CONFIG_STRICT_DEVMEM.

(the polarity of the option is still the same; it needs to be for now
to not break architectures that don't have the infastructure yet to support
this feature)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/Kconfig.debug            |    6 ++++--
 arch/x86/configs/i386_defconfig   |    2 +-
 arch/x86/configs/x86_64_defconfig |    2 +-
 arch/x86/mm/pat.c                 |    6 +++---
 drivers/char/mem.c                |    2 +-
 5 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index ae36bfa..8d6b649 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -5,13 +5,15 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
-config NONPROMISC_DEVMEM
+config STRICT_DEVMEM
 	bool "Filter access to /dev/mem"
 	help
 	  If this option is left off, you allow userspace access to all
 	  of memory, including kernel and userspace memory. Accidental
 	  access to this is obviously disastrous, but specific access can
-	  be used by people debugging the kernel.
+	  be used by people debugging the kernel. Note that with PAT support
+	  enabled, even in this case there are restrictions on /dev/mem
+	  use due to the cache aliasing requirements.
 
 	  If this option is switched on, the /dev/mem file only allows
 	  userspace access to PCI space and the BIOS code and data regions.
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 9bc34e2..4d73f53 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -2047,7 +2047,7 @@ CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 # CONFIG_SAMPLES is not set
 # CONFIG_KGDB is not set
 CONFIG_HAVE_ARCH_KGDB=y
-# CONFIG_NONPROMISC_DEVMEM is not set
+# CONFIG_STRICT_DEVMEM is not set
 CONFIG_EARLY_PRINTK=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 CONFIG_DEBUG_STACK_USAGE=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index ae5124e..a404524 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -2012,7 +2012,7 @@ CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 # CONFIG_SAMPLES is not set
 # CONFIG_KGDB is not set
 CONFIG_HAVE_ARCH_KGDB=y
-# CONFIG_NONPROMISC_DEVMEM is not set
+# CONFIG_STRICT_DEVMEM is not set
 CONFIG_EARLY_PRINTK=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 CONFIG_DEBUG_STACK_USAGE=y
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index d458507..6bb597f 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -373,8 +373,8 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 	return vma_prot;
 }
 
-#ifdef CONFIG_NONPROMISC_DEVMEM
-/* This check is done in drivers/char/mem.c in case of NONPROMISC_DEVMEM*/
+#ifdef CONFIG_STRICT_DEVMEM
+/* This check is done in drivers/char/mem.c in case of STRICT_DEVMEM*/
 static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 {
 	return 1;
@@ -398,7 +398,7 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 	}
 	return 1;
 }
-#endif /* CONFIG_NONPROMISC_DEVMEM */
+#endif /* CONFIG_STRICT_DEVMEM */
 
 int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t *vma_prot)
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 070e22e..b6772d6 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -80,7 +80,7 @@ static inline int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
 }
 #endif
 
-#ifdef CONFIG_NONPROMISC_DEVMEM
+#ifdef CONFIG_STRICT_DEVMEM
 static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 {
 	u64 from = ((u64)pfn) << PAGE_SHIFT;
-- 
1.5.5.1



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
