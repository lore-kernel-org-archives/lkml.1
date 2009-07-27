Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbZG0SA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbZG0SA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbZG0SA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:00:56 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:45086 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752668AbZG0SAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:00:55 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2009 14:00:54 EDT
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNGBZU-04-P6Q-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] x86: fix section mismatch for i386 init code
Date: Mon, 27 Jul 2009 19:43:52 +0200
Message-ID: <1248716632-26844-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 27 Jul 2009 17:45:34.0238 (UTC) FILETIME=[0AF003E0:01CA0EE2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Startup code for i386 in arch/x86/kernel/head_32.S is using the
reference variable initial_code that is located in the .cpuinit.data
section. If CONFIG_HOTPLUG_CPU is enabled, startup code is not in an
init section and can be called later too. In this case the reference
initial_code must be kept too. This patch fixes this. See below for
the section mismatch warning.

 WARNING: vmlinux.o(.cpuinit.data+0x0): Section mismatch in reference from the variable initial_code to the function .init.text:i386_start_kernel()
 The variable __cpuinitdata initial_code references
 a function __init i386_start_kernel().
 If i386_start_kernel is only used by initial_code then
 annotate i386_start_kernel with a matching annotation.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/head_32.S |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 8663afb..0d98a01 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -602,7 +602,11 @@ ignore_int:
 #endif
 	iret
 
-.section .cpuinit.data,"wa"
+#ifndef CONFIG_HOTPLUG_CPU
+	__CPUINITDATA
+#else
+	__REFDATA
+#endif
 .align 4
 ENTRY(initial_code)
 	.long i386_start_kernel
-- 
1.6.3.3


