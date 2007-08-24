Return-Path: <linux-kernel-owner+w=401wt.eu-S1764709AbXHXTRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764709AbXHXTRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbXHXTRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:17:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52818 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbXHXTRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:17:30 -0400
Date: Sat, 25 Aug 2007 01:00:23 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86_64 mce{_amd}: __cpuinit{data} section annotations
Message-ID: <alpine.LFD.0.999.0708250054060.19678@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

With the "redefine register_hotcpu_notifier() stub as static inline
function" patch gone, I can no longer reproduce the section mismatches
mentioned in: x86_64-mce_amd-fix-section-mismatch-warnings.patch
[ The section annotations of that patch still stand, just the changelog
  is no longer completely accurate. ]

If we care enough about this, I'm resubmitting that patch with updated
patch name and changelog here -- the content is same.

Satyam


[PATCH] x86_64 mce{_amd}: __cpuinit{data} section annotations

* mce.c:

CPU hotplug notifier callback function mce_cpu_callback() is not marked
__cpuinit and may thus go to the .text section unconditionally, but it
references mce_create_device() that is marked __cpuinit and may be
emitted into the .init.text section when HOTPLUG_CPU=n. This may cause
modpost to warn about this mismatch (in practice, though, the compiler
may elide the unreferenced callback function completely when
HOTPLUG_CPU=n therefore modpost may never warn).

Let us fix this by marking the callback as __cpuinit and corresponding
notifier_block as __cpuinitdata. Having done that, mce_remove_device()
is only ever called from __cpuinit marked functions so can be marked
__cpuinit itself.

* mce_amd.c:

Has an exactly similar issue as that discussed in previous case. Solve
it similarly by marking callback as __cpuinit and notifier_block as
__cpuinitdata. This causes a viral effect and allows us to mark a bunch
of other functions as __cpuinit also.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

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
 
