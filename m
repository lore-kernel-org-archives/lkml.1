Return-Path: <linux-kernel-owner+w=401wt.eu-S932068AbZKKVhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbZKKVhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759334AbZKKVhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:37:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759324AbZKKVg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:36:58 -0500
Date: Wed, 11 Nov 2009 22:32:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ptrace: change tracehook_report_syscall_exit() to
	handle stepping
Message-ID: <20091111213201.GA10653@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested by Roland.

Change tracehook_report_syscall_exit() to look at step flag and send
the trap signal if needed.

This change affects ia64, microblaze, parisc, powerpc, sh.  They pass
nonzero "step" argument to tracehook but since it was ignored the tracee
reports via ptrace_notify(), this is not right and not consistent.

	- PTRACE_SETSIGINFO doesn't work

	- if the tracer resumes the tracee with signr != 0 the new signal
	  is generated rather than delivering it

	- If PT_TRACESYSGOOD is set the tracee reports the wrong exit_code

I don't have a powerpc machine, but I think this test-case should
see the difference:

	#include <unistd.h>
	#include <sys/ptrace.h>
	#include <sys/wait.h>
	#include <assert.h>
	#include <stdio.h>

	int main(void)
	{
		int pid, status;

		if (!(pid = fork())) {
			assert(ptrace(PTRACE_TRACEME) == 0);
			kill(getpid(), SIGSTOP);

			getppid();

			return 0;
		}

		assert(pid == wait(&status));
		assert(ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_TRACESYSGOOD) == 0);

		assert(ptrace(PTRACE_SYSCALL, pid, 0,0) == 0);
		assert(pid == wait(&status));

		assert(ptrace(PTRACE_SINGLESTEP, pid, 0,0) == 0);
		assert(pid == wait(&status));

		if (status == 0x57F)
			return 0;

		printf("kernel bug: status=%X shouldn't have 0x80\n", status);
		return 1;
	}

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
---

 include/linux/tracehook.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- TH/include/linux/tracehook.h~3_TRACEHOOK_HANDLE_STEPPING	2009-11-10 01:03:22.000000000 +0100
+++ TH/include/linux/tracehook.h	2009-11-10 22:00:37.000000000 +0100
@@ -134,6 +134,13 @@ static inline __must_check int tracehook
  */
 static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
 {
+	if (step) {
+		siginfo_t info;
+		user_single_step_siginfo(current, regs, &info);
+		force_sig_info(SIGTRAP, &info, current);
+		return;
+	}
+
 	ptrace_report_syscall(regs);
 }
 

