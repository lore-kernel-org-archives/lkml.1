Return-Path: <linux-kernel-owner+w=401wt.eu-S1752136AbXBJIev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbXBJIev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 03:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbXBJIev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 03:34:51 -0500
Received: from pxy2nd.nifty.com ([202.248.175.14]:16074 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752136AbXBJIeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 03:34:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=yjFituGK2rZXXQnYoNszKZ2KtcTw3qAvR4Sq9ny42mN8VF2n7wR7mtOUCnsiKIJODHgHI7qaPDay/EorZ1ERQg==  ;
Date: Sat, 10 Feb 2007 17:34:45 +0900 (JST)
Message-Id: <20070210.173445.242527990.takada@mbf.nifty.com>
To: linux-kernel@vger.kernel.org
Subject: i386: pit_latch_buggy has no effect.
From: takada <takada@mbf.nifty.com>
X-Mailer: Mew version 5.1 on Emacs 22.0.92 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
Eliminated the arch/i386/kernel/timers in 2.6.18, use clocksoures instead.
pit_latch_buggy was referred in timers/timer_tsc.c, and currently removed.
Therefore nobody refer it.
Until 2.6.17, MediaGX's TSC works correctly. after 2.6.18, warned
"TSC appears to be running slowly. Marking it as unstable". So marked 
unstable TSC when CS55x0.


diff -Naru a/arch/i386/kernel/cpu/cyrix.c b/arch/i386/kernel/cpu/cyrix.c
--- a/arch/i386/kernel/cpu/cyrix.c	2007-02-05 03:44:54.000000000 +0900
+++ b/arch/i386/kernel/cpu/cyrix.c	2007-02-10 16:11:31.000000000 +0900
@@ -278,7 +278,7 @@
 		 *  The 5510/5520 companion chips have a funky PIT.
 		 */  
 		if (pci_dev_present(cyrix_55x0))
-			pit_latch_buggy = 1;
+			mark_tsc_unstable();
 #endif
 		c->x86_cache_size=16;	/* Yep 16K integrated cache thats it */
 
diff -Naru a/arch/i386/kernel/time.c b/arch/i386/kernel/time.c
--- a/arch/i386/kernel/time.c	2007-02-05 03:44:54.000000000 +0900
+++ b/arch/i386/kernel/time.c	2007-02-10 16:12:04.000000000 +0900
@@ -70,8 +70,6 @@
 
 #include <asm/i8259.h>
 
-int pit_latch_buggy;              /* extern */
-
 #include "do_timer.h"
 
 unsigned int cpu_khz;	/* Detected as we calibrate the TSC */
diff -Naru a/include/asm-i386/timer.h b/include/asm-i386/timer.h
--- a/include/asm-i386/timer.h	2007-02-05 03:44:54.000000000 +0900
+++ b/include/asm-i386/timer.h	2007-02-10 16:12:21.000000000 +0900
@@ -5,8 +5,6 @@
 
 #define TICK_SIZE (tick_nsec / 1000)
 void setup_pit_timer(void);
-/* Modifiers for buggy PIT handling */
-extern int pit_latch_buggy;
 extern int timer_ack;
 extern int recalibrate_cpu_khz(void);
 

