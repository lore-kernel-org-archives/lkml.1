Return-Path: <linux-kernel-owner+w=401wt.eu-S1761579AbYDZTH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761579AbYDZTH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759276AbYDZTHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:07:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33326 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759255AbYDZTHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:07:20 -0400
Date: Sat, 26 Apr 2008 21:07:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] x86, PAT: disable /dev/mem mmap RAM with PAT
Message-ID: <20080426190707.GA1300@elte.hu>
References: <20080424225625.GB8717@elte.hu> <alpine.LFD.1.10.0804251351511.2779@woody.linux-foundation.org> <481271F4.7060401@zytor.com> <alpine.LFD.1.10.0804251808590.2813@woody.linux-foundation.org> <20080426085600.GA5891@elte.hu> <924EFEDD5F540B4284297C4DC59F3DEEF313A6@orsmsx423.amr.corp.intel.com> <alpine.LFD.1.10.0804261011030.2813@woody.linux-foundation.org> <20080426183212.GA15007@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426183212.GA15007@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> OK. Below is the quick to disable /dev/mem mmap of RAM with PAT. This 
> should go along with Ingo's patch that removes PAT dependency on 
> NONPROMISC_DEVMEM.  It makes things safer and eliminates aliasing. 
> Still somewhat unclean as the range_is_allowed is duplicated. And 
> also, just compile tested right now.

thanks, i've queued up the patch below. I'll do some testing and then 
send it to Linus.

	Ingo

--------------->
Subject: x86, PAT: disable /dev/mem mmap RAM with PAT
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date: Sat, 26 Apr 2008 11:32:12 -0700

disable /dev/mem mmap of RAM with PAT. It makes things safer and
eliminates aliasing. A future improvement would be to avoid the
range_is_allowed duplication.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pat.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

Index: linux-x86.q/arch/x86/mm/pat.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/pat.c
+++ linux-x86.q/arch/x86/mm/pat.c
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
