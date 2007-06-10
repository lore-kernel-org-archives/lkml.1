Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbXFJJd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbXFJJd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbXFJJbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:31:06 -0400
Received: from www.osadl.org ([213.239.205.134]:43065 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752259AbXFJJa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:30:58 -0400
Message-Id: <20070610092446.662428398@inhelltoy.tec.linutronix.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 10 Jun 2007 09:44:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 08/23] i386: PIT stop only, when in periodic or oneshot mode
Content-Disposition: inline; filename=i386-add-another-pit-quirk.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is necessary on one of my boxen, where programming the stop
sequence twice leads to PIT malfunction.

Sigh !

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/i386/kernel/i8253.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc4-mm/arch/i386/kernel/i8253.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/i386/kernel/i8253.c	2007-06-10 10:44:38.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/i386/kernel/i8253.c	2007-06-10 10:44:38.000000000 +0200
@@ -48,9 +48,12 @@ static void init_pit_timer(enum clock_ev
 
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	case CLOCK_EVT_MODE_UNUSED:
-		outb_p(0x30, PIT_MODE);
-		outb_p(0, PIT_CH0);	/* LSB */
-		outb_p(0, PIT_CH0);	/* MSB */
+		if (evt->mode == CLOCK_EVT_MODE_PERIODIC ||
+		    evt->mode == CLOCK_EVT_MODE_ONESHOT) {
+			outb_p(0x30, PIT_MODE);
+			outb_p(0, PIT_CH0);
+			outb_p(0, PIT_CH0);
+		}
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:

-- 

