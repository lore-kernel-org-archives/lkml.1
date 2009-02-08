Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZBHO7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZBHO7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 09:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZBHO6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 09:58:48 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:4065 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZBHO6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 09:58:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NHI+xvtN7Ruw/zLVXv6fT/omZuU3B0lybZkJpwDtEQr0HyeBnyeRFluQ6gwev5dUpy
         JBDQ3pXbX4YjYduK3u9nEPEYr+7/pX23Rnpg3MW0hVU0Eyk7y67jGMwym+wxJCIHAM1l
         qaCKUlCIIs8H356uwNcEwtdwbs6FetkJa0zSY=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] percpu: Make PER_CPU_BASE_SECTION overridable by arches
Date: Sun,  8 Feb 2009 09:58:38 -0500
Message-Id: <1234105120-19731-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bug fix

IA-64 needs to put percpu data in the seperate section even on UP.
Fixes regression caused by "percpu: refactor percpu.h"

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/include/asm/percpu.h |    4 ++--
 include/linux/percpu.h         |    8 +++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/include/asm/percpu.h b/arch/ia64/include/asm/percpu.h
index 77f30b6..30cf465 100644
--- a/arch/ia64/include/asm/percpu.h
+++ b/arch/ia64/include/asm/percpu.h
@@ -27,12 +27,12 @@ extern void *per_cpu_init(void);
 
 #else /* ! SMP */
 
-#define PER_CPU_ATTRIBUTES	__attribute__((__section__(".data.percpu")))
-
 #define per_cpu_init()				(__phys_per_cpu_start)
 
 #endif	/* SMP */
 
+#define PER_CPU_BASE_SECTION ".data.percpu"
+
 /*
  * Be extremely careful when taking the address of this variable!  Due to virtual
  * remapping, it is different from the canonical address returned by __get_cpu_var(var)!
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 0e24202..3577ffd 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -8,8 +8,15 @@
 
 #include <asm/percpu.h>
 
+#ifndef PER_CPU_BASE_SECTION
 #ifdef CONFIG_SMP
 #define PER_CPU_BASE_SECTION ".data.percpu"
+#else
+#define PER_CPU_BASE_SECTION ".data"
+#endif
+#endif
+
+#ifdef CONFIG_SMP
 
 #ifdef MODULE
 #define PER_CPU_SHARED_ALIGNED_SECTION ""
@@ -20,7 +27,6 @@
 
 #else
 
-#define PER_CPU_BASE_SECTION ".data"
 #define PER_CPU_SHARED_ALIGNED_SECTION ""
 #define PER_CPU_FIRST_SECTION ""
 
-- 
1.6.1

