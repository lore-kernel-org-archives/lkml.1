Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbZGBG3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbZGBG3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZGBG3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:29:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33184 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbZGBG3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:29:00 -0400
Date: Thu, 2 Jul 2009 08:28:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH, v2] x86: Fix printk call in print_local_apic()
Message-ID: <20090702062847.GB23277@elte.hu>
References: <4A4C3410.8080704@kernel.org> <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain> <alpine.LFD.2.01.0907012126371.3380@localhost.localdomain> <4A4C43BC.90506@kernel.org> <20090702061254.GA23277@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702061254.GA23277@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,TRACKER_ID autolearn=no SpamAssassin version=3.2.5
	2.0 TRACKER_ID             BODY: Incorporates a tracking ID number
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> > -	printk(KERN_DEBUG "0123456789abcdef0123456789abcdef\n" KERN_DEBUG);
> > +	printk(KERN_DEBUG "0123456789abcdef0123456789abcdef\n");
> >  	for (i = 0; i < 8; i++) {
> > +		char bin[33];
> >  		v = apic_read(base + i*0x10);
> > +
> > +		/* Do we really want to print out LSB first? */
> 
> We definitely want MSB first - i'll flip around the order.

in fact i dont remember ever having relied on the bitfield nature of 
that printout. Since this is uncommon debug code, printing the plain 
hexa value is more than enough.

In fact we can compact it down to a single line:

0123456701234567012345670123456701234567012345670123456701234567

instead of 4 lines of bitfields.

So i've done the patch below that looks quite a bit simpler. Mind 
testing it, does it fix all the printout artifacts you've seen?

	Ingo

------------------>
>From ef611b322dc9a917c71f28f9498dfff0d3949779 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 2 Jul 2009 08:26:20 +0200
Subject: [PATCH] x86: Fix printk call in print_local_apic()

Instead of this:

[   75.690022] <7>printing local APIC contents on CPU#0/0:
[   75.704406] ... APIC ID:      00000000 (0)
[   75.707905] ... APIC VERSION: 00060015
[   75.722551] ... APIC TASKPRI: 00000000 (00)
[   75.725473] ... APIC PROCPRI: 00000000
[   75.728592] ... APIC LDR: 00000001
[   75.742137] ... APIC SPIV: 000001ff
[   75.744101] ... APIC ISR field:
[   75.746648] 0123456789abcdef0123456789abcdef
[   75.746649] <7>00000000000000000000000000000000

Improve the code to be saner and simpler and just print out
the bitfield in a single line using hexa values - not as a
(rather pointless) binary bitfield.

Partially reused Linus's initial fix for this.

Reported-and-Tested-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4A4C43BC.90506@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4d0216f..e32e453 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1716,25 +1716,19 @@ __apicdebuginit(void) print_IO_APIC(void)
 	return;
 }
 
-__apicdebuginit(void) print_APIC_bitfield(int base)
+__apicdebuginit(void) print_APIC_(int base)
 {
-	unsigned int v;
 	int i, j;
 
-	if (apic_verbosity == APIC_QUIET)
+	if (apic_verbosity != APIC_QUIET)
 		return;
 
-	printk(KERN_DEBUG "0123456789abcdef0123456789abcdef\n" KERN_DEBUG);
-	for (i = 0; i < 8; i++) {
-		v = apic_read(base + i*0x10);
-		for (j = 0; j < 32; j++) {
-			if (v & (1<<j))
-				printk("1");
-			else
-				printk("0");
-		}
-		printk("\n");
-	}
+	printk(KERN_DEBUG);
+
+	for (i = 0; i < 8; i++)
+		printk(KERN_CONT "%08x", i, apic_read(base + i*0x10));
+
+	printk(KERN_CONT "\n");
 }
 
 __apicdebuginit(void) print_local_APIC(void *dummy)
@@ -1745,7 +1739,8 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	if (apic_verbosity == APIC_QUIET)
 		return;
 
-	printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
+	printk(KERN_DEBUG "\n");
+	printk(KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
 	v = apic_read(APIC_ID);
 	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, read_apic_id());
