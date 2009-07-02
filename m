Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZGBFVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZGBFVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbZGBFVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:21:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:44562 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbZGBFVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:21:30 -0400
Message-ID: <4A4C43BC.90506@kernel.org>
Date: Wed, 01 Jul 2009 22:21:00 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix printk calling in print_local_apic
References: <4A4C3410.8080704@kernel.org> <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain> <alpine.LFD.2.01.0907012126371.3380@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0907012126371.3380@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

remove the extra <7>
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

Reported-and-Tested-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>


 arch/x86/kernel/apic/io_apic.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1718,16 +1718,19 @@ __apicdebuginit(void) print_APIC_bitfiel
 	unsigned int v;
 	int i, j;
 
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
 
@@ -1736,7 +1739,8 @@ __apicdebuginit(void) print_local_APIC(v
 	unsigned int i, v, ver, maxlvt;
 	u64 icr;
 
-	printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
+	printk(KERN_DEBUG "\n");
+	printk(KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
 	v = apic_read(APIC_ID);
 	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, read_apic_id());
