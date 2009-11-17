Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbZKQJZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbZKQJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 04:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZKQJZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 04:25:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:46307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbZKQJZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 04:25:24 -0500
Date: Tue, 17 Nov 2009 09:24:36 GMT
From: tip-bot for Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       travis@sgi.com, andreas.herrmann3@amd.com, tigran@aivazian.fsnet.co.uk,
       steiner@sgi.com, dmitry.adamushko@gmail.com,
       herrmann.der.user@googlemail.com, tglx@linutronix.de, mingo@elte.hu,
       andi@lisas.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, travis@sgi.com, tigran@aivazian.fsnet.co.uk,
       steiner@sgi.com, dmitry.adamushko@gmail.com,
       herrmann.der.user@googlemail.com, tglx@linutronix.de,
       borislav.petkov@amd.com, andi@lisas.de, mingo@elte.hu
In-Reply-To: <20091117070638.GA27691@alberich.amd.com>
References: <20091117070638.GA27691@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86: ucode-amd: Move family check to microcde_amd.c's init function
Message-ID: <tip-8cc2361bd00e87aab2827a3996a71fe9b2c9f9c4@git.kernel.org>
Git-Commit-ID: 8cc2361bd00e87aab2827a3996a71fe9b2c9f9c4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8cc2361bd00e87aab2827a3996a71fe9b2c9f9c4
Gitweb:     http://git.kernel.org/tip/8cc2361bd00e87aab2827a3996a71fe9b2c9f9c4
Author:     Andreas Herrmann <herrmann.der.user@googlemail.com>
AuthorDate: Tue, 17 Nov 2009 08:06:38 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 10:10:40 +0100

x86: ucode-amd: Move family check to microcde_amd.c's init function

... to avoid useless trial to load firmware on systems with
unsupported AMD CPUs.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20091117070638.GA27691@alberich.amd.com>
[ v2: changed BUG_ON() to WARN_ON() ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/microcode_amd.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 26e33bd..63123d9 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -34,6 +34,7 @@ MODULE_LICENSE("GPL v2");
 #define UCODE_UCODE_TYPE           0x00000001
 
 const struct firmware *firmware;
+static int supported_cpu;
 
 struct equiv_cpu_entry {
 	u32	installed_cpu;
@@ -73,15 +74,12 @@ static struct equiv_cpu_entry *equiv_cpu_table;
 
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	u32 dummy;
 
-	memset(csig, 0, sizeof(*csig));
-	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
-		pr_warning("microcode: CPU%d: AMD CPU family 0x%x not "
-			   "supported\n", cpu, c->x86);
+	if (!supported_cpu)
 		return -1;
-	}
+
+	memset(csig, 0, sizeof(*csig));
 	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
 	pr_info("microcode: CPU%d: patch_level=0x%x\n", cpu, csig->rev);
 	return 0;
@@ -331,6 +329,17 @@ static void microcode_fini_cpu_amd(int cpu)
 void init_microcode_amd(struct device *device)
 {
 	const char *fw_name = "amd-ucode/microcode_amd.bin";
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	WARN_ON(c->x86_vendor != X86_VENDOR_AMD);
+
+	if (c->x86 < 0x10) {
+		pr_warning("microcode: AMD CPU family 0x%x not supported\n",
+			   c->x86);
+		return;
+	}
+	supported_cpu = 1;
+
 	if (request_firmware(&firmware, fw_name, device))
 		pr_err("microcode: failed to load file %s\n", fw_name);
 }
