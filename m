Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYLGK4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYLGK4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 05:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYLGKzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 05:55:50 -0500
Received: from ozlabs.org ([203.10.76.45]:52308 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbYLGKzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 05:55:50 -0500
To: "kvm-devel" <kvm-devel@lists.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Avi Kivity <avi@qumranet.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 7 Dec 2008 21:25:45 +1030
Subject: [PATCH 2/2] kvm: use cpumask_var_t for cpus_hardware_enabled
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072125.45757.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes cpus_hardware_enabled from a cpumask_t to a cpumask_var_t:
equivalent for CONFIG_CPUMASKS_OFFSTACK=n, otherwise dynamically allocated.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 virt/kvm/kvm_main.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -63,7 +63,7 @@ DEFINE_SPINLOCK(kvm_lock);
 DEFINE_SPINLOCK(kvm_lock);
 LIST_HEAD(vm_list);
 
-static cpumask_t cpus_hardware_enabled;
+static cpumask_var_t cpus_hardware_enabled;
 
 struct kmem_cache *kvm_vcpu_cache;
 EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
@@ -1796,9 +1796,9 @@ static void hardware_enable(void *junk)
 {
 	int cpu = raw_smp_processor_id();
 
-	if (cpu_isset(cpu, cpus_hardware_enabled))
+	if (cpumask_test_cpu(cpu, cpus_hardware_enabled))
 		return;
-	cpu_set(cpu, cpus_hardware_enabled);
+	cpumask_set_cpu(cpu, cpus_hardware_enabled);
 	kvm_arch_hardware_enable(NULL);
 }
 
@@ -1806,9 +1806,9 @@ static void hardware_disable(void *junk)
 {
 	int cpu = raw_smp_processor_id();
 
-	if (!cpu_isset(cpu, cpus_hardware_enabled))
+	if (!cpumask_test_cpu(cpu, cpus_hardware_enabled))
 		return;
-	cpu_clear(cpu, cpus_hardware_enabled);
+	cpumask_clear_cpu(cpu, cpus_hardware_enabled);
 	kvm_arch_hardware_disable(NULL);
 }
 
@@ -2042,9 +2042,14 @@ int kvm_init(void *opaque, unsigned int 
 
 	bad_pfn = page_to_pfn(bad_page);
 
+	if (!alloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
+		r = -ENOMEM;
+		goto out_free_0;
+	}
+
 	r = kvm_arch_hardware_setup();
 	if (r < 0)
-		goto out_free_0;
+		goto out_free_0a;
 
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu,
@@ -2103,6 +2108,8 @@ out_free_2:
 	on_each_cpu(hardware_disable, NULL, 1);
 out_free_1:
 	kvm_arch_hardware_unsetup();
+out_free_0a:
+	free_cpumask_var(cpus_hardware_enabled);
 out_free_0:
 	__free_page(bad_page);
 out:
@@ -2126,6 +2133,7 @@ void kvm_exit(void)
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
 	kvm_exit_debug();
+	free_cpumask_var(cpus_hardware_enabled);
 	__free_page(bad_page);
 }
 EXPORT_SYMBOL_GPL(kvm_exit);

