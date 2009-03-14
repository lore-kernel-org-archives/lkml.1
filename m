Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbZCNBqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbZCNBqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZCNBVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:22 -0400
Received: from kroah.org ([198.145.64.141]:35502 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753742AbZCNBUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:54 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:42 2009
Message-Id: <20090314011041.891793353@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:48 -0700
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
Subject: [patch 071/114] x86-64: syscall-audit: fix 32/64 syscall hole
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=x86-64-syscall-audit-fix-32-64-syscall-hole.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland McGrath <roland@redhat.com>

commit ccbe495caa5e604b04d5a31d7459a6f6a76a756c upstream.

On x86-64, a 32-bit process (TIF_IA32) can switch to 64-bit mode with
ljmp, and then use the "syscall" instruction to make a 64-bit system
call.  A 64-bit process make a 32-bit system call with int $0x80.

In both these cases, audit_syscall_entry() will use the wrong system
call number table and the wrong system call argument registers.  This
could be used to circumvent a syscall audit configuration that filters
based on the syscall numbers or argument details.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1512,7 +1512,7 @@ void send_sigtrap(struct task_struct *ts
 #ifdef CONFIG_X86_32
 # define IS_IA32	1
 #elif defined CONFIG_IA32_EMULATION
-# define IS_IA32	test_thread_flag(TIF_IA32)
+# define IS_IA32	is_compat_task()
 #else
 # define IS_IA32	0
 #endif


