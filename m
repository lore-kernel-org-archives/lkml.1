Return-Path: <linux-kernel-owner+w=401wt.eu-S1759692AbZAHM6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692AbZAHM6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756664AbZAHM4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:56:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40766 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759614AbZAHM4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:56:15 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/10] FDPIC: Don't attempt to expand the userspace stack to
	fill the space allocated [ver #3]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: bernds_cb1@t-online.de, dhowells@redhat.com, rgetz@blackfin.uclinux.org,
       vapier.adi@gmail.com, lethal@linux-sh.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Jan 2009 12:54:22 +0000
Message-ID: <20090108125422.28454.99617.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
References: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the ELF-FDPIC binfmt from attempting to expand the userspace stack and brk
segments to fill the space actually allocated for it.  The space allocated may
be rounded up by mmap(), and may be wasted.

However, finding out how much space we actually obtained uses the contentious
kobjsize() function which we'd like to get rid of as it doesn't necessarily
work for all slab allocators.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Mike Frysinger <vapier.adi@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---

 fs/binfmt_elf_fdpic.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)


diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 22baf1b..f3e72c5 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -168,9 +168,6 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	struct elf_fdpic_params exec_params, interp_params;
 	struct elf_phdr *phdr;
 	unsigned long stack_size, entryaddr;
-#ifndef CONFIG_MMU
-	unsigned long fullsize;
-#endif
 #ifdef ELF_FDPIC_PLAT_INIT
 	unsigned long dynaddr;
 #endif
@@ -390,11 +387,6 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 		goto error_kill;
 	}
 
-	/* expand the stack mapping to use up the entire allocation granule */
-	fullsize = kobjsize((char *) current->mm->start_brk);
-	if (!IS_ERR_VALUE(do_mremap(current->mm->start_brk, stack_size,
-				    fullsize, 0, 0)))
-		stack_size = fullsize;
 	up_write(&current->mm->mmap_sem);
 
 	current->mm->brk = current->mm->start_brk;

