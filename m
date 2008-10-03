Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbYJCURS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbYJCURS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 16:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYJCURI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 16:17:08 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:14365 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbYJCURH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 16:17:07 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 5/9] traps: i386: expand clear_mem_error and remove from mach_traps.h
Date: Fri,  3 Oct 2008 22:00:36 +0200
Message-Id: <1223064040-23170-6-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223064040-23170-5-git-send-email-heukelum@fastmail.fm>
References: <1223064040-23170-1-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-2-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-3-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-4-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-5-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Fri, 03 Oct 2008 22:16:50 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.242; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the last user of clear_mem_error, which is defined
only on i386. Expand the inline function and remove it from
include/asm-x86/mach-default/mach_traps.h

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c                |    3 ++-
 include/asm-x86/mach-default/mach_traps.h |    6 ------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 535c41a..adc70ee 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -314,7 +314,8 @@ mem_parity_error(unsigned char reason, struct pt_regs *regs)
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 
 	/* Clear and disable the memory parity error line. */
-	clear_mem_error(reason);
+	reason = (reason & 0xf) | 4;
+	outb(reason, 0x61);
 }
 
 static notrace __kprobes void
diff --git a/include/asm-x86/mach-default/mach_traps.h b/include/asm-x86/mach-default/mach_traps.h
index de9ac3f..ff8778f 100644
--- a/include/asm-x86/mach-default/mach_traps.h
+++ b/include/asm-x86/mach-default/mach_traps.h
@@ -7,12 +7,6 @@
 
 #include <asm/mc146818rtc.h>
 
-static inline void clear_mem_error(unsigned char reason)
-{
-	reason = (reason & 0xf) | 4;
-	outb(reason, 0x61);
-}
-
 static inline unsigned char get_nmi_reason(void)
 {
 	return inb(0x61);
-- 
1.5.4.3

