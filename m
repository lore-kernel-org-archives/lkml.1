Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbYI2TiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbYI2TiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 15:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYI2ThE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 15:37:04 -0400
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:51389 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbYI2ThD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 15:37:03 -0400
Message-Id: <20080929193515.737110249@quilx.com>
References: <20080929193500.470295078@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 12:35:01 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
CC: linux-mm@kvack.org
Cc: rusty@rustcorp.com.au
Cc: jeremy@goop.org
Cc: ebiederm@xmission.com
Cc: travis@sgi.com
Cc: herbert@gondor.apana.org.au
Cc: xemul@openvz.org
Cc: penberg@cs.helsinki.fi
Subject: [patch 1/4] Make the per cpu reserve configurable
Content-Disposition: inline; filename=cpu_alloc_configurable_percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The per cpu reserve from which loadable modules allocate their percpu sections
is currently fixed at 8000 bytes.

Add a new kernel parameter

	percpu=<dynamically allocatable percpu bytes>

The per cpu reserve area will be used in following patches by the
per cpu allocator.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/ia64/include/asm/percpu.h |    1 +
 include/linux/percpu.h         |    7 ++++++-
 init/main.c                    |   13 +++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2008-09-25 08:39:19.000000000 -0500
+++ linux-2.6/include/linux/percpu.h	2008-09-29 13:08:25.000000000 -0500
@@ -34,6 +34,7 @@
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
 
+extern unsigned int percpu_reserve;
 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_ENOUGH_ROOM
 #ifdef CONFIG_MODULES
@@ -43,7 +44,7 @@
 #endif
 
 #define PERCPU_ENOUGH_ROOM						\
-	(__per_cpu_end - __per_cpu_start + PERCPU_MODULE_RESERVE)
+	(__per_cpu_end - __per_cpu_start + percpu_reserve)
 #endif	/* PERCPU_ENOUGH_ROOM */
 
 /*
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c	2008-09-25 08:39:19.000000000 -0500
+++ linux-2.6/init/main.c	2008-09-29 13:09:13.000000000 -0500
@@ -253,6 +253,16 @@
 
 early_param("loglevel", loglevel);
 
+unsigned int percpu_reserve = PERCPU_MODULE_RESERVE;
+
+static int __init init_percpu_reserve(char *str)
+{
+	get_option(&str, &percpu_reserve);
+	return 0;
+}
+
+early_param("percpu", init_percpu_reserve);
+
 /*
  * Unknown boot options get handed to init, unless they look like
  * failed parameters
@@ -397,6 +407,9 @@
 
 	/* Copy section for each CPU (we discard the original) */
 	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
+	printk(KERN_INFO "percpu area: %d bytes total, %d available.\n",
+			size, size - (__per_cpu_end - __per_cpu_start));
+
 	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
 
 	for_each_possible_cpu(i) {
Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt	2008-09-25 08:39:19.000000000 -0500
+++ linux-2.6/Documentation/kernel-parameters.txt	2008-09-29 13:05:36.000000000 -0500
@@ -1643,6 +1643,13 @@
 			Format: { 0 | 1 }
 			See arch/parisc/kernel/pdc_chassis.c
 
+	percpu=		Configure the number of percpu bytes that can be
+			dynamically allocated. This is used for per cpu
+			variables of modules and other dynamic per cpu data
+			structures. Creation of per cpu structures after boot
+			may fail if this is set too low.
+			Default is 8000 bytes.
+
 	pf.		[PARIDE]
 			See Documentation/paride.txt.
 

-- 
