Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbZK1PYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbZK1PYY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 10:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZK1PYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 10:24:23 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:35997 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZK1PYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 10:24:22 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: [PATCH] FDPIC: respect PT_GNU_STACK exec markings when creating NOMMU stack
Date: Sat, 28 Nov 2009 10:24:23 -0500
Message-Id: <1259421863-12777-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code will load the stack size and markings, but then only use
the markings in the MMU code path.  The NOMMU code path always passes EXEC
to the mmap() call.  While this doesn't matter to most people during the
run of the code, it causes a pointless icache flush when starting every
FDPIC application and by default, that tends to be 128kB of waste.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
note: this will apply cleanly with the uninitialized flag patch applied,
but otherwise doesn't directly depend on it

 fs/binfmt_elf_fdpic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 8563a57..3e2507b 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -380,7 +380,8 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 
 	down_write(&current->mm->mmap_sem);
 	current->mm->start_brk = do_mmap(NULL, 0, stack_size,
-					 PROT_READ | PROT_WRITE | PROT_EXEC,
+					 PROT_READ | PROT_WRITE |
+					 (executable_stack & EXSTACK_ENABLE_X ? PROT_EXEC : 0),
 					 MAP_PRIVATE | MAP_ANONYMOUS |
 					 MAP_UNINITIALIZED | MAP_GROWSDOWN,
 					 0);
-- 
1.6.5.3

