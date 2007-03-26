Return-Path: <linux-kernel-owner+w=401wt.eu-S933760AbXCZJVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbXCZJVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933771AbXCZJVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:21:13 -0400
Received: from www.osadl.org ([213.239.205.134]:42287 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933760AbXCZJVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:21:11 -0400
Subject: [PATCH] clockevents: remove bad designed sysfs support for now
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 11:21:08 +0200
Message-Id: <1174900868.4182.21.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current sysfs support of clockevents does not obey the "only one
value per file" rule.

The real fix is not 2.6.21 material. Therefor remove the sysfs support
for now.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 67932ea..76212b2 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -274,72 +274,3 @@ void clockevents_notify(unsigned long reason, void *arg)
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
 
-#ifdef CONFIG_SYSFS
-
-/**
- * clockevents_show_registered - sysfs interface for listing clockevents
- * @dev:	unused
- * @buf:	char buffer to be filled with clock events list
- *
- * Provides sysfs interface for listing registered clock event devices
- */
-static ssize_t clockevents_show_registered(struct sys_device *dev, char *buf)
-{
-	struct list_head *tmp;
-	char *p = buf;
-	int cpu;
-
-	spin_lock(&clockevents_lock);
-
-	list_for_each(tmp, &clockevent_devices) {
-		struct clock_event_device *ce;
-
-		ce = list_entry(tmp, struct clock_event_device, list);
-		p += sprintf(p, "%-20s F:%04x M:%d", ce->name,
-			     ce->features, ce->mode);
-		p += sprintf(p, " C:");
-		if (!cpus_equal(ce->cpumask, cpu_possible_map)) {
-			for_each_cpu_mask(cpu, ce->cpumask)
-				p += sprintf(p, " %d", cpu);
-		} else {
-			/*
-			 * FIXME: Add the cpu which is handling this sucker
-			 */
-		}
-		p += sprintf(p, "\n");
-	}
-
-	spin_unlock(&clockevents_lock);
-
-	return p - buf;
-}
-
-/*
- * Sysfs setup bits:
- */
-static SYSDEV_ATTR(registered, 0600,
-		   clockevents_show_registered, NULL);
-
-static struct sysdev_class clockevents_sysclass = {
-	set_kset_name("clockevents"),
-};
-
-static struct sys_device clockevents_sys_device = {
-	.id	= 0,
-	.cls	= &clockevents_sysclass,
-};
-
-static int __init clockevents_sysfs_init(void)
-{
-	int error = sysdev_class_register(&clockevents_sysclass);
-
-	if (!error)
-		error = sysdev_register(&clockevents_sys_device);
-	if (!error)
-		error = sysdev_create_file(
-				&clockevents_sys_device,
-				&attr_registered);
-	return error;
-}
-device_initcall(clockevents_sysfs_init);
-#endif


