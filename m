Return-Path: <linux-kernel-owner+w=401wt.eu-S1764044AbXF1Hs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764044AbXF1Hs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 03:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759676AbXF1HsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 03:48:18 -0400
Received: from ozlabs.org ([203.10.76.45]:60335 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759272AbXF1HsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 03:48:17 -0400
To: Paul Mackerras <paulus@samba.org>
Cc: <decimal@us.ibm.com>, <linux-arch@vger.kernel.org>,
       Arnd Bergmann <arnd.bergmann@de.ibm.com>, <cbe-oss-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>, <petr@vandrovec.name>, <ak@suse.de>,
       <jdelsign@totalviewtech.com>
Message-Id: <67867aa5e78ae107a62706a33a2aa643e8244256.1183016719.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 1/1] Fix elf_core_dump() when writing arch specific notes (spu coredumps)
Date: Thu, 28 Jun 2007 17:48:16 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

elf_core_dump() supports dumping arch specific ELF notes, via the #define
ELF_CORE_WRITE_EXTRA_NOTES. Currently the only user of this is the powerpc
spu coredump code.

There is a bug in the handling of foffset WRT the arch notes, which causes
us to erroneously increment foffset by the size of the arch notes, leaving
a block of zeroes in the file, and causing all subsequent data in the file
to be at <supposed position> + <arch note size>. eg:

  LOAD  0x050000 0x00100000 0x00000000 0x20000 0x20000 R E 0x10000

Tells us we should have a chunk of data at 0x50000. The truth is the data is
at 0x90dbc = 0x50000 + 0x40dbc (the size of the arch notes).

This bug prevents gdb from reading the core file correctly.

The simplest fix is to simply remember the size of the arch notes, and add
it to foffset after we've written the arch notes. The only drawback is that
if the arch code doesn't write as many bytes as it said it would, we end up
with a broken core dump again. For now I think that's a reasonable
requirement.

Tested on a Cell blade, gdb no longer complains about the core file being
bogus.

While I'm here I should point out that the spu coredump code does not work
if we're dumping to a pipe - we'll have to wait for 23 to fix that.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 fs/binfmt_elf.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index fa8ea33..08e4414 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1499,6 +1499,9 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
 #endif
 	int thread_status_size = 0;
 	elf_addr_t *auxv;
+#ifdef ELF_CORE_WRITE_EXTRA_NOTES
+	int extra_notes_size;
+#endif
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1628,7 +1631,8 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
 		sz += thread_status_size;
 
 #ifdef ELF_CORE_WRITE_EXTRA_NOTES
-		sz += ELF_CORE_EXTRA_NOTES_SIZE;
+		extra_notes_size = ELF_CORE_EXTRA_NOTES_SIZE;
+		sz += extra_notes_size;
 #endif
 
 		fill_elf_note_phdr(&phdr, sz, offset);
@@ -1674,6 +1678,7 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
 
 #ifdef ELF_CORE_WRITE_EXTRA_NOTES
 	ELF_CORE_WRITE_EXTRA_NOTES;
+	foffset += extra_notes_size;
 #endif
 
 	/* write out the thread status notes section */
-- 
1.5.1.3.g7a33b

