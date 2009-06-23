Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZFWAzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZFWAzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 20:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZFWAyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 20:54:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:53025 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbZFWAyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 20:54:55 -0400
Subject: [PATCH] mm/init: cpu_hotplug_init() must be initialized before SLAB
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Sachin Sant <sachinp@in.ibm.com>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 10:31:29 +1000
Message-Id: <1245717089.4017.18.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLAB uses get/put_online_cpus() which use a mutex which is itself
only initialized when cpu_hotplug_init() is called. Currently
we hang suring boot in SLAB due to doing that too late. This
moves the call to cpu_hotplug_init() to before mm_init() (it
should be safe to call that early).

This fixes boot with SLAB on some PowerPC machines.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Sachin, James, do that fix the boot failures you've been seeing ?

Index: linux-work/init/main.c
===================================================================
--- linux-work.orig/init/main.c	2009-06-23 10:17:46.000000000 +1000
+++ linux-work/init/main.c	2009-06-23 10:20:30.000000000 +1000
@@ -608,7 +608,18 @@ asmlinkage void __init start_kernel(void
 	vfs_caches_init_early();
 	sort_main_extable();
 	trap_init();
+
+	/*
+	 * This initializes the mutex used by get/put_online_cpus()
+	 * which is used by SLAB
+	 */
+	cpu_hotplug_init();
+
+	/*
+	 * Initialize the page allocator, SL*B and vmalloc
+	 */
 	mm_init();
+
 	/*
 	 * Set up the scheduler prior starting any interrupts (such as the
 	 * timer interrupt). Full topology setup happens at smp_init()
@@ -678,7 +689,6 @@ asmlinkage void __init start_kernel(void
 #endif
 	page_cgroup_init();
 	enable_debug_pagealloc();
-	cpu_hotplug_init();
 	kmemtrace_init();
 	kmemleak_init();
 	debug_objects_mem_init();


