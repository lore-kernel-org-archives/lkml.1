Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbXC2NrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbXC2NrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 09:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXC2NrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 09:47:05 -0400
Received: from hu-out-0506.google.com ([72.14.214.229]:3662 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbXC2NrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 09:47:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=oEHj/nZV0DYhhEdOmJjGY2lTUli1RTdf/b+BSiW6VCcLoAlNkQfFKd7LQF5Pm0Iaan/pshwvFtxZUTh6rIwxRU2TBf2bA3n+dBaQtpokz8gk3tBMcIQqNbZ1yrcoqiNTExNYvKmrvGI5JPIKGAmRRKl+2xw0vFAWKNtgB2PqMWk=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH v2] Add suspend/resume for HPET
Date: Thu, 29 Mar 2007 15:46:48 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
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
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <460BBD1B.4040308@ru.mvista.com> <200703291531.18253.maximlevitsky@gmail.com>
In-Reply-To: <200703291531.18253.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703291546.48996.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Add suspend/resume for HPET
This adds support of suspend/resume on i386 for HPET
Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

---
 arch/i386/kernel/hpet.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/arch/i386/kernel/hpet.c b/arch/i386/kernel/hpet.c
index 0fd9fba..7c67780 100644
--- a/arch/i386/kernel/hpet.c
+++ b/arch/i386/kernel/hpet.c
@@ -3,6 +3,8 @@
 #include <linux/errno.h>
 #include <linux/hpet.h>
 #include <linux/init.h>
+#include <linux/sysdev.h>
+#include <linux/pm.h>
 
 #include <asm/hpet.h>
 #include <asm/io.h>
@@ -310,6 +312,7 @@ int __init hpet_enable(void)
 out_nohpet:
 	iounmap(hpet_virt_address);
 	hpet_virt_address = NULL;
+	boot_hpet_disable = 1;
 	return 0;
 }
 
@@ -524,3 +527,68 @@ irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
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
-- 
1.4.4.2

