Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbZB0RTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbZB0RTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 12:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbZB0RTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 12:19:31 -0500
Received: from gw.goop.org ([64.81.55.164]:37561 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbZB0RTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 12:19:30 -0500
Message-ID: <49A8209E.7020101@goop.org>
Date: Fri, 27 Feb 2009 09:19:26 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Gerd Hoffmann <kraxel@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] xen: deal with virtually mapped percpu data
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The virtually mapped percpu space causes us two problems:
 - for hypercalls which take an mfn, we need to do a full pagetable
   walk to convert the percpu va into an mfn, and
 - when a hypercall requires a page to be mapped RO via all its aliases,
   we need to make sure its RO in both the percpu mapping and in the
   linear mapping

This primarily affects the gdt and the vcpu info structure.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 4bd990e..1a918dd 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -164,6 +164,7 @@ static inline pte_t __pte_ma(pteval_t x)
 
 
 xmaddr_t arbitrary_virt_to_machine(void *address);
+unsigned long arbitrary_virt_to_mfn(void *vaddr);
 void make_lowmem_page_readonly(void *vaddr);
 void make_lowmem_page_readwrite(void *vaddr);
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 01f5905..70b355d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -103,7 +103,7 @@ static void xen_vcpu_setup(int cpu)
 
 	vcpup = &per_cpu(xen_vcpu_info, cpu);
 
-	info.mfn = virt_to_mfn(vcpup);
+	info.mfn = arbitrary_virt_to_mfn(vcpup);
 	info.offset = offset_in_page(vcpup);
 
 	printk(KERN_DEBUG "trying to map vcpu_info %d at %p, mfn %llx, offset %d\n",
@@ -301,8 +301,10 @@ static void xen_load_gdt(const struct desc_ptr *dtr)
 	frames = mcs.args;
 
 	for (f = 0; va < dtr->address + size; va += PAGE_SIZE, f++) {
-		frames[f] = virt_to_mfn(va);
+		frames[f] = arbitrary_virt_to_mfn((void *)va);
+
 		make_lowmem_page_readonly((void *)va);
+		make_lowmem_page_readonly(mfn_to_virt(frames[f]));
 	}
 
 	MULTI_set_gdt(mcs.mc, frames, size / sizeof(struct desc_struct));
@@ -314,7 +316,7 @@ static void load_TLS_descriptor(struct thread_struct *t,
 				unsigned int cpu, unsigned int i)
 {
 	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
-	xmaddr_t maddr = virt_to_machine(&gdt[GDT_ENTRY_TLS_MIN+i]);
+	xmaddr_t maddr = arbitrary_virt_to_machine(&gdt[GDT_ENTRY_TLS_MIN+i]);
 	struct multicall_space mc = __xen_mc_entry(0);
 
 	MULTI_update_descriptor(mc.mc, maddr.maddr, t->tls_array[i]);
@@ -488,7 +490,7 @@ static void xen_write_gdt_entry(struct desc_struct *dt, int entry,
 		break;
 
 	default: {
-		xmaddr_t maddr = virt_to_machine(&dt[entry]);
+		xmaddr_t maddr = arbitrary_virt_to_machine(&dt[entry]);
 
 		xen_mc_flush();
 		if (HYPERVISOR_update_descriptor(maddr.maddr, *(u64 *)desc))
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b931761..0e57238 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -276,6 +276,13 @@ void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 	p2m_top[topidx][idx] = mfn;
 }
 
+unsigned long arbitrary_virt_to_mfn(void *vaddr)
+{
+	xmaddr_t maddr = arbitrary_virt_to_machine(vaddr);
+
+	return PFN_DOWN(maddr.maddr);
+}
+
 xmaddr_t arbitrary_virt_to_machine(void *vaddr)
 {
 	unsigned long address = (unsigned long)vaddr;
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 035582a..8d47056 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -219,6 +219,7 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 {
 	struct vcpu_guest_context *ctxt;
 	struct desc_struct *gdt;
+	unsigned long gdt_mfn;
 
 	if (cpumask_test_and_set_cpu(cpu, xen_cpu_initialized_map))
 		return 0;
@@ -248,9 +249,12 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	ctxt->ldt_ents = 0;
 
 	BUG_ON((unsigned long)gdt & ~PAGE_MASK);
+
+	gdt_mfn = arbitrary_virt_to_mfn(gdt);
 	make_lowmem_page_readonly(gdt);
+	make_lowmem_page_readonly(mfn_to_virt(gdt_mfn));
 
-	ctxt->gdt_frames[0] = virt_to_mfn(gdt);
+	ctxt->gdt_frames[0] = gdt_mfn;
 	ctxt->gdt_ents      = GDT_ENTRIES;
 
 	ctxt->user_regs.cs = __KERNEL_CS;


