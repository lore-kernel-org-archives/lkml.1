Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988Ab0AWGwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab0AWGwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 01:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673Ab0AWGwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 01:52:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:40649 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab0AWGwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 01:52:14 -0500
Date: Sat, 23 Jan 2010 06:51:55 GMT
From: "tip-bot for Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markh@compro.net, stable@kernel.org, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markh@compro.net, venkatesh.pallipadi@intel.com, stable@kernel.org,
       tglx@linutronix.de
In-Reply-To: <20100121190952.GA32523@linux-os.sc.intel.com>
References: <20100121190952.GA32523@linux-os.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Disable HPET MSI on ATI SB700/SB800
Message-ID: <tip-73472a46b5b28116b145fb5fc05242c1aa8e1461@git.kernel.org>
Git-Commit-ID: 73472a46b5b28116b145fb5fc05242c1aa8e1461
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 23 Jan 2010 06:51:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73472a46b5b28116b145fb5fc05242c1aa8e1461
Gitweb:     http://git.kernel.org/tip/73472a46b5b28116b145fb5fc05242c1aa8e1461
Author:     Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
AuthorDate: Thu, 21 Jan 2010 11:09:52 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 23 Jan 2010 06:21:58 +0100

x86: Disable HPET MSI on ATI SB700/SB800

HPET MSI on platforms with ATI SB700/SB800 as they seem to have some
side-effects on floppy DMA. Do not use HPET MSI on such platforms.

Original problem report from Mark Hounschell
http://lkml.indiana.edu/hypermail/linux/kernel/0912.2/01118.html

[ This patch needs to go to stable as well. But, there are some
  conflicts that prevents the patch from going as is. I can
  rebase/resubmit to stable once the patch goes upstream.
  hpa: still Cc:'ing stable@ as an FYI. ]

Tested-by: Mark Hounschell <markh@compro.net>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: <stable@kernel.org>
LKML-Reference: <20100121190952.GA32523@linux-os.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
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
