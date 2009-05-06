Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbZEFMsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbZEFMsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757109AbZEFMsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:48:06 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:51132
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754086AbZEFMsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:48:04 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KJ83JB-04-ZDF-01
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] oprofile: introduce module_param oprofile.cpu_type
Date: Wed, 6 May 2009 14:39:13 +0200
Message-ID: <1241613554-31539-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241613554-31539-1-git-send-email-robert.richter@amd.com>
References: <1241613554-31539-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 06 May 2009 12:47:35.0189 (UTC) FILETIME=[D4522450:01C9CE48]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes module_param oprofile.force_arch_perfmon and
introduces oprofile.cpu_type=archperfmon instead. This new parameter
can be reused for other models and architectures.

Currently only archperfmon is supported.

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 Documentation/kernel-parameters.txt |   12 +++++++-----
 arch/x86/oprofile/nmi_int.c         |   13 +++++++++++--
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9b9566b..6ce5f48 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1650,11 +1650,13 @@ and is between 256 and 4096 characters. It is defined in the file
 	oprofile.timer=	[HW]
 			Use timer interrupt instead of performance counters
 
-	oprofile.force_arch_perfmon=1	[X86]
-			Force use of architectural perfmon instead of
-			the CPU specific event set.
-			This might be useful if you have older oprofile
-			userland or if you want common events over Intel CPUs.
+	oprofile.cpu_type=	Force an oprofile cpu type
+			This might be useful if you have an older oprofile
+			userland or if you want common events.
+			Format: { archperfmon }
+			archperfmon: [X86] Force use of architectural
+				perfmon on Intel CPUs instead of the
+				CPU specific event set.
 
 	osst=		[HW,SCSI] SCSI Tape Driver
 			Format: <buffer_size>,<write_threshold>
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 3308147..3b285e6 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -386,8 +386,17 @@ static int __init p4_init(char **cpu_type)
 	return 0;
 }
 
-int force_arch_perfmon;
-module_param(force_arch_perfmon, int, 0);
+static int force_arch_perfmon;
+static int force_cpu_type(const char *str, struct kernel_param *kp)
+{
+	if (!strcmp(str, "archperfmon")) {
+		force_arch_perfmon = 1;
+		printk(KERN_INFO "oprofile: forcing architectural perfmon\n");
+	}
+
+	return 0;
+}
+module_param_call(cpu_type, force_cpu_type, NULL, NULL, 0);
 
 static int __init ppro_init(char **cpu_type)
 {
-- 
1.6.1.3


