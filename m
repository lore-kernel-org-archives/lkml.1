Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZCSLzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZCSLzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 07:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZCSLzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 07:55:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:45869 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbZCSLzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 07:55:19 -0400
Date: Thu, 19 Mar 2009 11:54:35 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-discussion>
References: <new-discussion>
Subject: [tip:core/stacktrace] symbols, stacktrace: look up init symbols after module symbols
Message-ID: <tip-4a44bac1f98223ed77e47bf3b42fcfd10cddd85f@git.kernel.org>
Git-Commit-ID: 4a44bac1f98223ed77e47bf3b42fcfd10cddd85f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 19 Mar 2009 11:54:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a44bac1f98223ed77e47bf3b42fcfd10cddd85f
Gitweb:     http://git.kernel.org/tip/4a44bac1f98223ed77e47bf3b42fcfd10cddd85f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 19 Mar 2009 13:21:44 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 Mar 2009 13:38:35 +0100

symbols, stacktrace: look up init symbols after module symbols

Impact: fix incomplete stacktraces

I noticed such weird stacktrace entries in lockdep dumps:

[    0.285956] {HARDIRQ-ON-W} state was registered at:
[    0.285956]   [<ffffffff802bce90>] mark_irqflags+0xbe/0x125
[    0.285956]   [<ffffffff802bf2fd>] __lock_acquire+0x674/0x82d
[    0.285956]   [<ffffffff802bf5b2>] lock_acquire+0xfc/0x128
[    0.285956]   [<ffffffff8135b636>] rt_spin_lock+0xc8/0xd0
[    0.285956]   [<ffffffffffffffff>] 0xffffffffffffffff

The stacktrace entry is cut off after rt_spin_lock.

After much debugging i found out that stacktrace entries that
belong to init symbols dont get printed out, due to commit:

  a2da405: module: Don't report discarded init pages as kernel text.

The reason is this check added to core_kernel_text():

-       if (addr >= (unsigned long)_sinittext &&
+       if (system_state == SYSTEM_BOOTING &&
+           addr >= (unsigned long)_sinittext &&
            addr <= (unsigned long)_einittext)
                return 1;

This will discard inittext symbols even though their symbol table
is still present and even though stacktraces done while the system
was booting up might still be relevant.

To not reintroduce the (not well-specified) bug addressed in that
commit, first do a module symbols lookup, then a final init-symbols
lookup.

This will work fine on architectures that have separate address
spaces for modules (such as x86) - and should not crash any other
architectures either.

Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <new-discussion>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/extable.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index e136ed8..c46da6a 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -41,6 +41,14 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
 	return e;
 }
 
+static inline int init_kernel_text(unsigned long addr)
+{
+	if (addr >= (unsigned long)_sinittext &&
+	    addr <= (unsigned long)_einittext)
+		return 1;
+	return 0;
+}
+
 __notrace_funcgraph int core_kernel_text(unsigned long addr)
 {
 	if (addr >= (unsigned long)_stext &&
@@ -48,8 +56,7 @@ __notrace_funcgraph int core_kernel_text(unsigned long addr)
 		return 1;
 
 	if (system_state == SYSTEM_BOOTING &&
-	    addr >= (unsigned long)_sinittext &&
-	    addr <= (unsigned long)_einittext)
+	    init_kernel_text(addr))
 		return 1;
 	return 0;
 }
@@ -58,7 +65,19 @@ __notrace_funcgraph int __kernel_text_address(unsigned long addr)
 {
 	if (core_kernel_text(addr))
 		return 1;
-	return __module_text_address(addr) != NULL;
+	if (__module_text_address(addr))
+		return 1;
+	/*
+	 * There might be init symbols in saved stacktraces.
+	 * Give those symbols a chance to be printed in
+	 * backtraces (such as lockdep traces).
+	 *
+	 * Since we are after the module-symbols check, there's
+	 * no danger of address overlap:
+	 */
+	if (init_kernel_text(addr))
+		return 1;
+	return 0;
 }
 
 int kernel_text_address(unsigned long addr)
