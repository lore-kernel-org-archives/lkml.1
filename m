Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbXHVF2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbXHVF2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 01:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbXHVF2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 01:28:22 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:38121 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752291AbXHVF2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 01:28:21 -0400
Message-ID: <46CBC842.4070100@vmware.com>
Date: Tue, 21 Aug 2007 22:23:14 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] Add I/O hypercalls for i386 paravirt
Content-Type: multipart/mixed;
 boundary="------------060402000106030709040002"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060402000106030709040002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

In general, I/O in a virtual guest is subject to performance problems.  
The I/O can not be completed physically, but must be virtualized.  This 
means trapping and decoding port I/O instructions from the guest OS.  
Not only is the trap for a #GP heavyweight, both in the processor and 
the hypervisor (which usually has a complex #GP path), but this forces 
the hypervisor to decode the individual instruction which has faulted.  
Worse, even with hardware assist such as VT, the exit reason alone is 
not sufficient to determine the true nature of the faulting instruction, 
requiring a complex and costly instruction decode and simulation.

This patch provides hypercalls for the i386 port I/O instructions, which 
vastly helps guests which use native-style drivers.  For certain VMI 
workloads, this provides a performance boost of up to 30%.  We expect 
KVM and lguest to be able to achieve similar gains on I/O intensive 
workloads.

This patch is against 2.6.23-rc2-mm2, and should be targeted for 2.6.24.

Zach

--------------060402000106030709040002
Content-Type: text/x-patch;
 name="i386-mm-paravirt-io-ops.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="i386-mm-paravirt-io-ops.patch"

Virtualized guests in general benefit from having I/O hypercalls.  This
patch adds support for port I/O hypercalls to VMI and provides the
infrastructure for other backends to make use of this feature.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff --git a/arch/i386/kernel/paravirt.c b/arch/i386/kernel/paravirt.c
index ea962c0..4d0d150 100644
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -329,6 +329,18 @@ struct paravirt_ops paravirt_ops = {
 
 	.set_iopl_mask = native_set_iopl_mask,
 	.io_delay = native_io_delay,
+	.outb = native_outb,
+	.outw = native_outw,
+	.outl = native_outl,
+	.inb = native_inb,
+	.inw = native_inw,
+	.inl = native_inl,
+	.outsb = native_outsb,
+	.outsw = native_outsw,
+	.outsl = native_outsl,
+	.insb = native_insb,
+	.insw = native_insw,
+	.insl = native_insl,
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	.apic_write = native_apic_write,
diff --git a/arch/i386/kernel/vmi.c b/arch/i386/kernel/vmi.c
index 44feb34..5ecd85b 100644
--- a/arch/i386/kernel/vmi.c
+++ b/arch/i386/kernel/vmi.c
@@ -56,6 +56,7 @@ static int disable_tsc;
 static int disable_mtrr;
 static int disable_noidle;
 static int disable_vmi_timer;
+static int disable_io_ops;
 
 /* Cached VMI operations */
 static struct {
@@ -72,6 +73,18 @@ static struct {
 	void (*set_initial_ap_state)(int, int);
 	void (*halt)(void);
   	void (*set_lazy_mode)(int mode);
+	void (*outb)(u8 value, u16 port);
+	void (*outw)(u16 value, u16 port);
+	void (*outl)(u32 value, u16 port);
+	u8 (*inb)(u16 port);
+	u16 (*inw)(u16 port);
+	u32 (*inl)(u16 port);
+	void (*outsb)(const void *addr, u16 port, u32 count);
+	void (*outsw)(const void *addr, u16 port, u32 count);
+	void (*outsl)(const void *addr, u16 port, u32 count);
+	void (*insb)(void *addr, u16 port, u32 count);
+	void (*insw)(void *addr, u16 port, u32 count);
+	void (*insl)(void *addr, u16 port, u32 count);
 } vmi_ops;
 
 /* Cached VMI operations */
@@ -565,6 +578,33 @@ static void vmi_set_lazy_mode(enum paravirt_lazy_mode mode)
 	}
 }
 
+#define BUILDIO(bwl,type) \
+static void vmi_out##bwl(type value, int port) { \
+	__asm__ __volatile__("call *%0" : : \
+		"r"(vmi_ops.out##bwl), "a"(value), "d"(port)); \
+} \
+static type vmi_in##bwl(int port) { \
+	type value; \
+	__asm__ __volatile__("call *%1" : \
+		"=a"(value) : \
+		"r"(vmi_ops.in##bwl), "d"(port)); \
+	return value; \
+} \
+static void vmi_outs##bwl(int port, const void *addr, unsigned long count) { \
+	__asm__ __volatile__("call *%2" : \
+		"+S"(addr), "+c"(count) : \
+		"r"(vmi_ops.outs##bwl), "d"(port)); \
+} \
+static void vmi_ins##bwl(int port, void *addr, unsigned long count) { \
+	__asm__ __volatile__("call *%2" : \
+		"+D"(addr), "+c"(count) : \
+		"r"(vmi_ops.ins##bwl), "d"(port)); \
+} 
+
+BUILDIO(b,unsigned char)
+BUILDIO(w,unsigned short)
+BUILDIO(l,unsigned int)
+
 static inline int __init check_vmi_rom(struct vrom_header *rom)
 {
 	struct pci_header *pci;
@@ -791,6 +831,21 @@ static inline int __init activate_vmi(void)
 	para_wrap(load_esp0, vmi_load_esp0, set_kernel_stack, UpdateKernelStack);
 	para_fill(set_iopl_mask, SetIOPLMask);
 	para_fill(io_delay, IODelay);
+	if (!disable_io_ops) {
+		para_wrap(inb, vmi_inb, inb, INB);
+		para_wrap(inw, vmi_inw, inw, INW);
+		para_wrap(inl, vmi_inl, inl, INL);
+		para_wrap(outb, vmi_outb, outb, OUTB);
+		para_wrap(outw, vmi_outw, outw, OUTW);
+		para_wrap(outl, vmi_outl, outl, OUTL);
+		para_wrap(insb, vmi_insb, insb, INSB);
+		para_wrap(insw, vmi_insw, insw, INSW);
+		para_wrap(insl, vmi_insl, insl, INSL);
+		para_wrap(outsb, vmi_outsb, outsb, OUTSB);
+		para_wrap(outsw, vmi_outsw, outsw, OUTSW);
+		para_wrap(outsl, vmi_outsl, outsl, OUTSL);
+	}
+
 	para_wrap(set_lazy_mode, vmi_set_lazy_mode, set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
@@ -968,6 +1023,8 @@ static int __init parse_vmi(char *arg)
 		disable_noidle = 1;
 	} else if (!strcmp(arg, "disable_noidle"))
 		disable_noidle = 1;
+	else if (!strcmp(arg, "disable_io_ops"))
+		disable_io_ops = 1;
 	return 0;
 }
 
diff --git a/include/asm-i386/io.h b/include/asm-i386/io.h
index e8e0bd6..0669d5f 100644
--- a/include/asm-i386/io.h
+++ b/include/asm-i386/io.h
@@ -272,6 +272,17 @@ static inline void slow_down_io(void) {
 #endif
 }
 
+#define	__BUILDOUTINST(bwl,bw,value,port); \
+	__asm__ __volatile__("out" #bwl " %" #bw "0, %w1" : : "a"(value), "Nd"(port));
+
+#define	__BUILDININST(bwl,bw,value,port); \
+	__asm__ __volatile__("in" #bwl " %w1, %" #bw "0" : "=a"(value) : "Nd"(port));
+
+#define __BUILDOUTSINST(bwl,addr,count,port) \
+	__asm__ __volatile__("rep; outs" #bwl : "+S"(addr), "+c"(count) : "d"(port));
+
+#define __BUILDINSINST(bwl,addr,count,port) \
+	__asm__ __volatile__("rep; ins" #bwl : "+D"(addr), "+c"(count) : "d"(port));
 #endif
 
 #ifdef CONFIG_X86_NUMAQ
@@ -308,14 +319,22 @@ static inline unsigned type in##bwl(int port) { \
 
 
 #define BUILDIO(bwl,bw,type) \
-static inline void out##bwl##_local(unsigned type value, int port) { \
+static inline void native_out##bwl(unsigned type value, int port) { \
 	__asm__ __volatile__("out" #bwl " %" #bw "0, %w1" : : "a"(value), "Nd"(port)); \
 } \
-static inline unsigned type in##bwl##_local(int port) { \
+static inline void out##bwl##_local(unsigned type value, int port) { \
+	__BUILDOUTINST(bwl,bw,value,port); \
+} \
+static inline unsigned type native_in##bwl(int port) { \
 	unsigned type value; \
 	__asm__ __volatile__("in" #bwl " %w1, %" #bw "0" : "=a"(value) : "Nd"(port)); \
 	return value; \
 } \
+static inline unsigned type in##bwl##_local(int port) { \
+	unsigned type value; \
+	__BUILDININST(bwl,bw,value,port); \
+	return value; \
+} \
 static inline void out##bwl##_local_p(unsigned type value, int port) { \
 	out##bwl##_local(value, port); \
 	slow_down_io(); \
@@ -335,15 +354,23 @@ static inline unsigned type in##bwl##_p(int port) { \
 	slow_down_io(); \
 	return value; \
 } \
-static inline void outs##bwl(int port, const void *addr, unsigned long count) { \
+static inline void native_outs##bwl(int port, const void *addr, unsigned long count) { \
 	__asm__ __volatile__("rep; outs" #bwl : "+S"(addr), "+c"(count) : "d"(port)); \
 } \
-static inline void ins##bwl(int port, void *addr, unsigned long count) { \
+static inline void native_ins##bwl(int port, void *addr, unsigned long count) { \
 	__asm__ __volatile__("rep; ins" #bwl : "+D"(addr), "+c"(count) : "d"(port)); \
+} \
+static inline void outs##bwl(int port, const void *addr, unsigned long count) { \
+	__BUILDOUTSINST(bwl,addr,count,port); \
+} \
+static inline void ins##bwl(int port, void *addr, unsigned long count) { \
+	__BUILDINSINST(bwl,addr,count,port); \
 }
 
 BUILDIO(b,b,char)
 BUILDIO(w,w,short)
 BUILDIO(l,,int)
 
+#undef BUILDIO
+
 #endif
diff --git a/include/asm-i386/paravirt.h b/include/asm-i386/paravirt.h
index 7df88be..ad44e4f 100644
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -141,6 +141,22 @@ struct paravirt_ops
 	void (*set_iopl_mask)(unsigned mask);
 	void (*io_delay)(void);
 
+	void (*outb)(unsigned char value, int port);
+	void (*outw)(unsigned short value, int port);
+	void (*outl)(unsigned int value, int port);
+
+	unsigned char (*inb)(int port);
+	unsigned short (*inw)(int port);
+	unsigned int (*inl)(int port);
+
+	void (*outsb)(int port, const void *addr, unsigned long count);
+	void (*outsw)(int port, const void *addr, unsigned long count);
+	void (*outsl)(int port, const void *addr, unsigned long count);
+	
+	void (*insb)(int port, void *addr, unsigned long count);
+	void (*insw)(int port, void *addr, unsigned long count);
+	void (*insl)(int port, void *addr, unsigned long count);
+
 	/*
 	 * Hooks for intercepting the creation/use/destruction of an
 	 * mm_struct.
@@ -645,6 +661,15 @@ static inline void slow_down_io(void) {
 #endif
 }
 
+#define __BUILDOUTINST(bwl,bw,value,port) \
+        paravirt_ops.out##bwl(value, port)
+#define __BUILDININST(bwl,bw,value,port) \
+        do { value = paravirt_ops.in##bwl(port); } while (0)
+#define __BUILDOUTSINST(bwl,addr,count,port) \
+        paravirt_ops.outs##bwl(port, addr, count)
+#define __BUILDINSINST(bwl,addr,count,port) \
+        paravirt_ops.ins##bwl(port, addr, count)
+
 #ifdef CONFIG_X86_LOCAL_APIC
 /*
  * Basic functions accessing APICs.
diff --git a/include/asm-i386/vmi.h b/include/asm-i386/vmi.h
index eb8bd89..a5072b2 100644
--- a/include/asm-i386/vmi.h
+++ b/include/asm-i386/vmi.h
@@ -92,7 +92,18 @@
 #define VMI_CALL_InvalPage		46
 #define VMI_CALL_FlushTLB		47
 #define VMI_CALL_SetLinearMapping	48
-
+#define VMI_CALL_INL			49
+#define VMI_CALL_INB			50
+#define VMI_CALL_INW			51
+#define VMI_CALL_INSL			52
+#define VMI_CALL_INSB			53
+#define VMI_CALL_INSW			54
+#define VMI_CALL_OUTL			55
+#define VMI_CALL_OUTB			56
+#define VMI_CALL_OUTW			57
+#define VMI_CALL_OUTSL			58
+#define VMI_CALL_OUTSB			59
+#define VMI_CALL_OUTSW			60
 #define VMI_CALL_SetIOPLMask		61
 #define VMI_CALL_SetInitialAPState	62
 #define VMI_CALL_APICWrite		63

--------------060402000106030709040002--
