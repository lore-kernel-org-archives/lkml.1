Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbXHWBsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbXHWBsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 21:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXHWBsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 21:48:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50634 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbXHWBsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 21:48:23 -0400
Date: Thu, 23 Aug 2007 07:31:12 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andi Kleen <ak@suse.de>
cc: Jacob Shin <jacob.shin@amd.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86_64 mce{_amd}: Fix section mismatch warnings
Message-ID: <alpine.LFD.0.999.0708230729070.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* mce.c:

mce_create_device() is marked __cpuinit and hence goes into .init.text
when HOTPLUG_CPU=n. However, the hotplug notifier callback function
mce_cpu_callback() is not marked __cpuinit therefore goes into .text
section unconditionally. This causes reference to .init.text from .text
which would cause modpost to warn (bogusly, because a CPU hotplug event
can never happen anyway if HOTPLUG_CPU=n). Anyway, let's fix this by
marking callback as __cpuinit and the notifier_block as __cpuinitdata.
Having done that, mce_remove_device() is only ever called from __cpuinit
marked functions so can be marked __cpuinit itself.

* mce_amd.c:

Has an exactly similar section mismatch as that discussed in previous
case. Solve it similarly by marking notifier callback as __cpuinit and
notifier_block as __cpuinitdata. This causes a viral effect and allows
us to mark a bunch of other functions as __cpuinit also.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

[ I don't have x86_64 toolchain, but it's still obvious enough to me
  that the existing code would cause said section mismatch warnings. ]

 arch/x86_64/kernel/mce.c     |    6 +++---
 arch/x86_64/kernel/mce_amd.c |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86_64/kernel/mce.c b/arch/x86_64/kernel/mce.c
index a66d607..5c0c4ee 100644
--- a/arch/x86_64/kernel/mce.c
+++ b/arch/x86_64/kernel/mce.c
@@ -820,7 +820,7 @@ static __cpuinit int mce_create_device(unsigned int cpu)
 	return err;
 }
 
-static void mce_remove_device(unsigned int cpu)
+static void __cpuinit mce_remove_device(unsigned int cpu)
 {
 	int i;
 
@@ -832,7 +832,7 @@ static void mce_remove_device(unsigned int cpu)
 }
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
-static int
+static int __cpuinit
 mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
@@ -850,7 +850,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
-static struct notifier_block mce_cpu_notifier = {
+static struct notifier_block mce_cpu_notifier __cpuinitdata = {
 	.notifier_call = mce_cpu_callback,
 };
 
diff --git a/arch/x86_64/kernel/mce_amd.c b/arch/x86_64/kernel/mce_amd.c
index 2f8a7f1..364c80b 100644
--- a/arch/x86_64/kernel/mce_amd.c
+++ b/arch/x86_64/kernel/mce_amd.c
@@ -569,7 +569,7 @@ out:
  *   of shared sysfs dir/files, and rest of the cores will be symlinked to it.
  */
 
-static void deallocate_threshold_block(unsigned int cpu,
+static void __cpuinit deallocate_threshold_block(unsigned int cpu,
 						 unsigned int bank)
 {
 	struct threshold_block *pos = NULL;
@@ -589,7 +589,7 @@ static void deallocate_threshold_block(unsigned int cpu,
 	per_cpu(threshold_banks, cpu)[bank]->blocks = NULL;
 }
 
-static void threshold_remove_bank(unsigned int cpu, int bank)
+static void __cpuinit threshold_remove_bank(unsigned int cpu, int bank)
 {
 	int i = 0;
 	struct threshold_bank *b;
@@ -631,7 +631,7 @@ free_out:
 	per_cpu(threshold_banks, cpu)[bank] = NULL;
 }
 
-static void threshold_remove_device(unsigned int cpu)
+static void __cpuinit threshold_remove_device(unsigned int cpu)
 {
 	unsigned int bank;
 
@@ -643,7 +643,7 @@ static void threshold_remove_device(unsigned int cpu)
 }
 
 /* get notified when a cpu comes on/off */
-static int threshold_cpu_callback(struct notifier_block *nfb,
+static int __cpuinit threshold_cpu_callback(struct notifier_block *nfb,
 					    unsigned long action, void *hcpu)
 {
 	/* cpu was unsigned int to begin with */
@@ -668,7 +668,7 @@ static int threshold_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block threshold_cpu_notifier = {
+static struct notifier_block threshold_cpu_notifier __cpuinitdata = {
 	.notifier_call = threshold_cpu_callback,
 };
 
