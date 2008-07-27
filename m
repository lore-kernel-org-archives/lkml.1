Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbYG0GuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbYG0GuB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYG0Gtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:49:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbYG0Gtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:49:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Fcc: ~/Mail/linus
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] powerpc: tracehook_signal_handler
In-Reply-To: Roland McGrath's message of  Saturday, 26 July 2008 23:48:59 -0700 <20080727064859.69692154280@magilla.localdomain>
References: <20080727064859.69692154280@magilla.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080727064950.F2F69154280@magilla.localdomain>
Date: Sat, 26 Jul 2008 23:49:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the powerpc signal handling code call tracehook_signal_handler()
after a handler is set up.  This means that using PTRACE_SINGLESTEP to
enter a signal handler will report to ptrace on the first instruction of
the handler, instead of the second.  This is consistent with what x86 and
other machines do, and what users and debuggers want.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/signal.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index 7aada78..11a5c45 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -9,7 +9,7 @@
  * this archive for more details.
  */
 
-#include <linux/ptrace.h>
+#include <linux/tracehook.h>
 #include <linux/signal.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -177,6 +177,12 @@ int do_signal(sigset_t *oldset, struct pt_regs *regs)
 		 * its frame, and we can clear the TLF_RESTORE_SIGMASK flag.
 		 */
 		current_thread_info()->local_flags &= ~_TLF_RESTORE_SIGMASK;
+
+		/*
+		 * Let tracing know that we've done the handler setup.
+		 */
+		tracehook_signal_handler(signr, &info, &ka, regs,
+					 test_thread_flag(TIF_SINGLESTEP));
 	}
 
 	return ret;
