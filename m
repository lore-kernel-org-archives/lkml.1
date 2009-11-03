Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbZKCE2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbZKCE2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbZKCE2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:28:14 -0500
Received: from ozlabs.org ([203.10.76.45]:39487 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845AbZKCE2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:28:13 -0500
To: Andy Henroid <andrew.d.henroid@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911031458.17003.rusty@rustcorp.com.au>
Date: Tue, 3 Nov 2009 14:58:16 +1030
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/14] cpumask: convert drivers/idle/i7300_idle.c to cpumask_var_t
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fairly simple transformation:
1) cpumask_t -> cpumask_var_t and alloc_cpumask_var/free_cpumask_var
   (which are a NOOP unless CONFIG_CPUMASK_OFFSTACK=y).
2) cpu_set -> cpumask_set_cpu
3) cpus_weight -> cpumask_weight
4) cpu_clear -> cpumask_clear_cpu

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: Andy Henroid <andrew.d.henroid@intel.com>
---
 drivers/idle/i7300_idle.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/idle/i7300_idle.c b/drivers/idle/i7300_idle.c
--- a/drivers/idle/i7300_idle.c
+++ b/drivers/idle/i7300_idle.c
@@ -77,7 +77,7 @@ static u8 i7300_idle_thrtlow_saved;
 static u8 i7300_idle_thrtlow_saved;
 static u32 i7300_idle_mc_saved;
 
-static cpumask_t idle_cpumask;
+static cpumask_var_t idle_cpumask;
 static ktime_t start_ktime;
 static unsigned long avg_idle_us;
 
@@ -455,9 +455,9 @@ static int i7300_idle_notifier(struct no
 	spin_lock_irqsave(&i7300_idle_lock, flags);
 	if (val == IDLE_START) {
 
-		cpu_set(smp_processor_id(), idle_cpumask);
+		cpumask_set_cpu(smp_processor_id(), idle_cpumask);
 
-		if (cpus_weight(idle_cpumask) != num_online_cpus())
+		if (cpumask_weight(idle_cpumask) != num_online_cpus())
 			goto end;
 
 		now_ktime = ktime_get();
@@ -474,8 +474,8 @@ static int i7300_idle_notifier(struct no
 		i7300_idle_ioat_start();
 
 	} else if (val == IDLE_END) {
-		cpu_clear(smp_processor_id(), idle_cpumask);
-		if (cpus_weight(idle_cpumask) == (num_online_cpus() - 1)) {
+		cpumask_clear_cpu(smp_processor_id(), idle_cpumask);
+		if (cpumask_weight(idle_cpumask) == (num_online_cpus() - 1)) {
 			/* First CPU coming out of idle */
 			u64 idle_duration_us;
 
@@ -549,7 +549,6 @@ static int __init i7300_idle_init(void)
 static int __init i7300_idle_init(void)
 {
 	spin_lock_init(&i7300_idle_lock);
-	cpus_clear(idle_cpumask);
 	total_us = 0;
 
 	if (i7300_idle_platform_probe(&fbd_dev, &ioat_dev))
@@ -560,6 +559,9 @@ static int __init i7300_idle_init(void)
 
 	if (i7300_idle_ioat_init())
 		return -ENODEV;
+
+	if (!zalloc_cpumask_var(&idle_cpumask, GFP_KERNEL))
+		return -ENOMEM;
 
 	debugfs_dir = debugfs_create_dir("i7300_idle", NULL);
 	if (debugfs_dir) {
@@ -585,6 +587,7 @@ static void __exit i7300_idle_exit(void)
 static void __exit i7300_idle_exit(void)
 {
 	idle_notifier_unregister(&i7300_idle_nb);
+	free_cpumask_var(idle_cpumask);
 
 	if (debugfs_dir) {
 		int i = 0;

