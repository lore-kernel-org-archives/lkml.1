Return-Path: <linux-kernel-owner+w=401wt.eu-S1765749AbYDQJWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765749AbYDQJWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760840AbYDQJL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:29 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59011
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763206AbYDQJLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:07 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 30/45] KVM: ia64: Prepare some structure and routines for kvm use
Date: Thu, 17 Apr 2008 12:10:35 +0300
Message-Id: <1208423450-29415-31-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Register structures are defined per SDM.
Add three small routines for kernel:
ia64_ttag, ia64_loadrs, ia64_flushrs

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-ia64/gcc_intrin.h |   12 ++++++++
 include/asm-ia64/processor.h  |   63 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/include/asm-ia64/gcc_intrin.h b/include/asm-ia64/gcc_intrin.h
index de2ed2c..2fe292c 100644
--- a/include/asm-ia64/gcc_intrin.h
+++ b/include/asm-ia64/gcc_intrin.h
@@ -21,6 +21,10 @@
 
 #define ia64_invala_fr(regnum)	asm volatile ("invala.e f%0" :: "i"(regnum))
 
+#define ia64_flushrs() asm volatile ("flushrs;;":::"memory")
+
+#define ia64_loadrs() asm volatile ("loadrs;;":::"memory")
+
 extern void ia64_bad_param_for_setreg (void);
 extern void ia64_bad_param_for_getreg (void);
 
@@ -517,6 +521,14 @@ do {										\
 #define ia64_ptrd(addr, size)						\
 	asm volatile ("ptr.d %0,%1" :: "r"(addr), "r"(size) : "memory")
 
+#define ia64_ttag(addr)							\
+({									  \
+	__u64 ia64_intri_res;						   \
+	asm volatile ("ttag %0=%1" : "=r"(ia64_intri_res) : "r" (addr));   \
+	ia64_intri_res;							 \
+})
+
+
 /* Values for lfhint in ia64_lfetch and ia64_lfetch_fault */
 
 #define ia64_lfhint_none   0
diff --git a/include/asm-ia64/processor.h b/include/asm-ia64/processor.h
index 741f7ec..6aff126 100644
--- a/include/asm-ia64/processor.h
+++ b/include/asm-ia64/processor.h
@@ -119,6 +119,69 @@ struct ia64_psr {
 	__u64 reserved4 : 19;
 };
 
+union ia64_isr {
+	__u64  val;
+	struct {
+		__u64 code : 16;
+		__u64 vector : 8;
+		__u64 reserved1 : 8;
+		__u64 x : 1;
+		__u64 w : 1;
+		__u64 r : 1;
+		__u64 na : 1;
+		__u64 sp : 1;
+		__u64 rs : 1;
+		__u64 ir : 1;
+		__u64 ni : 1;
+		__u64 so : 1;
+		__u64 ei : 2;
+		__u64 ed : 1;
+		__u64 reserved2 : 20;
+	};
+};
+
+union ia64_lid {
+	__u64 val;
+	struct {
+		__u64  rv  : 16;
+		__u64  eid : 8;
+		__u64  id  : 8;
+		__u64  ig  : 32;
+	};
+};
+
+union ia64_tpr {
+	__u64 val;
+	struct {
+		__u64 ig0 : 4;
+		__u64 mic : 4;
+		__u64 rsv : 8;
+		__u64 mmi : 1;
+		__u64 ig1 : 47;
+	};
+};
+
+union ia64_itir {
+	__u64 val;
+	struct {
+		__u64 rv3  :  2; /* 0-1 */
+		__u64 ps   :  6; /* 2-7 */
+		__u64 key  : 24; /* 8-31 */
+		__u64 rv4  : 32; /* 32-63 */
+	};
+};
+
+union  ia64_rr {
+	__u64 val;
+	struct {
+		__u64  ve	:  1;  /* enable hw walker */
+		__u64  reserved0:  1;  /* reserved */
+		__u64  ps	:  6;  /* log page size */
+		__u64  rid	: 24;  /* region id */
+		__u64  reserved1: 32;  /* reserved */
+	};
+};
+
 /*
  * CPU type, hardware bug flags, and per-CPU state.  Frequently used
  * state comes earlier:
-- 
1.5.5

