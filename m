Return-Path: <linux-kernel-owner+w=401wt.eu-S1763041AbXGZMck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763041AbXGZMck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbXGZMca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:32:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36099 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbXGZMc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:32:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <ak@suse.de>
Subject: [2.6.23-rc1 REGRESSION] CPU hotplug totally broken on HPC nx6325 (x86_64)
Date: Thu, 26 Jul 2007 14:40:49 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707261440.50649.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On my Turion64-based HPC nx6325 with the 2.6.23-rc1 x86_64 kernel doing

# echo 0 > /sys/devices/system/cpu/cpu1/online

causes the system to crash in a spectacular fashion (call traces going
continuously on the console, no reaction to anything except for the power
button).  For this reason, suspend and hibernation don't work as well.

Bisection has shown that your commit 19d36ccdc34f5ed444f8a6af0cbfdb6790eb1177
"x86: Fix alternatives and kprobes to remap write-protected kernel text" causes
that to happen and indeed after applying the appended patch the problem doesn't
show up any more.

[In the first version of the appended patch I forgot to add the chunk in
mark_rodata_ro() and thus I got an oops from the line added to nop_out().
I wonder if that might be related to the $subject problem.]

Strangely enough, everything works fine on my second test box based on a
dual-core Athlon 64.

Unfortunately, I can't get any debugging information from the box after the
failure.  I can try to set up netconsole, but I don't really expect it to work.

Greetings,
Rafael


---
 arch/i386/kernel/alternative.c |    8 ++++++--
 arch/i386/kernel/kprobes.c     |    8 ++++++--
 arch/x86_64/kernel/kprobes.c   |    9 +++++++--
 arch/x86_64/mm/init.c          |   10 ++++++++++
 4 files changed, 29 insertions(+), 6 deletions(-)

Index: linux-2.6.23-rc1/arch/i386/kernel/alternative.c
===================================================================
--- linux-2.6.23-rc1.orig/arch/i386/kernel/alternative.c
+++ linux-2.6.23-rc1/arch/i386/kernel/alternative.c
@@ -156,7 +156,7 @@ static void nop_out(void *insns, unsigne
 		unsigned int noplen = len;
 		if (noplen > ASM_NOP_MAX)
 			noplen = ASM_NOP_MAX;
-		text_poke(insns, noptable[noplen], noplen);
+		memcpy(insns, noptable[noplen], noplen);
 		insns += noplen;
 		len -= noplen;
 	}
@@ -208,7 +208,7 @@ static void alternatives_smp_lock(u8 **s
 			continue;
 		if (*ptr > text_end)
 			continue;
-		text_poke(*ptr, ((unsigned char []){0xf0}), 1); /* add lock prefix */
+		**ptr = 0xf0; /* lock prefix */
 	};
 }
 
@@ -366,6 +366,10 @@ void apply_paravirt(struct paravirt_patc
 		/* Pad the rest with nops */
 		nop_out(p->instr + used, p->len - used);
 	}
+
+	/* Sync to be conservative, in case we patched following
+	 * instructions */
+	sync_core();
 }
 extern struct paravirt_patch_site __start_parainstructions[],
 	__stop_parainstructions[];
Index: linux-2.6.23-rc1/arch/i386/kernel/kprobes.c
===================================================================
--- linux-2.6.23-rc1.orig/arch/i386/kernel/kprobes.c
+++ linux-2.6.23-rc1/arch/i386/kernel/kprobes.c
@@ -170,12 +170,16 @@ int __kprobes arch_prepare_kprobe(struct
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
+	*p->addr = BREAKPOINT_INSTRUCTION;
+	flush_icache_range((unsigned long) p->addr,
+			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	text_poke(p->addr, &p->opcode, 1);
+	*p->addr = p->opcode;
+	flush_icache_range((unsigned long) p->addr,
+			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
Index: linux-2.6.23-rc1/arch/x86_64/kernel/kprobes.c
===================================================================
--- linux-2.6.23-rc1.orig/arch/x86_64/kernel/kprobes.c
+++ linux-2.6.23-rc1/arch/x86_64/kernel/kprobes.c
@@ -39,6 +39,7 @@
 #include <linux/module.h>
 #include <linux/kdebug.h>
 
+#include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/alternative.h>
@@ -209,12 +210,16 @@ static void __kprobes arch_copy_kprobe(s
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
+	*p->addr = BREAKPOINT_INSTRUCTION;
+	flush_icache_range((unsigned long) p->addr,
+			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	text_poke(p->addr, &p->opcode, 1);
+	*p->addr = p->opcode;
+	flush_icache_range((unsigned long) p->addr,
+			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
Index: linux-2.6.23-rc1/arch/x86_64/mm/init.c
===================================================================
--- linux-2.6.23-rc1.orig/arch/x86_64/mm/init.c
+++ linux-2.6.23-rc1/arch/x86_64/mm/init.c
@@ -600,6 +600,16 @@ void mark_rodata_ro(void)
 {
 	unsigned long start = (unsigned long)_stext, end;
 
+#ifdef CONFIG_HOTPLUG_CPU
+	/* It must still be possible to apply SMP alternatives. */
+	if (num_possible_cpus() > 1)
+		start = (unsigned long)_etext;
+#endif
+
+#ifdef CONFIG_KPROBES
+	start = (unsigned long)__start_rodata;
+#endif
+	
 	end = (unsigned long)__end_rodata;
 	start = (start + PAGE_SIZE - 1) & PAGE_MASK;
 	end &= PAGE_MASK;
