Return-Path: <linux-kernel-owner+w=401wt.eu-S964975AbXBLQvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964975AbXBLQvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964985AbXBLQvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:51:33 -0500
Received: from mx1.suse.de ([195.135.220.2]:47919 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964975AbXBLQvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:31 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: Roland Dreier <rdreier@cisco.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [8/29] x86_64: avoid warning message livelock
Message-Id: <20070212165128.2460213FC3@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Roland Dreier <rdreier@cisco.com>

I've seen my box paralyzed by an endless spew of

    rtc: lost some interrupts at 1024Hz.

messages on the serial console.  What seems to be happening is that
something real causes an interrupt to be lost and triggers the
message.  But then printing the message to the serial console (from
the hpet interrupt handler) takes more than 1/1024th of a second, and
then some more interrupts are lost, so the message triggers again....

Fix this by adding a printk_ratelimit() before printing the warning.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/time.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/time.c
===================================================================
--- linux.orig/arch/x86_64/kernel/time.c
+++ linux/arch/x86_64/kernel/time.c
@@ -1226,8 +1226,9 @@ static void hpet_rtc_timer_reinit(void)
 		if (PIE_on)
 			PIE_count += lost_ints;
 
-		printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n",
-		       hpet_rtc_int_freq);
+		if (printk_ratelimit())
+			printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n",
+			       hpet_rtc_int_freq);
 	}
 }
 
