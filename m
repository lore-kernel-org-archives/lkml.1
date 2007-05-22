Return-Path: <linux-kernel-owner+w=401wt.eu-S1765355AbXEVIh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765355AbXEVIh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbXEVIhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:37:21 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:7084 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbXEVIhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:37:19 -0400
X-IronPort-AV: i="4.14,565,1170651600"; 
   d="scan'208"; a="39655737:sNHT25673060"
Subject: Re: [PATCH 00/32] Blackfin update for 2.6.22-rc2
From: Bryan Wu <bryan.wu@analog.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>,
       David Howells <dhowells@redhat.com>,
       Mike Frysinger <vapier.adi@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200705211752.06709.rgetz@blackfin.uclinux.org>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
	 <200705211035.08380.rgetz@blackfin.uclinux.org>
	 <8bd0f97a0705211036q1162e9edvd73af8d6c536e565@mail.gmail.com>
	 <200705211752.06709.rgetz@blackfin.uclinux.org>
Content-Type: text/plain
Date: Tue, 22 May 2007 16:37:59 +0800
Message-Id: <1179823079.11754.5.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 17:52 -0400, Robin Getz wrote:
> On Mon 21 May 2007 13:36, Mike Frysinger pondered:
> > On 5/21/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > > since there is noMMU, are we better:
> > >  - putting stubs (return ENOSYS - give runtime errors), or
> > >  - just ignore the errors - and give compile errors? (Is there any way to
> > > put something into the syscall table, as not to get the warnings?)
> >
> > there are no compile errors ... having a stub that returns -ENOSYS is
> > the same thing as not having a stub as the fallback code when given an
> > unknown syscall # will return -ENOSYS ...
> 
> So, is there a way to tell ./scripts/checksyscalls.sh that here is a list of 
> syscalls that we can't do/have chosen not to implement - so we can live with 
> the common fallback code, and not get the warnings?
> 
> -Robin

Can we copy the new syscall numbers from i386 to asm-blackfin/unistd.h
and fill out the syscall table in entry.S too, as David Howells' patch
for FRV?

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
+       .long sys_unshare               /* 310 */
+       .long sys_set_robust_list
+       .long sys_get_robust_list
+       .long sys_splice
+       .long sys_sync_file_range
+       .long sys_tee                   /* 315 */
+       .long sys_vmsplice
+       .long sys_move_pages
+       .long sys_getcpu
+       .long sys_epoll_pwait


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
       .uartclk                = 0,
       .membase                = (char *) UART0_BASE,
       .irq                    = IRQ_CPU_UART0,
@@ -200,7 +200,7 @@ static struct uart_port __initdata __frv_uart0 = {
       .flags                  = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
 };

-static struct uart_port __initdata __frv_uart1 = {
+static struct uart_port __pminitdata __frv_uart1 = {
       .uartclk                = 0,
       .membase                = (char *) UART1_BASE,
       .irq                    = IRQ_CPU_UART1,
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
 #define __NR_rt_sigtimedwait   177
 #define __NR_rt_sigqueueinfo   178
 #define __NR_rt_sigsuspend     179
-#define __NR_pread             180
-#define __NR_pwrite            181
+#define __NR_pread64           180
+#define __NR_pwrite64          181
 #define __NR_chown             182
 #define __NR_getcwd            183
 #define __NR_capget            184
@@ -316,10 +316,20 @@
 #define __NR_faccessat         307
 #define __NR_pselect6          308
 #define __NR_ppoll             309
+#define __NR_unshare           310
+#define __NR_set_robust_list   311
+#define __NR_get_robust_list   312
+#define __NR_splice            313
+#define __NR_sync_file_range   314
+#define __NR_tee               315
+#define __NR_vmsplice          316
+#define __NR_move_pages                317
+#define __NR_getcpu            318
+#define __NR_epoll_pwait       319

 #ifdef __KERNEL__

-#define NR_syscalls 310
+#define NR_syscalls 320

 #define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */
---

Thanks
-Bryan Wu
