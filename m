Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbYIRXpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbYIRXpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYIRXpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:45:11 -0400
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:46450 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbYIRXpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:45:10 -0400
Message-Id: <20080918233701.127757960@quilx.com>
References: <20080918233648.581696416@quilx.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Sep 2008 16:36:49 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
CC: linux-mm@vger.kernel.org
Cc: jeremy@goop.org
Cc: ebiederm@xmission.com
Cc: travis@sgi.com
Cc: herbert@gondor.apana.org.au
Cc: xemul@openvz.org
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
--- linux-2.6.orig/include/linux/percpu.h	2008-09-16 18:14:58.000000000 -0700
+++ linux-2.6/include/linux/percpu.h	2008-09-16 18:21:01.000000000 -0700
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
--- linux-2.6.orig/init/main.c	2008-09-16 18:14:59.000000000 -0700
+++ linux-2.6/init/main.c	2008-09-16 18:24:12.000000000 -0700
@@ -253,6 +253,16 @@ static int __init loglevel(char *str)
 
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
@@ -397,6 +407,9 @@ static void __init setup_per_cpu_areas(v
 
 	/* Copy section for each CPU (we discard the original) */
 	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
+	printk(KERN_INFO "percpu area: %d bytes total, %d available.\n",
+			size, size - (__per_cpu_end - __per_cpu_start));
+
 	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
 
 	for_each_possible_cpu(i) {
Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt	2008-09-16 18:14:59.000000000 -0700
+++ linux-2.6/Documentation/kernel-parameters.txt	2008-09-16 18:20:08.000000000 -0700
@@ -1643,6 +1643,13 @@ and is between 256 and 4096 characters. 
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
