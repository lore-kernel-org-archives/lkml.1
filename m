Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739Ab0AUTJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab0AUTJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 14:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052Ab0AUTJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 14:09:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:20029 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab0AUTJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 14:09:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,318,1262592000"; 
   d="scan'208";a="766222216"
Date: Thu, 21 Jan 2010 11:09:52 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Mark Hounschell <markh@compro.net>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       stable@kernel.org
Subject: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
Message-ID: <20100121190952.GA32523@linux-os.sc.intel.com>
References: <87bphpd4rt.fsf@basil.nowhere.org> <4B32565E.6000501@compro.net> <20091223191806.GA3336@linux-os.sc.intel.com> <4B3270FE.5090607@compro.net> <1261600243.16916.56.camel@localhost.localdomain> <4B476E8D.1030308@compro.net> <1263255557.16916.132.camel@localhost.localdomain> <4B4C3B1A.50906@cfl.rr.com> <1263520917.16916.171.camel@localhost.localdomain> <4B50ADD0.20508@compro.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B50ADD0.20508@compro.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


HPET MSI on platforms with ATI SB700/SB800 as they seem to have some
side-effects on floppy DMA. Do not use HPET MSI on such platforms.

Original problem report from Mark Hounschell
http://lkml.indiana.edu/hypermail/linux/kernel/0912.2/01118.html

Tested-by: Mark Hounschell <markh@compro.net>

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---

This patch needs to go to stable as well. But, there are some conflicts that prevents
the patch from going as is. I can rebase/resubmit to stable once the patch goes upstream.

 arch/x86/include/asm/hpet.h |    1 +
 arch/x86/kernel/hpet.c      |    8 ++++++++
 arch/x86/kernel/quirks.c    |   13 +++++++++++++
 3 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index 5d89fd2..1d5c08a 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -67,6 +67,7 @@ extern unsigned long hpet_address;
 extern unsigned long force_hpet_address;
 extern u8 hpet_blockid;
 extern int hpet_force_user;
+extern u8 hpet_msi_disable;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
 extern void hpet_disable(void);
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ba6e658..ad80a1c 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -34,6 +34,8 @@
  */
 unsigned long				hpet_address;
 u8					hpet_blockid; /* OS timer block num */
+u8					hpet_msi_disable;
+
 #ifdef CONFIG_PCI_MSI
 static unsigned long			hpet_num_timers;
 #endif
@@ -596,6 +598,9 @@ static void hpet_msi_capability_lookup(unsigned int start_timer)
 	unsigned int num_timers_used = 0;
 	int i;
 
+	if (hpet_msi_disable)
+		return;
+
 	if (boot_cpu_has(X86_FEATURE_ARAT))
 		return;
 	id = hpet_readl(HPET_ID);
@@ -928,6 +933,9 @@ static __init int hpet_late_init(void)
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
 	hpet_print_config();
 
+	if (hpet_msi_disable)
+		return 0;
+
 	if (boot_cpu_has(X86_FEATURE_ARAT))
 		return 0;
 
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 18093d7..12e9fea 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -491,6 +491,19 @@ void force_hpet_resume(void)
 		break;
 	}
 }
+
+/*
+ * HPET MSI on some boards (ATI SB700/SB800) has side effect on
+ * floppy DMA. Disable HPET MSI on such platforms.
+ */
+static void force_disable_hpet_msi(struct pci_dev *unused)
+{
+	hpet_msi_disable = 1;
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
+			 force_disable_hpet_msi);
+
 #endif
 
 #if defined(CONFIG_PCI) && defined(CONFIG_NUMA)
-- 
1.6.0.6

