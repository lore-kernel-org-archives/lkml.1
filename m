Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYIEX1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYIEX1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 19:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYIEX04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 19:26:56 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:50832 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYIEX04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 19:26:56 -0400
Message-ID: <48C1C03F.20400@ct.jp.nec.com>
Date: Fri, 05 Sep 2008 16:26:55 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] x86_32: signal: use syscall_get_nr and error
References: <48C1BF41.8040404@ct.jp.nec.com>
In-Reply-To: <48C1BF41.8040404@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Use asm/syscall.h interfaces that do the same things.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index b21070e..3e4a688 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -27,6 +27,7 @@
 #include <asm/uaccess.h>
 #include <asm/i387.h>
 #include <asm/vdso.h>
+#include <asm/syscall.h>
 #include <asm/syscalls.h>
 
 #include "sigframe.h"
@@ -507,9 +508,9 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	int ret;
 
 	/* Are we from a system call? */
-	if ((long)regs->orig_ax >= 0) {
+	if (syscall_get_nr(current, regs) >= 0) {
 		/* If so, check system call restarting.. */
-		switch (regs->ax) {
+		switch (syscall_get_error(current, regs)) {
 		case -ERESTART_RESTARTBLOCK:
 		case -ERESTARTNOHAND:
 			regs->ax = -EINTR;
@@ -623,9 +624,9 @@ static void do_signal(struct pt_regs *regs)
 	}
 
 	/* Did we come from a system call? */
-	if ((long)regs->orig_ax >= 0) {
+	if (syscall_get_nr(current, regs) >= 0) {
 		/* Restart the system call - no handlers present */
-		switch (regs->ax) {
+		switch (syscall_get_error(current, regs)) {
 		case -ERESTARTNOHAND:
 		case -ERESTARTSYS:
 		case -ERESTARTNOINTR:
-- 
1.5.6

