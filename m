Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbZGFNQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbZGFNQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZGFNQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:16:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59694 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbZGFNQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:16:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FDPIC: Ignore the loader's PT_GNU_STACK when calculating the
	stack size [ver #2]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: rgetz@blackfin.uclinux.org, gerg@uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Mike Frysinger <vapier@gentoo.org>,
       Paul Mundt <lethal@linux-sh.org>
Date: Mon, 06 Jul 2009 14:15:13 +0100
Message-ID: <20090706131513.16304.33549.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore the loader's PT_GNU_STACK when calculating the stack size, and only
consider the executable's PT_GNU_STACK, assuming the executable has one.

Currently the behaviour is to take the largest stack size and use that, but
that means you can't reduce the stack size in the executable.  The loader's
stack size should probably only be used when executing the loader directly.

WARNING: This patch is slightly dangerous - it may render a system inoperable
if the loader's stack size is larger than that of important executables, and
the system relies unknowingly on this increasing the size of the stack.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---

 fs/binfmt_elf_fdpic.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)


diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 81ca047..a1e6365 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -283,20 +283,23 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	}
 
 	stack_size = exec_params.stack_size;
-	if (stack_size < interp_params.stack_size)
-		stack_size = interp_params.stack_size;
-
 	if (exec_params.flags & ELF_FDPIC_FLAG_EXEC_STACK)
 		executable_stack = EXSTACK_ENABLE_X;
 	else if (exec_params.flags & ELF_FDPIC_FLAG_NOEXEC_STACK)
 		executable_stack = EXSTACK_DISABLE_X;
-	else if (interp_params.flags & ELF_FDPIC_FLAG_EXEC_STACK)
-		executable_stack = EXSTACK_ENABLE_X;
-	else if (interp_params.flags & ELF_FDPIC_FLAG_NOEXEC_STACK)
-		executable_stack = EXSTACK_DISABLE_X;
 	else
 		executable_stack = EXSTACK_DEFAULT;
 
+	if (stack_size == 0) {
+		stack_size = interp_params.stack_size;
+		if (interp_params.flags & ELF_FDPIC_FLAG_EXEC_STACK)
+			executable_stack = EXSTACK_ENABLE_X;
+		else if (interp_params.flags & ELF_FDPIC_FLAG_NOEXEC_STACK)
+			executable_stack = EXSTACK_DISABLE_X;
+		else
+			executable_stack = EXSTACK_DEFAULT;
+	}
+
 	retval = -ENOEXEC;
 	if (stack_size == 0)
 		goto error;

