Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab0BXIJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:09:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:58689 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668Ab0BXIJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:09:33 -0500
Date: Wed, 24 Feb 2010 08:09:06 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F0755A318D2D2@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F0755A318D2D2@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, apbt: Moorestown APB system timer driver
Message-ID: <tip-aa19febbc933936219c59ac83e61049fc7136e62@git.kernel.org>
Git-Commit-ID: aa19febbc933936219c59ac83e61049fc7136e62
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Feb 2010 08:09:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa19febbc933936219c59ac83e61049fc7136e62
Gitweb:     http://git.kernel.org/tip/aa19febbc933936219c59ac83e61049fc7136e62
Author:     Jacob Pan <jacob.jun.pan@intel.com>
AuthorDate: Wed, 2 Sep 2009 07:37:17 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 23 Feb 2010 23:15:19 -0800

x86, apbt: Moorestown APB system timer driver

Moorestown platform does not have PIT or HPET platform timers.  Instead it
has a bank of eight APB timers.  The number of available timers to the os
is exposed via SFI mtmr tables.  All APB timer interrupts are routed via
ioapic rtes and delivered as MSI.
Currently, we use timer 0 and 1 for per cpu clockevent devices, timer 2
for clocksource.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
LKML-Reference: <43F901BD926A4E43B106BF17856F0755A318D2D2@orsmsx508.amr.corp.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 arch/x86/Kconfig                    |   11 +++++++++++
 arch/x86/kernel/Makefile            |    1 +
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 51bceb0..9172204 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2793,6 +2793,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			default x2apic cluster mode on platforms
 			supporting x2apic.
 
+	x86_mrst_timer= [X86-32,APBT]
+			Choose timer option for x86 Moorestown MID platform.
+			Two valid options are apbt timer only and lapic timer
+			plus one apbt timer for broadcast timer.
+			x86_mrst_timer=apbt_only | lapic_and_apbt
+
 	xd=		[HW,XT] Original XT pre-IDE (RLL encoded) disks.
 	xd_geo=		See header of drivers/block/xd.c.
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eb40925..0ab2dce 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -390,6 +390,7 @@ config X86_MRST
        bool "Moorestown MID platform"
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
+	select APB_TIMER
 	---help---
 	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
 	  Internet Device(MID) platform. Moorestown consists of two chips:
@@ -612,6 +613,16 @@ config HPET_EMULATE_RTC
 	def_bool y
 	depends on HPET_TIMER && (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
 
+config APB_TIMER
+       def_bool y if MRST
+       prompt "Langwell APB Timer Support" if X86_MRST
+       help
+         APB timer is the replacement for 8254, HPET on X86 MID platforms.
+         The APBT provides a stable time base on SMP
+         systems, unlike the TSC, but it is more expensive to access,
+         as it is off-chip. APB timers are always running regardless of CPU
+         C states, they are used as per CPU clockevent device when possible.
+
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
 config DMI
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index d87f09b..4c58352 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -87,6 +87,7 @@ obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
+obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
 
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
