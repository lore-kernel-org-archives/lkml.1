Return-Path: <linux-kernel-owner+w=401wt.eu-S938243AbXGSKYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938243AbXGSKYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762780AbXGSJ4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:56:10 -0400
Received: from mx1.suse.de ([195.135.220.2]:35443 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947AbXGSJzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:47 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: trux@truxton.com, lee-in-berlin@web.de, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [51/58] i386: fix machine rebooting
Message-Id: <20070719095538.2965B14E05@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Truxton Fulton <trux@truxton.com>

59f4e7d572980a521b7bdba74ab71b21f5995538 fixed machine rebooting on Truxton's
machine (when no keyboard was present).  But it broke it on Lee's machine.

The patch reinstates the old (pre-59f4e7d572980a521b7bdba74ab71b21f5995538)
code and if that doesn't work out, try the new,
post-59f4e7d572980a521b7bdba74ab71b21f5995538 code instead.

Cc: Lee Garrett <lee-in-berlin@web.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/asm-i386/mach-default/mach_reboot.h |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

Index: linux/include/asm-i386/mach-default/mach_reboot.h
===================================================================
--- linux.orig/include/asm-i386/mach-default/mach_reboot.h
+++ linux/include/asm-i386/mach-default/mach_reboot.h
@@ -19,14 +19,37 @@ static inline void kb_wait(void)
 static inline void mach_reboot(void)
 {
 	int i;
+
+	/* old method, works on most machines */
 	for (i = 0; i < 10; i++) {
 		kb_wait();
 		udelay(50);
+		outb(0xfe, 0x64);	/* pulse reset low */
+		udelay(50);
+	}
+
+	/* New method: sets the "System flag" which, when set, indicates
+	 * successful completion of the keyboard controller self-test (Basic
+	 * Assurance Test, BAT).  This is needed for some machines with no
+	 * keyboard plugged in.  This read-modify-write sequence sets only the
+	 * system flag
+	 */
+	for (i = 0; i < 10; i++) {
+		int cmd;
+
+		outb(0x20, 0x64);	/* read Controller Command Byte */
+		udelay(50);
+		kb_wait();
+		udelay(50);
+		cmd = inb(0x60);
+		udelay(50);
+		kb_wait();
+		udelay(50);
 		outb(0x60, 0x64);	/* write Controller Command Byte */
 		udelay(50);
 		kb_wait();
 		udelay(50);
-		outb(0x14, 0x60);	/* set "System flag" */
+		outb(cmd | 0x04, 0x60);	/* set "System flag" */
 		udelay(50);
 		kb_wait();
 		udelay(50);
