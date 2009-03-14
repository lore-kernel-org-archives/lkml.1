Return-Path: <linux-kernel-owner+w=401wt.eu-S1764603AbZCNBnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764603AbZCNBnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZCNBVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:09 -0400
Received: from kroah.org ([198.145.64.141]:35428 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753538AbZCNBUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:41 2009
Message-Id: <20090314011041.046871380@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Roland McGrath <roland@redhat.com>
Subject: [patch 065/114] x86-64: fix int $0x80 -ENOSYS return
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=x86-64-fix-int-0x80-enosys-return.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland McGrath <roland@redhat.com>

commit c09249f8d1b84344eca882547afdbffee8c09d14 upstream.

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
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/ia32/ia32entry.S |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

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


