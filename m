Return-Path: <linux-kernel-owner+w=401wt.eu-S936052AbYBCHWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936052AbYBCHWD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 02:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757436AbYBCHVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 02:21:53 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:57785 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757031AbYBCHVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 02:21:52 -0500
Date: Sun, 3 Feb 2008 09:21:49 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH v2] x86: mmiotrace - trace memory mapped IO
Message-ID: <20080203092149.553bb7b5@daedalus.pq.iki.fi>
In-Reply-To: <20080131082906.6a1befba@laptopd505.fenrus.org>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<1201660102.8837.9.camel@brick>
	<1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
	<20080131180253.6c007852@daedalus.pq.iki.fi>
	<20080131181630.10cb1eac@daedalus.pq.iki.fi>
	<20080131082906.6a1befba@laptopd505.fenrus.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 08:29:06 -0800
Arjan van de Ven <arjan@infradead.org> wrote:

> On Thu, 31 Jan 2008 18:16:30 +0200
> Pekka Paalanen <pq@iki.fi> wrote:
> 
> > And here's mmiotrace. This works for me (amd64), but not for a test
> > user who has 32-bit x86. We have not had the chance to debug it yet.
> > The symptom is "everything locked up" after insmodding
> > testmmiotrace.ko, targeting the mid-point of his VRAM. And there's
> > the "undefined symbol init_mm" problem on 32-bit, but we just put the
> > export back in (not included in these patches).

This problem seems to have been due to kgdb being enabled. Quote from
Jaap Stolk, the test user:
"(test)mmiotrace will trigger wait for serial debugger if kgdb and
CONFIG_KGDB_ATTACH_WAIT is enabled."
After disabling it, mmiotrace ran fine.

> > No-one has tried this on SMP. I have a Core 2 Duo laptop where I will
> > test this when I get the chance.

I tested, worked just fine. Well, the test module does not really test
simultaneous iomem access. And I have an issue with following relay
buffers' full/not-full status, I'm looking into that now.

> ok this wants to use some of the page_address() and other helpers from pageattr.c;
> that should be easy to solve during integration
> (I can even see a more generic version of this function moving there)

page_address() seems to be dealing with struct page, someone said we
usually don't have that (ioremap).

Is this what you had in mind? I had to add an export for lookup_address()
to make this work.

 arch/x86/kernel/mmiotrace/kmmio.c    |   46 +++++++++++++++++++++++-----------
 arch/x86/kernel/mmiotrace/mmio-mod.c |   19 +++++++++-----
 arch/x86/mm/pageattr.c               |    1 +
 3 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/mmiotrace/kmmio.c b/arch/x86/kernel/mmiotrace/kmmio.c
index 8ba48f9..28411da 100644
--- a/arch/x86/kernel/mmiotrace/kmmio.c
+++ b/arch/x86/kernel/mmiotrace/kmmio.c
@@ -20,6 +20,7 @@
 #include <asm/cacheflush.h>
 #include <asm/errno.h>
 #include <asm/tlbflush.h>
+#include <asm/pgtable.h>
 
 #include "kmmio.h"
 
@@ -117,40 +118,55 @@ static struct kmmio_fault_page *get_kmmio_fault_page(unsigned long page)
 	return NULL;
 }
 
