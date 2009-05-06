Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbZEFMsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbZEFMsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759463AbZEFMsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:48:16 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:6672 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759451AbZEFMsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:48:14 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KJ83JS-02-AB6-01
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] x86/oprofile: add module parameter option to force a core 2 cpu
Date: Wed, 6 May 2009 14:39:14 +0200
Message-ID: <1241613554-31539-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241613554-31539-1-git-send-email-robert.richter@amd.com>
References: <1241613554-31539-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 06 May 2009 12:47:35.0439 (UTC) FILETIME=[D47849F0:01C9CE48]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current userland does not yet fully support all cpu types
implemented in the kernel. With the module parameter:

 oprofile.cpu_type=core_2

the kernel reports a core_2 cpu to the userland on an Intel system and
thus makes oprofile usable with current distros.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 Documentation/kernel-parameters.txt |    3 ++-
 arch/x86/oprofile/nmi_int.c         |   17 ++++++++++++++---
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6ce5f48..ea7ead3 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1653,10 +1653,11 @@ and is between 256 and 4096 characters. It is defined in the file
 	oprofile.cpu_type=	Force an oprofile cpu type
 			This might be useful if you have an older oprofile
 			userland or if you want common events.
-			Format: { archperfmon }
+			Format: { archperfmon | core_2 }
 			archperfmon: [X86] Force use of architectural
 				perfmon on Intel CPUs instead of the
 				CPU specific event set.
+			core_2: [X86] On Intel systems: report core_2 CPU.
 
 	osst=		[HW,SCSI] SCSI Tape Driver
 			Format: <buffer_size>,<write_threshold>
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 3b285e6..d7348a2 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -386,12 +386,20 @@ static int __init p4_init(char **cpu_type)
 	return 0;
 }
 
-static int force_arch_perfmon;
+static enum {
+	NONE = 0,
+	ARCH_PERFMON,
+	CORE_2,
+} forced_cpu;
+
 static int force_cpu_type(const char *str, struct kernel_param *kp)
 {
 	if (!strcmp(str, "archperfmon")) {
-		force_arch_perfmon = 1;
+		forced_cpu = ARCH_PERFMON;
 		printk(KERN_INFO "oprofile: forcing architectural perfmon\n");
+	} else if (!strcmp(str, "core_2")) {
+		forced_cpu = CORE_2;
+		printk(KERN_INFO "oprofile: forcing core_2\n");
 	}
 
 	return 0;
@@ -402,9 +410,12 @@ static int __init ppro_init(char **cpu_type)
 {
 	__u8 cpu_model = boot_cpu_data.x86_model;
 
-	if (force_arch_perfmon && cpu_has_arch_perfmon)
+	if (forced_cpu == ARCH_PERFMON && cpu_has_arch_perfmon)
 		return 0;
 
+	if (forced_cpu == CORE_2)
+		cpu_model = 15;
+
 	switch (cpu_model) {
 	case 0 ... 2:
 		*cpu_type = "i386/ppro";
-- 
1.6.1.3


