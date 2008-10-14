Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYJNBlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYJNBlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYJNBlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:41:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446AbYJNBlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:41:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Petr Tesarik <ptesarik@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86 syscall.h: fix argument order
In-Reply-To: Petr Tesarik's message of  Monday, 13 October 2008 17:58:31 +0200 <1223913511.15996.13.camel@elijah.suse.cz>
References: <1223913511.15996.13.camel@elijah.suse.cz>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20081014014004.B637F154284@magilla.localdomain>
Date: Mon, 13 Oct 2008 18:40:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Tesarik noticed that I'd bungled the syscall_get_arguments code for
64-bit kernels, so it inverted the order of the syscall argument registers.
Petr wrote a patch to fix that, and I've amended it to fix the same braino
in the syscall_set_arguments code.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/asm-x86/syscall.h |  106 +++++++++++++++++++++++----------------------
 1 files changed, 54 insertions(+), 52 deletions(-)

diff --git a/include/asm-x86/syscall.h b/include/asm-x86/syscall.h
index 04c47dc..ec2a95e 100644
--- a/include/asm-x86/syscall.h
+++ b/include/asm-x86/syscall.h
@@ -93,26 +93,26 @@ static inline void syscall_get_arguments(struct task_struct *task,
 {
 # ifdef CONFIG_IA32_EMULATION
 	if (task_thread_info(task)->status & TS_COMPAT)
-		switch (i + n) {
-		case 6:
+		switch (i) {
+		case 0:
 			if (!n--) break;
-			*args++ = regs->bp;
-		case 5:
+			*args++ = regs->bx;
+		case 1:
 			if (!n--) break;
-			*args++ = regs->di;
-		case 4:
+			*args++ = regs->cx;
+		case 2:
 			if (!n--) break;
-			*args++ = regs->si;
+			*args++ = regs->dx;
 		case 3:
 			if (!n--) break;
-			*args++ = regs->dx;
-		case 2:
+			*args++ = regs->si;
+		case 4:
 			if (!n--) break;
-			*args++ = regs->cx;
-		case 1:
+			*args++ = regs->di;
+		case 5:
 			if (!n--) break;
-			*args++ = regs->bx;
-		case 0:
+			*args++ = regs->bp;
+		case 6:
 			if (!n--) break;
 		default:
 			BUG();
@@ -120,26 +120,26 @@ static inline void syscall_get_arguments(struct task_struct *task,
 		}
 	else
 # endif
-		switch (i + n) {
-		case 6:
+		switch (i) {
+		case 0:
 			if (!n--) break;
-			*args++ = regs->r9;
-		case 5:
+			*args++ = regs->di;
+		case 1:
 			if (!n--) break;
-			*args++ = regs->r8;
-		case 4:
+			*args++ = regs->si;
+		case 2:
 			if (!n--) break;
-			*args++ = regs->r10;
+			*args++ = regs->dx;
 		case 3:
 			if (!n--) break;
-			*args++ = regs->dx;
-		case 2:
+			*args++ = regs->r10;
+		case 4:
 			if (!n--) break;
-			*args++ = regs->si;
-		case 1:
+			*args++ = regs->r8;
+		case 5:
 			if (!n--) break;
-			*args++ = regs->di;
-		case 0:
+			*args++ = regs->r9;
+		case 6:
 			if (!n--) break;
 		default:
 			BUG();
@@ -154,55 +154,57 @@ static inline void syscall_set_arguments(struct task_struct *task,
 {
 # ifdef CONFIG_IA32_EMULATION
 	if (task_thread_info(task)->status & TS_COMPAT)
-		switch (i + n) {
-		case 6:
+		switch (i) {
+		case 0:
 			if (!n--) break;
-			regs->bp = *args++;
-		case 5:
+			regs->bx = *args++;
+		case 1:
 			if (!n--) break;
-			regs->di = *args++;
-		case 4:
+			regs->cx = *args++;
+		case 2:
 			if (!n--) break;
-			regs->si = *args++;
+			regs->dx = *args++;
 		case 3:
 			if (!n--) break;
-			regs->dx = *args++;
-		case 2:
+			regs->si = *args++;
+		case 4:
 			if (!n--) break;
-			regs->cx = *args++;
-		case 1:
+			regs->di = *args++;
+		case 5:
 			if (!n--) break;
-			regs->bx = *args++;
-		case 0:
+			regs->bp = *args++;
+		case 6:
 			if (!n--) break;
 		default:
 			BUG();
+			break;
 		}
 	else
 # endif
-		switch (i + n) {
-		case 6:
+		switch (i) {
+		case 0:
 			if (!n--) break;
-			regs->r9 = *args++;
-		case 5:
+			regs->di = *args++;
+		case 1:
 			if (!n--) break;
-			regs->r8 = *args++;
-		case 4:
+			regs->si = *args++;
+		case 2:
 			if (!n--) break;
-			regs->r10 = *args++;
+			regs->dx = *args++;
 		case 3:
 			if (!n--) break;
-			regs->dx = *args++;
-		case 2:
+			regs->r10 = *args++;
+		case 4:
 			if (!n--) break;
-			regs->si = *args++;
-		case 1:
+			regs->r8 = *args++;
+		case 5:
 			if (!n--) break;
-			regs->di = *args++;
-		case 0:
+			regs->r9 = *args++;
+		case 6:
 			if (!n--) break;
 		default:
 			BUG();
+			break;
 		}
 }
 
