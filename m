Return-Path: <linux-kernel-owner+w=401wt.eu-S1764491AbYARScD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764491AbYARScD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:32:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762293AbYARSaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:30:05 -0500
Received: from relay1.sgi.com ([192.48.171.29]:39510 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764009AbYARS3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:29:55 -0500
Message-Id: <20080118182954.718110000@sgi.com>
References: <20080118182953.748071000@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jan 2008 10:30:00 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] percpu: Add debug detection of uninitialized usage of per_cpu variable
Content-Disposition: inline; filename=debug-percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a means to trap usages of per_cpu variables before
the per_cpu_areas are setup.  Define CONFIG_DEBUG_PER_CPU to activate.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/asm-generic/percpu.h |   11 ++++++++++-
 lib/Kconfig.debug            |   12 ++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -47,12 +47,21 @@ extern unsigned long __per_cpu_offset[NR
 #endif
 
 /*
- * A percpu variable may point to a discarded reghions. The following are
+ * A percpu variable may point to a discarded regions. The following are
  * established ways to produce a usable pointer from the percpu variable
  * offset.
  */
+#ifdef	CONFIG_DEBUG_PER_CPU
+#define per_cpu(var, cpu) (*({		\
+	if(!per_cpu_offset(cpu)) {	\
+		printk("KERN_NOTICE per_cpu(%s,%d): not available!\n", #var, (int)cpu); \
+		BUG();			\
+	}				\
+	SHIFT_PERCPU_PTR(&per_cpu_var(var), per_cpu_offset(cpu));}))
+#else
 #define per_cpu(var, cpu) \
 	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), per_cpu_offset(cpu)))
+#endif
 #define __get_cpu_var(var) \
 	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), my_cpu_offset))
 #define __raw_get_cpu_var(var) \
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -610,6 +610,18 @@ config PROVIDE_OHCI1394_DMA_INIT
 
 	  See Documentation/debugging-via-ohci1394.txt for more information.
 
+config DEBUG_PER_CPU
+	bool "Debug per_cpu usage"
+	depends on DEBUG_KERNEL
+	depends on SMP
+	default n
+	help
+	  Say Y here to add code that verifies the per_cpu area is
+	  setup before accessing a per_cpu variable.  It does add a
+	  significant amount of code to kernel memory.
+
+	  If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"

-- 
