Return-Path: <linux-kernel-owner+w=401wt.eu-S933406AbXCEM2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406AbXCEM2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 07:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933403AbXCEM2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 07:28:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48432 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406AbXCEM2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 07:28:17 -0500
Date: Mon, 5 Mar 2007 13:20:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [patch] disable NMI watchdog by default
Message-ID: <20070305122011.GA16133@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Andrew sent the patch below (which is now months old and has been in -mm 
for some time) towards Andi's tree 4 weeks ago, but apparently it fell 
into a black hole there - the patch is still not upstream!

This is a must-have for v2.6.21, because the problem still triggers even 
with the latest upstream tree, if i boot a KVM guest.

Frankly, i find it ridiculous that i had to write more than 10 emails 
about this stupid topic already, while i'm the original author of this 
feature to begin with. The "do not enable by default debug features that 
break certain systems" concept is obvious to me.

This category of regressions has been introduced by Andi when he made 
the NMI watchdog the default in certain scenarios at around v2.6.18 - 
over my repeated objections. Andi Cc:-ed :-)

	Ingo

----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----

From: Ingo Molnar <mingo@elte.hu>
Subject: [patch] disable NMI watchdog by default

there's a new NMI watchdog related problem: KVM crashes on certain 
bzImages because ... we enable the NMI watchdog by default (even if the 
user does not ask for it) , and no other OS on this planet does that so 
KVM doesnt have emulation for that yet. So KVM injects a #GP, which 
crashes the Linux guest:

 general protection fault: 0000 [#1]
 PREEMPT SMP
 Modules linked in:
 CPU:    0
 EIP:    0060:[<c011a8ae>]    Not tainted VLI
 EFLAGS: 00000246   (2.6.20-rc5-rt0 #3)
 EIP is at setup_apic_nmi_watchdog+0x26d/0x3d3

and no, i did /not/ request an nmi_watchdog on the boot command line!

Solution: turn off that darn thing! It's a debug tool, not a 'make life 
harder' tool!!

with this patch the KVM guest boots up just fine.

And with this my laptop (Lenovo T60) also stopped its sporadic hard 
hanging (sometimes in acpi_init(), sometimes later during bootup, 
sometimes much later during actual use) as well. It hung with both 
nmi_watchdog=1 and nmi_watchdog=2, so it's generally the fact of NMI 
injection that is causing problems, not the NMI watchdog variant, nor 
any particular bootup code.

The patch is unintrusive.

Signed-off-by: Ingo Molnar <mingo@elte.hu>

Index: linux/include/asm-i386/nmi.h
===================================================================
--- linux.orig/include/asm-i386/nmi.h
+++ linux/include/asm-i386/nmi.h
@@ -33,7 +33,7 @@ extern int nmi_watchdog_tick (struct pt_
 
 extern atomic_t nmi_active;
 extern unsigned int nmi_watchdog;
-#define NMI_DEFAULT     -1
+#define NMI_DEFAULT     0
 #define NMI_NONE	0
 #define NMI_IO_APIC	1
 #define NMI_LOCAL_APIC	2
Index: linux/include/asm-x86_64/nmi.h
===================================================================
--- linux.orig/include/asm-x86_64/nmi.h
+++ linux/include/asm-x86_64/nmi.h
@@ -63,7 +63,7 @@ extern int setup_nmi_watchdog(char *);
 
 extern atomic_t nmi_active;
 extern unsigned int nmi_watchdog;
-#define NMI_DEFAULT	-1
+#define NMI_DEFAULT	0
 #define NMI_NONE	0
 #define NMI_IO_APIC	1
 #define NMI_LOCAL_APIC	2

