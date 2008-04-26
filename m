Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbYDZScf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbYDZScf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 14:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760882AbYDZScT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 14:32:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:32096 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760403AbYDZScS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 14:32:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,711,1199692800"; 
   d="scan'208";a="238266078"
Date: Sat, 26 Apr 2008 11:32:12 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] x86 PAT changes
Message-ID: <20080426183212.GA15007@linux-os.sc.intel.com>
References: <20080424225625.GB8717@elte.hu> <alpine.LFD.1.10.0804251351511.2779@woody.linux-foundation.org> <481271F4.7060401@zytor.com> <alpine.LFD.1.10.0804251808590.2813@woody.linux-foundation.org> <20080426085600.GA5891@elte.hu> <924EFEDD5F540B4284297C4DC59F3DEEF313A6@orsmsx423.amr.corp.intel.com> <alpine.LFD.1.10.0804261011030.2813@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804261011030.2813@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 10:15:33AM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 26 Apr 2008, Pallipadi, Venkatesh wrote:
> > 
> > Agreed that NONPROMISC_DEVMEM is not really needed for read/write. But,
> > we will still need it for /dev/mem.
> 
> If so, just disable it unconditionally for mmap.
> 
> As mentioned, that's really just a return to original Linux /dev/mmap 
> semantics: long ago (well, not _that_ long ago) we never used to be able 
> to mmap() normal kernel memory, because the page counts would get screwed 
> up on pages that weren't marked PG_Reserved.
> 
> So the traditional Linux behavior for mmap() on /dev/mem was always to 
> only allow it on memory that either had no "struct page *" backing at all, 
> or that was marked PG_Reserved (ie the ISA hole ay 640k-1M and things like 
> the BIOS tables etc).
> 
> Going back to that doesn't sound horrible.
> 

OK. Below is the quick to disable /dev/mem mmap of RAM with PAT.
This should go along with Ingo's patch that removes PAT dependency on
NONPROMISC_DEVMEM.  It makes things safer and eliminates aliasing.
Still somewhat unclean as the range_is_allowed is duplicated.
And also, just compile tested right now.


Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/mm/pat.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2008-04-26 09:34:31.000000000 -0700
+++ linux-2.6/arch/x86/mm/pat.c	2008-04-26 11:25:57.000000000 -0700
@@ -16,6 +16,7 @@
 #include <asm/msr.h>
 #include <asm/tlbflush.h>
 #include <asm/processor.h>
+#include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/pat.h>
 #include <asm/e820.h>
@@ -477,6 +478,33 @@ pgprot_t phys_mem_access_prot(struct fil
 	return vma_prot;
 }
 
+#ifdef CONFIG_NONPROMISC_DEVMEM
+/* This check is done in drivers/char/mem.c in case of NONPROMISC_DEVMEM*/
+static inline int range_is_allowed(unsigned long pfn, unsigned long size)
+{
+	return 1;
+}
+#else
+static inline int range_is_allowed(unsigned long pfn, unsigned long size)
+{
+	u64 from = ((u64)pfn) << PAGE_SHIFT;
+	u64 to = from + size;
+	u64 cursor = from;
+
+	while (cursor < to) {
+		if (!devmem_is_allowed(pfn)) {
+			printk(KERN_INFO
+		"Program %s tried to access /dev/mem between %Lx->%Lx.\n",
+				current->comm, from, to);
+			return 0;
+		}
+		cursor += PAGE_SIZE;
+		pfn++;
+	}
+	return 1;
+}
+#endif /* CONFIG_NONPROMISC_DEVMEM */
+
 int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t *vma_prot)
 {
@@ -485,6 +513,9 @@ int phys_mem_access_prot_allowed(struct 
 	unsigned long ret_flags;
 	int retval;
 
+	if (!range_is_allowed(pfn, size))
+		return 0;
+
 	if (file->f_flags & O_SYNC) {
 		flags = _PAGE_CACHE_UC;
 	}

