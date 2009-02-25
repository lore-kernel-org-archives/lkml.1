Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbZBYPEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbZBYPEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbZBYPEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:04:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60659 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbZBYPEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:04:45 -0500
Subject: Re: WARNING: at kernel/smp.c:332
 smp_call_function_many+0x38/0x1d9()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20090225141607.GA8478@elte.hu>
References: <20090225125946.840677191@chello.nl>
	 <20090225131645.GA30136@elte.hu>  <20090225141607.GA8478@elte.hu>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 16:04:03 +0100
Message-Id: <1235574243.4645.3478.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-25 at 15:16 +0100, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > Hopefully the final version ;-)
> > 
> > Started testing them in tip:core/ipi, thanks Peter!
> 
> -tip testing found a new runtime warning - see it below. Config 
> attached.
> 
> 	Ingo
> 
> 
> [    2.903171] calling  init_kprobes+0x0/0x12f @ 1
> [    2.945871] Kprobe smoke test started
> [    3.018374] ------------[ cut here ]------------
> [    3.021836] WARNING: at kernel/smp.c:332 smp_call_function_many+0x38/0x1d9()

Looking at a fresh -tip tree, that line reads:

/* FIXME: Shim for archs using old arch_send_call_function_ipi API. */

But I figure its the !irqs_disabled(), which is on line 362.

> [    3.021836] Hardware name: HP OmniBook PC         
> [    3.021836] Modules linked in:
> [    3.021836] Pid: 1, comm: swapper Not tainted 2.6.29-rc6-tip-01845-g9f734f8-dirty #273
> [    3.021836] Call Trace:
> [    3.021836]  [<c013abfa>] warn_slowpath+0x79/0x8f
> [    3.021836]  [<c0160145>] smp_call_function_many+0x38/0x1d9
> [    3.021836]  [<c0160307>] smp_call_function+0x21/0x28
> [    3.021836]  [<c013f98e>] on_each_cpu+0x14/0x2d
> [    3.021836]  [<c0126206>] flush_tlb_all+0x19/0x1b
> [    3.021836]  [<c01ab3bf>] flush_tlb_kernel_range+0xd/0xf
> [    3.021836]  [<c01ab401>] vmap_debug_free_range+0x1c/0x20
> [    3.021836]  [<c01abb98>] remove_vm_area+0x28/0x67
> [    3.021836]  [<c01abc7a>] __vunmap+0x30/0xa1
> [    3.021836]  [<c01abd12>] vunmap+0x27/0x29
> [    3.021836]  [<c06a6096>] text_poke+0x12a/0x158
> [    3.021836]  [<c06a6ba1>] arch_disarm_kprobe+0x13/0x15
> [    3.021836]  [<c06a763b>] __unregister_kprobe_top+0x68/0xda
> [    3.021836]  [<c06a7852>] unregister_kretprobes+0x24/0x68
> [    3.021836]  [<c06a78ac>] unregister_kretprobe+0x16/0x18
> [    3.021836]  [<c016a664>] test_kretprobe+0x3d/0x64
> [    3.021836]  [<c016a80e>] init_test_probes+0xbd/0x131
> [    3.021836]  [<c0a68864>] init_kprobes+0x125/0x12f

Looks to be the same one we had the other day, blaming text_poke.

We did send some patches out in that thread to make vmap yell louder
when it was used under irqs_disabled.

Of course, non of that explains any of the above...

---
diff --git a/arch/x86/kernel/alternative.c
b/arch/x86/kernel/alternative.c
index 5b8394a..4c80f15 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -503,12 +503,12 @@ void *text_poke_early(void *addr, const void
*opcode, size_t len)
  */
 void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 {
-	unsigned long flags;
 	char *vaddr;
 	int nr_pages = 2;
 	struct page *pages[2];
 	int i;
 
+	might_sleep();
 	if (!core_kernel_text((unsigned long)addr)) {
 		pages[0] = vmalloc_to_page(addr);
 		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
@@ -522,9 +522,9 @@ void *__kprobes text_poke(void *addr, const void
*opcode, size_t len)
 		nr_pages = 1;
 	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
 	BUG_ON(!vaddr);
-	local_irq_save(flags);
+	local_irq_disable();
 	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
-	local_irq_restore(flags);
+	local_irq_enable();
 	vunmap(vaddr);
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index fb6f599..100d9f0 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1347,6 +1347,7 @@ EXPORT_SYMBOL(vfree);
 void vunmap(const void *addr)
 {
 	BUG_ON(in_interrupt());
+	might_sleep();
 	__vunmap(addr, 0);
 }
 EXPORT_SYMBOL(vunmap);
@@ -1366,6 +1367,8 @@ void *vmap(struct page **pages, unsigned int
count,
 {
 	struct vm_struct *area;
 
+	might_sleep();
+
 	if (count > num_physpages)
 		return NULL;
 


