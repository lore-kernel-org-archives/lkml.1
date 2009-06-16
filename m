Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZFPI4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZFPI4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833AbZFPI42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:56:28 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:41626
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753169AbZFPI41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:56:27 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i17ch62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KLBQ5U-01-29G-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/6] x86: disable IOMMUs on kernel crash
Date: Tue, 16 Jun 2009 10:56:11 +0200
Message-ID: <1245142575-7166-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245142575-7166-1-git-send-email-joerg.roedel@amd.com>
References: <1245142575-7166-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Jun 2009 08:56:17.0616 (UTC) FILETIME=[4F944D00:01C9EE60]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the IOMMUs are still enabled when the kexec kernel boots access to
the disk is not possible. This is bad for tools like kdump or anything
else which wants to use PCI devices.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/crash.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index ff95824..5e409dc 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -27,6 +27,7 @@
 #include <asm/cpu.h>
 #include <asm/reboot.h>
 #include <asm/virtext.h>
+#include <asm/iommu.h>
 
 
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
@@ -103,5 +104,10 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 #ifdef CONFIG_HPET_TIMER
 	hpet_disable();
 #endif
+
+#ifdef CONFIG_X86_64
+	pci_iommu_shutdown();
+#endif
+
 	crash_save_cpu(regs, safe_smp_processor_id());
 }
-- 
1.6.3.1


