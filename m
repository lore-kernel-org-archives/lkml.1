Return-Path: <linux-kernel-owner+w=401wt.eu-S1761291AbYFZTxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291AbYFZTxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbYFZTxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:53:31 -0400
Received: from ns2.suse.de ([195.135.220.15]:40929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbYFZTxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:53:30 -0400
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org
Cc: vgoyal@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] x86: Find offset for crashkernel reservation automatically
Date: Thu, 26 Jun 2008 21:54:08 +0200
Message-Id: <1214510048-21215-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the need of the crashkernel=...@offset parameter to define
a fixed offset for crashkernel reservation. That feature can be used together
with a relocatable kernel where the kexec-tools relocate the kernel and
get the actual offset from /proc/iomem.

The use case is a kernel where the .text+.data+.bss is after 16M physical
memory (debug kernel with lockdep on x86_64 can cause that) which caused a
major pain in autoconfiguration in our distribution.

Also, that patch unifies crashdump architectures a bit since IA64 has
that semantics from the very beginning of the kdump port.

Please provide feedback!


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/x86/kernel/setup.c |   70 +++++++++++++++++++++++++++++++++++------------
 1 files changed, 52 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a81d82c..c30bb7b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -435,6 +435,34 @@ static inline unsigned long long get_total_mem(void)
 }
 
 #ifdef CONFIG_KEXEC
+
+/**
+ * Reserve @size bytes of crashkernel memory at any suitable offset.
+ *
+ * @size: Size of the crashkernel memory to reserve.
+ * Returns the base address on success, and -1ULL on failure.
+ */
+unsigned long long find_and_reserve_crashkernel(unsigned long long size)
+{
+	const unsigned long long alignment = 16<<20; 	/* 16M */
+	unsigned long long start = 0LL;
+
+	while (1) {
+		int ret;
+
+		start = find_e820_area(start, ULONG_MAX, size, alignment);
+		if (start == -1ULL)
+			return start;
+
+		/* try to reserve it */
+		ret = reserve_bootmem_generic(start, size, BOOTMEM_EXCLUSIVE);
+		if (ret >= 0)
+			return start;
+
+		start += alignment;
+	}
+}
+
 void __init reserve_crashkernel(void)
 {
 	unsigned long long total_mem;
@@ -445,30 +473,36 @@ void __init reserve_crashkernel(void)
 
 	ret = parse_crashkernel(boot_command_line, total_mem,
 			&crash_size, &crash_base);
-	if (ret == 0 && crash_size > 0) {
-		if (crash_base <= 0) {
-			printk(KERN_INFO "crashkernel reservation failed - "
-					"you have to specify a base address\n");
+	if (ret != 0 || crash_size <= 0)
+		return;
+
+	/* 0 means: find the address automatically */
+	if (crash_base <= 0) {
+		crash_base = find_and_reserve_crashkernel(crash_size);
+		if (crash_base == -1ULL) {
+			pr_info("crashkernel reservation failed. "
+				"No suitable area found.\n");
 			return;
 		}
-
-		if (reserve_bootmem_generic(crash_base, crash_size,
-					BOOTMEM_EXCLUSIVE) < 0) {
-			printk(KERN_INFO "crashkernel reservation failed - "
-					"memory is in use\n");
+	} else {
+		ret = reserve_bootmem_generic(crash_base, crash_size,
+					BOOTMEM_EXCLUSIVE);
+		if (ret < 0) {
+			pr_info("crashkernel reservation failed - "
+				"memory is in use\n");
 			return;
 		}
+	}
 
-		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
-				"for crashkernel (System RAM: %ldMB)\n",
-				(unsigned long)(crash_size >> 20),
-				(unsigned long)(crash_base >> 20),
-				(unsigned long)(total_mem >> 20));
+	printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+			"for crashkernel (System RAM: %ldMB)\n",
+			(unsigned long)(crash_size >> 20),
+			(unsigned long)(crash_base >> 20),
+			(unsigned long)(total_mem >> 20));
 
-		crashk_res.start = crash_base;
-		crashk_res.end   = crash_base + crash_size - 1;
-		insert_resource(&iomem_resource, &crashk_res);
-	}
+	crashk_res.start = crash_base;
+	crashk_res.end   = crash_base + crash_size - 1;
+	insert_resource(&iomem_resource, &crashk_res);
 }
 #else
 void __init reserve_crashkernel(void)
-- 
1.5.6

