Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbXH1MwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbXH1MwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 08:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbXH1MwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 08:52:15 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:36867 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1751818AbXH1MwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 08:52:14 -0400
Date: Tue, 28 Aug 2007 16:58:32 +0400
From: Konstantin Baydarov <kbaidarov@ru.mvista.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: <vgoyal@in.ibm.com>, "RT" <linux-rt-users@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] kexec: reenable HPET before kexec
Message-ID: <20070828165832.5047d4de@windmill.dev.rtsoft.ru>
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F501522051@scsmsx415.amr.corp.intel.com>
References: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru>
	<20070823090845.GA13065@in.ibm.com>
	<20070823154936.3b7ae498@windmill.dev.rtsoft.ru>
	<20070827053656.GC9809@in.ibm.com>
	<653FFBB4508B9042B5D43DC9E18836F501522051@scsmsx415.amr.corp.intel.com>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.19; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 11:26:29 -0700
"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:

> 
> 
> - Another thing to try is to disable HPET and boot with PIT in the
> first kernel. Just to check whether PIT never works on this platform
> or the first kernel is doing something to stop PIT. You can try
> "hpet=disable" boot option for that.
> 
> Thanks,
> Venki

I've tried kernel 1 with HPET disabled - it boots fine, PIT works!
Then I made additional investigations and found out that PIT won't work
in kernel 2 if bit HPET_CFG_LEGACY is set.
Bit HPET_CFG_LEGACY is set by hpet_enable_int() during HPET
initialization, so if this bit is cleared in machine_kexec() kernel 2
boots fine.
I can't explain this magic, maybe someone can explain this. Thanks.

Here is new version of workaround for 2.6.23-rc3

Signed-off-by: Konstantin Baydarov <kbaidarov@ru.mvista.com>

 arch/i386/kernel/hpet.c          |   12 ++++++++++++
 arch/i386/kernel/machine_kexec.c |    6 ++++++
 include/asm-i386/hpet.h          |    3 +++
 3 files changed, 21 insertions(+)

Index: linux-2.6.23-rc3/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.23-rc3.orig/arch/i386/kernel/hpet.c
+++ linux-2.6.23-rc3/arch/i386/kernel/hpet.c
@@ -149,6 +149,18 @@ static void hpet_enable_int(void)
 	hpet_legacy_int_enabled = 1;
 }
 
+#ifdef CONFIG_KEXEC
+void hpet_disable_int(void)
+{
+	unsigned long cfg = hpet_readl(HPET_CFG);
+
+	cfg &= ~HPET_CFG_LEGACY;
+	hpet_writel(cfg, HPET_CFG);
+	hpet_legacy_int_enabled = 0;
+
+}
+#endif
+
 static void hpet_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt)
 {
Index: linux-2.6.23-rc3/arch/i386/kernel/machine_kexec.c
===================================================================
--- linux-2.6.23-rc3.orig/arch/i386/kernel/machine_kexec.c
+++ linux-2.6.23-rc3/arch/i386/kernel/machine_kexec.c
@@ -19,6 +19,7 @@
 #include <asm/cpufeature.h>
 #include <asm/desc.h>
 #include <asm/system.h>
+#include <asm/hpet.h>
 
 #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
 static u32 kexec_pgd[1024] PAGE_ALIGNED;
@@ -109,6 +110,11 @@ NORET_TYPE void machine_kexec(struct kim
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
 
+#ifdef CONFIG_HPET_TIMER
+	/* Without this PIT won't work in executed kernel */
+	hpet_disable_int();
+#endif
+
 	control_page = page_address(image->control_code_page);
 	memcpy(control_page, relocate_kernel, PAGE_SIZE);
 
Index: linux-2.6.23-rc3/include/asm-i386/hpet.h
===================================================================
--- linux-2.6.23-rc3.orig/include/asm-i386/hpet.h
+++ linux-2.6.23-rc3/include/asm-i386/hpet.h
@@ -66,6 +66,9 @@
 extern unsigned long hpet_address;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
+#ifdef CONFIG_KEXEC
+extern void hpet_disable_int(void);
+#endif
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 
