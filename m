Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbZBGC2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbZBGC2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 21:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZBGC2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 21:28:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbZBGC2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 21:28:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: x86@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Dmitry V.Levin" <ldv@altlinux.org>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH] x86-64: fix int $0x80 -ENOSYS return
Emacs: impress your (remaining) friends and neighbors.
Message-Id: <20090207022740.968D0FC3AD@magilla.sf.frob.com>
Date: Fri,  6 Feb 2009 18:27:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6cec50838ed04a9833fb5549f698d3756bbe7e72:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../tiwai/sound-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git x86/fixes

Roland McGrath (1):
      x86-64: fix int $0x80 -ENOSYS return

 arch/x86/ia32/ia32entry.S |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)


Thanks,
Roland

---
[PATCH] x86-64: fix int $0x80 -ENOSYS return

One of my past fixes to this code introduced a different new bug.
When using 32-bit "int $0x80" entry for a bogus syscall number,
the return value is not correctly set to -ENOSYS.  This only happens
when neither syscall-audit nor syscall tracing is enabled (i.e., never
seen if auditd ever started).  Test program:

	/* gcc -o int80-badsys -m32 -g int80-badsys.c
	   Run on x86-64 kernel.
	   Note to reproduce the bug you need auditd never to have started.  */

	#include <errno.h>
	#include <stdio.h>

	int
	main (void)
	{
	  long res;
	  asm ("int $0x80" : "=a" (res) : "0" (99999));
	  printf ("bad syscall returns %ld\n", res);
	  return res != -ENOSYS;
	}

The fix makes the int $0x80 path match the sysenter and syscall paths.

Reported-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ia32entry.S |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 256b00b..5a0d76d 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -418,9 +418,9 @@ ENTRY(ia32_syscall)
 	orl   $TS_COMPAT,TI_status(%r10)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	jnz ia32_tracesys
-ia32_do_syscall:	
 	cmpl $(IA32_NR_syscalls-1),%eax
-	ja  int_ret_from_sys_call	/* ia32_tracesys has set RAX(%rsp) */
+	ja ia32_badsys
+ia32_do_call:
 	IA32_ARG_FIXUP
 	call *ia32_sys_call_table(,%rax,8) # xxx: rip relative
 ia32_sysret:
@@ -435,7 +435,9 @@ ia32_tracesys:
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	jmp ia32_do_syscall
+	cmpl $(IA32_NR_syscalls-1),%eax
+	ja  int_ret_from_sys_call	/* ia32_tracesys has set RAX(%rsp) */
+	jmp ia32_do_call
 END(ia32_syscall)
 
 ia32_badsys:
