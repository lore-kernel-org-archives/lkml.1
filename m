Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZLBUL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZLBUL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZLBUL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:11:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40359 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbZLBULV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:11:21 -0500
X-Authority-Analysis: v=1.0 c=1 a=MUNJlz75cwwA:10 a=7U3hwN5JcxgA:10 a=meVymXHHAAAA:8 a=mQEMpwvj8npdP0MctR0A:9 a=TdlKM-chMdI3eyQ0yIAA:7 a=0viFnn2Vbj0yZqkCFsqbR5s3hHQA:4 a=jeBq3FmKZ4MA:10 a=DRza-4hlVR8_-GcV:21 a=a4--HRaOZq8zubq5:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][tip/perf/core] tracing: Rename TRACE_EVENT and others to
 something resonable
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, mhiramat@redhat.com,
       linux-tip-commits@vger.kernel.org, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20091202190135.GA23316@Krystal>
References: <tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org>
	 <1259761934.12870.12.camel@gandalf.stny.rr.com>
	 <20091202140128.GA2611@elte.hu>
	 <1259764109.12870.37.camel@gandalf.stny.rr.com>
	 <20091202144334.GA30359@elte.hu>
	 <1259765735.12870.42.camel@gandalf.stny.rr.com>
	 <20091202162715.GB9710@Krystal>
	 <1259773888.12870.61.camel@gandalf.stny.rr.com>
	 <20091202180633.GF9710@Krystal>
	 <1259777987.12870.70.camel@gandalf.stny.rr.com>
	 <20091202190135.GA23316@Krystal>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 02 Dec 2009 15:11:23 -0500
Message-Id: <1259784683.12870.100.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of TRACE_EVENT templates (or classes) the issue of
naming has come up.

Originally, the template was called TRACE_EVENT_TEMPLATE. This was to be
used to consolidate similar TRACE_EVENTs because a single TRACE_EVENT
takes up quite a bit of code. One TRACE_EVENT creates a function to
register and unregister a trace point, a function to record the event in
a buffer, a function to display the binary output to user space, a
function to add counters to record the number of times the event is
reached, and so on.

All these functions creates a lot of bloat, especially since these
functions are almost identical to each other. Unfortunately, these
functions require specific parameters and structure fields, and can't
always be the same. But for those events that share the same structure
and parameters, a class/template allows them to share the same functions
and this cuts down the bloat substantially.

But what to call these macros to satisfy the already confused kernel
developers?

Ideally, DECLARE_EVENT_CLASS to create the class, DEFINE_EVENT to create
an instance of the class, and even DEFINE_EVENT_CLASS to replace the
current TRACE_EVENT that defines a class and creates an event of the
same name as the class. New DEFINE_EVENTs may also reference a class
declared by DEFINE_EVENT_CLASS.

But us kernel developers stay up too late at night, drinking jolt (or
beer if you are in Europe), and our brain cells have fused to only
logical circuitry, thus understanding concepts that are not engraved in
stone becomes a bit too straining for us, and we may finally have to
give up on solving this one last bug to get some rest with our love one
that's been sleeping since 9pm.

This means using DECLARE_* and DEFINE_* will push us over that brink to
normalcy and must be avoided. A new name must be established to clearly
describe the mystical CPP magic that comprises the TRACE_EVENT hackery.
Something that can bring us back to our roots. Something where it all
begins. The stone age.

Thus, this patch renames the MACROS to the most obvious definitions
around. Something we should have thought of at the start.


s/DEFINE_EVENT_CLASS/FRED/g
s/DEFINE_EVENT/WILMA/g
s/TRACE_EVENT/BARNEY/g


Thus with the new naming convention:

FRED(x, ...) -- will declare a class but will not make any events
WILMA(x, y, ...) -- will create an event based off of class made by FRED
BARNEY(x, ...) -- will create both a class and an event

/* Little known secret, WILMA can also fool around with BARNEY and can
create new events with BARNEY as well as with FRED */

  (apologies to Thomas Gleixner and his renaming to "fred")

Signed-off-by: Steven Rostedt <flintstone@goodmis.org>

diff --git a/arch/powerpc/include/asm/trace.h b/arch/powerpc/include/asm/trace.h
index cbe2297..6427fb6 100644
--- a/arch/powerpc/include/asm/trace.h
+++ b/arch/powerpc/include/asm/trace.h
@@ -8,7 +8,7 @@
 
 struct pt_regs;
 
-TRACE_EVENT(irq_entry,
+BARNEY(irq_entry,
 
 	TP_PROTO(struct pt_regs *regs),
 
@@ -25,7 +25,7 @@ TRACE_EVENT(irq_entry,
 	TP_printk("pt_regs=%p", __entry->regs)
 );
 
-TRACE_EVENT(irq_exit,
+BARNEY(irq_exit,
 
 	TP_PROTO(struct pt_regs *regs),
 
@@ -42,7 +42,7 @@ TRACE_EVENT(irq_exit,
 	TP_printk("pt_regs=%p", __entry->regs)
 );
 
-TRACE_EVENT(timer_interrupt_entry,
+BARNEY(timer_interrupt_entry,
 
 	TP_PROTO(struct pt_regs *regs),
 
@@ -59,7 +59,7 @@ TRACE_EVENT(timer_interrupt_entry,
 	TP_printk("pt_regs=%p", __entry->regs)
 );
 
-TRACE_EVENT(timer_interrupt_exit,
+BARNEY(timer_interrupt_exit,
 
 	TP_PROTO(struct pt_regs *regs),
 
@@ -80,7 +80,7 @@ TRACE_EVENT(timer_interrupt_exit,
 extern void hcall_tracepoint_regfunc(void);
 extern void hcall_tracepoint_unregfunc(void);
 
-TRACE_EVENT_FN(hcall_entry,
+BARNEY_FN(hcall_entry,
 
 	TP_PROTO(unsigned long opcode, unsigned long *args),
 
@@ -99,7 +99,7 @@ TRACE_EVENT_FN(hcall_entry,
 	hcall_tracepoint_regfunc, hcall_tracepoint_unregfunc
 );
 
-TRACE_EVENT_FN(hcall_exit,
+BARNEY_FN(hcall_exit,
 
 	TP_PROTO(unsigned long opcode, unsigned long retval,
 		unsigned long *retbuf),
diff --git a/arch/powerpc/kvm/trace.h b/arch/powerpc/kvm/trace.h
index 67f219d..53c838f 100644
--- a/arch/powerpc/kvm/trace.h
+++ b/arch/powerpc/kvm/trace.h
@@ -11,7 +11,7 @@
 /*
  * Tracepoint for guest mode entry.
  */
-TRACE_EVENT(kvm_ppc_instr,
+BARNEY(kvm_ppc_instr,
 	TP_PROTO(unsigned int inst, unsigned long pc, unsigned int emulate),
 	TP_ARGS(inst, pc, emulate),
 
@@ -31,7 +31,7 @@ TRACE_EVENT(kvm_ppc_instr,
 		  __entry->inst, __entry->pc, __entry->emulate)
 );
 
-TRACE_EVENT(kvm_stlb_inval,
+BARNEY(kvm_stlb_inval,
 	TP_PROTO(unsigned int stlb_index),
 	TP_ARGS(stlb_index),
 
@@ -46,7 +46,7 @@ TRACE_EVENT(kvm_stlb_inval,
 	TP_printk("stlb_index %u", __entry->stlb_index)
 );
 
-TRACE_EVENT(kvm_stlb_write,
+BARNEY(kvm_stlb_write,
 	TP_PROTO(unsigned int victim, unsigned int tid, unsigned int word0,
 		 unsigned int word1, unsigned int word2),
 	TP_ARGS(victim, tid, word0, word1, word2),
@@ -72,7 +72,7 @@ TRACE_EVENT(kvm_stlb_write,
 		__entry->word1, __entry->word2)
 );
 
-TRACE_EVENT(kvm_gtlb_write,
+BARNEY(kvm_gtlb_write,
 	TP_PROTO(unsigned int gtlb_index, unsigned int tid, unsigned int word0,
 		 unsigned int word1, unsigned int word2),
 	TP_ARGS(gtlb_index, tid, word0, word1, word2),
diff --git a/arch/powerpc/platforms/cell/spufs/sputrace.h b/arch/powerpc/platforms/cell/spufs/sputrace.h
index db2656a..4ceb1a9 100644
--- a/arch/powerpc/platforms/cell/spufs/sputrace.h
+++ b/arch/powerpc/platforms/cell/spufs/sputrace.h
@@ -6,7 +6,7 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM spufs
 
-TRACE_EVENT(spufs_context,
+BARNEY(spufs_context,
 	TP_PROTO(struct spu_context *ctx, struct spu *spu, const char *name),
 	TP_ARGS(ctx, spu, name),
 
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 3e4a5c6..6a4c1df 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -54,7 +54,7 @@
 /*
  * A pagetable walk has started
  */
-TRACE_EVENT(
+BARNEY(
 	kvm_mmu_pagetable_walk,
 	TP_PROTO(u64 addr, int write_fault, int user_fault, int fetch_fault),
 	TP_ARGS(addr, write_fault, user_fault, fetch_fault),
@@ -76,7 +76,7 @@ TRACE_EVENT(
 
 
 /* We just walked a paging element */
-TRACE_EVENT(
+BARNEY(
 	kvm_mmu_paging_element,
 	TP_PROTO(u64 pte, int level),
 	TP_ARGS(pte, level),
@@ -95,7 +95,7 @@ TRACE_EVENT(
 );
 
 /* We set a pte accessed bit */
-TRACE_EVENT(
+BARNEY(
 	kvm_mmu_set_accessed_bit,
 	TP_PROTO(unsigned long table_gfn, unsigned index, unsigned size),
 	TP_ARGS(table_gfn, index, size),
@@ -113,7 +113,7 @@ TRACE_EVENT(
 );
 
 /* We set a pte dirty bit */
-TRACE_EVENT(
+BARNEY(
 	kvm_mmu_set_dirty_bit,
 	TP_PROTO(unsigned long table_gfn, unsigned index, unsigned size),
 	TP_ARGS(table_gfn, index, size),
@@ -130,7 +130,7 @@ TRACE_EVENT(
 	TP_printk("gpa %llx", __entry->gpa)
 );
 
-TRACE_EVENT(
+BARNEY(
 	kvm_mmu_walker_error,
 	TP_PROTO(u32 pferr),
 	TP_ARGS(pferr),
@@ -147,7 +147,7 @@ TRACE_EVENT(
 		  __print_flags(__entry->pferr, "|", kvm_mmu_trace_pferr_flags))
 );
 
-TRACE_EVENT(
+BARNEY(
 	kvm_mmu_get_page,
 	TP_PROTO(struct kvm_mmu_page *sp, bool created),
 	TP_ARGS(sp, created),
@@ -166,7 +166,7 @@ TRACE_EVENT(
 		  __entry->created ? "new" : "existing")
 );
 
-TRACE_EVENT(
+BARNEY(
 	kvm_mmu_sync_page,
 	TP_PROTO(struct kvm_mmu_page *sp),
 	TP_ARGS(sp),
@@ -182,7 +182,7 @@ TRACE_EVENT(
 	TP_printk("%s", KVM_MMU_PAGE_PRINTK())
 );
 
-TRACE_EVENT(
+BARNEY(
 	kvm_mmu_unsync_page,
 	TP_PROTO(struct kvm_mmu_page *sp),
 	TP_ARGS(sp),
@@ -198,7 +198,7 @@ TRACE_EVENT(
 	TP_printk("%s", KVM_MMU_PAGE_PRINTK())
 );
 
-TRACE_EVENT(
+BARNEY(
 	kvm_mmu_zap_page,
 	TP_PROTO(struct kvm_mmu_page *sp),
 	TP_ARGS(sp),
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 0d480e7..bbe873f 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -11,7 +11,7 @@
 /*
  * Tracepoint for guest mode entry.
  */
-TRACE_EVENT(kvm_entry,
+BARNEY(kvm_entry,
 	TP_PROTO(unsigned int vcpu_id),
 	TP_ARGS(vcpu_id),
 
@@ -29,7 +29,7 @@ TRACE_EVENT(kvm_entry,
 /*
  * Tracepoint for hypercall.
  */
-TRACE_EVENT(kvm_hypercall,
+BARNEY(kvm_hypercall,
 	TP_PROTO(unsigned long nr, unsigned long a0, unsigned long a1,
 		 unsigned long a2, unsigned long a3),
 	TP_ARGS(nr, a0, a1, a2, a3),
@@ -58,7 +58,7 @@ TRACE_EVENT(kvm_hypercall,
 /*
  * Tracepoint for PIO.
  */
-TRACE_EVENT(kvm_pio,
+BARNEY(kvm_pio,
 	TP_PROTO(unsigned int rw, unsigned int port, unsigned int size,
 		 unsigned int count),
 	TP_ARGS(rw, port, size, count),
@@ -85,7 +85,7 @@ TRACE_EVENT(kvm_pio,
 /*
  * Tracepoint for cpuid.
  */
-TRACE_EVENT(kvm_cpuid,
+BARNEY(kvm_cpuid,
 	TP_PROTO(unsigned int function, unsigned long rax, unsigned long rbx,
 		 unsigned long rcx, unsigned long rdx),
 	TP_ARGS(function, rax, rbx, rcx, rdx),
@@ -123,7 +123,7 @@ TRACE_EVENT(kvm_cpuid,
 /*
  * Tracepoint for apic access.
  */
-TRACE_EVENT(kvm_apic,
+BARNEY(kvm_apic,
 	TP_PROTO(unsigned int rw, unsigned int reg, unsigned int val),
 	TP_ARGS(rw, reg, val),
 
@@ -151,7 +151,7 @@ TRACE_EVENT(kvm_apic,
 /*
  * Tracepoint for kvm guest exit:
  */
-TRACE_EVENT(kvm_exit,
+BARNEY(kvm_exit,
 	TP_PROTO(unsigned int exit_reason, unsigned long guest_rip),
 	TP_ARGS(exit_reason, guest_rip),
 
@@ -174,7 +174,7 @@ TRACE_EVENT(kvm_exit,
 /*
  * Tracepoint for kvm interrupt injection:
  */
-TRACE_EVENT(kvm_inj_virq,
+BARNEY(kvm_inj_virq,
 	TP_PROTO(unsigned int irq),
 	TP_ARGS(irq),
 
@@ -192,7 +192,7 @@ TRACE_EVENT(kvm_inj_virq,
 /*
  * Tracepoint for page fault.
  */
-TRACE_EVENT(kvm_page_fault,
+BARNEY(kvm_page_fault,
 	TP_PROTO(unsigned long fault_address, unsigned int error_code),
 	TP_ARGS(fault_address, error_code),
 
@@ -213,7 +213,7 @@ TRACE_EVENT(kvm_page_fault,
 /*
  * Tracepoint for guest MSR access.
  */
-TRACE_EVENT(kvm_msr,
+BARNEY(kvm_msr,
 	TP_PROTO(unsigned int rw, unsigned int ecx, unsigned long data),
 	TP_ARGS(rw, ecx, data),
 
@@ -240,7 +240,7 @@ TRACE_EVENT(kvm_msr,
 /*
  * Tracepoint for guest CR access.
  */
-TRACE_EVENT(kvm_cr,
+BARNEY(kvm_cr,
 	TP_PROTO(unsigned int rw, unsigned int cr, unsigned long val),
 	TP_ARGS(rw, cr, val),
 
@@ -264,7 +264,7 @@ TRACE_EVENT(kvm_cr,
 #define trace_kvm_cr_read(cr, val)		trace_kvm_cr(0, cr, val)
 #define trace_kvm_cr_write(cr, val)		trace_kvm_cr(1, cr, val)
 
-TRACE_EVENT(kvm_pic_set_irq,
+BARNEY(kvm_pic_set_irq,
 	    TP_PROTO(__u8 chip, __u8 pin, __u8 elcr, __u8 imr, bool coalesced),
 	    TP_ARGS(chip, pin, elcr, imr, coalesced),
 
@@ -297,7 +297,7 @@ TRACE_EVENT(kvm_pic_set_irq,
 	{0x2, "all"},			\
 	{0x3, "all-but-self"}
 
-TRACE_EVENT(kvm_apic_ipi,
+BARNEY(kvm_apic_ipi,
 	    TP_PROTO(__u32 icr_low, __u32 dest_id),
 	    TP_ARGS(icr_low, dest_id),
 
@@ -322,7 +322,7 @@ TRACE_EVENT(kvm_apic_ipi,
 				   kvm_apic_dst_shorthand))
 );
 
-TRACE_EVENT(kvm_apic_accept_irq,
+BARNEY(kvm_apic_accept_irq,
 	    TP_PROTO(__u32 apicid, __u16 dm, __u8 tm, __u8 vec, bool coalesced),
 	    TP_ARGS(apicid, dm, tm, vec, coalesced),
 
diff --git a/drivers/gpu/drm/i915/i915_trace.h b/drivers/gpu/drm/i915/i915_trace.h
index 01840d9..72b067c 100644
--- a/drivers/gpu/drm/i915/i915_trace.h
+++ b/drivers/gpu/drm/i915/i915_trace.h
@@ -14,7 +14,7 @@
 
 /* object tracking */
 
-TRACE_EVENT(i915_gem_object_create,
+BARNEY(i915_gem_object_create,
 
 	    TP_PROTO(struct drm_gem_object *obj),
 
@@ -33,7 +33,7 @@ TRACE_EVENT(i915_gem_object_create,
 	    TP_printk("obj=%p, size=%u", __entry->obj, __entry->size)
 );
 
-TRACE_EVENT(i915_gem_object_bind,
+BARNEY(i915_gem_object_bind,
 
 	    TP_PROTO(struct drm_gem_object *obj, u32 gtt_offset),
 
@@ -53,7 +53,7 @@ TRACE_EVENT(i915_gem_object_bind,
 		      __entry->obj, __entry->gtt_offset)
 );
 
-TRACE_EVENT(i915_gem_object_clflush,
+BARNEY(i915_gem_object_clflush,
 
 	    TP_PROTO(struct drm_gem_object *obj),
 
@@ -70,7 +70,7 @@ TRACE_EVENT(i915_gem_object_clflush,
 	    TP_printk("obj=%p", __entry->obj)
 );
 
-TRACE_EVENT(i915_gem_object_change_domain,
+BARNEY(i915_gem_object_change_domain,
 
 	    TP_PROTO(struct drm_gem_object *obj, uint32_t old_read_domains, uint32_t old_write_domain),
 
@@ -93,7 +93,7 @@ TRACE_EVENT(i915_gem_object_change_domain,
 		      __entry->read_domains, __entry->write_domain)
 );
 
-TRACE_EVENT(i915_gem_object_get_fence,
+BARNEY(i915_gem_object_get_fence,
 
 	    TP_PROTO(struct drm_gem_object *obj, int fence, int tiling_mode),
 
@@ -115,7 +115,7 @@ TRACE_EVENT(i915_gem_object_get_fence,
 		      __entry->obj, __entry->fence, __entry->tiling_mode)
 );
 
-TRACE_EVENT(i915_gem_object_unbind,
+BARNEY(i915_gem_object_unbind,
 
 	    TP_PROTO(struct drm_gem_object *obj),
 
@@ -132,7 +132,7 @@ TRACE_EVENT(i915_gem_object_unbind,
 	    TP_printk("obj=%p", __entry->obj)
 );
 
-TRACE_EVENT(i915_gem_object_destroy,
+BARNEY(i915_gem_object_destroy,
 
 	    TP_PROTO(struct drm_gem_object *obj),
 
@@ -151,7 +151,7 @@ TRACE_EVENT(i915_gem_object_destroy,
 
 /* batch tracing */
 
-TRACE_EVENT(i915_gem_request_submit,
+BARNEY(i915_gem_request_submit,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
@@ -171,7 +171,7 @@ TRACE_EVENT(i915_gem_request_submit,
 	    TP_printk("dev=%u, seqno=%u", __entry->dev, __entry->seqno)
 );
 
-TRACE_EVENT(i915_gem_request_flush,
+BARNEY(i915_gem_request_flush,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno,
 		     u32 flush_domains, u32 invalidate_domains),
@@ -198,7 +198,7 @@ TRACE_EVENT(i915_gem_request_flush,
 );
 
 
-TRACE_EVENT(i915_gem_request_complete,
+BARNEY(i915_gem_request_complete,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
@@ -217,7 +217,7 @@ TRACE_EVENT(i915_gem_request_complete,
 	    TP_printk("dev=%u, seqno=%u", __entry->dev, __entry->seqno)
 );
 
-TRACE_EVENT(i915_gem_request_retire,
+BARNEY(i915_gem_request_retire,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
@@ -236,7 +236,7 @@ TRACE_EVENT(i915_gem_request_retire,
 	    TP_printk("dev=%u, seqno=%u", __entry->dev, __entry->seqno)
 );
 
-TRACE_EVENT(i915_gem_request_wait_begin,
+BARNEY(i915_gem_request_wait_begin,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
@@ -255,7 +255,7 @@ TRACE_EVENT(i915_gem_request_wait_begin,
 	    TP_printk("dev=%u, seqno=%u", __entry->dev, __entry->seqno)
 );
 
-TRACE_EVENT(i915_gem_request_wait_end,
+BARNEY(i915_gem_request_wait_end,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
@@ -274,7 +274,7 @@ TRACE_EVENT(i915_gem_request_wait_end,
 	    TP_printk("dev=%u, seqno=%u", __entry->dev, __entry->seqno)
 );
 
-TRACE_EVENT(i915_ring_wait_begin,
+BARNEY(i915_ring_wait_begin,
 
 	    TP_PROTO(struct drm_device *dev),
 
@@ -291,7 +291,7 @@ TRACE_EVENT(i915_ring_wait_begin,
 	    TP_printk("dev=%u", __entry->dev)
 );
 
-TRACE_EVENT(i915_ring_wait_end,
+BARNEY(i915_ring_wait_end,
 
 	    TP_PROTO(struct drm_device *dev),
 
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index 148d55c..fabb5a6 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -68,7 +68,7 @@ static inline u8 glock_trace_state(unsigned int state)
  */
 
 /* General glock state change (DLM lock request completes) */
-TRACE_EVENT(gfs2_glock_state_change,
+BARNEY(gfs2_glock_state_change,
 
 	TP_PROTO(const struct gfs2_glock *gl, unsigned int new_state),
 
@@ -107,7 +107,7 @@ TRACE_EVENT(gfs2_glock_state_change,
 );
 
 /* State change -> unlocked, glock is being deallocated */
-TRACE_EVENT(gfs2_glock_put,
+BARNEY(gfs2_glock_put,
 
 	TP_PROTO(const struct gfs2_glock *gl),
 
@@ -139,7 +139,7 @@ TRACE_EVENT(gfs2_glock_put,
 );
 
 /* Callback (local or remote) requesting lock demotion */
-TRACE_EVENT(gfs2_demote_rq,
+BARNEY(gfs2_demote_rq,
 
 	TP_PROTO(const struct gfs2_glock *gl),
 
@@ -173,7 +173,7 @@ TRACE_EVENT(gfs2_demote_rq,
 );
 
 /* Promotion/grant of a glock */
-TRACE_EVENT(gfs2_promote,
+BARNEY(gfs2_promote,
 
 	TP_PROTO(const struct gfs2_holder *gh, int first),
 
@@ -203,7 +203,7 @@ TRACE_EVENT(gfs2_promote,
 );
 
 /* Queue/dequeue a lock request */
-TRACE_EVENT(gfs2_glock_queue,
+BARNEY(gfs2_glock_queue,
 
 	TP_PROTO(const struct gfs2_holder *gh, int queue),
 
@@ -241,7 +241,7 @@ TRACE_EVENT(gfs2_glock_queue,
  */
 
 /* Pin/unpin a block in the log */
-TRACE_EVENT(gfs2_pin,
+BARNEY(gfs2_pin,
 
 	TP_PROTO(const struct gfs2_bufdata *bd, int pin),
 
@@ -272,7 +272,7 @@ TRACE_EVENT(gfs2_pin,
 );
 
 /* Flushing the log */
-TRACE_EVENT(gfs2_log_flush,
+BARNEY(gfs2_log_flush,
 
 	TP_PROTO(const struct gfs2_sbd *sdp, int start),
 
@@ -297,7 +297,7 @@ TRACE_EVENT(gfs2_log_flush,
 );
 
 /* Reserving/releasing blocks in the log */
-TRACE_EVENT(gfs2_log_blocks,
+BARNEY(gfs2_log_blocks,
 
 	TP_PROTO(const struct gfs2_sbd *sdp, int blocks),
 
@@ -326,7 +326,7 @@ TRACE_EVENT(gfs2_log_blocks,
  */
 
 /* Map an extent of blocks, possibly a new allocation */
-TRACE_EVENT(gfs2_bmap,
+BARNEY(gfs2_bmap,
 
 	TP_PROTO(const struct gfs2_inode *ip, const struct buffer_head *bh,
 		sector_t lblock, int create, int errno),
@@ -366,7 +366,7 @@ TRACE_EVENT(gfs2_bmap,
 );
 
 /* Keep track of blocks as they are allocated/freed */
-TRACE_EVENT(gfs2_block_alloc,
+BARNEY(gfs2_block_alloc,
 
 	TP_PROTO(const struct gfs2_inode *ip, u64 block, unsigned len,
 		u8 block_state),
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b6e818f..a2fcf5f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -113,11 +113,11 @@
 #endif
 
 #ifdef CONFIG_EVENT_TRACING
-#define FTRACE_EVENTS()	VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
+#define FBARNEYS()	VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
 			*(_ftrace_events)				\
 			VMLINUX_SYMBOL(__stop_ftrace_events) = .;
 #else
-#define FTRACE_EVENTS()
+#define FBARNEYS()
 #endif
 
 #ifdef CONFIG_TRACING
@@ -162,7 +162,7 @@
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
 	TRACE_PRINTKS()							\
-	FTRACE_EVENTS()							\
+	FBARNEYS()							\
 	TRACE_SYSCALLS()
 
 /*
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 47bbdf9..764391f 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -1,5 +1,5 @@
-#ifndef _LINUX_FTRACE_EVENT_H
-#define _LINUX_FTRACE_EVENT_H
+#ifndef _LINUX_FBARNEY_H
+#define _LINUX_FBARNEY_H
 
 #include <linux/ring_buffer.h>
 #include <linux/trace_seq.h>
@@ -196,4 +196,4 @@ extern int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 extern void ftrace_profile_free_filter(struct perf_event *event);
 #endif
 
-#endif /* _LINUX_FTRACE_EVENT_H */
+#endif /* _LINUX_FBARNEY_H */
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index f59604e..eac3f68 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -168,27 +168,27 @@ static inline void tracepoint_synchronize_unregister(void)
 #endif /* _LINUX_TRACEPOINT_H */
 
 /*
- * Note: we keep the TRACE_EVENT outside the include file ifdef protection.
+ * Note: we keep the BARNEY outside the include file ifdef protection.
  *  This is due to the way trace events work. If a file includes two
  *  trace event headers under one "CREATE_TRACE_POINTS" the first include
- *  will override the TRACE_EVENT and break the second include.
+ *  will override the BARNEY and break the second include.
  */
 
-#ifndef TRACE_EVENT
+#ifndef BARNEY
 /*
- * For use with the TRACE_EVENT macro:
+ * For use with the BARNEY macro:
  *
  * We define a tracepoint, its arguments, its printk format
  * and its 'fast binay record' layout.
  *
- * Firstly, name your tracepoint via TRACE_EVENT(name : the
+ * Firstly, name your tracepoint via BARNEY(name : the
  * 'subsystem_event' notation is fine.
  *
  * Think about this whole construct as the
  * 'trace_sched_switch() function' from now on.
  *
  *
- *  TRACE_EVENT(sched_switch,
+ *  BARNEY(sched_switch,
  *
  *	*
  *	* A function has a regular function arguments
@@ -277,19 +277,19 @@ static inline void tracepoint_synchronize_unregister(void)
  * /sys/kernel/debug/tracing/events/.
  *
  * A set of (un)registration functions can be passed to the variant
- * TRACE_EVENT_FN to perform any (un)registration work.
+ * BARNEY_FN to perform any (un)registration work.
  */
 
-#define DECLARE_EVENT_CLASS(name, proto, args, tstruct, assign, print)
-#define DEFINE_EVENT(template, name, proto, args)		\
+#define FRED(name, proto, args, tstruct, assign, print)
+#define WILMA(template, name, proto, args)		\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
+#define WILMA_PRINT(template, name, proto, args, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
-#define TRACE_EVENT(name, proto, args, struct, assign, print)	\
+#define BARNEY(name, proto, args, struct, assign, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
-#define TRACE_EVENT_FN(name, proto, args, struct,		\
+#define BARNEY_FN(name, proto, args, struct,		\
 		assign, print, reg, unreg)			\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
-#endif /* ifdef TRACE_EVENT (see note above) */
+#endif /* ifdef BARNEY (see note above) */
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 5acfb1e..a3d4749 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -22,21 +22,21 @@
 
 #include <linux/stringify.h>
 
-#undef TRACE_EVENT
-#define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
+#undef BARNEY
+#define BARNEY(name, proto, args, tstruct, assign, print)	\
 	DEFINE_TRACE(name)
 
-#undef TRACE_EVENT_FN
-#define TRACE_EVENT_FN(name, proto, args, tstruct,		\
+#undef BARNEY_FN
+#define BARNEY_FN(name, proto, args, tstruct,		\
 		assign, print, reg, unreg)			\
 	DEFINE_TRACE_FN(name, reg, unreg)
 
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, name, proto, args) \
+#undef WILMA
+#define WILMA(template, name, proto, args) \
 	DEFINE_TRACE(name)
 
-#undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
+#undef WILMA_PRINT
+#define WILMA_PRINT(template, name, proto, args, print)	\
 	DEFINE_TRACE(name)
 
 #undef DECLARE_TRACE
@@ -69,11 +69,11 @@
 #include <trace/ftrace.h>
 #endif
 
-#undef TRACE_EVENT
-#undef TRACE_EVENT_FN
-#undef DECLARE_EVENT_CLASS
-#undef DEFINE_EVENT
-#undef DEFINE_EVENT_PRINT
+#undef BARNEY
+#undef BARNEY_FN
+#undef FRED
+#undef WILMA
+#undef WILMA_PRINT
 #undef TRACE_HEADER_MULTI_READ
 
 /* Only undef what we defined in this file */
diff --git a/include/trace/events/bkl.h b/include/trace/events/bkl.h
index 1af72dc..03ad013 100644
--- a/include/trace/events/bkl.h
+++ b/include/trace/events/bkl.h
@@ -6,7 +6,7 @@
 
 #include <linux/tracepoint.h>
 
-TRACE_EVENT(lock_kernel,
+BARNEY(lock_kernel,
 
 	TP_PROTO(const char *func, const char *file, int line),
 
@@ -31,7 +31,7 @@ TRACE_EVENT(lock_kernel,
 		  __entry->file, __entry->line, __entry->func)
 );
 
-TRACE_EVENT(unlock_kernel,
+BARNEY(unlock_kernel,
 
 	TP_PROTO(const char *func, const char *file, int line),
 
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 5fb7273..1c33d21 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -8,7 +8,7 @@
 #include <linux/blkdev.h>
 #include <linux/tracepoint.h>
 
-DECLARE_EVENT_CLASS(block_rq_with_error,
+FRED(block_rq_with_error,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
@@ -40,28 +40,28 @@ DECLARE_EVENT_CLASS(block_rq_with_error,
 		  __entry->nr_sector, __entry->errors)
 );
 
-DEFINE_EVENT(block_rq_with_error, block_rq_abort,
+WILMA(block_rq_with_error, block_rq_abort,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
 	TP_ARGS(q, rq)
 );
 
-DEFINE_EVENT(block_rq_with_error, block_rq_requeue,
+WILMA(block_rq_with_error, block_rq_requeue,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
 	TP_ARGS(q, rq)
 );
 
-DEFINE_EVENT(block_rq_with_error, block_rq_complete,
+WILMA(block_rq_with_error, block_rq_complete,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
 	TP_ARGS(q, rq)
 );
 
-DECLARE_EVENT_CLASS(block_rq,
+FRED(block_rq,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
@@ -95,21 +95,21 @@ DECLARE_EVENT_CLASS(block_rq,
 		  __entry->nr_sector, __entry->comm)
 );
 
-DEFINE_EVENT(block_rq, block_rq_insert,
+WILMA(block_rq, block_rq_insert,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
 	TP_ARGS(q, rq)
 );
 
-DEFINE_EVENT(block_rq, block_rq_issue,
+WILMA(block_rq, block_rq_issue,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
 	TP_ARGS(q, rq)
 );
 
-TRACE_EVENT(block_bio_bounce,
+BARNEY(block_bio_bounce,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
 
@@ -138,7 +138,7 @@ TRACE_EVENT(block_bio_bounce,
 		  __entry->nr_sector, __entry->comm)
 );
 
-TRACE_EVENT(block_bio_complete,
+BARNEY(block_bio_complete,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
 
@@ -165,7 +165,7 @@ TRACE_EVENT(block_bio_complete,
 		  __entry->nr_sector, __entry->error)
 );
 
-DECLARE_EVENT_CLASS(block_bio,
+FRED(block_bio,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
 
@@ -193,28 +193,28 @@ DECLARE_EVENT_CLASS(block_bio,
 		  __entry->nr_sector, __entry->comm)
 );
 
-DEFINE_EVENT(block_bio, block_bio_backmerge,
+WILMA(block_bio, block_bio_backmerge,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
 
 	TP_ARGS(q, bio)
 );
 
-DEFINE_EVENT(block_bio, block_bio_frontmerge,
+WILMA(block_bio, block_bio_frontmerge,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
 
 	TP_ARGS(q, bio)
 );
 
-DEFINE_EVENT(block_bio, block_bio_queue,
+WILMA(block_bio, block_bio_queue,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
 
 	TP_ARGS(q, bio)
 );
 
-DECLARE_EVENT_CLASS(block_get_rq,
+FRED(block_get_rq,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
 
@@ -243,21 +243,21 @@ DECLARE_EVENT_CLASS(block_get_rq,
 		  __entry->nr_sector, __entry->comm)
 );
 
-DEFINE_EVENT(block_get_rq, block_getrq,
+WILMA(block_get_rq, block_getrq,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
 
 	TP_ARGS(q, bio, rw)
 );
 
-DEFINE_EVENT(block_get_rq, block_sleeprq,
+WILMA(block_get_rq, block_sleeprq,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
 
 	TP_ARGS(q, bio, rw)
 );
 
-TRACE_EVENT(block_plug,
+BARNEY(block_plug,
 
 	TP_PROTO(struct request_queue *q),
 
@@ -274,7 +274,7 @@ TRACE_EVENT(block_plug,
 	TP_printk("[%s]", __entry->comm)
 );
 
-DECLARE_EVENT_CLASS(block_unplug,
+FRED(block_unplug,
 
 	TP_PROTO(struct request_queue *q),
 
@@ -293,21 +293,21 @@ DECLARE_EVENT_CLASS(block_unplug,
 	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
 );
 
-DEFINE_EVENT(block_unplug, block_unplug_timer,
+WILMA(block_unplug, block_unplug_timer,
 
 	TP_PROTO(struct request_queue *q),
 
 	TP_ARGS(q)
 );
 
-DEFINE_EVENT(block_unplug, block_unplug_io,
+WILMA(block_unplug, block_unplug_io,
 
 	TP_PROTO(struct request_queue *q),
 
 	TP_ARGS(q)
 );
 
-TRACE_EVENT(block_split,
+BARNEY(block_split,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio,
 		 unsigned int new_sector),
@@ -337,7 +337,7 @@ TRACE_EVENT(block_split,
 		  __entry->comm)
 );
 
-TRACE_EVENT(block_remap,
+BARNEY(block_remap,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
 		 sector_t from),
@@ -370,7 +370,7 @@ TRACE_EVENT(block_remap,
 		  (unsigned long long)__entry->old_sector)
 );
 
-TRACE_EVENT(block_rq_remap,
+BARNEY(block_rq_remap,
 
 	TP_PROTO(struct request_queue *q, struct request *rq, dev_t dev,
 		 sector_t from),
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 318f765..13f07ac 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -15,7 +15,7 @@ struct mpage_da_data;
 
 #define EXT4_I(inode) (container_of(inode, struct ext4_inode_info, vfs_inode))
 
-TRACE_EVENT(ext4_free_inode,
+BARNEY(ext4_free_inode,
 	TP_PROTO(struct inode *inode),
 
 	TP_ARGS(inode),
@@ -44,7 +44,7 @@ TRACE_EVENT(ext4_free_inode,
 		  (unsigned long long) __entry->blocks)
 );
 
-TRACE_EVENT(ext4_request_inode,
+BARNEY(ext4_request_inode,
 	TP_PROTO(struct inode *dir, int mode),
 
 	TP_ARGS(dir, mode),
@@ -66,7 +66,7 @@ TRACE_EVENT(ext4_request_inode,
 		  __entry->mode)
 );
 
-TRACE_EVENT(ext4_allocate_inode,
+BARNEY(ext4_allocate_inode,
 	TP_PROTO(struct inode *inode, struct inode *dir, int mode),
 
 	TP_ARGS(inode, dir, mode),
@@ -90,7 +90,7 @@ TRACE_EVENT(ext4_allocate_inode,
 		  (unsigned long) __entry->dir, __entry->mode)
 );
 
-DECLARE_EVENT_CLASS(ext4__write_begin,
+FRED(ext4__write_begin,
 
 	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
 		 unsigned int flags),
@@ -118,7 +118,7 @@ DECLARE_EVENT_CLASS(ext4__write_begin,
 		  __entry->pos, __entry->len, __entry->flags)
 );
 
-DEFINE_EVENT(ext4__write_begin, ext4_write_begin,
+WILMA(ext4__write_begin, ext4_write_begin,
 
 	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
 		 unsigned int flags),
@@ -126,7 +126,7 @@ DEFINE_EVENT(ext4__write_begin, ext4_write_begin,
 	TP_ARGS(inode, pos, len, flags)
 );
 
-DEFINE_EVENT(ext4__write_begin, ext4_da_write_begin,
+WILMA(ext4__write_begin, ext4_da_write_begin,
 
 	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
 		 unsigned int flags),
@@ -134,7 +134,7 @@ DEFINE_EVENT(ext4__write_begin, ext4_da_write_begin,
 	TP_ARGS(inode, pos, len, flags)
 );
 
-DECLARE_EVENT_CLASS(ext4__write_end,
+FRED(ext4__write_end,
 	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
 			unsigned int copied),
 
@@ -161,7 +161,7 @@ DECLARE_EVENT_CLASS(ext4__write_end,
 		  __entry->pos, __entry->len, __entry->copied)
 );
 
-DEFINE_EVENT(ext4__write_end, ext4_ordered_write_end,
+WILMA(ext4__write_end, ext4_ordered_write_end,
 
 	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
 		 unsigned int copied),
@@ -169,7 +169,7 @@ DEFINE_EVENT(ext4__write_end, ext4_ordered_write_end,
 	TP_ARGS(inode, pos, len, copied)
 );
 
-DEFINE_EVENT(ext4__write_end, ext4_writeback_write_end,
+WILMA(ext4__write_end, ext4_writeback_write_end,
 
 	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
 		 unsigned int copied),
@@ -177,7 +177,7 @@ DEFINE_EVENT(ext4__write_end, ext4_writeback_write_end,
 	TP_ARGS(inode, pos, len, copied)
 );
 
-DEFINE_EVENT(ext4__write_end, ext4_journalled_write_end,
+WILMA(ext4__write_end, ext4_journalled_write_end,
 
 	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
 		 unsigned int copied),
@@ -185,7 +185,7 @@ DEFINE_EVENT(ext4__write_end, ext4_journalled_write_end,
 	TP_ARGS(inode, pos, len, copied)
 );
 
-DEFINE_EVENT(ext4__write_end, ext4_da_write_end,
+WILMA(ext4__write_end, ext4_da_write_end,
 
 	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
 		 unsigned int copied),
@@ -193,7 +193,7 @@ DEFINE_EVENT(ext4__write_end, ext4_da_write_end,
 	TP_ARGS(inode, pos, len, copied)
 );
 
-TRACE_EVENT(ext4_writepage,
+BARNEY(ext4_writepage,
 	TP_PROTO(struct inode *inode, struct page *page),
 
 	TP_ARGS(inode, page),
@@ -216,7 +216,7 @@ TRACE_EVENT(ext4_writepage,
 		  __entry->index)
 );
 
-TRACE_EVENT(ext4_da_writepages,
+BARNEY(ext4_da_writepages,
 	TP_PROTO(struct inode *inode, struct writeback_control *wbc),
 
 	TP_ARGS(inode, wbc),
@@ -259,7 +259,7 @@ TRACE_EVENT(ext4_da_writepages,
 		  (unsigned long) __entry->writeback_index)
 );
 
-TRACE_EVENT(ext4_da_write_pages,
+BARNEY(ext4_da_write_pages,
 	TP_PROTO(struct inode *inode, struct mpage_da_data *mpd),
 
 	TP_ARGS(inode, mpd),
@@ -293,7 +293,7 @@ TRACE_EVENT(ext4_da_write_pages,
 		  __entry->io_done, __entry->pages_written)
 );
 
-TRACE_EVENT(ext4_da_writepages_result,
+BARNEY(ext4_da_writepages_result,
 	TP_PROTO(struct inode *inode, struct writeback_control *wbc,
 			int ret, int pages_written),
 
@@ -332,7 +332,7 @@ TRACE_EVENT(ext4_da_writepages_result,
 		  (unsigned long) __entry->writeback_index)
 );
 
-TRACE_EVENT(ext4_discard_blocks,
+BARNEY(ext4_discard_blocks,
 	TP_PROTO(struct super_block *sb, unsigned long long blk,
 			unsigned long long count),
 
@@ -355,7 +355,7 @@ TRACE_EVENT(ext4_discard_blocks,
 		  jbd2_dev_to_name(__entry->dev), __entry->blk, __entry->count)
 );
 
-TRACE_EVENT(ext4_mb_new_inode_pa,
+BARNEY(ext4_mb_new_inode_pa,
 	TP_PROTO(struct ext4_allocation_context *ac,
 		 struct ext4_prealloc_space *pa),
 
@@ -383,7 +383,7 @@ TRACE_EVENT(ext4_mb_new_inode_pa,
 		  __entry->pa_pstart, __entry->pa_len, __entry->pa_lstart)
 );
 
-TRACE_EVENT(ext4_mb_new_group_pa,
+BARNEY(ext4_mb_new_group_pa,
 	TP_PROTO(struct ext4_allocation_context *ac,
 		 struct ext4_prealloc_space *pa),
 
@@ -411,7 +411,7 @@ TRACE_EVENT(ext4_mb_new_group_pa,
 		  __entry->pa_pstart, __entry->pa_len, __entry->pa_lstart)
 );
 
-TRACE_EVENT(ext4_mb_release_inode_pa,
+BARNEY(ext4_mb_release_inode_pa,
 	TP_PROTO(struct ext4_allocation_context *ac,
 		 struct ext4_prealloc_space *pa,
 		 unsigned long long block, unsigned int count),
@@ -438,7 +438,7 @@ TRACE_EVENT(ext4_mb_release_inode_pa,
 		  __entry->block, __entry->count)
 );
 
-TRACE_EVENT(ext4_mb_release_group_pa,
+BARNEY(ext4_mb_release_group_pa,
 	TP_PROTO(struct ext4_allocation_context *ac,
 		 struct ext4_prealloc_space *pa),
 
@@ -463,7 +463,7 @@ TRACE_EVENT(ext4_mb_release_group_pa,
 		  jbd2_dev_to_name(__entry->dev), __entry->pa_pstart, __entry->pa_len)
 );
 
-TRACE_EVENT(ext4_discard_preallocations,
+BARNEY(ext4_discard_preallocations,
 	TP_PROTO(struct inode *inode),
 
 	TP_ARGS(inode),
@@ -483,7 +483,7 @@ TRACE_EVENT(ext4_discard_preallocations,
 		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino)
 );
 
-TRACE_EVENT(ext4_mb_discard_preallocations,
+BARNEY(ext4_mb_discard_preallocations,
 	TP_PROTO(struct super_block *sb, int needed),
 
 	TP_ARGS(sb, needed),
@@ -503,7 +503,7 @@ TRACE_EVENT(ext4_mb_discard_preallocations,
 		  jbd2_dev_to_name(__entry->dev), __entry->needed)
 );
 
-TRACE_EVENT(ext4_request_blocks,
+BARNEY(ext4_request_blocks,
 	TP_PROTO(struct ext4_allocation_request *ar),
 
 	TP_ARGS(ar),
@@ -545,7 +545,7 @@ TRACE_EVENT(ext4_request_blocks,
 		  (unsigned long long) __entry->pright)
 );
 
-TRACE_EVENT(ext4_allocate_blocks,
+BARNEY(ext4_allocate_blocks,
 	TP_PROTO(struct ext4_allocation_request *ar, unsigned long long block),
 
 	TP_ARGS(ar, block),
@@ -589,7 +589,7 @@ TRACE_EVENT(ext4_allocate_blocks,
 		  (unsigned long long) __entry->pright)
 );
 
-TRACE_EVENT(ext4_free_blocks,
+BARNEY(ext4_free_blocks,
 	TP_PROTO(struct inode *inode, __u64 block, unsigned long count,
 			int metadata),
 
@@ -617,7 +617,7 @@ TRACE_EVENT(ext4_free_blocks,
 		  __entry->block, __entry->count, __entry->metadata)
 );
 
-TRACE_EVENT(ext4_sync_file,
+BARNEY(ext4_sync_file,
 	TP_PROTO(struct file *file, struct dentry *dentry, int datasync),
 
 	TP_ARGS(file, dentry, datasync),
@@ -641,7 +641,7 @@ TRACE_EVENT(ext4_sync_file,
 		  (unsigned long) __entry->parent, __entry->datasync)
 );
 
-TRACE_EVENT(ext4_sync_fs,
+BARNEY(ext4_sync_fs,
 	TP_PROTO(struct super_block *sb, int wait),
 
 	TP_ARGS(sb, wait),
@@ -661,7 +661,7 @@ TRACE_EVENT(ext4_sync_fs,
 		  __entry->wait)
 );
 
-TRACE_EVENT(ext4_alloc_da_blocks,
+BARNEY(ext4_alloc_da_blocks,
 	TP_PROTO(struct inode *inode),
 
 	TP_ARGS(inode),
@@ -685,7 +685,7 @@ TRACE_EVENT(ext4_alloc_da_blocks,
 		  __entry->data_blocks, __entry->meta_blocks)
 );
 
-TRACE_EVENT(ext4_mballoc_alloc,
+BARNEY(ext4_mballoc_alloc,
 	TP_PROTO(struct ext4_allocation_context *ac),
 
 	TP_ARGS(ac),
@@ -751,7 +751,7 @@ TRACE_EVENT(ext4_mballoc_alloc,
 		  __entry->buddy ? 1 << __entry->buddy : 0)
 );
 
-TRACE_EVENT(ext4_mballoc_prealloc,
+BARNEY(ext4_mballoc_prealloc,
 	TP_PROTO(struct ext4_allocation_context *ac),
 
 	TP_ARGS(ac),
@@ -790,7 +790,7 @@ TRACE_EVENT(ext4_mballoc_prealloc,
 		  __entry->result_len, __entry->result_logical)
 );
 
-TRACE_EVENT(ext4_mballoc_discard,
+BARNEY(ext4_mballoc_discard,
 	TP_PROTO(struct ext4_allocation_context *ac),
 
 	TP_ARGS(ac),
@@ -819,7 +819,7 @@ TRACE_EVENT(ext4_mballoc_discard,
 		  __entry->result_len, __entry->result_logical)
 );
 
-TRACE_EVENT(ext4_mballoc_free,
+BARNEY(ext4_mballoc_free,
 	TP_PROTO(struct ext4_allocation_context *ac),
 
 	TP_ARGS(ac),
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 0e4cfb6..077be6d 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -32,7 +32,7 @@
  * conjunction with the irq_handler_exit tracepoint, we can figure
  * out irq handler latencies.
  */
-TRACE_EVENT(irq_handler_entry,
+BARNEY(irq_handler_entry,
 
 	TP_PROTO(int irq, struct irqaction *action),
 
@@ -62,7 +62,7 @@ TRACE_EVENT(irq_handler_entry,
  * a shared irq line, or the irq was not handled successfully. Can be used in
  * conjunction with the irq_handler_entry to understand irq handler latencies.
  */
-TRACE_EVENT(irq_handler_exit,
+BARNEY(irq_handler_exit,
 
 	TP_PROTO(int irq, struct irqaction *action, int ret),
 
@@ -82,7 +82,7 @@ TRACE_EVENT(irq_handler_exit,
 		  __entry->irq, __entry->ret ? "handled" : "unhandled")
 );
 
-DECLARE_EVENT_CLASS(softirq,
+FRED(softirq,
 
 	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
 
@@ -111,7 +111,7 @@ DECLARE_EVENT_CLASS(softirq,
  * number. Also, when used in combination with the softirq_exit tracepoint
  * we can determine the softirq latency.
  */
-DEFINE_EVENT(softirq, softirq_entry,
+WILMA(softirq, softirq_entry,
 
 	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
 
@@ -129,7 +129,7 @@ DEFINE_EVENT(softirq, softirq_entry,
  * combination with the softirq_entry tracepoint we can determine the softirq
  * latency.
  */
-DEFINE_EVENT(softirq, softirq_exit,
+WILMA(softirq, softirq_exit,
 
 	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
 
diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
index 96b370a..a0a6a0e 100644
--- a/include/trace/events/jbd2.h
+++ b/include/trace/events/jbd2.h
@@ -10,7 +10,7 @@
 struct transaction_chp_stats_s;
 struct transaction_run_stats_s;
 
-TRACE_EVENT(jbd2_checkpoint,
+BARNEY(jbd2_checkpoint,
 
 	TP_PROTO(journal_t *journal, int result),
 
@@ -30,7 +30,7 @@ TRACE_EVENT(jbd2_checkpoint,
 		  jbd2_dev_to_name(__entry->dev), __entry->result)
 );
 
-DECLARE_EVENT_CLASS(jbd2_commit,
+FRED(jbd2_commit,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
@@ -53,35 +53,35 @@ DECLARE_EVENT_CLASS(jbd2_commit,
 		  __entry->sync_commit)
 );
 
-DEFINE_EVENT(jbd2_commit, jbd2_start_commit,
+WILMA(jbd2_commit, jbd2_start_commit,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
 	TP_ARGS(journal, commit_transaction)
 );
 
-DEFINE_EVENT(jbd2_commit, jbd2_commit_locking,
+WILMA(jbd2_commit, jbd2_commit_locking,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
 	TP_ARGS(journal, commit_transaction)
 );
 
-DEFINE_EVENT(jbd2_commit, jbd2_commit_flushing,
+WILMA(jbd2_commit, jbd2_commit_flushing,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
 	TP_ARGS(journal, commit_transaction)
 );
 
-DEFINE_EVENT(jbd2_commit, jbd2_commit_logging,
+WILMA(jbd2_commit, jbd2_commit_logging,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
 	TP_ARGS(journal, commit_transaction)
 );
 
-TRACE_EVENT(jbd2_end_commit,
+BARNEY(jbd2_end_commit,
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
 	TP_ARGS(journal, commit_transaction),
@@ -105,7 +105,7 @@ TRACE_EVENT(jbd2_end_commit,
 		  __entry->sync_commit, __entry->head)
 );
 
-TRACE_EVENT(jbd2_submit_inode_data,
+BARNEY(jbd2_submit_inode_data,
 	TP_PROTO(struct inode *inode),
 
 	TP_ARGS(inode),
@@ -124,7 +124,7 @@ TRACE_EVENT(jbd2_submit_inode_data,
 		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino)
 );
 
-TRACE_EVENT(jbd2_run_stats,
+BARNEY(jbd2_run_stats,
 	TP_PROTO(dev_t dev, unsigned long tid,
 		 struct transaction_run_stats_s *stats),
 
@@ -168,7 +168,7 @@ TRACE_EVENT(jbd2_run_stats,
 		  __entry->blocks_logged)
 );
 
-TRACE_EVENT(jbd2_checkpoint_stats,
+BARNEY(jbd2_checkpoint_stats,
 	TP_PROTO(dev_t dev, unsigned long tid,
 		 struct transaction_chp_stats_s *stats),
 
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 3adca0c..ae51357 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -44,7 +44,7 @@
 	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"}		\
 	) : "GFP_NOWAIT"
 
-DECLARE_EVENT_CLASS(kmem_alloc,
+FRED(kmem_alloc,
 
 	TP_PROTO(unsigned long call_site,
 		 const void *ptr,
@@ -78,7 +78,7 @@ DECLARE_EVENT_CLASS(kmem_alloc,
 		show_gfp_flags(__entry->gfp_flags))
 );
 
-DEFINE_EVENT(kmem_alloc, kmalloc,
+WILMA(kmem_alloc, kmalloc,
 
 	TP_PROTO(unsigned long call_site, const void *ptr,
 		 size_t bytes_req, size_t bytes_alloc, gfp_t gfp_flags),
@@ -86,7 +86,7 @@ DEFINE_EVENT(kmem_alloc, kmalloc,
 	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags)
 );
 
-DEFINE_EVENT(kmem_alloc, kmem_cache_alloc,
+WILMA(kmem_alloc, kmem_cache_alloc,
 
 	TP_PROTO(unsigned long call_site, const void *ptr,
 		 size_t bytes_req, size_t bytes_alloc, gfp_t gfp_flags),
@@ -94,7 +94,7 @@ DEFINE_EVENT(kmem_alloc, kmem_cache_alloc,
 	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags)
 );
 
-DECLARE_EVENT_CLASS(kmem_alloc_node,
+FRED(kmem_alloc_node,
 
 	TP_PROTO(unsigned long call_site,
 		 const void *ptr,
@@ -132,7 +132,7 @@ DECLARE_EVENT_CLASS(kmem_alloc_node,
 		__entry->node)
 );
 
-DEFINE_EVENT(kmem_alloc_node, kmalloc_node,
+WILMA(kmem_alloc_node, kmalloc_node,
 
 	TP_PROTO(unsigned long call_site, const void *ptr,
 		 size_t bytes_req, size_t bytes_alloc,
@@ -141,7 +141,7 @@ DEFINE_EVENT(kmem_alloc_node, kmalloc_node,
 	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node)
 );
 
-DEFINE_EVENT(kmem_alloc_node, kmem_cache_alloc_node,
+WILMA(kmem_alloc_node, kmem_cache_alloc_node,
 
 	TP_PROTO(unsigned long call_site, const void *ptr,
 		 size_t bytes_req, size_t bytes_alloc,
@@ -150,7 +150,7 @@ DEFINE_EVENT(kmem_alloc_node, kmem_cache_alloc_node,
 	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node)
 );
 
-DECLARE_EVENT_CLASS(kmem_free,
+FRED(kmem_free,
 
 	TP_PROTO(unsigned long call_site, const void *ptr),
 
@@ -169,21 +169,21 @@ DECLARE_EVENT_CLASS(kmem_free,
 	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
 );
 
-DEFINE_EVENT(kmem_free, kfree,
+WILMA(kmem_free, kfree,
 
 	TP_PROTO(unsigned long call_site, const void *ptr),
 
 	TP_ARGS(call_site, ptr)
 );
 
-DEFINE_EVENT(kmem_free, kmem_cache_free,
+WILMA(kmem_free, kmem_cache_free,
 
 	TP_PROTO(unsigned long call_site, const void *ptr),
 
 	TP_ARGS(call_site, ptr)
 );
 
-TRACE_EVENT(mm_page_free_direct,
+BARNEY(mm_page_free_direct,
 
 	TP_PROTO(struct page *page, unsigned int order),
 
@@ -205,7 +205,7 @@ TRACE_EVENT(mm_page_free_direct,
 			__entry->order)
 );
 
-TRACE_EVENT(mm_pagevec_free,
+BARNEY(mm_pagevec_free,
 
 	TP_PROTO(struct page *page, int cold),
 
@@ -227,7 +227,7 @@ TRACE_EVENT(mm_pagevec_free,
 			__entry->cold)
 );
 
-TRACE_EVENT(mm_page_alloc,
+BARNEY(mm_page_alloc,
 
 	TP_PROTO(struct page *page, unsigned int order,
 			gfp_t gfp_flags, int migratetype),
@@ -256,7 +256,7 @@ TRACE_EVENT(mm_page_alloc,
 		show_gfp_flags(__entry->gfp_flags))
 );
 
-DECLARE_EVENT_CLASS(mm_page,
+FRED(mm_page,
 
 	TP_PROTO(struct page *page, unsigned int order, int migratetype),
 
@@ -282,14 +282,14 @@ DECLARE_EVENT_CLASS(mm_page,
 		__entry->order == 0)
 );
 
-DEFINE_EVENT(mm_page, mm_page_alloc_zone_locked,
+WILMA(mm_page, mm_page_alloc_zone_locked,
 
 	TP_PROTO(struct page *page, unsigned int order, int migratetype),
 
 	TP_ARGS(page, order, migratetype)
 );
 
-DEFINE_EVENT_PRINT(mm_page, mm_page_pcpu_drain,
+WILMA_PRINT(mm_page, mm_page_pcpu_drain,
 
 	TP_PROTO(struct page *page, unsigned int order, int migratetype),
 
@@ -300,7 +300,7 @@ DEFINE_EVENT_PRINT(mm_page, mm_page_pcpu_drain,
 		__entry->order, __entry->migratetype)
 );
 
-TRACE_EVENT(mm_page_alloc_extfrag,
+BARNEY(mm_page_alloc_extfrag,
 
 	TP_PROTO(struct page *page,
 			int alloc_order, int fallback_order,
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index dbe1084..1a2a4eb 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -8,7 +8,7 @@
 #define TRACE_INCLUDE_FILE kvm
 
 #if defined(__KVM_HAVE_IOAPIC)
-TRACE_EVENT(kvm_set_irq,
+BARNEY(kvm_set_irq,
 	TP_PROTO(unsigned int gsi, int level, int irq_source_id),
 	TP_ARGS(gsi, level, irq_source_id),
 
@@ -38,7 +38,7 @@ TRACE_EVENT(kvm_set_irq,
 	{0x6, "SIPI"},			\
 	{0x7, "ExtINT"}
 
-TRACE_EVENT(kvm_ioapic_set_irq,
+BARNEY(kvm_ioapic_set_irq,
 	    TP_PROTO(__u64 e, int pin, bool coalesced),
 	    TP_ARGS(e, pin, coalesced),
 
@@ -63,7 +63,7 @@ TRACE_EVENT(kvm_ioapic_set_irq,
 		  __entry->coalesced ? " (coalesced)" : "")
 );
 
-TRACE_EVENT(kvm_msi_set_irq,
+BARNEY(kvm_msi_set_irq,
 	    TP_PROTO(__u64 address, __u64 data),
 	    TP_ARGS(address, data),
 
@@ -90,7 +90,7 @@ TRACE_EVENT(kvm_msi_set_irq,
 	{KVM_IRQCHIP_PIC_SLAVE,		"PIC slave"},		\
 	{KVM_IRQCHIP_IOAPIC,		"IOAPIC"}
 
-TRACE_EVENT(kvm_ack_irq,
+BARNEY(kvm_ack_irq,
 	TP_PROTO(unsigned int irqchip, unsigned int pin),
 	TP_ARGS(irqchip, pin),
 
@@ -122,7 +122,7 @@ TRACE_EVENT(kvm_ack_irq,
 	{ KVM_TRACE_MMIO_READ, "read" }, \
 	{ KVM_TRACE_MMIO_WRITE, "write" }
 
-TRACE_EVENT(kvm_mmio,
+BARNEY(kvm_mmio,
 	TP_PROTO(int type, int len, u64 gpa, u64 val),
 	TP_ARGS(type, len, gpa, val),
 
diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index a870ba1..641773f 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -9,7 +9,7 @@
 
 #ifdef CONFIG_LOCKDEP
 
-TRACE_EVENT(lock_acquire,
+BARNEY(lock_acquire,
 
 	TP_PROTO(struct lockdep_map *lock, unsigned int subclass,
 		int trylock, int read, int check,
@@ -32,7 +32,7 @@ TRACE_EVENT(lock_acquire,
 		  __get_str(name))
 );
 
-TRACE_EVENT(lock_release,
+BARNEY(lock_release,
 
 	TP_PROTO(struct lockdep_map *lock, int nested, unsigned long ip),
 
@@ -51,7 +51,7 @@ TRACE_EVENT(lock_release,
 
 #ifdef CONFIG_LOCK_STAT
 
-TRACE_EVENT(lock_contended,
+BARNEY(lock_contended,
 
 	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
 
@@ -68,7 +68,7 @@ TRACE_EVENT(lock_contended,
 	TP_printk("%s", __get_str(name))
 );
 
-TRACE_EVENT(lock_acquired,
+BARNEY(lock_acquired,
 	TP_PROTO(struct lockdep_map *lock, unsigned long ip, s64 waittime),
 
 	TP_ARGS(lock, ip, waittime),
diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 4b0f48b..e441922 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -15,7 +15,7 @@ struct module;
 	{ (1UL << TAINT_FORCED_MODULE),		"F" },		\
 	{ (1UL << TAINT_CRAP),			"C" })
 
-TRACE_EVENT(module_load,
+BARNEY(module_load,
 
 	TP_PROTO(struct module *mod),
 
@@ -34,7 +34,7 @@ TRACE_EVENT(module_load,
 	TP_printk("%s %s", __get_str(name), show_module_flags(__entry->taints))
 );
 
-TRACE_EVENT(module_free,
+BARNEY(module_free,
 
 	TP_PROTO(struct module *mod),
 
@@ -51,7 +51,7 @@ TRACE_EVENT(module_free,
 	TP_printk("%s", __get_str(name))
 );
 
-DECLARE_EVENT_CLASS(module_refcnt,
+FRED(module_refcnt,
 
 	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
 
@@ -73,21 +73,21 @@ DECLARE_EVENT_CLASS(module_refcnt,
 		  __get_str(name), (void *)__entry->ip, __entry->refcnt)
 );
 
-DEFINE_EVENT(module_refcnt, module_get,
+WILMA(module_refcnt, module_get,
 
 	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
 
 	TP_ARGS(mod, ip, refcnt)
 );
 
-DEFINE_EVENT(module_refcnt, module_put,
+WILMA(module_refcnt, module_put,
 
 	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
 
 	TP_ARGS(mod, ip, refcnt)
 );
 
-TRACE_EVENT(module_request,
+BARNEY(module_request,
 
 	TP_PROTO(char *name, bool wait, unsigned long ip),
 
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index c4efe9b..e004e74 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -16,7 +16,7 @@ enum {
 };
 #endif
 
-DECLARE_EVENT_CLASS(power,
+FRED(power,
 
 	TP_PROTO(unsigned int type, unsigned int state),
 
@@ -35,21 +35,21 @@ DECLARE_EVENT_CLASS(power,
 	TP_printk("type=%lu state=%lu", (unsigned long)__entry->type, (unsigned long)__entry->state)
 );
 
-DEFINE_EVENT(power, power_start,
+WILMA(power, power_start,
 
 	TP_PROTO(unsigned int type, unsigned int state),
 
 	TP_ARGS(type, state)
 );
 
-DEFINE_EVENT(power, power_frequency,
+WILMA(power, power_frequency,
 
 	TP_PROTO(unsigned int type, unsigned int state),
 
 	TP_ARGS(type, state)
 );
 
-TRACE_EVENT(power_end,
+BARNEY(power_end,
 
 	TP_PROTO(int dummy),
 
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index cfceb0b..5a15cde 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -10,7 +10,7 @@
 /*
  * Tracepoint for calling kthread_stop, performed to end a kthread:
  */
-TRACE_EVENT(sched_kthread_stop,
+BARNEY(sched_kthread_stop,
 
 	TP_PROTO(struct task_struct *t),
 
@@ -32,7 +32,7 @@ TRACE_EVENT(sched_kthread_stop,
 /*
  * Tracepoint for the return value of the kthread stopping:
  */
-TRACE_EVENT(sched_kthread_stop_ret,
+BARNEY(sched_kthread_stop_ret,
 
 	TP_PROTO(int ret),
 
@@ -55,7 +55,7 @@ TRACE_EVENT(sched_kthread_stop_ret,
  * (NOTE: the 'rq' argument is not used by generic trace events,
  *        but used by the latency tracer plugin. )
  */
-TRACE_EVENT(sched_wait_task,
+BARNEY(sched_wait_task,
 
 	TP_PROTO(struct rq *rq, struct task_struct *p),
 
@@ -83,7 +83,7 @@ TRACE_EVENT(sched_wait_task,
  * (NOTE: the 'rq' argument is not used by generic trace events,
  *        but used by the latency tracer plugin. )
  */
-DECLARE_EVENT_CLASS(sched_wakeup_template,
+FRED(sched_wakeup_template,
 
 	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
 
@@ -110,7 +110,7 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
 		  __entry->success, __entry->target_cpu)
 );
 
-DEFINE_EVENT(sched_wakeup_template, sched_wakeup,
+WILMA(sched_wakeup_template, sched_wakeup,
 	     TP_PROTO(struct rq *rq, struct task_struct *p, int success),
 	     TP_ARGS(rq, p, success));
 
@@ -120,7 +120,7 @@ DEFINE_EVENT(sched_wakeup_template, sched_wakeup,
  * (NOTE: the 'rq' argument is not used by generic trace events,
  *        but used by the latency tracer plugin. )
  */
-DEFINE_EVENT(sched_wakeup_template, sched_wakeup_new,
+WILMA(sched_wakeup_template, sched_wakeup_new,
 	     TP_PROTO(struct rq *rq, struct task_struct *p, int success),
 	     TP_ARGS(rq, p, success));
 
@@ -130,7 +130,7 @@ DEFINE_EVENT(sched_wakeup_template, sched_wakeup_new,
  * (NOTE: the 'rq' argument is not used by generic trace events,
  *        but used by the latency tracer plugin. )
  */
-TRACE_EVENT(sched_switch,
+BARNEY(sched_switch,
 
 	TP_PROTO(struct rq *rq, struct task_struct *prev,
 		 struct task_struct *next),
@@ -170,7 +170,7 @@ TRACE_EVENT(sched_switch,
 /*
  * Tracepoint for a task being migrated:
  */
-TRACE_EVENT(sched_migrate_task,
+BARNEY(sched_migrate_task,
 
 	TP_PROTO(struct task_struct *p, int dest_cpu),
 
@@ -197,7 +197,7 @@ TRACE_EVENT(sched_migrate_task,
 		  __entry->orig_cpu, __entry->dest_cpu)
 );
 
-DECLARE_EVENT_CLASS(sched_process_template,
+FRED(sched_process_template,
 
 	TP_PROTO(struct task_struct *p),
 
@@ -222,7 +222,7 @@ DECLARE_EVENT_CLASS(sched_process_template,
 /*
  * Tracepoint for freeing a task:
  */
-DEFINE_EVENT(sched_process_template, sched_process_free,
+WILMA(sched_process_template, sched_process_free,
 	     TP_PROTO(struct task_struct *p),
 	     TP_ARGS(p));
 	     
@@ -230,14 +230,14 @@ DEFINE_EVENT(sched_process_template, sched_process_free,
 /*
  * Tracepoint for a task exiting:
  */
-DEFINE_EVENT(sched_process_template, sched_process_exit,
+WILMA(sched_process_template, sched_process_exit,
 	     TP_PROTO(struct task_struct *p),
 	     TP_ARGS(p));
 
 /*
  * Tracepoint for a waiting task:
  */
-TRACE_EVENT(sched_process_wait,
+BARNEY(sched_process_wait,
 
 	TP_PROTO(struct pid *pid),
 
@@ -262,7 +262,7 @@ TRACE_EVENT(sched_process_wait,
 /*
  * Tracepoint for do_fork:
  */
-TRACE_EVENT(sched_process_fork,
+BARNEY(sched_process_fork,
 
 	TP_PROTO(struct task_struct *parent, struct task_struct *child),
 
@@ -291,7 +291,7 @@ TRACE_EVENT(sched_process_fork,
  * XXX the below sched_stat tracepoints only apply to SCHED_OTHER/BATCH/IDLE
  *     adding sched_stat support to SCHED_FIFO/RR would be welcome.
  */
-DECLARE_EVENT_CLASS(sched_stat_template,
+FRED(sched_stat_template,
 
 	TP_PROTO(struct task_struct *tsk, u64 delay),
 
@@ -322,7 +322,7 @@ DECLARE_EVENT_CLASS(sched_stat_template,
  * Tracepoint for accounting wait time (time the task is runnable
  * but not actually running due to scheduler contention).
  */
-DEFINE_EVENT(sched_stat_template, sched_stat_wait,
+WILMA(sched_stat_template, sched_stat_wait,
 	     TP_PROTO(struct task_struct *tsk, u64 delay),
 	     TP_ARGS(tsk, delay));
 
@@ -330,7 +330,7 @@ DEFINE_EVENT(sched_stat_template, sched_stat_wait,
  * Tracepoint for accounting sleep time (time the task is not runnable,
  * including iowait, see below).
  */
-DEFINE_EVENT(sched_stat_template, sched_stat_sleep,
+WILMA(sched_stat_template, sched_stat_sleep,
 	     TP_PROTO(struct task_struct *tsk, u64 delay),
 	     TP_ARGS(tsk, delay));
 
@@ -338,7 +338,7 @@ DEFINE_EVENT(sched_stat_template, sched_stat_sleep,
  * Tracepoint for accounting iowait time (time the task is not runnable
  * due to waiting on IO to complete).
  */
-DEFINE_EVENT(sched_stat_template, sched_stat_iowait,
+WILMA(sched_stat_template, sched_stat_iowait,
 	     TP_PROTO(struct task_struct *tsk, u64 delay),
 	     TP_ARGS(tsk, delay));
 
@@ -346,7 +346,7 @@ DEFINE_EVENT(sched_stat_template, sched_stat_iowait,
  * Tracepoint for accounting runtime (time the task is executing
  * on a CPU).
  */
-TRACE_EVENT(sched_stat_runtime,
+BARNEY(sched_stat_runtime,
 
 	TP_PROTO(struct task_struct *tsk, u64 runtime, u64 vruntime),
 
diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index a510b75..6b2f798 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -34,7 +34,7 @@
  * SEND_SIG_NOINFO means that si_code is SI_USER, and SEND_SIG_PRIV
  * means that si_code is SI_KERNEL.
  */
-TRACE_EVENT(signal_generate,
+BARNEY(signal_generate,
 
 	TP_PROTO(int sig, struct siginfo *info, struct task_struct *task),
 
@@ -74,7 +74,7 @@ TRACE_EVENT(signal_generate,
  * This means, this can show which signals are actually delivered, but
  * matching generated signals and delivered signals may not be correct.
  */
-TRACE_EVENT(signal_deliver,
+BARNEY(signal_deliver,
 
 	TP_PROTO(int sig, struct siginfo *info, struct k_sigaction *ka),
 
@@ -111,7 +111,7 @@ TRACE_EVENT(signal_deliver,
  * 'group' is not 0 if the signal will be sent to a process group.
  * 'sig' is always one of RT signals.
  */
-TRACE_EVENT(signal_overflow_fail,
+BARNEY(signal_overflow_fail,
 
 	TP_PROTO(int sig, int group, struct siginfo *info),
 
@@ -145,7 +145,7 @@ TRACE_EVENT(signal_overflow_fail,
  * 'group' is not 0 if the signal will be sent to a process group.
  * 'sig' is always one of non-RT signals.
  */
-TRACE_EVENT(signal_lose_info,
+BARNEY(signal_lose_info,
 
 	TP_PROTO(int sig, int group, struct siginfo *info),
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 4b2be6d..55a1082 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -11,7 +11,7 @@
 /*
  * Tracepoint for free an sk_buff:
  */
-TRACE_EVENT(kfree_skb,
+BARNEY(kfree_skb,
 
 	TP_PROTO(struct sk_buff *skb, void *location),
 
@@ -35,7 +35,7 @@ TRACE_EVENT(kfree_skb,
 		__entry->skbaddr, __entry->protocol, __entry->location)
 );
 
-TRACE_EVENT(skb_copy_datagram_iovec,
+BARNEY(skb_copy_datagram_iovec,
 
 	TP_PROTO(const struct sk_buff *skb, int len),
 
diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
index 397dff2..3e70f03 100644
--- a/include/trace/events/syscalls.h
+++ b/include/trace/events/syscalls.h
@@ -1,8 +1,8 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM syscalls
 
-#if !defined(_TRACE_EVENTS_SYSCALLS_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_EVENTS_SYSCALLS_H
+#if !defined(_BARNEYS_SYSCALLS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _BARNEYS_SYSCALLS_H
 
 #include <linux/tracepoint.h>
 
@@ -15,7 +15,7 @@
 extern void syscall_regfunc(void);
 extern void syscall_unregfunc(void);
 
-TRACE_EVENT_FN(sys_enter,
+BARNEY_FN(sys_enter,
 
 	TP_PROTO(struct pt_regs *regs, long id),
 
@@ -39,7 +39,7 @@ TRACE_EVENT_FN(sys_enter,
 	syscall_regfunc, syscall_unregfunc
 );
 
-TRACE_EVENT_FN(sys_exit,
+BARNEY_FN(sys_exit,
 
 	TP_PROTO(struct pt_regs *regs, long ret),
 
@@ -63,7 +63,7 @@ TRACE_EVENT_FN(sys_exit,
 
 #endif /* CONFIG_HAVE_SYSCALL_TRACEPOINTS */
 
-#endif /* _TRACE_EVENTS_SYSCALLS_H */
+#endif /* _BARNEYS_SYSCALLS_H */
 
 /* This part must be outside protection */
 #include <trace/define_trace.h>
diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index e5ce87a..63e823e 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -12,7 +12,7 @@
  * timer_init - called when the timer is initialized
  * @timer:	pointer to struct timer_list
  */
-TRACE_EVENT(timer_init,
+BARNEY(timer_init,
 
 	TP_PROTO(struct timer_list *timer),
 
@@ -34,7 +34,7 @@ TRACE_EVENT(timer_init,
  * @timer:	pointer to struct timer_list
  * @expires:	the timers expiry time
  */
-TRACE_EVENT(timer_start,
+BARNEY(timer_start,
 
 	TP_PROTO(struct timer_list *timer, unsigned long expires),
 
@@ -65,7 +65,7 @@ TRACE_EVENT(timer_start,
  *
  * Allows to determine the timer latency.
  */
-TRACE_EVENT(timer_expire_entry,
+BARNEY(timer_expire_entry,
 
 	TP_PROTO(struct timer_list *timer),
 
@@ -94,7 +94,7 @@ TRACE_EVENT(timer_expire_entry,
  * NOTE: Do NOT derefernce timer in TP_fast_assign. The pointer might
  * be invalid. We solely track the pointer.
  */
-TRACE_EVENT(timer_expire_exit,
+BARNEY(timer_expire_exit,
 
 	TP_PROTO(struct timer_list *timer),
 
@@ -115,7 +115,7 @@ TRACE_EVENT(timer_expire_exit,
  * timer_cancel - called when the timer is canceled
  * @timer:	pointer to struct timer_list
  */
-TRACE_EVENT(timer_cancel,
+BARNEY(timer_cancel,
 
 	TP_PROTO(struct timer_list *timer),
 
@@ -138,7 +138,7 @@ TRACE_EVENT(timer_cancel,
  * @clockid:	the hrtimers clock
  * @mode:	the hrtimers mode
  */
-TRACE_EVENT(hrtimer_init,
+BARNEY(hrtimer_init,
 
 	TP_PROTO(struct hrtimer *hrtimer, clockid_t clockid,
 		 enum hrtimer_mode mode),
@@ -168,7 +168,7 @@ TRACE_EVENT(hrtimer_init,
  * hrtimer_start - called when the hrtimer is started
  * @timer: pointer to struct hrtimer
  */
-TRACE_EVENT(hrtimer_start,
+BARNEY(hrtimer_start,
 
 	TP_PROTO(struct hrtimer *hrtimer),
 
@@ -204,7 +204,7 @@ TRACE_EVENT(hrtimer_start,
  *
  * Allows to determine the timer latency.
  */
-TRACE_EVENT(hrtimer_expire_entry,
+BARNEY(hrtimer_expire_entry,
 
 	TP_PROTO(struct hrtimer *hrtimer, ktime_t *now),
 
@@ -231,7 +231,7 @@ TRACE_EVENT(hrtimer_expire_entry,
  * When used in combination with the hrtimer_expire_entry tracepoint we can
  * determine the runtime of the callback function.
  */
-TRACE_EVENT(hrtimer_expire_exit,
+BARNEY(hrtimer_expire_exit,
 
 	TP_PROTO(struct hrtimer *hrtimer),
 
@@ -252,7 +252,7 @@ TRACE_EVENT(hrtimer_expire_exit,
  * hrtimer_cancel - called when the hrtimer is canceled
  * @hrtimer:	pointer to struct hrtimer
  */
-TRACE_EVENT(hrtimer_cancel,
+BARNEY(hrtimer_cancel,
 
 	TP_PROTO(struct hrtimer *hrtimer),
 
@@ -276,7 +276,7 @@ TRACE_EVENT(hrtimer_cancel,
  *		zero, otherwise it is started
  * @expires:	the itimers expiry time
  */
-TRACE_EVENT(itimer_state,
+BARNEY(itimer_state,
 
 	TP_PROTO(int which, const struct itimerval *const value,
 		 cputime_t expires),
@@ -313,7 +313,7 @@ TRACE_EVENT(itimer_state,
  * @pid:	pid of the process which owns the timer
  * @now:	current time, used to calculate the latency of itimer
  */
-TRACE_EVENT(itimer_expire,
+BARNEY(itimer_expire,
 
 	TP_PROTO(int which, struct pid *pid, cputime_t now),
 
diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index d6c9744..33077fb 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -8,7 +8,7 @@
 #include <linux/sched.h>
 #include <linux/tracepoint.h>
 
-DECLARE_EVENT_CLASS(workqueue,
+FRED(workqueue,
 
 	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
 
@@ -30,14 +30,14 @@ DECLARE_EVENT_CLASS(workqueue,
 		__entry->thread_pid, __entry->func)
 );
 
-DEFINE_EVENT(workqueue, workqueue_insertion,
+WILMA(workqueue, workqueue_insertion,
 
 	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
 
 	TP_ARGS(wq_thread, work)
 );
 
-DEFINE_EVENT(workqueue, workqueue_execution,
+WILMA(workqueue, workqueue_execution,
 
 	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
 
@@ -45,7 +45,7 @@ DEFINE_EVENT(workqueue, workqueue_execution,
 );
 
 /* Trace the creation of one workqueue thread on a cpu */
-TRACE_EVENT(workqueue_creation,
+BARNEY(workqueue_creation,
 
 	TP_PROTO(struct task_struct *wq_thread, int cpu),
 
@@ -67,7 +67,7 @@ TRACE_EVENT(workqueue_creation,
 		__entry->thread_pid, __entry->cpu)
 );
 
-TRACE_EVENT(workqueue_destruction,
+BARNEY(workqueue_destruction,
 
 	TP_PROTO(struct task_struct *wq_thread),
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 2c9c073..561de7f 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -19,23 +19,23 @@
 #include <linux/ftrace_event.h>
 
 /*
- * DECLARE_EVENT_CLASS can be used to add a generic function
+ * FRED can be used to add a generic function
  * handlers for events. That is, if all events have the same
  * parameters and just have distinct trace points.
- * Each tracepoint can be defined with DEFINE_EVENT and that
- * will map the DECLARE_EVENT_CLASS to the tracepoint.
+ * Each tracepoint can be defined with WILMA and that
+ * will map the FRED to the tracepoint.
  *
- * TRACE_EVENT is a one to one mapping between tracepoint and template.
+ * BARNEY is a one to one mapping between tracepoint and template.
  */
-#undef TRACE_EVENT
-#define TRACE_EVENT(name, proto, args, tstruct, assign, print) \
-	DECLARE_EVENT_CLASS(name,			       \
+#undef BARNEY
+#define BARNEY(name, proto, args, tstruct, assign, print) \
+	FRED(name,			       \
 			     PARAMS(proto),		       \
 			     PARAMS(args),		       \
 			     PARAMS(tstruct),		       \
 			     PARAMS(assign),		       \
 			     PARAMS(print));		       \
-	DEFINE_EVENT(name, name, PARAMS(proto), PARAMS(args));
+	WILMA(name, name, PARAMS(proto), PARAMS(args));
 
 
 #undef __field
@@ -56,29 +56,29 @@
 #undef TP_STRUCT__entry
 #define TP_STRUCT__entry(args...) args
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(name, proto, args, tstruct, assign, print)	\
+#undef FRED
+#define FRED(name, proto, args, tstruct, assign, print)	\
 	struct ftrace_raw_##name {					\
 		struct trace_entry	ent;				\
 		tstruct							\
 		char			__data[0];			\
 	};
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, name, proto, args)	\
+#undef WILMA
+#define WILMA(template, name, proto, args)	\
 	static struct ftrace_event_call event_##name
 
-#undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
-	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+#undef WILMA_PRINT
+#define WILMA_PRINT(template, name, proto, args, print)	\
+	WILMA(template, name, PARAMS(proto), PARAMS(args))
 
 #undef __cpparg
 #define __cpparg(arg...) arg
 
 /* Callbacks are meaningless to ftrace. */
-#undef TRACE_EVENT_FN
-#define TRACE_EVENT_FN(name, proto, args, tstruct,			\
+#undef BARNEY_FN
+#define BARNEY_FN(name, proto, args, tstruct,			\
 		assign, print, reg, unreg)				\
-	TRACE_EVENT(name, __cpparg(proto), __cpparg(args),		\
+	BARNEY(name, __cpparg(proto), __cpparg(args),		\
 		__cpparg(tstruct), __cpparg(assign), __cpparg(print))	\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
@@ -115,18 +115,18 @@
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+#undef FRED
+#define FRED(call, proto, args, tstruct, assign, print)	\
 	struct ftrace_data_offsets_##call {				\
 		tstruct;						\
 	};
 
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, name, proto, args)
+#undef WILMA
+#define WILMA(template, name, proto, args)
 
-#undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
-	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+#undef WILMA_PRINT
+#define WILMA_PRINT(template, name, proto, args, print)	\
+	WILMA(template, name, PARAMS(proto), PARAMS(args))
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
@@ -203,8 +203,8 @@
 #undef TP_perf_assign
 #define TP_perf_assign(args...)
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
+#undef FRED
+#define FRED(call, proto, args, tstruct, func, print)	\
 static int								\
 ftrace_format_setup_##call(struct ftrace_event_call *unused,		\
 			   struct trace_seq *s)				\
@@ -232,11 +232,11 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
 	return ret;							\
 }
 
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, name, proto, args)
+#undef WILMA
+#define WILMA(template, name, proto, args)
 
-#undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)		\
+#undef WILMA_PRINT
+#define WILMA_PRINT(template, name, proto, args, print)		\
 static int								\
 ftrace_format_##name(struct ftrace_event_call *unused,			\
 		      struct trace_seq *s)				\
@@ -321,8 +321,8 @@ ftrace_format_##name(struct ftrace_event_call *unused,			\
 		ftrace_print_symbols_seq(p, value, symbols);		\
 	})
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+#undef FRED
+#define FRED(call, proto, args, tstruct, assign, print)	\
 static enum print_line_t						\
 ftrace_raw_output_id_##call(int event_id, const char *name,		\
 			    struct trace_iterator *iter, int flags)	\
@@ -354,8 +354,8 @@ ftrace_raw_output_id_##call(int event_id, const char *name,		\
 	return TRACE_TYPE_HANDLED;					\
 }
 
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, name, proto, args)			\
+#undef WILMA
+#define WILMA(template, name, proto, args)			\
 static enum print_line_t						\
 ftrace_raw_output_##name(struct trace_iterator *iter, int flags)	\
 {									\
@@ -363,8 +363,8 @@ ftrace_raw_output_##name(struct trace_iterator *iter, int flags)	\
 					       #name, iter, flags);	\
 }
 
-#undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
+#undef WILMA_PRINT
+#define WILMA_PRINT(template, call, proto, args, print)		\
 static enum print_line_t						\
 ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 {									\
@@ -428,8 +428,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
+#undef FRED
+#define FRED(call, proto, args, tstruct, func, print)	\
 static int								\
 ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 {									\
@@ -445,12 +445,12 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 	return ret;							\
 }
 
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, name, proto, args)
+#undef WILMA
+#define WILMA(template, name, proto, args)
 
-#undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
-	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+#undef WILMA_PRINT
+#define WILMA_PRINT(template, name, proto, args, print)	\
+	WILMA(template, name, PARAMS(proto), PARAMS(args))
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
@@ -480,8 +480,8 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, strlen(src) + 1)
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+#undef FRED
+#define FRED(call, proto, args, tstruct, assign, print)	\
 static inline int ftrace_get_offsets_##call(				\
 	struct ftrace_data_offsets_##call *__data_offsets, proto)       \
 {									\
@@ -493,12 +493,12 @@ static inline int ftrace_get_offsets_##call(				\
 	return __data_size;						\
 }
 
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, name, proto, args)
+#undef WILMA
+#define WILMA(template, name, proto, args)
 
-#undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
-	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+#undef WILMA_PRINT
+#define WILMA_PRINT(template, name, proto, args, print)	\
+	WILMA(template, name, PARAMS(proto), PARAMS(args))
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
@@ -521,11 +521,11 @@ static inline int ftrace_get_offsets_##call(				\
  *
  */
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)
+#undef FRED
+#define FRED(call, proto, args, tstruct, assign, print)
 
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, name, proto, args)			\
+#undef WILMA
+#define WILMA(template, name, proto, args)			\
 									\
 static void ftrace_profile_##name(proto);				\
 									\
@@ -539,9 +539,9 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
 	unregister_trace_##name(ftrace_profile_##name);			\
 }
 
-#undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
-	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+#undef WILMA_PRINT
+#define WILMA_PRINT(template, name, proto, args, print)	\
+	WILMA(template, name, PARAMS(proto), PARAMS(args))
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
@@ -574,7 +574,7 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
  * }
  *
  *
- * For those macros defined with TRACE_EVENT:
+ * For those macros defined with BARNEY:
  *
  * static struct ftrace_event_call event_<call>;
  *
@@ -681,8 +681,8 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
 #define __assign_str(dst, src)						\
 	strcpy(__get_str(dst), src);
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+#undef FRED
+#define FRED(call, proto, args, tstruct, assign, print)	\
 									\
 static void ftrace_raw_event_id_##call(struct ftrace_event_call *event_call, \
 				       proto)				\
@@ -718,8 +718,8 @@ static void ftrace_raw_event_id_##call(struct ftrace_event_call *event_call, \
 						  event, irq_flags, pc); \
 }
 
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, call, proto, args)			\
+#undef WILMA
+#define WILMA(template, call, proto, args)			\
 									\
 static void ftrace_raw_event_##call(proto)				\
 {									\
@@ -758,17 +758,17 @@ static int ftrace_raw_init_event_##call(struct ftrace_event_call *unused)\
 	return 0;							\
 }
 
-#undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
-	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+#undef WILMA_PRINT
+#define WILMA_PRINT(template, name, proto, args, print)	\
+	WILMA(template, name, PARAMS(proto), PARAMS(args))
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)
+#undef FRED
+#define FRED(call, proto, args, tstruct, assign, print)
 
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, call, proto, args)			\
+#undef WILMA
+#define WILMA(template, call, proto, args)			\
 									\
 static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
@@ -784,8 +784,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	_TRACE_PROFILE_INIT(call)					\
 }
 
-#undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
+#undef WILMA_PRINT
+#define WILMA_PRINT(template, call, proto, args, print)		\
 									\
 static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
@@ -885,8 +885,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #undef __perf_count
 #define __perf_count(c) __count = (c)
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+#undef FRED
+#define FRED(call, proto, args, tstruct, assign, print)	\
 static void								\
 ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
 			    proto)					\
@@ -956,8 +956,8 @@ end_recursion:								\
 									\
 }
 
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, call, proto, args)		\
+#undef WILMA
+#define WILMA(template, call, proto, args)		\
 static void ftrace_profile_##call(proto)			\
 {								\
 	struct ftrace_event_call *event_call = &event_##call;	\
@@ -965,9 +965,9 @@ static void ftrace_profile_##call(proto)			\
 	ftrace_profile_templ_##template(event_call, args);	\
 }
 
-#undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
-	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+#undef WILMA_PRINT
+#define WILMA_PRINT(template, name, proto, args, print)	\
+	WILMA(template, name, PARAMS(proto), PARAMS(args))
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 #endif /* CONFIG_EVENT_PROFILE */
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 1d7f483..568f0ad 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -695,8 +695,8 @@ int tracing_update_buffers(void);
 
 /* trace event type bit fields, not numeric */
 enum {
-	TRACE_EVENT_TYPE_PRINTF		= 1,
-	TRACE_EVENT_TYPE_RAW		= 2,
+	BARNEY_TYPE_PRINTF		= 1,
+	BARNEY_TYPE_RAW		= 2,
 };
 
 struct ftrace_event_field {
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 9d91c72..e2872d2 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -1,5 +1,5 @@
-#ifndef __TRACE_EVENTS_H
-#define __TRACE_EVENTS_H
+#ifndef __BARNEYS_H
+#define __BARNEYS_H
 
 #include <linux/trace_seq.h>
 #include "trace.h"
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 37b9051..93ec2dc 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -6,8 +6,8 @@
 #include "ieee80211_i.h"
 
 #if !defined(CONFIG_MAC80211_DRIVER_API_TRACER) || defined(__CHECKER__)
-#undef TRACE_EVENT
-#define TRACE_EVENT(name, proto, ...) \
+#undef BARNEY
+#define BARNEY(name, proto, ...) \
 static inline void trace_ ## name(proto) {}
 #endif
 
@@ -30,7 +30,7 @@ static inline void trace_ ## name(proto) {}
 #define VIF_PR_FMT	" vif:%p(%d)"
 #define VIF_PR_ARG	__entry->vif, __entry->vif_type
 
-TRACE_EVENT(drv_start,
+BARNEY(drv_start,
 	TP_PROTO(struct ieee80211_local *local, int ret),
 
 	TP_ARGS(local, ret),
@@ -50,7 +50,7 @@ TRACE_EVENT(drv_start,
 	)
 );
 
-TRACE_EVENT(drv_stop,
+BARNEY(drv_stop,
 	TP_PROTO(struct ieee80211_local *local),
 
 	TP_ARGS(local),
@@ -68,7 +68,7 @@ TRACE_EVENT(drv_stop,
 	)
 );
 
-TRACE_EVENT(drv_add_interface,
+BARNEY(drv_add_interface,
 	TP_PROTO(struct ieee80211_local *local,
 		 const u8 *addr,
 		 struct ieee80211_vif *vif,
@@ -96,7 +96,7 @@ TRACE_EVENT(drv_add_interface,
 	)
 );
 
-TRACE_EVENT(drv_remove_interface,
+BARNEY(drv_remove_interface,
 	TP_PROTO(struct ieee80211_local *local,
 		 const u8 *addr, struct ieee80211_vif *vif),
 
@@ -120,7 +120,7 @@ TRACE_EVENT(drv_remove_interface,
 	)
 );
 
-TRACE_EVENT(drv_config,
+BARNEY(drv_config,
 	TP_PROTO(struct ieee80211_local *local,
 		 u32 changed,
 		 int ret),
@@ -145,7 +145,7 @@ TRACE_EVENT(drv_config,
 	)
 );
 
-TRACE_EVENT(drv_bss_info_changed,
+BARNEY(drv_bss_info_changed,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_vif *vif,
 		 struct ieee80211_bss_conf *info,
@@ -191,7 +191,7 @@ TRACE_EVENT(drv_bss_info_changed,
 	)
 );
 
-TRACE_EVENT(drv_prepare_multicast,
+BARNEY(drv_prepare_multicast,
 	TP_PROTO(struct ieee80211_local *local, int mc_count, u64 ret),
 
 	TP_ARGS(local, mc_count, ret),
@@ -215,7 +215,7 @@ TRACE_EVENT(drv_prepare_multicast,
 	)
 );
 
-TRACE_EVENT(drv_configure_filter,
+BARNEY(drv_configure_filter,
 	TP_PROTO(struct ieee80211_local *local,
 		 unsigned int changed_flags,
 		 unsigned int *total_flags,
@@ -243,7 +243,7 @@ TRACE_EVENT(drv_configure_filter,
 	)
 );
 
-TRACE_EVENT(drv_set_tim,
+BARNEY(drv_set_tim,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sta *sta, bool set, int ret),
 
@@ -269,7 +269,7 @@ TRACE_EVENT(drv_set_tim,
 	)
 );
 
-TRACE_EVENT(drv_set_key,
+BARNEY(drv_set_key,
 	TP_PROTO(struct ieee80211_local *local,
 		 enum set_key_cmd cmd, struct ieee80211_vif *vif,
 		 struct ieee80211_sta *sta,
@@ -305,7 +305,7 @@ TRACE_EVENT(drv_set_key,
 	)
 );
 
-TRACE_EVENT(drv_update_tkip_key,
+BARNEY(drv_update_tkip_key,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_key_conf *conf,
 		 const u8 *address, u32 iv32),
@@ -330,7 +330,7 @@ TRACE_EVENT(drv_update_tkip_key,
 	)
 );
 
-TRACE_EVENT(drv_hw_scan,
+BARNEY(drv_hw_scan,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct cfg80211_scan_request *req, int ret),
 
@@ -352,7 +352,7 @@ TRACE_EVENT(drv_hw_scan,
 	)
 );
 
-TRACE_EVENT(drv_sw_scan_start,
+BARNEY(drv_sw_scan_start,
 	TP_PROTO(struct ieee80211_local *local),
 
 	TP_ARGS(local),
@@ -370,7 +370,7 @@ TRACE_EVENT(drv_sw_scan_start,
 	)
 );
 
-TRACE_EVENT(drv_sw_scan_complete,
+BARNEY(drv_sw_scan_complete,
 	TP_PROTO(struct ieee80211_local *local),
 
 	TP_ARGS(local),
@@ -388,7 +388,7 @@ TRACE_EVENT(drv_sw_scan_complete,
 	)
 );
 
-TRACE_EVENT(drv_get_stats,
+BARNEY(drv_get_stats,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_low_level_stats *stats,
 		 int ret),
@@ -419,7 +419,7 @@ TRACE_EVENT(drv_get_stats,
 	)
 );
 
-TRACE_EVENT(drv_get_tkip_seq,
+BARNEY(drv_get_tkip_seq,
 	TP_PROTO(struct ieee80211_local *local,
 		 u8 hw_key_idx, u32 *iv32, u16 *iv16),
 
@@ -444,7 +444,7 @@ TRACE_EVENT(drv_get_tkip_seq,
 	)
 );
 
-TRACE_EVENT(drv_set_rts_threshold,
+BARNEY(drv_set_rts_threshold,
 	TP_PROTO(struct ieee80211_local *local, u32 value, int ret),
 
 	TP_ARGS(local, value, ret),
@@ -467,7 +467,7 @@ TRACE_EVENT(drv_set_rts_threshold,
 	)
 );
 
-TRACE_EVENT(drv_sta_notify,
+BARNEY(drv_sta_notify,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_vif *vif,
 		 enum sta_notify_cmd cmd,
@@ -495,7 +495,7 @@ TRACE_EVENT(drv_sta_notify,
 	)
 );
 
-TRACE_EVENT(drv_conf_tx,
+BARNEY(drv_conf_tx,
 	TP_PROTO(struct ieee80211_local *local, u16 queue,
 		 const struct ieee80211_tx_queue_params *params,
 		 int ret),
@@ -528,7 +528,7 @@ TRACE_EVENT(drv_conf_tx,
 	)
 );
 
-TRACE_EVENT(drv_get_tx_stats,
+BARNEY(drv_get_tx_stats,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_tx_queue_stats *stats,
 		 int ret),
@@ -551,7 +551,7 @@ TRACE_EVENT(drv_get_tx_stats,
 	)
 );
 
-TRACE_EVENT(drv_get_tsf,
+BARNEY(drv_get_tsf,
 	TP_PROTO(struct ieee80211_local *local, u64 ret),
 
 	TP_ARGS(local, ret),
@@ -572,7 +572,7 @@ TRACE_EVENT(drv_get_tsf,
 	)
 );
 
-TRACE_EVENT(drv_set_tsf,
+BARNEY(drv_set_tsf,
 	TP_PROTO(struct ieee80211_local *local, u64 tsf),
 
 	TP_ARGS(local, tsf),
@@ -593,7 +593,7 @@ TRACE_EVENT(drv_set_tsf,
 	)
 );
 
-TRACE_EVENT(drv_reset_tsf,
+BARNEY(drv_reset_tsf,
 	TP_PROTO(struct ieee80211_local *local),
 
 	TP_ARGS(local),
@@ -611,7 +611,7 @@ TRACE_EVENT(drv_reset_tsf,
 	)
 );
 
-TRACE_EVENT(drv_tx_last_beacon,
+BARNEY(drv_tx_last_beacon,
 	TP_PROTO(struct ieee80211_local *local, int ret),
 
 	TP_ARGS(local, ret),
@@ -632,7 +632,7 @@ TRACE_EVENT(drv_tx_last_beacon,
 	)
 );
 
-TRACE_EVENT(drv_ampdu_action,
+BARNEY(drv_ampdu_action,
 	TP_PROTO(struct ieee80211_local *local,
 		 enum ieee80211_ampdu_mlme_action action,
 		 struct ieee80211_sta *sta, u16 tid,
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 6af3732..7a3beda 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -32,8 +32,8 @@
  *
  * serves this purpose.
  */
-#if !defined(_TRACE_EVENT_SAMPLE_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_EVENT_SAMPLE_H
+#if !defined(_BARNEY_SAMPLE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _BARNEY_SAMPLE_H
 
 /*
  * All trace headers should include tracepoint.h, until we finally
@@ -42,7 +42,7 @@
 #include <linux/tracepoint.h>
 
 /*
- * The TRACE_EVENT macro is broken up into 5 parts.
+ * The BARNEY macro is broken up into 5 parts.
  *
  * name: name of the trace point. This is also how to enable the tracepoint.
  *   A function called trace_foo_bar() will be created.
@@ -74,7 +74,7 @@
  * to the data structure in the ring buffer, and is defined by the
  * TP_STRUCT__entry.
  */
-TRACE_EVENT(foo_bar,
+BARNEY(foo_bar,
 
 	TP_PROTO(char *foo, int bar),
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index dd51c68..90120ab 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -1,5 +1,5 @@
-#ifndef __PERF_TRACE_EVENTS_H
-#define __PERF_TRACE_EVENTS_H
+#ifndef __PERF_BARNEYS_H
+#define __PERF_BARNEYS_H
 
 #include "parse-events.h"
 
@@ -259,4 +259,4 @@ enum trace_flag_type {
 	TRACE_FLAG_SOFTIRQ		= 0x10,
 };
 
-#endif /* __PERF_TRACE_EVENTS_H */
+#endif /* __PERF_BARNEYS_H */


