Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZGAQvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZGAQvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbZGAQvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:51:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36813 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbZGAQvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:51:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FDPIC: Ignore the loader's PT_GNU_STACK when calculating the
	stack size [ver #2]
To: vapier.adi@gmail.com, rgetz@blackfin.uclinux.org, lethal@linux-sh.org
Cc: dhowells@redhat.com, gerg@uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Wed, 01 Jul 2009 17:49:51 +0100
Message-ID: <20090701164951.30018.21925.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090701120814.30741.10146.stgit@warthog.procyon.org.uk>
References: <20090701120814.30741.10146.stgit@warthog.procyon.org.uk>
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