-static void arm_kmmio_fault_page(unsigned long page, int *large)
+static void arm_kmmio_fault_page(unsigned long page, int *page_level)
 {
 	unsigned long address = page & PAGE_MASK;
-	pgd_t *pgd = pgd_offset_k(address);
-	pud_t *pud = pud_offset(pgd, address);
-	pmd_t *pmd = pmd_offset(pud, address);
-	pte_t *pte = pte_offset_kernel(pmd, address);
+	int level;
+	pte_t *pte = lookup_address(address, &level);
 
-	if (pmd_large(*pmd)) {
+	if (!pte) {
+		printk(KERN_ERR "Error in %s: no pte for page 0x%08lx\n",
+						__FUNCTION__, page);
+		return;
+	}
+
+	if (level == PG_LEVEL_2M) {
+		pmd_t *pmd = (pmd_t *)pte;
 		set_pmd(pmd, __pmd(pmd_val(*pmd) & ~_PAGE_PRESENT));
-		if (large)
-			*large = 1;
 	} else {
+		/* PG_LEVEL_4K */
 		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
 	}
 
+	if (page_level)
+		*page_level = level;
+
 	__flush_tlb_one(page);
 }
 
-static void disarm_kmmio_fault_page(unsigned long page, int *large)
+static void disarm_kmmio_fault_page(unsigned long page, int *page_level)
 {
 	unsigned long address = page & PAGE_MASK;
-	pgd_t *pgd = pgd_offset_k(address);
-	pud_t *pud = pud_offset(pgd, address);
-	pmd_t *pmd = pmd_offset(pud, address);
-	pte_t *pte = pte_offset_kernel(pmd, address);
+	int level;
+	pte_t *pte = lookup_address(address, &level);
 
-	if (large && *large) {
+	if (!pte) {
+		printk(KERN_ERR "Error in %s: no pte for page 0x%08lx\n",
+						__FUNCTION__, page);
+		return;
+	}
+
+	if (level == PG_LEVEL_2M) {
+		pmd_t *pmd = (pmd_t *)pte;
 		set_pmd(pmd, __pmd(pmd_val(*pmd) | _PAGE_PRESENT));
-		*large = 0;
 	} else {
+		/* PG_LEVEL_4K */
 		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
 	}
 
+	if (page_level)
+		*page_level = level;
+
 	__flush_tlb_one(page);
 }
 
diff --git a/arch/x86/kernel/mmiotrace/mmio-mod.c b/arch/x86/kernel/mmiotrace/mmio-mod.c
index 4a8c859..82ae920 100644
--- a/arch/x86/kernel/mmiotrace/mmio-mod.c
+++ b/arch/x86/kernel/mmiotrace/mmio-mod.c
@@ -120,19 +120,24 @@ static int write_marker(struct file *file, const char __user *buffer,
 
 static void print_pte(unsigned long address)
 {
-	pgd_t *pgd = pgd_offset_k(address);
-	pud_t *pud = pud_offset(pgd, address);
-	pmd_t *pmd = pmd_offset(pud, address);
-	if (pmd_large(*pmd)) {
+	int level;
+	pte_t *pte = lookup_address(address, &level);
+
+	if (!pte) {
+		printk(KERN_ERR "Error in %s: no pte for page 0x%08lx\n",
+						__FUNCTION__, address);
+		return;
+	}
+
+	if (level == PG_LEVEL_2M) {
 		printk(KERN_EMERG MODULE_NAME ": 4MB pages are not "
 						"currently supported: %lx\n",
 						address);
 		BUG();
 	}
 	printk(KERN_DEBUG MODULE_NAME ": pte for 0x%lx: 0x%lx 0x%lx\n",
-		address,
-		pte_val(*pte_offset_kernel(pmd, address)),
-		pte_val(*pte_offset_kernel(pmd, address)) & _PAGE_PRESENT);
+					address, pte_val(*pte),
+					pte_val(*pte) & _PAGE_PRESENT);
 }
 
 /*
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index b8a8408..7f0a84e 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -194,6 +194,7 @@ pte_t *lookup_address(unsigned long address, int *level)
 	*level = PG_LEVEL_4K;
 	return pte_offset_kernel(pmd, address);
 }
+EXPORT_SYMBOL(lookup_address);
 
 static void __set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte)
 {


> > +	mmio_fops.read = relay_file_operations.read;
> > +	mmio_fops.open = relay_file_operations.open;
> > +	mmio_fops.poll = relay_file_operations.poll;
> > +	mmio_fops.mmap = relay_file_operations.mmap;
> > +	mmio_fops.release = relay_file_operations.release;
> > +	mmio_fops.splice_read = relay_file_operations.splice_read;
> 
> can't we do this at compile time?

Nope, the compiler says the initializer is not constant.

> > +
> > +void __iomem *ioremap_cache_trace(unsigned long offset, unsigned
> > long size) +{
> > +	void __iomem *p = ioremap_cache(offset, size);
> > +	printk(KERN_DEBUG MODULE_NAME ": ioremap_cache(0x%lx, 0x%lx)
> > = %p\n",
> > +							offset,
> > size, p);
> > +	ioremap_trace_core(offset, size, p);
> > +	return p;
> > +}
> > +EXPORT_SYMBOL(ioremap_cache_trace);
> > +
> > +void __iomem *ioremap_nocache_trace(unsigned long offset, unsigned
> > long size) +{
> > +	void __iomem *p = ioremap_nocache(offset, size);
> > +	printk(KERN_DEBUG MODULE_NAME ": ioremap_nocache(0x%lx,
> > 0x%lx) = %p\n",
> > +							offset,
> > size, p);
> > +	ioremap_trace_core(offset, size, p);
> > +	return p;
> > +}
> > +EXPORT_SYMBOL(ioremap_nocache_trace);
> 
> I would rather keep the split I think and make the trace call explicit

I don't think I understand what you mean. Get rid of
(do_)ioremap_trace_core?

> or.. even nicer, we could go fancy and allow the mmio tracer to "subscribe"
> to, say, a PCI bar, and auto-enable tracing when the bar gets ioremap'd

Might be cool, but not until there's no hope of getting into 2.6.25.

> about the isntruction decoding.. would be nice if we can share that with kvm
> so that we can debug that stuff once ;-)

Uhh yeah, if you mean the stuff in drivers/kvm/x86_emulate.c, it indeed looks
like it's decoding instructions. Other than that, I understood almost nothing
in there. There's one gigantic function that seems to decode and emulate an
instruction. I would have to refactor all that code and I'm not up for it.

> other than that I think the code is quite nice already, seems getting this merge
> ready isn't going to be an enormous deal in terms of complexity

Thank you for your kind and constructive comments.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
