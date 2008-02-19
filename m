Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbYBSS7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbYBSS7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759294AbYBSS7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:59:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759601AbYBSS7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:59:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/4] MN10300: Make the kernel jump into gdbstub on a BUG
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Date: Tue, 19 Feb 2008 18:58:59 +0000
Message-ID: <20080219185859.22304.99197.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080219185848.22304.75764.stgit@warthog.procyon.org.uk>
References: <20080219185848.22304.75764.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the kernel jump into gdbstub (if configured) on a BUG with the register
set from the BUG rather than interpolating another illegal instruction and
leaving gdbstub's idea of the process counter in unsupported_syscall() where
the original BUG was detected.

With this patch, gdbstub reports a SIGABRT to the compiler and reports the
program counter at the original BUG, allowing the execution state at the time
of the BUG to be examined with GDB.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index 8b9dc6d..fcb9a03 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -391,7 +391,7 @@ static asmlinkage void unsupported_syscall(struct pt_regs *regs,
 	if (code == EXCEP_SYSCALL15 && !user_mode(regs)) {
 		if (report_bug(regs->pc, regs) == BUG_TRAP_TYPE_BUG) {
 #ifdef CONFIG_GDBSTUB
-			__gdbstub_bug_trap();
+			gdbstub_intercept(regs, code);
 #endif
 		}
 	}

