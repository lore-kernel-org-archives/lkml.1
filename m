Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbYHVS1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbYHVS1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYHVS10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:27:26 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:40661 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbYHVS1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:27:25 -0400
X-BigFish: VPS-16(zz98dR936eQzz10d3izz5a6ciz32i66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0K60LX7-02-4AJ-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       Jan Beulich <jbeulich@novell.com>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: fix: do not run code in amd_bus.c on non-AMD CPUs
Date: Fri, 22 Aug 2008 20:23:37 +0200
Message-ID: <1219429418-29023-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <48AD82D5.76E4.0078.0@novell.com>
References: <48AD82D5.76E4.0078.0@novell.com>
X-OriginalArrivalTime: 22 Aug 2008 18:27:13.0321 (UTC) FILETIME=[B2789190:01C90484]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.08.08 13:59:33, Jan Beulich wrote:
> Even worse - this would even try to access the MSR on non-AMD CPUs
> (currently probably prevented just by the fact that only AMD ones use
> family values of 0x10 or higher).

This patch adds cpu vendor check to the postcore_initcalls.

Cc: Jan Beulich <jbeulich@novell.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/amd_bus.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index dbf5323..4a6f1a6 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -555,9 +555,11 @@ static int __init early_fill_mp_bus_info(void)
 	return 0;
 }
 
-postcore_initcall(early_fill_mp_bus_info);
+#else  /* !CONFIG_X86_64 */
 
-#endif
+static int __init early_fill_mp_bus_info(void) { return 0; }
+
+#endif /* !CONFIG_X86_64 */
 
 /* common 32/64 bit code */
 
@@ -583,4 +585,15 @@ static int __init enable_pci_io_ecs(void)
 	return 0;
 }
 
-postcore_initcall(enable_pci_io_ecs);
+static int __init amd_postcore_init(void)
+{
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
+		return 0;
+
+	early_fill_mp_bus_info();
+	enable_pci_io_ecs();
+
+	return 0;
+}
+
+postcore_initcall(amd_postcore_init);
-- 
1.5.6.4


