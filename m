Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbZBBWKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbZBBWKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZBBWKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:10:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752381AbZBBWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:10:30 -0500
Date: Mon, 2 Feb 2009 14:09:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902021407550.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021241430.3247@localhost.localdomain> <alpine.LFD.2.00.0902021251130.3247@localhost.localdomain> <200902022239.02453.rjw@sisk.pl>
 <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Feb 2009, Linus Torvalds wrote:
> 
> Ingo: how do we walk over all the interrupt descriptors in todays world? 
> The whole sparse-vs-nonsparse makes things a bit more complex. 

Stage#2 would look something like this, except I haven't written the 
"[disable|enable]_device_interrupts()" for the simple reason that I'd like 
somebody else to do it ;)

But it would basically be just

	for (irq = 1; irq < NR_IRQS; irq++)
		[disable|enable]_irq(irq);

with maybe some day some way of marking system interrupts separately (ie 
timers).

		Linus

---
 kernel/power/main.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/power/main.c b/kernel/power/main.c
index 7709556..f54acb6 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -290,14 +290,15 @@ static int suspend_enter(suspend_state_t state)
 	int error = 0;
 
 	device_pm_lock();
-	arch_suspend_disable_irqs();
-	BUG_ON(!irqs_disabled());
-
+	disable_device_interrupts();
 	if ((error = device_power_down(PMSG_SUSPEND))) {
 		printk(KERN_ERR "PM: Some devices failed to power down\n");
 		goto Done;
 	}
 
+	arch_suspend_disable_irqs();
+	BUG_ON(!irqs_disabled());
+
 	error = sysdev_suspend();
 	if (!error) {
 		if (!suspend_test(TEST_CORE))
@@ -305,10 +306,12 @@ static int suspend_enter(suspend_state_t state)
 		sysdev_resume();
 	}
 
-	device_power_up(PMSG_RESUME);
- Done:
 	arch_suspend_enable_irqs();
 	BUG_ON(irqs_disabled());
+
+	device_power_up(PMSG_RESUME);
+ Done:
+	enable_device_interrupts();
 	device_pm_unlock();
 	return error;
 }
