Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbZCMNN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbZCMNN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759086AbZCMNNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:13:44 -0400
Received: from ozlabs.org ([203.10.76.45]:33724 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759355AbZCMNNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:13:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Move numa_node_id default implementation to topology.h
Date: Fri, 13 Mar 2009 23:43:37 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
References: <200903121453.45163.rusty@rustcorp.com.au> <20090313052754.GA20389@elte.hu> <20090313053214.GA21183@elte.hu>
In-Reply-To: <20090313053214.GA21183@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903132343.37661.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, potential bugfix

Not sure what changed to expose this, but clearly that numa_node_id()
doesn't belong in mmzone.h (the inline in gfp.h is probably overkill, too).

In file included from include/linux/topology.h:34,
                 from arch/x86/mm/numa.c:2:
/home/rusty/patches-cpumask/linux-2.6/arch/x86/include/asm/topology.h:64:1: warning: "numa_node_id" redefined
In file included from include/linux/topology.h:32,
                 from arch/x86/mm/numa.c:2:
include/linux/mmzone.h:770:1: warning: this is the location of the previous definition

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -4,6 +4,7 @@
 #include <linux/mmzone.h>
 #include <linux/stddef.h>
 #include <linux/linkage.h>
+#include <linux/topology.h>
 
 struct vm_area_struct;
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -763,12 +763,6 @@ extern int numa_zonelist_order_handler(s
 			struct file *, void __user *, size_t *, loff_t *);
 extern char numa_zonelist_order[];
 #define NUMA_ZONELIST_ORDER_LEN 16	/* string buffer size */
-
-#include <linux/topology.h>
-/* Returns the number of the current Node. */
-#ifndef numa_node_id
-#define numa_node_id()		(cpu_to_node(raw_smp_processor_id()))
-#endif
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 
diff --git a/include/linux/topology.h b/include/linux/topology.h
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -196,4 +196,9 @@ int arch_update_cpu_topology(void);
 #define topology_core_cpumask(cpu)		cpumask_of(cpu)
 #endif
 
+/* Returns the number of the current Node. */
+#ifndef numa_node_id
+#define numa_node_id()		(cpu_to_node(raw_smp_processor_id()))
+#endif
+
 #endif /* _LINUX_TOPOLOGY_H */
