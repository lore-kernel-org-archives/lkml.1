Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYHSWQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYHSWQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYHSWQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:16:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:48856 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYHSWQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:16:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jkHCV4K6sJGV9cXqWpAyB1ejiHITKhUpi0Qd3oA3WdfWqu74zgEr/pa86J3rnDgY/w
         P2UGiTagENhQs2Y06lo9IOXxXNlOs/hkg4Ndjt+Z05kPQj/YNkoa+Q32lrUdRdFu8r1U
         x4e0ZjqadKGLyvFS4fsaeo9zOqUhHNpb9UUH0=
Subject: [1/2 -tip, BUG-fix] x86-microcode: fix unbalanced use of get_cpu()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Oruba <peter.oruba@amd.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Max Krasnyansky <maxk@qualcomm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 00:16:13 +0200
Message-Id: <1219184173.10426.33.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

Subject: x86-microcode: fix unbalanced use of get_cpu()

Don't use get_cpu() at all. Resort to checking a boot-up CPU (#0) in
microcode_{intel,amd}_module_init().

---

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>


commit 9375be36d98cdaecefbd98904609f1aee0d50367
Author: dimm <dimm@earth.(none)>
Date:   Tue Aug 19 22:40:41 2008 +0200

    microcode: bug-fix

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 33b2a21..a6e76cc 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -500,13 +500,15 @@ static struct microcode_ops microcode_amd_ops = {
 
 static int __init microcode_amd_module_init(void)
 {
-	struct cpuinfo_x86 *c = &cpu_data(get_cpu());
+	struct cpuinfo_x86 *c = &cpu_data(0);
 
 	equiv_cpu_table = NULL;
-	if (c->x86_vendor == X86_VENDOR_AMD)
-		return microcode_init(&microcode_amd_ops, THIS_MODULE);
-	else
+	if (c->x86_vendor != X86_VENDOR_AMD) {
+		printk(KERN_ERR "microcode: CPU platform is not AMD-capable\n");
 		return -ENODEV;
+	}
+
+	return microcode_init(&microcode_amd_ops, THIS_MODULE);
 }
 
 static void __exit microcode_amd_module_exit(void)
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index d2d9d74..6dd8907 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -531,12 +531,14 @@ static struct microcode_ops microcode_intel_ops = {
 
 static int __init microcode_intel_module_init(void)
 {
-	struct cpuinfo_x86 *c = &cpu_data(get_cpu());
+	struct cpuinfo_x86 *c = &cpu_data(0);
 
-	if (c->x86_vendor == X86_VENDOR_INTEL)
-		return microcode_init(&microcode_intel_ops, THIS_MODULE);
-	else
+	if (c->x86_vendor != X86_VENDOR_INTEL) {
+                printk(KERN_ERR "microcode: CPU platform is not Intel-capable\n");
 		return -ENODEV;
+	}
+
+	return microcode_init(&microcode_intel_ops, THIS_MODULE);
 }
 
 static void __exit microcode_intel_module_exit(void)


