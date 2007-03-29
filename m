Return-Path: <linux-kernel-owner+w=401wt.eu-S965944AbXC2Ele@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965944AbXC2Ele (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 00:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965955AbXC2Eld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 00:41:33 -0400
Received: from hu-out-0506.google.com ([72.14.214.226]:54546 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965948AbXC2Elb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 00:41:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=T2m1YlogNJDfUFByhxS9QWtZhV4xlq3AF6lKFI9S6+4CcZCNjYHV107FTU7IIw7mPbZOI6aZ6gn2dCvhq45qHnVXR3AVCrXHURiO8XkQ51vA7Wb2pwQguRs0Pc6ls9Reoi0jk+46soocs/FBmNB6bHCTxAEOvcJej5cDSZuoV8c=
From: Maxim <maximlevitsky@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ PATCH] Add suspend/resume for HPET was: Re: [3/6] 2.6.21-rc4: known regressions
Date: Thu, 29 Mar 2007 06:41:16 +0200
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
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703281701.23876.maximlevitsky@gmail.com> <Pine.LNX.4.64.0703280931520.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703280931520.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703290641.20236.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 18:38:48 Linus Torvalds wrote:
> 
> On Wed, 28 Mar 2007, Maxim wrote:
> > 
> > 	Now I don't have a clue how to set those bits if only HPET is used as clock source because now clocksources
> > 	don't have _any_ resume hook.
> 
> One thing that drives me wild about that "clocksource resume" thing is 
> that it seems to think that clocksources are somehow different from any 
> other system devices..
> 
> Why isn't the HPET considered a "device", and has it's own *device* 
> "suspend" and "resume"? Why do we seem to think that only "set_mode()" 
> etc should wake up clock sources?
> 
> It's a *device*, dammit. It should save and resume like one (probably as a 
> system device). The "set_mode()" etc stuff is at a completely different 
> (higher) conceptual level.
> 
> Thomas? It does seem like Maxim has hit the nail on the head (at least 
> partly) on the HPET timer resume problems..
> 
> 		Linus
> 


Hi,
	I am sending here a patch that as was discussed here adds hpet to list of system devices
	and adds suspend/resume hooks this way.
	I tested it and it works fine.

---
Add suspend/resume support for HPET
Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

---
 arch/i386/kernel/hpet.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/arch/i386/kernel/hpet.c b/arch/i386/kernel/hpet.c
index 0fd9fba..ac41476 100644
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
@@ -524,3 +526,65 @@ irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
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

