Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbZCIHqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbZCIHqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 03:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbZCIHqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 03:46:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40999 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbZCIHqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 03:46:45 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: Abhishek Sagar <sagar.abhishek@gmail.com>,
       Russell King <linux@arm.linux.org.uk>,
       Steven Rostedt <rostedt@rostedt.homelinux.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] ftrace: fix crash due to tracing of __naked functions
Date: Mon,  9 Mar 2009 08:46:40 +0100
Message-Id: <1236584800-7686-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fix for the following crash observed in 2.6.29-rc3:
http://lkml.org/lkml/2009/1/29/150

On ARM it doesn't make sense to trace a naked function because then
mcount is called without stack and frame pointer being set up and there
is no chance to restore the lr register to the value before mcount was
called.

Compared to the original fix posted to arm-linux-kernel ML on 29 Jan
2009 by Abhishek Sagar I only changed the definition of __naked for ARM.

Reported-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Steven Rostedt <rostedt@home.goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

without this change a kernel having CONFIG_FUNCTION_TRACER=y doesn't
boot on many maschines.  It would be great if this change would make it
into .29.

The change of include/linux/compiler-gcc.h isn't pretty, but this is the
best change I currently see without bigger modifications.

Best regards
Uwe

 arch/arm/kernel/fiq.c           |    4 ++--
 arch/arm/mm/copypage-feroceon.c |    2 +-
 arch/arm/mm/copypage-v3.c       |    2 +-
 arch/arm/mm/copypage-v4mc.c     |    2 +-
 arch/arm/mm/copypage-v4wb.c     |    2 +-
 arch/arm/mm/copypage-v4wt.c     |    2 +-
 arch/arm/mm/copypage-xsc3.c     |    2 +-
 arch/arm/mm/copypage-xscale.c   |    2 +-
 include/linux/compiler-gcc.h    |    6 ++++++
 9 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 36f81d9..6ff7919 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -88,7 +88,7 @@ void set_fiq_handler(void *start, unsigned int length)
  * disable irqs for the duration.  Note - these functions are almost
  * entirely coded in assembly.
  */
-void __attribute__((naked)) set_fiq_regs(struct pt_regs *regs)
+void __naked set_fiq_regs(struct pt_regs *regs)
 {
 	register unsigned long tmp;
 	asm volatile (
@@ -106,7 +106,7 @@ void __attribute__((naked)) set_fiq_regs(struct pt_regs *regs)
 	: "r" (&regs->ARM_r8), "I" (PSR_I_BIT | PSR_F_BIT | FIQ_MODE));
 }
 
-void __attribute__((naked)) get_fiq_regs(struct pt_regs *regs)
+void __naked get_fiq_regs(struct pt_regs *regs)
 {
 	register unsigned long tmp;
 	asm volatile (
diff --git a/arch/arm/mm/copypage-feroceon.c b/arch/arm/mm/copypage-feroceon.c
index c3ba6a9..70997d5 100644
--- a/arch/arm/mm/copypage-feroceon.c
+++ b/arch/arm/mm/copypage-feroceon.c
@@ -13,7 +13,7 @@
 #include <linux/init.h>
 #include <linux/highmem.h>
 
-static void __attribute__((naked))
+static void __naked
 feroceon_copy_user_page(void *kto, const void *kfrom)
 {
 	asm("\
diff --git a/arch/arm/mm/copypage-v3.c b/arch/arm/mm/copypage-v3.c
index 70ed96c..de9c068 100644
--- a/arch/arm/mm/copypage-v3.c
+++ b/arch/arm/mm/copypage-v3.c
@@ -15,7 +15,7 @@
  *
  * FIXME: do we need to handle cache stuff...
  */
-static void __attribute__((naked))
+static void __naked
 v3_copy_user_page(void *kto, const void *kfrom)
 {
 	asm("\n\
diff --git a/arch/arm/mm/copypage-v4mc.c b/arch/arm/mm/copypage-v4mc.c
index 1601698..7370a71 100644
--- a/arch/arm/mm/copypage-v4mc.c
+++ b/arch/arm/mm/copypage-v4mc.c
@@ -44,7 +44,7 @@ static DEFINE_SPINLOCK(minicache_lock);
  * instruction.  If your processor does not supply this, you have to write your
  * own copy_user_highpage that does the right thing.
  */
-static void __attribute__((naked))
+static void __naked
 mc_copy_user_page(void *from, void *to)
 {
 	asm volatile(
diff --git a/arch/arm/mm/copypage-v4wb.c b/arch/arm/mm/copypage-v4wb.c
index 3ec93da..9ab0984 100644
--- a/arch/arm/mm/copypage-v4wb.c
+++ b/arch/arm/mm/copypage-v4wb.c
@@ -22,7 +22,7 @@
  * instruction.  If your processor does not supply this, you have to write your
  * own copy_user_highpage that does the right thing.
  */
-static void __attribute__((naked))
+static void __naked
 v4wb_copy_user_page(void *kto, const void *kfrom)
 {
 	asm("\
diff --git a/arch/arm/mm/copypage-v4wt.c b/arch/arm/mm/copypage-v4wt.c
index 0f1188e..300efaf 100644
--- a/arch/arm/mm/copypage-v4wt.c
+++ b/arch/arm/mm/copypage-v4wt.c
@@ -20,7 +20,7 @@
  * dirty data in the cache.  However, we do have to ensure that
  * subsequent reads are up to date.
  */
-static void __attribute__((naked))
+static void __naked
 v4wt_copy_user_page(void *kto, const void *kfrom)
 {
 	asm("\
diff --git a/arch/arm/mm/copypage-xsc3.c b/arch/arm/mm/copypage-xsc3.c
index 39a9945..bc4525f 100644
--- a/arch/arm/mm/copypage-xsc3.c
+++ b/arch/arm/mm/copypage-xsc3.c
@@ -29,7 +29,7 @@
  * if we eventually end up using our copied page.
  *
  */
-static void __attribute__((naked))
+static void __naked
 xsc3_mc_copy_user_page(void *kto, const void *kfrom)
 {
 	asm("\
diff --git a/arch/arm/mm/copypage-xscale.c b/arch/arm/mm/copypage-xscale.c
index d18f239..76824d3 100644
--- a/arch/arm/mm/copypage-xscale.c
+++ b/arch/arm/mm/copypage-xscale.c
@@ -42,7 +42,7 @@ static DEFINE_SPINLOCK(minicache_lock);
  * Dcache aliasing issue.  The writes will be forwarded to the write buffer,
  * and merged as appropriate.
  */
-static void __attribute__((naked))
+static void __naked
 mc_copy_user_page(void *from, void *to)
 {
 	/*
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 1514d53..bf80fa0 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -52,7 +52,13 @@
 #define __deprecated			__attribute__((deprecated))
 #define __packed			__attribute__((packed))
 #define __weak				__attribute__((weak))
+
+#if defined(CONFIG_ARM)
+#define __naked				__attribute__((naked)) notrace
+#else
 #define __naked				__attribute__((naked))
+#endif
+
 #define __noreturn			__attribute__((noreturn))
 
 /*
-- 
tg: (7a203f3..) t/armmisc/make_naked_functions_use___naked (depends on: linus/master)
