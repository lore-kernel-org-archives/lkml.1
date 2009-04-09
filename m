Return-Path: <linux-kernel-owner+w=401wt.eu-S934321AbZDIXWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934321AbZDIXWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761441AbZDIXWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:22:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758997AbZDIXWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:22:40 -0400
Date: Thu, 9 Apr 2009 16:18:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Brian Maly <bmaly@redhat.com>
Cc: h.peter.anvin@intel.com, linux-kernel@vger.kernel.org, dannf@hp.com,
       ying.huang@intel.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] rtc: add x86 support for rtc-efi
Message-Id: <20090409161803.f79c0b64.akpm@linux-foundation.org>
In-Reply-To: <49DA8875.5050009@redhat.com>
References: <49DA40B9.2060804@redhat.com>
	<49DA817E.8040705@intel.com>
	<49DA8875.5050009@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Apr 2009 18:55:49 -0400
Brian Maly <bmaly@redhat.com> wrote:

> re-post of the patch, both as inline and as an attachment (which 
> hopefully wont cause confusion).
> 

Normally it does confuse me horridly because I get two copies of the
same patch, which applies happily with `patch --dry-run', but dies
horridly with `patch --for-real'.  But I was warned...

In future, please include a full copy of the (possibly modified)
changelog with each iteration of a patch.

As this patch is mostly-x86 I tossed it onto my for-Ingo pile.


From: Brian Maly <bmaly@redhat.com>

Add support for rtc-efi (RTC Class Driver for EFI-based systems) to x86.

This patch has been tested and works perfectly on every x86 EFI system I
could find, though all have been EL64 systems.  I would appreciate any
testing feedback from EL32 systems from anyone that has one and can test.

Signed-off-by: Brian Maly <bmaly@redhat.com>
Acked-by: dann frazier <dannf@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/time_32.c |   19 +++++++++++++++++++
 arch/x86/kernel/time_64.c |   18 ++++++++++++++++++
 drivers/rtc/Kconfig       |    2 +-
 3 files changed, 38 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/time_32.c~rtc-add-x86-support-for-rtc-efi arch/x86/kernel/time_32.c
--- a/arch/x86/kernel/time_32.c~rtc-add-x86-support-for-rtc-efi
+++ a/arch/x86/kernel/time_32.c
@@ -32,6 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/mca.h>
+#include <linux/platform_device.h>
 
 #include <asm/setup.h>
 #include <asm/hpet.h>
@@ -135,3 +136,21 @@ void __init time_init(void)
 	tsc_init();
 	late_time_init = choose_time_init();
 }
+
+
+#ifdef CONFIG_RTC_DRV_EFI
+static struct platform_device rtc_efi_dev = {
+	.name = "rtc-efi",
+	.id = -1,
+};
+
+static int __init rtc_init(void)
+{
+	if (platform_device_register(&rtc_efi_dev) < 0)
+		printk(KERN_ERR "unable to register rtc device...\n");
+
+	/* not necessarily an error */
+	return 0;
+}
+module_init(rtc_init);
+#endif
diff -puN arch/x86/kernel/time_64.c~rtc-add-x86-support-for-rtc-efi arch/x86/kernel/time_64.c
--- a/arch/x86/kernel/time_64.c~rtc-add-x86-support-for-rtc-efi
+++ a/arch/x86/kernel/time_64.c
@@ -18,6 +18,7 @@
 #include <linux/time.h>
 #include <linux/mca.h>
 #include <linux/nmi.h>
+#include <linux/platform_device.h>
 
 #include <asm/i8253.h>
 #include <asm/hpet.h>
@@ -133,3 +134,20 @@ void __init time_init(void)
 
 	late_time_init = choose_time_init();
 }
+
+#ifdef CONFIG_RTC_DRV_EFI
+static struct platform_device rtc_efi_dev = {
+	.name = "rtc-efi",
+	.id = -1,
+};
+
+static int __init rtc_init(void)
+{
+	if (platform_device_register(&rtc_efi_dev) < 0)
+		printk(KERN_ERR "unable to register rtc device...\n");
+
+	/* not necessarily an error */
+	return 0;
+}
+module_init(rtc_init);
+#endif
diff -puN drivers/rtc/Kconfig~rtc-add-x86-support-for-rtc-efi drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-x86-support-for-rtc-efi
+++ a/drivers/rtc/Kconfig
@@ -455,7 +455,7 @@ config RTC_DRV_DS1742
 
 config RTC_DRV_EFI
 	tristate "EFI RTC"
-	depends on IA64
+	depends on EFI
 	help
 	  If you say yes here you will get support for the EFI
 	  Real Time Clock.
_

