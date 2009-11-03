Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZKCRL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZKCRL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZKCRL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:11:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbZKCRL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:11:27 -0500
Date: Tue, 3 Nov 2009 12:10:17 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86: add config option for the default NMI watchdog
Message-ID: <20091103171016.GA25437@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds config options to allow selecting one of the two NMI watchdog
methods as default. It's still possible to select a different method or even
disable it using the command line mode. This is required for the next patch,
which adds support to "auto" mode.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
---
 arch/x86/kernel/apic/nmi.c |   11 ++++++++++-
 lib/Kconfig.debug          |   21 +++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index e82a450..fd176e9 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -50,7 +50,16 @@ static cpumask_var_t backtrace_mask;
 atomic_t nmi_active = ATOMIC_INIT(0);		/* oprofile uses this */
 EXPORT_SYMBOL(nmi_active);
 
-unsigned int nmi_watchdog = NMI_NONE;
+#ifdef CONFIG_DEBUG_DEFAULT_NMI_NONE
+#define DEFAULT_NMI_WATCHDOG_VALUE NMI_NONE
+#endif
+#ifdef CONFIG_DEBUG_DEFAULT_NMI_IOAPIC
+#define DEFAULT_NMI_WATCHDOG_VALUE NMI_IOAPIC
+#endif
+#ifdef CONFIG_DEBUG_DEFAULT_NMI_LAPIC
+#define DEFAULT_NMI_WATCHDOG_VALUE NMI_LAPIC
+#endif
+unsigned int nmi_watchdog = DEFAULT_NMI_WATCHDOG_VALUE;
 EXPORT_SYMBOL(nmi_watchdog);
 
 static int panic_on_timeout;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2790b4f..0a3622a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -253,6 +253,27 @@ config DEBUG_NMI_TIMEOUT
 	  This value is the number of seconds the NMI watchdog will tick
 	  before it decides the machine has hung.
 
+choice
+	prompt "Default NMI watchdog method"
+	default DEBUG_DEFAULT_NMI_NONE
+	depends on X86
+	help
+	  This allows to set the default NMI watchdog method to be used. The
+	  default can be changed using nmi_watchdog=. Only choose an option
+	  different from Disabled if you know the machine supports that method.
+
+config DEBUG_DEFAULT_NMI_NONE
+	bool "Disabled"
+
+config DEBUG_DEFAULT_NMI_IOAPIC
+	bool "IOAPIC"
+
+config DEBUG_DEFAULT_NMI_LAPIC
+	bool "LAPIC"
+
+endchoice
+
+
 config TIMER_STATS
 	bool "Collect kernel timers statistics"
 	depends on DEBUG_KERNEL && PROC_FS
-- 
1.5.5.6

