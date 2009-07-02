Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbZGBHIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbZGBHIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 03:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZGBHH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 03:07:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:54576 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601AbZGBHH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 03:07:56 -0400
Date: Thu, 2 Jul 2009 07:07:22 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A4C43BC.90506@kernel.org>
References: <4A4C43BC.90506@kernel.org>
Subject: [tip:x86/urgent] x86: Fix printk call in print_local_apic()
Message-ID: <tip-251e1e44b97852aa5e53e71c4b47e55b2dfd054e@git.kernel.org>
Git-Commit-ID: 251e1e44b97852aa5e53e71c4b47e55b2dfd054e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Jul 2009 07:07:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  251e1e44b97852aa5e53e71c4b47e55b2dfd054e
Gitweb:     http://git.kernel.org/tip/251e1e44b97852aa5e53e71c4b47e55b2dfd054e
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 2 Jul 2009 08:54:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Jul 2009 08:54:08 +0200

x86: Fix printk call in print_local_apic()

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
