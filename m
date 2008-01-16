Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbYAPV4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbYAPV4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbYAPVzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:55:55 -0500
Received: from mail.queued.net ([207.210.101.209]:4846 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbYAPVzy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:55:54 -0500
Date: Wed, 16 Jan 2008 16:56:06 -0500
From: Andres Salomon <dilinger@queued.net>
To: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
Cc: linux-kernel@vger.kernel.org, Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
Message-ID: <20080116165606.3ebc06a4@ephemeral>
In-Reply-To: <20080116161912.7b449466@ephemeral>
References: <478E4267.7020509@i4.informatik.rwth-aachen.de>
	<20080116161912.7b449466@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008 16:19:12 -0500
Andres Salomon <dilinger@queued.net> wrote:

> On Wed, 16 Jan 2008 18:44:07 +0100
> Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:
> 
> > Hi,
> > 
> > I'm trying to boot 2.6.24-rc8 on a GEODE LX board (ALIX.3),
> > and it hangs during boot:
> > 
> > [   12.689971] NET: Registered protocol family 16
> > [   12.703329] geode-mfgpt:  Registered timer 0
> > [   12.716149] mfgpt-timer:  registering the MFGT timer as a clock event...
> > 
> 
> 
> What BIOS are you using?  It's possible that our detection code is
> failing to detect in-use timers.


Also, could you provide a log with the following (untested) patch?  I'm
curious how many MFGPTs we're actually detecting as being available, and
the existing code is backwards.



>From 0ea825fd564056ac653507517beb5cea9034e464 Mon Sep 17 00:00:00 2001
From: Andres Salomon <dilinger@debian.org>
Date: Wed, 16 Jan 2008 16:53:16 -0500
Subject: [PATCH] x86: geode: fix up ordering of messages during MFGPT detection

We're printing out informational messages in the wrong order while
probing for MFGPTs.  This changes the order so that we first display
the number of available timers that were detected before displaying
messages about how we actually are using those timers.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 arch/x86/kernel/geode_32.c |    5 +----
 arch/x86/kernel/mfgpt_32.c |    7 +++----
 include/asm-x86/geode.h    |    2 +-
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/geode_32.c b/arch/x86/kernel/geode_32.c
index f12d8c5..00b45ae 100644
--- a/arch/x86/kernel/geode_32.c
+++ b/arch/x86/kernel/geode_32.c
@@ -145,14 +145,11 @@ EXPORT_SYMBOL_GPL(geode_gpio_setup_event);
 
 static int __init geode_southbridge_init(void)
 {
-	int timers;
-
 	if (!is_geode())
 		return -ENODEV;
 
 	init_lbars();
-	timers = geode_mfgpt_detect();
-	printk(KERN_INFO "geode:  %d MFGPT timers available.\n", timers);
+	geode_mfgpt_detect();
 	return 0;
 }
 
diff --git a/arch/x86/kernel/mfgpt_32.c b/arch/x86/kernel/mfgpt_32.c
index 0ab680f..d11cba3 100644
--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -70,14 +70,14 @@ __setup("nomfgpt", mfgpt_disable);
  * In other cases (such as with VSAless OpenFirmware), the system firmware
  * leaves timers available for us to use.
  */
-int __init geode_mfgpt_detect(void)
+void __init geode_mfgpt_detect(void)
 {
 	int count = 0, i;
 	u16 val;
 
 	if (disable) {
 		printk(KERN_INFO "geode-mfgpt:  Skipping MFGPT setup\n");
-		return 0;
+		return;
 	}
 
 	for (i = 0; i < MFGPT_MAX_TIMERS; i++) {
@@ -87,11 +87,10 @@ int __init geode_mfgpt_detect(void)
 			count++;
 		}
 	}
+	printk(KERN_INFO "geode-mfgpt:  %d MFGPT timers available.\n", count);
 
 	/* set up clock event device, if desired */
 	i = mfgpt_timer_setup();
-
-	return count;
 }
 
 int geode_mfgpt_toggle_event(int timer, int cmp, int event, int enable)
diff --git a/include/asm-x86/geode.h b/include/asm-x86/geode.h
index 771af33..1cb22cf 100644
--- a/include/asm-x86/geode.h
+++ b/include/asm-x86/geode.h
@@ -200,7 +200,7 @@ static inline u16 geode_mfgpt_read(int timer, u16 reg)
 	return inw(base + reg + (timer * 8));
 }
 
-extern int __init geode_mfgpt_detect(void);
+extern void __init geode_mfgpt_detect(void);
 extern int geode_mfgpt_toggle_event(int timer, int cmp, int event, int enable);
 extern int geode_mfgpt_set_irq(int timer, int cmp, int irq, int enable);
 extern int geode_mfgpt_alloc_timer(int timer, int domain, struct module *owner);
-- 
1.5.3.5

