Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbXHUMzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbXHUMzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 08:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbXHUMzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 08:55:33 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:37625 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1756252AbXHUMzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 08:55:32 -0400
Date: Tue, 21 Aug 2007 17:01:41 +0400
From: Konstantin Baydarov <kbaidarov@ru.mvista.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kexec: reenable HPET before kexec
Message-ID: <20070821170141.70a95dac@windmill.dev.rtsoft.ru>
In-Reply-To: <1187645464.7732.43.camel@imap.mvista.com>
References: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru>
	<46CA035A.5050202@ru.mvista.com>
	<1187645464.7732.43.camel@imap.mvista.com>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.19; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007 14:31:04 -0700
Daniel Walker <dwalker@mvista.com> wrote:

> On Tue, 2007-08-21 at 01:10 +0400, Konstantin Baydarov wrote:
> 
> It was in your original email ..  Are you saying this it is not a
> problem in plain 2.6.23-rc2? I thought I read that it was a problem on
> i386 ..
> 
> Daniel
> 

I can reproduce bug with plain 2.6.23-rc3 i386 kernel, without RT patch,
on pentiumd.
So I fixed this issue the same way as I fixed RT kernel. The side effect
of this fix is that when kernel 2 executes both Local APIC timer and HPET
are enabled and produce timer interrupts:
root@192.168.40.10:~# cat /proc/interrupts
           CPU0       CPU1
  0:       5643          0   IO-APIC-edge      timer
  1:          8          0   IO-APIC-edge      i8042
  2:          0          0    XT-PIC-XT        cascade
  4:        303        181   IO-APIC-edge      serial
  6:          3          0   IO-APIC-edge      floppy
 12:          4          0   IO-APIC-edge      i8042
 14:         11          0   IO-APIC-edge      ide0
 17:       5701         16   IO-APIC-fasteoi   uhci_hcd:usb3, eth0
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
 20:         38          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
 23:          3          0   IO-APIC-fasteoi   libata
NMI:          0          0
LOC:       5525       5489
ERR:          0
MIS:          0
root@192.168.40.10:~#

IRQ0 and LOC values practically the same.

Also I didn't see this bug on linux-rt-users@vger.kernel.org, maybe I should
resend it?

Patch against 2.6.23-rc3.

Signed-off-by: Konstantin Baydarov <kbaidarov@ru.mvista.com>

 arch/i386/kernel/hpet.c          |   15 +++++++++++++++
 arch/i386/kernel/machine_kexec.c |    5 +++++
 include/asm-i386/hpet.h          |    3 +++
 3 files changed, 23 insertions(+)

Index: linux-2.6.23-rc3-i386/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.23-rc3-i386.orig/arch/i386/kernel/hpet.c
+++ linux-2.6.23-rc3-i386/arch/i386/kernel/hpet.c
@@ -340,6 +340,21 @@ out_nohpet:
 	return 0;
 }
 
+#ifdef CONFIG_KEXEC
+/*
+ * reenable HPET timer
+ */
+int hpet_reenable(void)
+{
+	if (!is_hpet_capable())
+		return -1;
+
+	if (hpet_clockevent.mode != CLOCK_EVT_MODE_PERIODIC)
+		hpet_set_mode(CLOCK_EVT_MODE_PERIODIC, &hpet_clockevent);
+
+	return 0;
+}
+#endif
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 
Index: linux-2.6.23-rc3-i386/arch/i386/kernel/machine_kexec.c
===================================================================
--- linux-2.6.23-rc3-i386.orig/arch/i386/kernel/machine_kexec.c
+++ linux-2.6.23-rc3-i386/arch/i386/kernel/machine_kexec.c
@@ -19,6 +19,7 @@
 #include <asm/cpufeature.h>
 #include <asm/desc.h>
 #include <asm/system.h>
+#include <asm/hpet.h>
 
 #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
 static u32 kexec_pgd[1024] PAGE_ALIGNED;
@@ -109,6 +110,10 @@ NORET_TYPE void machine_kexec(struct kim
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
 
+#ifdef CONFIG_HPET_TIMER
+	hpet_reenable();
+#endif
+
 	control_page = page_address(image->control_code_page);
 	memcpy(control_page, relocate_kernel, PAGE_SIZE);
 
Index: linux-2.6.23-rc3-i386/include/asm-i386/hpet.h
===================================================================
--- linux-2.6.23-rc3-i386.orig/include/asm-i386/hpet.h
+++ linux-2.6.23-rc3-i386/include/asm-i386/hpet.h
@@ -66,6 +66,9 @@
 extern unsigned long hpet_address;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
+#ifdef CONFIG_KEXEC
+extern int hpet_reenable(void);
+#endif
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 
