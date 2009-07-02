Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZGBE3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZGBE3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 00:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbZGBE32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 00:29:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbZGBE31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 00:29:27 -0400
Date: Wed, 1 Jul 2009 21:28:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: printk regression?
In-Reply-To: <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0907012126371.3380@localhost.localdomain>
References: <4A4C3410.8080704@kernel.org> <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Jul 2009, Linus Torvalds wrote:
>
> Same goes for the insane binary printing crap. How about just making it 
> sane?

Untested.

Note the comment. I kept it doing the insane thing (print out bit#0 as the 
first bit), but do wonder if that's really what you want. Normally, you 
print the least-significant-bit right-most.

		Linus
---
 arch/x86/kernel/apic/io_apic.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4d0216f..cf52a29 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1724,16 +1724,19 @@ __apicdebuginit(void) print_APIC_bitfield(int base)
 	if (apic_verbosity == APIC_QUIET)
 		return;
 
-	printk(KERN_DEBUG "0123456789abcdef0123456789abcdef\n" KERN_DEBUG);
+	printk(KERN_DEBUG "0123456789abcdef0123456789abcdef\n");
 	for (i = 0; i < 8; i++) {
+		char bin[33];
 		v = apic_read(base + i*0x10);
+
+		/* Do we really want to print out LSB first? */
 		for (j = 0; j < 32; j++) {
-			if (v & (1<<j))
-				printk("1");
-			else
-				printk("0");
+			bin[j] = '0' + (v&1);
+			v >>= 1;
 		}
-		printk("\n");
+		bin[32] = 0;
+
+		printk(KERN_DEBUG "%s\n", bin);
 	}
 }
 
@@ -1745,7 +1748,7 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	if (apic_verbosity == APIC_QUIET)
 		return;
 
-	printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
+	printk(KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
 	v = apic_read(APIC_ID);
 	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, read_apic_id());
