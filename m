Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbZBVSOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbZBVSOB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 13:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbZBVSNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 13:13:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437AbZBVSNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 13:13:51 -0500
Date: Sun, 22 Feb 2009 10:13:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 0/2] Rework disabling of interrupts during
 suspend-resume
In-Reply-To: <200902221837.49396.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902221007150.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Feb 2009, Rafael J. Wysocki wrote:
> 
> However, x86 currently doesn't set the IRQF_TIMER flag and I need to 
> make it do so before going further in this direction and changing the 
> PCI PM framework to take advantage of the $subject changes, for example. 

Actually, you don't.

The modern form of timer interrupt on x86 is the local apic timer, and it 
doesn't go through the io-apic at all, and is not even visible to the irq 
subsystem. So it stays enabled through this all.

But for old-style timer interrupts, something like the appended should 
do it.

Untested, of course, but it looks obvious enough.

		Linus

---
 arch/x86/kernel/time_64.c     |    2 +-
 arch/x86/kernel/vmiclock_32.c |    3 ++-
 arch/x86/mach-default/setup.c |    2 +-
 arch/x86/mach-voyager/setup.c |    2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index e6e695a..241ec39 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -115,7 +115,7 @@ unsigned long __init calibrate_cpu(void)
 
 static struct irqaction irq0 = {
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING,
+	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING | IRQF_TIMER,
 	.mask		= CPU_MASK_NONE,
 	.name		= "timer"
 };
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index bde106c..7a29d5c 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -1,3 +1,4 @@
+
 /*
  * VMI paravirtual timer support routines.
  *
@@ -202,7 +203,7 @@ static irqreturn_t vmi_timer_interrupt(int irq, void *dev_id)
 static struct irqaction vmi_clock_action  = {
 	.name 		= "vmi-timer",
 	.handler 	= vmi_timer_interrupt,
-	.flags 		= IRQF_DISABLED | IRQF_NOBALANCING,
+	.flags 		= IRQF_DISABLED | IRQF_NOBALANCING, IRQF_TIMER,
 	.mask 		= CPU_MASK_ALL,
 };
 
diff --git a/arch/x86/mach-default/setup.c b/arch/x86/mach-default/setup.c
index a265a7c..d737542 100644
--- a/arch/x86/mach-default/setup.c
+++ b/arch/x86/mach-default/setup.c
@@ -96,7 +96,7 @@ void __init trap_init_hook(void)
 
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL, IRQF_TIMER,
 	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };
diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
index d914a79..4de9e08 100644
--- a/arch/x86/mach-voyager/setup.c
+++ b/arch/x86/mach-voyager/setup.c
@@ -56,7 +56,7 @@ void __init trap_init_hook(void)
 
 static struct irqaction irq0 = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL, IRQF_TIMER,
 	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };

