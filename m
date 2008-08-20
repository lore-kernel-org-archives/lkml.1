Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbYHTNkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbYHTNkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYHTNkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:40:11 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:31138 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYHTNkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:40:09 -0400
Message-ID: <48AC1EAF.9040906@colorfullife.com>
Date: Wed, 20 Aug 2008 15:39:59 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: hskinnemoen@atmel.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: AVR32: nmi_enter() without nmi_exit()
Content-Type: multipart/mixed;
 boundary="------------070508090609080401030406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070508090609080401030406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Haavard,

You are listed as the maintainer for AVR32. If someone else is doing 
that now, could you forward the mail?

While updating the rcu code, I noticed that do_nmi() for AVR32 is odd:
There is an nmi_enter() call without an nmi_exit().
This can't be correct, it breaks rcu (at least the preempt version) and 
lockdep.

Attached is a patch, not tested at all.

--
    Manfred

--------------070508090609080401030406
Content-Type: text/plain;
 name="patch-avr32-nmi-exit"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-avr32-nmi-exit"

diff --git a/arch/avr32/kernel/traps.c b/arch/avr32/kernel/traps.c
index b835c4c..c39cdfc 100644
--- a/arch/avr32/kernel/traps.c
+++ b/arch/avr32/kernel/traps.c
@@ -120,11 +120,11 @@ asmlinkage void do_nmi(unsigned long ecr, struct pt_regs *regs)
 	case NOTIFY_BAD:
 		die("Fatal Non-Maskable Interrupt", regs, SIGINT);
 	default:
+		printk(KERN_ALERT "Got NMI, but nobody cared. Disabling...\n");
+		nmi_disable();
 		break;
 	}
-
-	printk(KERN_ALERT "Got NMI, but nobody cared. Disabling...\n");
-	nmi_disable();
+	nmi_exit();
 }
 
 asmlinkage void do_critical_exception(unsigned long ecr, struct pt_regs *regs)

--------------070508090609080401030406--
