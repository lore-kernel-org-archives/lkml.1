Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbYC0QBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbYC0QBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbYC0QA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:00:58 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:53290 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754534AbYC0QA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:00:57 -0400
Date: Thu, 27 Mar 2008 17:00:22 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: [GIT PULL] Last minute avr32 fixes
Message-ID: <20080327170022.28a445ec@hskinnemo-gx620.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2008 16:00:22.0647 (UTC) FILETIME=[A9C36870:01C89023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull

  ssh://master.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git avr32-fixes

to receive the following fixes.

Haavard Skinnemoen (3):
      avr32: Work around byteswap bug in gcc < 4.2
      avr32: Build fix for CONFIG_BUG=n
      avr32: Fix bug in early resource allocation code

 arch/avr32/kernel/setup.c     |    1 +
 arch/avr32/kernel/traps.c     |    4 ++++
 include/asm-avr32/byteorder.h |    6 ++++++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/kernel/setup.c b/arch/avr32/kernel/setup.c
index e66a07a..2687b73 100644
--- a/arch/avr32/kernel/setup.c
+++ b/arch/avr32/kernel/setup.c
@@ -163,6 +163,7 @@ add_reserved_region(resource_size_t start, resource_size_t end,
 	new->start = start;
 	new->end = end;
 	new->name = name;
+	new->sibling = next;
 	new->flags = IORESOURCE_MEM;
 
 	*pprev = new;
diff --git a/arch/avr32/kernel/traps.c b/arch/avr32/kernel/traps.c
index cf6f686..b835c4c 100644
--- a/arch/avr32/kernel/traps.c
+++ b/arch/avr32/kernel/traps.c
@@ -178,6 +178,7 @@ static int do_cop_absent(u32 insn)
 	return 0;
 }
 
+#ifdef CONFIG_BUG
 int is_valid_bugaddr(unsigned long pc)
 {
 	unsigned short opcode;
@@ -189,6 +190,7 @@ int is_valid_bugaddr(unsigned long pc)
 
 	return opcode == AVR32_BUG_OPCODE;
 }
+#endif
 
 asmlinkage void do_illegal_opcode(unsigned long ecr, struct pt_regs *regs)
 {
@@ -197,6 +199,7 @@ asmlinkage void do_illegal_opcode(unsigned long ecr, struct pt_regs *regs)
 	void __user *pc;
 	long code;
 
+#ifdef CONFIG_BUG
 	if (!user_mode(regs) && (ecr == ECR_ILLEGAL_OPCODE)) {
 		enum bug_trap_type type;
 
@@ -211,6 +214,7 @@ asmlinkage void do_illegal_opcode(unsigned long ecr, struct pt_regs *regs)
 			die("Kernel BUG", regs, SIGKILL);
 		}
 	}
+#endif
 
 	local_irq_enable();
 
diff --git a/include/asm-avr32/byteorder.h b/include/asm-avr32/byteorder.h
index 402ff41..d77b48b 100644
--- a/include/asm-avr32/byteorder.h
+++ b/include/asm-avr32/byteorder.h
@@ -12,8 +12,14 @@ extern unsigned long __builtin_bswap_32(unsigned long x);
 extern unsigned short __builtin_bswap_16(unsigned short x);
 #endif
 
+/*
+ * avr32-linux-gcc versions earlier than 4.2 improperly sign-extends
+ * the result.
+ */
+#if !(__GNUC__ == 4 && __GNUC_MINOR__ < 2)
 #define __arch__swab32(x) __builtin_bswap_32(x)
 #define __arch__swab16(x) __builtin_bswap_16(x)
+#endif
 
 #if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
 # define __BYTEORDER_HAS_U64__
