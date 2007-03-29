Return-Path: <linux-kernel-owner+w=401wt.eu-S933998AbXC2Frm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998AbXC2Frm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 01:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934007AbXC2Frm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 01:47:42 -0400
Received: from hu-out-0506.google.com ([72.14.214.236]:30640 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934000AbXC2Frk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 01:47:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Ee8OtykTinvmiuTizABUb/FNuHYBozkjMmXoiJ/0uUhKipKdxhoZrseB4EIEVnIuL+1gefgdcx9u0UjjWAu6w3M6tUrc1jf+aLtcWaW9YfyasT7aMN3FobQBT9y/yd7OHkE+c1XRVqjWMTqOyF+HeAdxLOOBxlq6VKbCtN44B7g=
From: Maxim <maximlevitsky@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ PATCH] Add suspend/resume for HPET was: Re: [3/6] 2.6.21-rc4: known regressions
Date: Thu, 29 Mar 2007 07:47:28 +0200
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
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
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703290641.20236.maximlevitsky@gmail.com> <Pine.LNX.4.64.0703282203550.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703282203550.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703290747.28929.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 07:08:58 Linus Torvalds wrote:
> 
> On Thu, 29 Mar 2007, Maxim wrote:
> >
> > 	I am sending here a patch that as was discussed here adds hpet to list of system devices
> > 	and adds suspend/resume hooks this way.
> > 	I tested it and it works fine.
> 
> Ok, it certainly looks better, but it *also* looks like it just assumes 
> the HPET is there. Which would work in testing _with_ a HPET, but would 
> likely break on hardware without one, no?
> 
> Shouldn't there be at least something like a
> 
> 	if (!is_hpet_capable())
> 		return 0;
> 
> at the top of that init routine? I'd also expect that you'd need to check 
> that "hpet_virt_address" is valid or something?
> 
> (Or, better yet, shouldn't we set "boot_hpet_disable" when we decide not 
> to use the HPET, and set hpet_virt_address to NULL?)

This is done here

out_nohpet:
	iounmap(hpet_virt_address);
	hpet_virt_address = NULL;
> 
> 		Linus
> 

Hi, 
	Of course, I forgot.

	I was planning to put sysdev code in hpet_enable()
	but it is not possible because this function is called too early.

	Thus I put sysdev initialization  in separate function but forgot to test for HPET

	Thanks a lot.

	Best regards
		Maxim Levitsky

---
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
+		sysdev_register(&hpet_device);
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

