Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875Ab0ARCCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0ARCCL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373Ab0ARCCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:02:10 -0500
Received: from ozlabs.org ([203.10.76.45]:47190 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab0ARCCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:02:09 -0500
Date: Mon, 18 Jan 2010 13:00:51 +1100
From: Anton Blanchard <anton@samba.org>
To: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>
Cc: miltonm@bga.com, linux-kernel@vger.kernel.org
Subject: [PATCH] generic-ipi: Use DEFINE_PER_CPU_SHARED_ALIGNED for IPI data
Message-ID: <20100118020051.GR12666@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milton Miller <miltonm@bga.com>

The smp ipi data is passed around and given write access by other cpus
and should be seperated from per-cpu data consumed by this cpu.

Looking for hot lines, I saw call_function_data shared with tick_cpu_sched.

Signed-off-by: Milton Miller <miltonm@bga.com>
Acked-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/kernel/smp.c
===================================================================
--- linux.trees.git.orig/kernel/smp.c	2010-01-18 12:41:28.000000000 +1100
+++ linux.trees.git/kernel/smp.c	2010-01-18 12:47:42.000000000 +1100
@@ -12,8 +12,6 @@
 #include <linux/smp.h>
 #include <linux/cpu.h>
 
-static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
-
 static struct {
 	struct list_head	queue;
 	raw_spinlock_t		lock;
@@ -33,12 +31,14 @@ struct call_function_data {
 	cpumask_var_t		cpumask;
 };
 
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
+
 struct call_single_queue {
 	struct list_head	list;
 	raw_spinlock_t		lock;
 };
 
-static DEFINE_PER_CPU(struct call_function_data, cfd_data);
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_queue, call_single_queue);
 
 static int
 hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
@@ -256,7 +256,7 @@ void generic_smp_call_function_single_in
 	}
 }
 
-static DEFINE_PER_CPU(struct call_single_data, csd_data);
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_data, csd_data);
 
 /*
  * smp_call_function_single - Run a function on a specific CPU
