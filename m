Return-Path: <linux-kernel-owner+w=401wt.eu-S1760971AbYFXQsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971AbYFXQsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbYFXQsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:48:06 -0400
Received: from eucd.info ([88.191.250.43]:34521 "EHLO snail.fsffrance.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751280AbYFXQsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:48:05 -0400
X-Greylist: delayed 1361 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jun 2008 12:48:05 EDT
From: Segher Boessenkool <segher@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH] alpha: Fix percpu for !SMP
Date: Tue, 24 Jun 2008 18:25:12 +0200
Message-Id: <59ea9d21fca74a2e8ffec8384815d7c54c8b4a5c.1214324538.git.segher@kernel.crashing.org>
X-Mailer: git-send-email 1.5.5.1.g377d9.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9267b4b3880d00dc2dab90f1d817c856939114f7 introduced a
percpu.h for alpha.  It didn't define PER_CPU_ATTRIBUTES for
the non-SMP case, leading to build failures for such a config
(e.g., the alpha defconfig).

Fix this by defining PER_CPU_ATTRIBUTES to empty at the end of
asm-alpha/percpu.h if it wasn't already defined, just like the
asm-generic version does.  The SMP && !MODULE case can drop its
own definition now as well.

Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>
---

This is needed for 2.6.26, it's a regression fix.

 include/asm-alpha/percpu.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/asm-alpha/percpu.h b/include/asm-alpha/percpu.h
index 82e8a94..c3e2a1c 100644
--- a/include/asm-alpha/percpu.h
+++ b/include/asm-alpha/percpu.h
@@ -28,7 +28,6 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 
 #ifndef MODULE
 #define SHIFT_PERCPU_PTR(var, offset) RELOC_HIDE(&per_cpu_var(var), (offset))
-#define PER_CPU_ATTRIBUTES
 #else
 /*
  * To calculate addresses of locally defined variables, GCC uses 32-bit
@@ -73,4 +72,8 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu_var(name)
 
+#ifndef PER_CPU_ATTRIBUTES
+#define PER_CPU_ATTRIBUTES
+#endif
+
 #endif /* __ALPHA_PERCPU_H */
-- 
1.5.5.1.g377d9.dirty

