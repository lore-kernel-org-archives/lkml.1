Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbZDLLOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbZDLLOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 07:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759616AbZDLLOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 07:14:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:54125 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbZDLLOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 07:14:05 -0400
Date: Sun, 12 Apr 2009 11:12:34 GMT
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1239402084.27006.8057.camel@localhost.localdomain>
References: <1239402084.27006.8057.camel@localhost.localdomain>
Subject: [tip:x86/urgent] x86: add linux kernel support for YMM state
Message-ID: <tip-a30469e7921a6dd2067e9e836d7787cfa0105627@git.kernel.org>
Git-Commit-ID: a30469e7921a6dd2067e9e836d7787cfa0105627
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 11:12:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a30469e7921a6dd2067e9e836d7787cfa0105627
Gitweb:     http://git.kernel.org/tip/a30469e7921a6dd2067e9e836d7787cfa0105627
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 10 Apr 2009 15:21:24 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 13:08:56 +0200

x86: add linux kernel support for YMM state

Impact: save/restore Intel-AVX state properly between tasks

Intel Advanced Vector Extensions (AVX) introduce 256-bit vector processing
capability. More about AVX at http://software.intel.com/sites/avx

Add OS support for YMM state management using xsave/xrstor infrastructure
to support AVX.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1239402084.27006.8057.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/processor.h  |    6 ++++++
 arch/x86/include/asm/sigcontext.h |    6 ++++++
 arch/x86/include/asm/xsave.h      |    3 ++-
 arch/x86/kernel/xsave.c           |    2 +-
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 34c5237..fcf4d92 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -352,6 +352,11 @@ struct i387_soft_struct {
 	u32			entry_eip;
 };
 
+struct ymmh_struct {
+	/* 16 * 16 bytes for each YMMH-reg = 256 bytes */
+	u32 ymmh_space[64];
+};
+
 struct xsave_hdr_struct {
 	u64 xstate_bv;
 	u64 reserved1[2];
@@ -361,6 +366,7 @@ struct xsave_hdr_struct {
 struct xsave_struct {
 	struct i387_fxsave_struct i387;
 	struct xsave_hdr_struct xsave_hdr;
+	struct ymmh_struct ymmh;
 	/* new processor state extensions will go here */
 } __attribute__ ((packed, aligned (64)));
 
diff --git a/arch/x86/include/asm/sigcontext.h b/arch/x86/include/asm/sigcontext.h
index ec66649..72e5a44 100644
--- a/arch/x86/include/asm/sigcontext.h
+++ b/arch/x86/include/asm/sigcontext.h
@@ -269,6 +269,11 @@ struct _xsave_hdr {
 	__u64 reserved2[5];
 };
 
+struct _ymmh_state {
+	/* 16 * 16 bytes for each YMMH-reg */
+	__u32 ymmh_space[64];
+};
+
 /*
  * Extended state pointed by the fpstate pointer in the sigcontext.
  * In addition to the fpstate, information encoded in the xstate_hdr
@@ -278,6 +283,7 @@ struct _xsave_hdr {
 struct _xstate {
 	struct _fpstate fpstate;
 	struct _xsave_hdr xstate_hdr;
+	struct _ymmh_state ymmh;
 	/* new processor state extensions go here */
 };
 
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 08e9a1a..727acc1 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -7,6 +7,7 @@
 
 #define XSTATE_FP	0x1
 #define XSTATE_SSE	0x2
+#define XSTATE_YMM	0x4
 
 #define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
 
@@ -15,7 +16,7 @@
 /*
  * These are the features that the OS can handle currently.
  */
-#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE)
+#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
 
 #ifdef CONFIG_X86_64
 #define REX_PREFIX	"0x48, "
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 2b54fe0..0a5b04a 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -324,7 +324,7 @@ void __ref xsave_cntxt_init(void)
 	}
 
 	/*
-	 * for now OS knows only about FP/SSE
+	 * Support only the state known to OS.
 	 */
 	pcntxt_mask = pcntxt_mask & XCNTXT_MASK;
 	xsave_init();
