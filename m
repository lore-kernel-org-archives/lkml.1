Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbYG2Rms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbYG2Rms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbYG2Rk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:40:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:20554 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbYG2RkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:40:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,273,1215414000"; 
   d="scan'208";a="423495875"
Message-Id: <20080729173158.239663000@linux-os.sc.intel.com>
References: <20080729172917.185593000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jul 2008 10:29:24 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, roland@redhat.com, drepper@redhat.com,
       mikpe@it.uu.se, chrisw@sous-sol.org, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 7/9] x86, xsave: struct _fpstate extensions to include extended state information
Content-Disposition: inline; filename=sigcontext_header_extensions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bytes 464..511 in the current 512byte layout of fxsave/fxrstor
frame, are reserved for SW usage. On cpu's supporting xsave/xrstor, these bytes
are used to extended the fpstate pointer in the sigcontext, which now includes
the extended state information along with fpstate information.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip-0728/include/asm-x86/sigcontext.h
===================================================================
--- tip-0728.orig/include/asm-x86/sigcontext.h	2008-07-28 18:42:45.000000000 -0700
+++ tip-0728/include/asm-x86/sigcontext.h	2008-07-28 18:44:20.000000000 -0700
@@ -4,6 +4,40 @@
 #include <linux/compiler.h>
 #include <asm/types.h>
 
+#define FP_XSTATE_MAGIC1	0x46505853U
+#define FP_XSTATE_MAGIC2	0x46505845U
+#define FP_XSTATE_MAGIC2_SIZE	sizeof(FP_XSTATE_MAGIC2)
+
+/*
+ * bytes 464..511 in the current 512byte layout of fxsave/fxrstor frame
+ * are reserved for SW usage. On cpu's supporting xsave/xrstor, these bytes
+ * are used to extended the fpstate pointer in the sigcontext, which now
+ * includes the extended state information along with fpstate information.
+ *
+ * Presence of FP_XSTATE_MAGIC1 at the beginning of this SW reserved
+ * area and FP_XSTATE_MAGIC2 at the end of memory layout
+ * (extended_size - FP_XSTATE_MAGIC2_SIZE) indicates the presence of the
+ * extended state information in the memory layout pointed by the fpstate
+ * pointer in sigcontext.
+ */
+struct _fpx_sw_bytes {
+	__u32 magic1;		/* FP_XSTATE_MAGIC1 */
+	__u32 extended_size;	/* total size of the layout referred by
+				 * fpstate pointer in the sigcontext.
+				 */
+	__u64 xstate_bv;
+				/* feature bit mask (including fp/sse/extended
+				 * state) that is present in the memory
+				 * layout.
+				 */
+	__u32 xstate_size;	/* actual xsave state size, based on the
+				 * features saved in the layout.
+				 * 'extended_size' will be greater than
+				 * 'xstate_size'.
+				 */
+	__u32 padding[7];	/*  for future use. */
+};
+
 #ifdef __i386__
 /*
  * As documented in the iBCS2 standard..
@@ -53,7 +87,13 @@
 	unsigned long	reserved;
 	struct _fpxreg	_fxsr_st[8];	/* FXSR FPU reg data is ignored */
 	struct _xmmreg	_xmm[8];
-	unsigned long	padding[56];
+	unsigned long	padding1[44];
+
+	union {
+		unsigned long	padding2[12];
+		struct _fpx_sw_bytes sw_reserved; /* represents the extended
+						   * state info */
+	};
 };
 
 #define X86_FXSR_MAGIC		0x0000
@@ -79,7 +119,14 @@
 	unsigned long flags;
 	unsigned long sp_at_signal;
 	unsigned short ss, __ssh;
-	struct _fpstate __user *fpstate;
+
+ 	/* fpstate is really (struct _fpstate *) or (struct _xstate *)
+	 * depending on the FP_XSTATE_MAGIC1 encoded in the SW reserved
+	 * bytes of (struct _fpstate) and FP_XSTATE_MAGIC2 present at the end
+	 * of extended memory layout. See comments at the defintion of
+	 * (struct _fpx_sw_bytes)
+	 */
+	void __user *fpstate;		/* zero when no FPU/extended context */
 	unsigned long oldmask;
 	unsigned long cr2;
 };
@@ -130,7 +177,12 @@
 	__u32	mxcsr_mask;
 	__u32	st_space[32];	/* 8*16 bytes for each FP-reg */
 	__u32	xmm_space[64];	/* 16*16 bytes for each XMM-reg  */
-	__u32	reserved2[24];
+	__u32	reserved2[12];
+	union {
+		__u32	reserved3[12];
+		struct _fpx_sw_bytes sw_reserved; /* represents the extended
+						   * state information */
+	};
 };
 
 #ifdef __KERNEL__
@@ -161,7 +213,14 @@
 	unsigned long trapno;
 	unsigned long oldmask;
 	unsigned long cr2;
-	struct _fpstate __user *fpstate;	/* zero when no FPU context */
+
+ 	/* fpstate is really (struct _fpstate *) or (struct _xstate *)
+	 * depending on the FP_XSTATE_MAGIC1 encoded in the SW reserved
+	 * bytes of (struct _fpstate) and FP_XSTATE_MAGIC2 present at the end
+	 * of extended memory layout. See comments at the defintion of
+	 * (struct _fpx_sw_bytes)
+	 */
+	void __user *fpstate;		/* zero when no FPU/extended context */
 	unsigned long reserved1[8];
 };
 #else /* __KERNEL__ */
@@ -202,4 +261,22 @@
 
 #endif /* !__i386__ */
 
+struct _xsave_hdr {
+	u64 xstate_bv;
+	u64 reserved1[2];
+	u64 reserved2[5];
+};
+
+/*
+ * Extended state pointed by the fpstate pointer in the sigcontext.
+ * In addition to the fpstate, information encoded in the xstate_hdr
+ * indicates the presence of other extended state information
+ * supported by the processor and OS.
+ */
+struct _xstate {
+	struct _fpstate fpstate;
+	struct _xsave_hdr xstate_hdr;
+	/* new processor state extensions go here */
+};
+
 #endif /* ASM_X86__SIGCONTEXT_H */
Index: tip-0728/include/asm-x86/sigcontext32.h
===================================================================
--- tip-0728.orig/include/asm-x86/sigcontext32.h	2008-07-28 18:42:45.000000000 -0700
+++ tip-0728/include/asm-x86/sigcontext32.h	2008-07-28 18:43:47.000000000 -0700
@@ -40,7 +40,11 @@
 	__u32	reserved;
 	struct _fpxreg	_fxsr_st[8];
 	struct _xmmreg	_xmm[8];	/* It's actually 16 */
-	__u32	padding[56];
+	__u32	padding[44];
+	union {
+		__u32 padding2[12];
+		struct _fpx_sw_bytes sw_reserved;
+	};
 };
 
 struct sigcontext_ia32 {
Index: tip-0728/include/asm-x86/processor.h
===================================================================
--- tip-0728.orig/include/asm-x86/processor.h	2008-07-28 18:42:45.000000000 -0700
+++ tip-0728/include/asm-x86/processor.h	2008-07-28 18:43:47.000000000 -0700
@@ -327,7 +327,12 @@
 	/* 16*16 bytes for each XMM-reg = 256 bytes:			*/
 	u32			xmm_space[64];
 
-	u32			padding[24];
+	u32			padding[12];
+
+	union {
+		u32		padding1[12];
+		u32		sw_reserved[12];
+	};
 
 } __attribute__((aligned(16)));
 

-- 

