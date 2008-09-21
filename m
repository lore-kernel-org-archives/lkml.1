Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbYIUCRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbYIUCRq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 22:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYIUCRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 22:17:38 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:63307 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751259AbYIUCRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 22:17:37 -0400
Date: Sun, 21 Sep 2008 11:16:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: [PATCH] [RFC] tracehook: Hook in syscall tracing markers.
Message-ID: <20080921021630.GA6443@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Roland McGrath <roland@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At kernel summit, the idea that syscall tracing was generally desirable
for tracing was mentioned several times, as was the argument that kernel
developers aren't placing markers in meaningful locations. This is a
simple patch to try and do that for the syscall case.

Presently LTTng attempts to litter these trace markers all over the
architecture code, primarily to get around the fact that there was no
generic way to get at this information before. Now that platforms are
starting to do their syscall entry/exit notifiers through tracehook and
we have the asm/syscall.h interface, all of this information can be
generically abstracted.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 include/linux/tracehook.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 6186a78..481ff45 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -49,6 +49,9 @@
 #include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/security.h>
+#include <linux/marker.h>
+#include <asm/syscall.h>
+
 struct linux_binprm;
 
 /**
@@ -112,6 +115,8 @@ static inline __must_check int tracehook_report_syscall_entry(
 	struct pt_regs *regs)
 {
 	ptrace_report_syscall(regs);
+	trace_mark(kernel_arch_syscall_entry, "syscall_id %ld ip #p%ld",
+		   syscall_get_nr(NULL, regs), instruction_pointer(regs));
 	return 0;
 }
 
@@ -135,6 +140,8 @@ static inline __must_check int tracehook_report_syscall_entry(
 static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
 {
 	ptrace_report_syscall(regs);
+	trace_mark(kernel_arch_syscall_exit, "ret %ld",
+		   syscall_get_return_value(NULL, regs));
 }
 
 /**
