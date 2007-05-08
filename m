Return-Path: <linux-kernel-owner+w=401wt.eu-S1032057AbXEHUMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032057AbXEHUMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968255AbXEHUMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:12:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032033AbXEHUM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:12:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] FRV: Miscellaneous fixes
To: torvalds@osdl.org, akpm@osdl.org
Cc: rientjes@google.com, linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Tue, 08 May 2007 21:11:43 +0100
Message-ID: <20070508201143.2302.25591.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070508201138.2302.87781.stgit@warthog.cambridge.redhat.com>
References: <20070508201138.2302.87781.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Miscellaneous fixes to bring FRV up to date:

 (1) Copy the new syscall numbers from i386 to asm-frv/unistd.h and fill out
     the syscall table in entry.S too.

 (2) Mark __frv_uart0 and __frv_uart1 __pminitdata rather than __initdata so
     that determine_clocks() can access them when CONFIG_PM=y.

 (3) Make arch/frv/mm/elf-fdpic.c include asm/mman.h so that MAP_FIXED is
     available (fixes commit 2fd3bebaad9da3b3b99c46a3389099424bf7ee35).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/entry.S  |   10 ++++++++++
 arch/frv/kernel/setup.c  |    4 ++--
 arch/frv/mm/elf-fdpic.c  |    1 +
 include/asm-frv/unistd.h |   16 +++++++++++++---
 4 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index 940ac30..43dc08e 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -1482,6 +1482,16 @@ sys_call_table:
 	.long sys_faccessat
 	.long sys_pselect6
 	.long sys_ppoll
+	.long sys_unshare		/* 310 */
+	.long sys_set_robust_list
+	.long sys_get_robust_list
+	.long sys_splice
+	.long sys_sync_file_range
+	.long sys_tee			/* 315 */
+	.long sys_vmsplice
+	.long sys_move_pages
+	.long sys_getcpu
+	.long sys_epoll_pwait
 
 
 syscall_table_size = (. - sys_call_table)
diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index 8ea3ca2..aa3c795 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -191,7 +191,7 @@ static struct clock_cmode __pminitdata clock_cmodes_fr555[16] = {
 static const struct clock_cmode __pminitdata *clock_cmodes;
 static int __pminitdata clock_doubled;
 
-static struct uart_port __initdata __frv_uart0 = {
+static struct uart_port __pminitdata __frv_uart0 = {
 	.uartclk		= 0,
 	.membase		= (char *) UART0_BASE,
 	.irq			= IRQ_CPU_UART0,
@@ -200,7 +200,7 @@ static struct uart_port __initdata __frv_uart0 = {
 	.flags			= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
 };
 
-static struct uart_port __initdata __frv_uart1 = {
+static struct uart_port __pminitdata __frv_uart1 = {
 	.uartclk		= 0,
 	.membase		= (char *) UART1_BASE,
 	.irq			= IRQ_CPU_UART1,
diff --git a/arch/frv/mm/elf-fdpic.c b/arch/frv/mm/elf-fdpic.c
index cac2c01..385fd30 100644
--- a/arch/frv/mm/elf-fdpic.c
+++ b/arch/frv/mm/elf-fdpic.c
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/elf-fdpic.h>
+#include <asm/mman.h>
 
 /*****************************************************************************/
 /*
diff --git a/include/asm-frv/unistd.h b/include/asm-frv/unistd.h
index 584c041..d0ea678 100644
--- a/include/asm-frv/unistd.h
+++ b/include/asm-frv/unistd.h
@@ -186,8 +186,8 @@
 #define __NR_rt_sigtimedwait	177
 #define __NR_rt_sigqueueinfo	178
 #define __NR_rt_sigsuspend	179
-#define __NR_pread		180
-#define __NR_pwrite		181
+#define __NR_pread64		180
+#define __NR_pwrite64		181
 #define __NR_chown		182
 #define __NR_getcwd		183
 #define __NR_capget		184
@@ -316,10 +316,20 @@
 #define __NR_faccessat		307
 #define __NR_pselect6		308
 #define __NR_ppoll		309
+#define __NR_unshare		310
+#define __NR_set_robust_list	311
+#define __NR_get_robust_list	312
+#define __NR_splice		313
+#define __NR_sync_file_range	314
+#define __NR_tee		315
+#define __NR_vmsplice		316
+#define __NR_move_pages		317
+#define __NR_getcpu		318
+#define __NR_epoll_pwait	319
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 310
+#define NR_syscalls 320
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */

