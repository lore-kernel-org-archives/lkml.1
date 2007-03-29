Return-Path: <linux-kernel-owner+w=401wt.eu-S934318AbXC2Rtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934318AbXC2Rtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934311AbXC2Rtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:49:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933688AbXC2Rta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:49:30 -0400
Date: Thu, 29 Mar 2007 19:47:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
Subject: Re: [patch, v2] add suspend/resume for HPET
Message-ID: <20070329174735.GA3216@elte.hu>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703290747.28929.maximlevitsky@gmail.com> <Pine.LNX.4.64.0703290930540.6730@woody.linux-foundation.org> <200703291851.19424.maximlevitsky@gmail.com> <Pine.LNX.4.64.0703291022100.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703291022100.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


update: i've tested Maxim's v2 patch on both a hpet-capable and a 
hpet-less system, and it works fine here.

on a dual-core hpet-capable system, running a NO_HZ+!HIGH_RES_TIMERS 
kernel:

  europe:~> grep Clock /proc/timer_list
  Clock Event Device: hpet
  Clock Event Device: lapic
  Clock Event Device: lapic

s2ram works fine now - it hung on resume before.

on a dual-core non-hpet system, with a NO_HZ+!HIGH_RES_TIMERS kernel:

  neptune:~> grep Clock /proc/timer_list
  Clock Event Device: pit
  Clock Event Device: lapic
  Clock Event Device: lapic

s2ram worked fine before - and it still works now.

(The combination of NO_HZ+!HIGH_RES_TIMERS was the most fragile wrt. 
suspend because in the !HIGH_RES_TIMERS there's just a single instance 
after resume that we touch the timer hardware, and we very much rely on 
the periodic interrupt being set to the precise value.)

So this is a go on my systems - good work Maxim! (I've reproduced 
Maxim's patch below with minor patch-metadata updates.)

	Ingo

---------------------------->
Subject: [patch] add suspend/resume for HPET
From: Maxim Levitsky <maximlevitsky@gmail.com>

This adds support for suspend/resume on i386 for HPET.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

---
 arch/i386/kernel/hpet.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

Index: linux/arch/i386/kernel/hpet.c
===================================================================
--- linux.orig/arch/i386/kernel/hpet.c
+++ linux/arch/i386/kernel/hpet.c
@@ -3,6 +3,8 @@
 #include <linux/errno.h>
 #include <linux/hpet.h>
 #include <linux/init.h>
+#include <linux/sysdev.h>
+#include <linux/pm.h>
 
 #include <asm/hpet.h>
 #include <asm/io.h>
@@ -307,6 +309,7 @@ int __init hpet_enable(void)
 out_nohpet:
 	iounmap(hpet_virt_address);
 	hpet_virt_address = NULL;
+	boot_hpet_disable = 1;
 	return 0;
 }
 
@@ -523,3 +526,68 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
 	return IRQ_HANDLED;
 }
 #endif
+
+
+/*
+ * Suspend/resume part
+ */
+
+#ifdef CONFIG_PM
+
+static int hpet_suspend(struct sys_device *sys_device, pm_message_t state)
+{
+	unsigned long cfg = hpet_readl(HPET_CFG);
+
+	cfg &= ~(HPET_CFG_ENABLE|HPET_CFG_LEGACY);
+	hpet_writel(cfg, HPET_CFG);
+
+	return 0;
+}
+
+static int hpet_resume(struct sys_device *sys_device)
+{
+	unsigned int id;
+
+	hpet_start_counter();
+
+	id = hpet_readl(HPET_ID);
+
+	if (id & HPET_ID_LEGSUP)
+		hpet_enable_int();
+
+	return 0;
+}
+
+static struct sysdev_class hpet_class = {
+	set_kset_name("hpet"),
+	.suspend	= hpet_suspend,
+	.resume		= hpet_resume,
+};
+
+static struct sys_device hpet_device = {
+	.id		= 0,
+	.cls		= &hpet_class,
+};
+
+
+static __init int hpet_register_sysfs(void)
+{
+	int err;
+
+	if (!is_hpet_capable())
+		return 0;
+
+	err = sysdev_class_register(&hpet_class);
+
+	if (!err) {
+		err = sysdev_register(&hpet_device);
+		if (err)
+			sysdev_class_unregister(&hpet_class);
+	}
+
+	return err;
+}
+
+device_initcall(hpet_register_sysfs);
+
+#endif
