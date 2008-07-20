Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYGTGiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYGTGiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 02:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYGTGiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 02:38:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37456 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYGTGiI (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 02:38:08 -0400
Date: Sun, 20 Jul 2008 08:37:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "V.Radhakrishnan" <rk@atr-labs.com>,
       Linux Kernel Mailing List <Linux-kernel@vger.kernel.org>
Subject: Re: Patch [1/1] minor bugfix in 2.6.26/arch/x86/mm/pat.c - caused
	problems in mmap() of /dev/mem character file
Message-ID: <20080720063711.GA27105@elte.hu>
References: <1216315516.2324.10.camel@atlas> <alpine.LFD.1.10.0807171025110.2959@woody.linux-foundation.org> <20080719154717.41068888@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080719154717.41068888@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> > > The above #ifdef must be actually #ifndef and not #ifdef The bug 
> > > does not allow a valid user (root) from accessing /dev/mem even 
> > > though the CONFIG_PROMISC_DEVMEM is NOT selected.
> > 
> > The real bug is that we shouldn't have "double negatives", and 
> > certainly not negative config options. Making that "promiscuous 
> > /dev/mem" option a negated thing as a config option was bad.
> > 
> > Ingo, over to you..
> 
> patch below clears the double-negative and adds the "PAT also causes 
> this" explenation

applied to tip/x86/urgent - i made this a delta commit (see below) 
because some other patches were picked up into x86/urgent meanwhile. 
Thanks Arjan,

	Ingo

--------------------->
commit d092633bff3b19faffc480fe9810805e7792a029
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jul 18 00:26:59 2008 +0200

    Subject: devmem, x86: fix rename of CONFIG_NONPROMISC_DEVMEM
    From: Arjan van de Ven <arjan@infradead.org>
    Date: Sat, 19 Jul 2008 15:47:17 -0700
    
    CONFIG_NONPROMISC_DEVMEM was a rather confusing name - but renaming it
    to CONFIG_PROMISC_DEVMEM causes problems on architectures that do not
    support this feature; this patch renames it to CONFIG_STRICT_DEVMEM,
    so that architectures can opt-in into it.
    
    ( the polarity of the option is still the same as it was originally; it
      needs to be for now to not break architectures that don't have the
      infastructure yet to support this feature)
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Cc: "V.Radhakrishnan" <rk@atr-labs.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    ---
---
 arch/x86/Kconfig.debug            |    9 +++++----
 arch/x86/configs/i386_defconfig   |    2 +-
 arch/x86/configs/x86_64_defconfig |    2 +-
 arch/x86/mm/pat.c                 |    6 +++---
 drivers/char/mem.c                |    2 +-
 5 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index f0cf5d9..51c8214 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -5,14 +5,15 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
-config PROMISC_DEVMEM
-	bool "Allow unlimited access to /dev/mem"
-	default y
+config STRICT_DEVMEM
+	bool "Filter access to /dev/mem"
 	help
 	  If this option is left on, you allow userspace (root) access to all
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
index c34dc48..6bb597f 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -373,8 +373,8 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 	return vma_prot;
 }
 
-#ifndef CONFIG_PROMISC_DEVMEM
-/* This check is done in drivers/char/mem.c in case of !PROMISC_DEVMEM*/
+#ifdef CONFIG_STRICT_DEVMEM
+/* This check is done in drivers/char/mem.c in case of STRICT_DEVMEM*/
 static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 {
 	return 1;
@@ -398,7 +398,7 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 	}
 	return 1;
 }
-#endif /* CONFIG_PROMISC_DEVMEM */
+#endif /* CONFIG_STRICT_DEVMEM */
 
 int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t *vma_prot)
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index de05775..b6772d6 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -80,7 +80,7 @@ static inline int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
 }
 #endif
 
-#ifndef CONFIG_PROMISC_DEVMEM
+#ifdef CONFIG_STRICT_DEVMEM
 static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 {
 	u64 from = ((u64)pfn) << PAGE_SHIFT;
