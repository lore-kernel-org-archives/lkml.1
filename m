Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbXK0SRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbXK0SRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 13:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758059AbXK0SRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 13:17:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:9161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879AbXK0SRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 13:17:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,220,1194249600"; 
   d="scan'208";a="281048636"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] x86: disable hpet legacy replacement for kexec
Date: Tue, 27 Nov 2007 10:17:12 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE2B36BF@orsmsx423.amr.corp.intel.com>
In-Reply-To: <87sl2s4ran.fsf@duaron.myhome.or.jp>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] x86: disable hpet legacy replacement for kexec
Thread-Index: AcgwdaDKaoS5+MRTQbiAQis+QKBmoQAq8vcQ
References: <20071126193353.GA1676@elte.hu> <87sl2s4ran.fsf@duaron.myhome.or.jp>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
       "Ingo Molnar" <mingo@elte.hu>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
X-OriginalArrivalTime: 27 Nov 2007 18:16:58.0931 (UTC) FILETIME=[B3255830:01C83121]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ack.

Thanks,
Venki 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of OGAWA Hirofumi
>Sent: Monday, November 26, 2007 1:43 PM
>To: Ingo Molnar
>Cc: Linus Torvalds; linux-kernel@vger.kernel.org; Thomas 
>Gleixner; H. Peter Anvin
>Subject: [PATCH] x86: disable hpet legacy replacement for kexec
>
>Hi,
>
>This seems to introduced after 2.6.23, so if possible, I'd like to fix
>before 2.6.24. What do you think the following?
>
>Thanks.
>-- 
>OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
>
>If HPET was enabled by pci quirks, we use i8253 as initial clockevent
>because pci quirks doesn't run until pci is initialized.
>
>The above means the kernel (or something) is assuming HPET legacy
>replacement is disabled and can use i8253 at boot.
>
>If we used kexec, it isn't true. So, this patch disables HPET legacy
>replacement for kexec in machine_shutdown().
>
>Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>---
>
> arch/x86/kernel/hpet.c      |   14 ++++++++++++++
> arch/x86/kernel/reboot_32.c |    4 ++++
> arch/x86/kernel/reboot_64.c |    4 ++++
> include/asm-x86/hpet.h      |    1 +
> 4 files changed, 23 insertions(+)
>
>diff -puN arch/x86/kernel/hpet.c~kexec-need-to-disable-hpet 
>arch/x86/kernel/hpet.c
>--- 
>linux-2.6/arch/x86/kernel/hpet.c~kexec-need-to-disable-hpet	
>2007-11-24 09:38:23.000000000 +0900
>+++ linux-2.6-hirofumi/arch/x86/kernel/hpet.c	2007-11-27 
>04:57:00.000000000 +0900
>@@ -446,6 +446,20 @@ static __init int hpet_late_init(void)
> }
> fs_initcall(hpet_late_init);
> 
>+void hpet_disable(void)
>+{
>+	if (is_hpet_capable()) {
>+		unsigned long cfg = hpet_readl(HPET_CFG);
>+
>+		if (hpet_legacy_int_enabled) {
>+			cfg &= ~HPET_CFG_LEGACY;
>+			hpet_legacy_int_enabled = 0;
>+		}
>+		cfg &= ~HPET_CFG_ENABLE;
>+		hpet_writel(cfg, HPET_CFG);
>+	}
>+}
>+
> #ifdef CONFIG_HPET_EMULATE_RTC
> 
> /* HPET in LegacyReplacement Mode eats up RTC interrupt line. 
>When, HPET
>diff -puN 
>arch/x86/kernel/reboot_32.c~kexec-need-to-disable-hpet 
>arch/x86/kernel/reboot_32.c
>--- 
>linux-2.6/arch/x86/kernel/reboot_32.c~kexec-need-to-disab
>le-hpet	2007-11-24 09:38:23.000000000 +0900
>+++ linux-2.6-hirofumi/arch/x86/kernel/reboot_32.c	
>2007-11-27 04:57:50.000000000 +0900
>@@ -11,6 +11,7 @@
> #include <linux/reboot.h>
> #include <asm/uaccess.h>
> #include <asm/apic.h>
>+#include <asm/hpet.h>
> #include <asm/desc.h>
> #include "mach_reboot.h"
> #include <asm/reboot_fixups.h>
>@@ -326,6 +327,9 @@ static void native_machine_shutdown(void
> #ifdef CONFIG_X86_IO_APIC
> 	disable_IO_APIC();
> #endif
>+#ifdef CONFIG_HPET_TIMER
>+	hpet_disable();
>+#endif
> }
> 
> void __attribute__((weak)) mach_reboot_fixups(void)
>diff -puN 
>arch/x86/kernel/reboot_64.c~kexec-need-to-disable-hpet 
>arch/x86/kernel/reboot_64.c
>--- 
>linux-2.6/arch/x86/kernel/reboot_64.c~kexec-need-to-disab
>le-hpet	2007-11-24 09:38:23.000000000 +0900
>+++ linux-2.6-hirofumi/arch/x86/kernel/reboot_64.c	
>2007-11-27 04:57:56.000000000 +0900
>@@ -17,6 +17,7 @@
> #include <asm/pgtable.h>
> #include <asm/tlbflush.h>
> #include <asm/apic.h>
>+#include <asm/hpet.h>
> #include <asm/gart.h>
> 
> /*
>@@ -113,6 +114,9 @@ void machine_shutdown(void)
> 
> 	disable_IO_APIC();
> 
>+#ifdef CONFIG_HPET_TIMER
>+	hpet_disable();
>+#endif
> 	local_irq_restore(flags);
> 
> 	pci_iommu_shutdown();
>diff -puN include/asm-x86/hpet.h~kexec-need-to-disable-hpet 
>include/asm-x86/hpet.h
>--- 
>linux-2.6/include/asm-x86/hpet.h~kexec-need-to-disable-hpet	
>2007-11-24 09:38:23.000000000 +0900
>+++ linux-2.6-hirofumi/include/asm-x86/hpet.h	2007-11-27 
>04:54:32.000000000 +0900
>@@ -61,6 +61,7 @@ extern unsigned long force_hpet_address;
> extern int hpet_force_user;
> extern int is_hpet_enabled(void);
> extern int hpet_enable(void);
>+extern void hpet_disable(void);
> extern unsigned long hpet_readl(unsigned long a);
> extern void force_hpet_resume(void);
> 
>_
>-
>To unsubscribe from this list: send the line "unsubscribe 
>linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
