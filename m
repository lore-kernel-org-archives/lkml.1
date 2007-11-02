Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbXKBR0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbXKBR0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbXKBR0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:26:43 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:58802 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbXKBR0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:26:42 -0400
Date: Fri, 2 Nov 2007 17:26:06 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Use i8253.c lock for PC speaker on MIPS, too.
Message-ID: <20071102172606.GA29513@linux-mips.org>
References: <20071102161650.GA28459@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102161650.GA28459@linux-mips.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Jazz machines have to use the PIT timer for dyntick and highresolution
kernels.  This may break because currently just like i386 used to do MIPS
uses two separate spinlocks in the actual PIT code and the PC speaker
code.  So switch to do it the same that x86 currently does PIT locking.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

---
Linus, this patch is meant to be applied on top of the pull request I mailed
you earlier today.

 arch/mips/kernel/i8253.c    |    2 +-
 drivers/input/misc/pcspkr.c |    2 +-
 include/asm-mips/i8253.h    |    4 ++++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
index a925abd..c2d497c 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
@@ -14,7 +14,7 @@
 #include <asm/io.h>
 #include <asm/time.h>
 
-static DEFINE_SPINLOCK(i8253_lock);
+DEFINE_SPINLOCK(i8253_lock);
 
 /*
  * Initialize the PIT timer.
diff --git a/drivers/input/misc/pcspkr.c b/drivers/input/misc/pcspkr.c
index 4941a9e..43aaa5c 100644
--- a/drivers/input/misc/pcspkr.c
+++ b/drivers/input/misc/pcspkr.c
@@ -24,7 +24,7 @@ MODULE_DESCRIPTION("PC Speaker beeper driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:pcspkr");
 
-#ifdef CONFIG_X86
+#if defined(CONFIG_MIPS) || defined(CONFIG_X86)
 /* Use the global PIT lock ! */
 #include <asm/i8253.h>
 #else
diff --git a/include/asm-mips/i8253.h b/include/asm-mips/i8253.h
index 778b2f0..032ca73 100644
--- a/include/asm-mips/i8253.h
+++ b/include/asm-mips/i8253.h
@@ -5,11 +5,15 @@
 #ifndef __ASM_I8253_H
 #define __ASM_I8253_H
 
+#include <linux/spinlock.h>
+
 /* i8253A PIT registers */
 #define PIT_MODE		0x43
 #define PIT_CH0			0x40
 #define PIT_CH2			0x42
 
+extern spinlock_t i8253_lock;
+
 extern void setup_pit_timer(void);
 
 #endif /* __ASM_I8253_H */
