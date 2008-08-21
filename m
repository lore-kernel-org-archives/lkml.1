Return-Path: <linux-kernel-owner+w=401wt.eu-S1757746AbYHUMuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbYHUMuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYHUMub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:50:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:46362 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbYHUMua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:50:30 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, linuxppc-dev@ozlabs.org
Subject: [PATCH] math-emu: Add support for reporting exact invalid exception
Date: Thu, 21 Aug 2008 07:50:21 -0500
Message-Id: <1219323021-7273-2-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1219323021-7273-1-git-send-email-galak@kernel.crashing.org>
References: <1219323021-7273-1-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures (like powerpc) provide status information on the exact
type of invalid exception.  This is pretty straight forward as we already
report invalid exceptions via FP_SET_EXCEPTION.

We add new flags (FP_EX_INVALID_*) the architecture code can define if it
wants the exact invalid exception reported.

We had to split out the INF/INF and 0/0 cases for divide to allow reporting
the two invalid forms properly.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
I intend these patches to go via the powerpc.git tree if no one has issues.

- k

 include/math-emu/op-common.h |   12 ++++++++----
 include/math-emu/soft-fp.h   |   19 +++++++++++++++++++
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/include/math-emu/op-common.h b/include/math-emu/op-common.h
index bb46e76..cc1ec39 100644
--- a/include/math-emu/op-common.h
+++ b/include/math-emu/op-common.h
@@ -73,7 +73,7 @@ do {									\
 	X##_c = FP_CLS_NAN;						\
 	/* Check for signaling NaN */					\
 	if (!(_FP_FRAC_HIGH_RAW_##fs(X) & _FP_QNANBIT_##fs))		\
-	  FP_SET_EXCEPTION(FP_EX_INVALID);				\
+	  FP_SET_EXCEPTION(FP_EX_INVALID | FP_EX_INVALID_SNAN);		\
       }									\
     break;								\
   }									\
@@ -324,7 +324,7 @@ do {									     \
 	_FP_FRAC_SET_##wc(R, _FP_NANFRAC_##fs);				     \
 	R##_s = _FP_NANSIGN_##fs;					     \
 	R##_c = FP_CLS_NAN;						     \
-	FP_SET_EXCEPTION(FP_EX_INVALID);				     \
+	FP_SET_EXCEPTION(FP_EX_INVALID | FP_EX_INVALID_ISI);		     \
 	break;								     \
       }									     \
     /* FALLTHRU */							     \
@@ -431,7 +431,7 @@ do {							\
     R##_s = _FP_NANSIGN_##fs;				\
     R##_c = FP_CLS_NAN;					\
     _FP_FRAC_SET_##wc(R, _FP_NANFRAC_##fs);		\
-    FP_SET_EXCEPTION(FP_EX_INVALID);			\
+    FP_SET_EXCEPTION(FP_EX_INVALID | FP_EX_INVALID_IMZ);\
     break;						\
 							\
   default:						\
@@ -490,11 +490,15 @@ do {							\
     break;						\
 							\
   case _FP_CLS_COMBINE(FP_CLS_INF,FP_CLS_INF):		\
+    R##_s = _FP_NANSIGN_##fs;				\
+    R##_c = FP_CLS_NAN;					\
+    _FP_FRAC_SET_##wc(R, _FP_NANFRAC_##fs);		\
+    FP_SET_EXCEPTION(FP_EX_INVALID | FP_EX_INVALID_IDI);\
   case _FP_CLS_COMBINE(FP_CLS_ZERO,FP_CLS_ZERO):	\
     R##_s = _FP_NANSIGN_##fs;				\
     R##_c = FP_CLS_NAN;					\
     _FP_FRAC_SET_##wc(R, _FP_NANFRAC_##fs);		\
-    FP_SET_EXCEPTION(FP_EX_INVALID);			\
+    FP_SET_EXCEPTION(FP_EX_INVALID | FP_EX_INVALID_ZDZ);\
     break;						\
 							\
   default:						\
diff --git a/include/math-emu/soft-fp.h b/include/math-emu/soft-fp.h
index a6f873b..3f284bc 100644
--- a/include/math-emu/soft-fp.h
+++ b/include/math-emu/soft-fp.h
@@ -51,6 +51,25 @@
 #ifndef FP_EX_INVALID
 #define FP_EX_INVALID		0
 #endif
+#ifndef FP_EX_INVALID_SNAN
+#define FP_EX_INVALID_SNAN	0
+#endif
+/* inf - inf */
+#ifndef FP_EX_INVALID_ISI
+#define FP_EX_INVALID_ISI	0
+#endif
+/* inf / inf */
+#ifndef FP_EX_INVALID_IDI
+#define FP_EX_INVALID_IDI	0
+#endif
+/* 0 / 0 */
+#ifndef FP_EX_INVALID_ZDZ
+#define FP_EX_INVALID_ZDZ	0
+#endif
+/* inf * 0 */
+#ifndef FP_EX_INVALID_IMZ
+#define FP_EX_INVALID_IMZ	0
+#endif
 #ifndef FP_EX_OVERFLOW
 #define FP_EX_OVERFLOW		0
 #endif
-- 
1.5.5.1

