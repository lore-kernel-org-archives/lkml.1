Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbYCCWzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbYCCWzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYCCWzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:55:08 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:15834 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYCCWzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:55:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=wT/IpMlHOSuMdIzAx+6QU5EJzq3dkUyFouNMgDJ+6MJ57kU/wAmr3dF90cDPkwFtwutWbsap1R08FXZJQPWJUu/LT5pPII5ojBVD2WFoJMifWSAxZfdCkZTvsh4quF1ZtG6MuQJw8XeNPhguMIa2sQxkEVOvi343hc15Vx0f9hU=
Message-ID: <386072610803031454r684c4701hc82eee900b71ccd7@mail.gmail.com>
Date: Mon, 3 Mar 2008 14:54:59 -0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [GIT PULL] Blackfin arch fixing for 2.6.25-rc4
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 58b5ab836fbbf616
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/kernel/fixed_code.S       |   12 ++++++------
 arch/blackfin/mach-bf548/boards/ezkit.c |    4 ++--
 arch/blackfin/mach-common/entry.S       |    5 ++++-
 include/asm-blackfin/unistd.h           |    6 ++++--
 4 files changed, 16 insertions(+), 11 deletions(-)

Bryan Wu (1):
      [Blackfin] arch: add new timerfd syscalls

Michael Hennerich (1):
      [Blackfin] arch: fix bug - allow SDH driver to be used as module

Mike Frysinger (1):
      [Blackfin] arch: fix atomic and32/xor32 comments and ENDPROC markings

diff --git a/arch/blackfin/kernel/fixed_code.S
b/arch/blackfin/kernel/fixed_code.S
index 9026269..5ed4722 100644
--- a/arch/blackfin/kernel/fixed_code.S
+++ b/arch/blackfin/kernel/fixed_code.S
@@ -101,9 +101,9 @@ ENDPROC (_atomic_ior32)

 .align 16
 	/*
-	 * Atomic ior, 32 bit.
+	 * Atomic and, 32 bit.
 	 * Inputs:	P0: memory address to use
-	 *		R0: value to ior
+	 *		R0: value to and
 	 * Outputs:	R0: new contents of the memory address.
 	 *		R1: previous contents of the memory address.
 	 */
@@ -112,13 +112,13 @@ ENTRY(_atomic_and32)
 	R0 = R1 & R0;
 	[P0] = R0;
 	rts;
-ENDPROC (_atomic_ior32)
+ENDPROC (_atomic_and32)

 .align 16
 	/*
-	 * Atomic ior, 32 bit.
+	 * Atomic xor, 32 bit.
 	 * Inputs:	P0: memory address to use
-	 *		R0: value to ior
+	 *		R0: value to xor
 	 * Outputs:	R0: new contents of the memory address.
 	 *		R1: previous contents of the memory address.
 	 */
@@ -127,7 +127,7 @@ ENTRY(_atomic_xor32)
 	R0 = R1 ^ R0;
 	[P0] = R0;
 	rts;
-ENDPROC (_atomic_ior32)
+ENDPROC (_atomic_xor32)

 .align 16
 	/*
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c
b/arch/blackfin/mach-bf548/boards/ezkit.c
index a0950c1..40846aa 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -323,7 +323,7 @@ static struct platform_device bf5xx_nand_device = {
 };
 #endif

-#if defined(CONFIG_SDH_BFIN) || defined(CONFIG_SDH_BFIN)
+#if defined(CONFIG_SDH_BFIN) || defined(CONFIG_SDH_BFIN_MODULE)
 static struct platform_device bf54x_sdh_device = {
 	.name = "bfin-sdh",
 	.id = 0,
@@ -636,7 +636,7 @@ static struct platform_device *ezkit_devices[]
__initdata = {
 	&bf5xx_nand_device,
 #endif

-#if defined(CONFIG_SDH_BFIN) || defined(CONFIG_SDH_BFIN)
+#if defined(CONFIG_SDH_BFIN) || defined(CONFIG_SDH_BFIN_MODULE)
 	&bf54x_sdh_device,
 #endif

diff --git a/arch/blackfin/mach-common/entry.S
b/arch/blackfin/mach-common/entry.S
index 2cbb7a0..cee54ce 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -1369,7 +1369,7 @@ ENTRY(_sys_call_table)
 	.long _sys_epoll_pwait
 	.long _sys_utimensat
 	.long _sys_signalfd
-	.long _sys_ni_syscall
+	.long _sys_timerfd_create
 	.long _sys_eventfd	/* 350 */
 	.long _sys_pread64
 	.long _sys_pwrite64
@@ -1378,6 +1378,9 @@ ENTRY(_sys_call_table)
 	.long _sys_get_robust_list	/* 355 */
 	.long _sys_fallocate
 	.long _sys_semtimedop
+	.long _sys_timerfd_settime
+	.long _sys_timerfd_gettime
+
 	.rept NR_syscalls-(.-_sys_call_table)/4
 	.long _sys_ni_syscall
 	.endr
diff --git a/include/asm-blackfin/unistd.h b/include/asm-blackfin/unistd.h
index e981673..c18a399 100644
--- a/include/asm-blackfin/unistd.h
+++ b/include/asm-blackfin/unistd.h
@@ -361,7 +361,7 @@
 #define __NR_epoll_pwait	346
 #define __NR_utimensat		347
 #define __NR_signalfd		348
-#define __NR_timerfd		349
+#define __NR_timerfd_create	349
 #define __NR_eventfd		350
 #define __NR_pread64		351
 #define __NR_pwrite64		352
@@ -370,8 +370,10 @@
 #define __NR_get_robust_list	355
 #define __NR_fallocate		356
 #define __NR_semtimedop		357
+#define __NR_timerfd_settime	358
+#define __NR_timerfd_gettime	359

-#define __NR_syscall		358
+#define __NR_syscall		360
 #define NR_syscalls		__NR_syscall

 /* Old optional stuff no one actually uses */
