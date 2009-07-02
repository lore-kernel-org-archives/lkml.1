Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZGBG7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZGBG7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbZGBG7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:59:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38315 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZGBG7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:59:40 -0400
Date: Thu, 2 Jul 2009 08:59:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH, v4] x86: Fix printk call in print_local_apic()
Message-ID: <20090702065922.GB28135@elte.hu>
References: <4A4C3410.8080704@kernel.org> <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain> <alpine.LFD.2.01.0907012126371.3380@localhost.localdomain> <4A4C43BC.90506@kernel.org> <20090702061254.GA23277@elte.hu> <20090702062847.GB23277@elte.hu> <20090701234848.03dfa601.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701234848.03dfa601.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 2 Jul 2009 08:28:47 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > +		printk(KERN_CONT "%08x", i, apic_read(base + i*0x10));
> 
> oop - compile it first ;)

oops - v4 below ...

> There was some talk about teaching the lib/hexdump.c code to be 
> able to take a caller-provided give-me-another-byte function 
> pointer.  This is the first potential user of such a thing which I 
> recall seeing, so it's probably good that we didn't do it ;)

This at most has 'give me another 4 bytes' - plus there's some 
indexing weirdness as well. (the bitfield is holey in the MSR range)

Dunno. Once the facility is available this code can be updated to 
use it, although it's certainly obvious enough in its current form 
already.

	Ingo

------------------->
>From 251e1e44b97852aa5e53e71c4b47e55b2dfd054e Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 2 Jul 2009 08:54:01 +0200
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
 arch/x86/kernel/apic/io_apic.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4d0216f..8fd1efb 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1716,25 +1716,19 @@ __apicdebuginit(void) print_IO_APIC(void)
 	return;
 }
 
-__apicdebuginit(void) print_APIC_bitfield(int base)
+__apicdebuginit(void) print_APIC_field(int base)
 {
-	unsigned int v;
-	int i, j;
+	int i;
 
 	if (apic_verbosity == APIC_QUIET)
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
+		printk(KERN_CONT "%08x", apic_read(base + i*0x10));
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
@@ -1786,11 +1781,11 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	printk(KERN_DEBUG "... APIC SPIV: %08x\n", v);
 
 	printk(KERN_DEBUG "... APIC ISR field:\n");
-	print_APIC_bitfield(APIC_ISR);
+	print_APIC_field(APIC_ISR);
 	printk(KERN_DEBUG "... APIC TMR field:\n");
-	print_APIC_bitfield(APIC_TMR);
+	print_APIC_field(APIC_TMR);
 	printk(KERN_DEBUG "... APIC IRR field:\n");
-	print_APIC_bitfield(APIC_IRR);
+	print_APIC_field(APIC_IRR);
 
 	if (APIC_INTEGRATED(ver)) {             /* !82489DX */
 		if (maxlvt > 3)         /* Due to the Pentium erratum 3AP. */
