Return-Path: <linux-kernel-owner+w=401wt.eu-S1760614AbZIPWsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbZIPWsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760559AbZIPWqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:46:52 -0400
Received: from kroah.org ([198.145.64.141]:48917 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760276AbZIPWjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:39:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:14 2009
Message-Id: <20090916223714.674467550@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roland McGrath <roland@redhat.com>, James Morris <jmorris@namei.org>
Subject: [patch 10/45] binfmt_elf: fix PT_INTERP bss handling
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=binfmt_elf-fix-pt_interp-bss-handling.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Roland McGrath <roland@redhat.com>

commit 9f0ab4a3f0fdb1ff404d150618ace2fa069bb2e1 upstream.

In fs/binfmt_elf.c, load_elf_interp() calls padzero() for .bss even if
the PT_LOAD has no PROT_WRITE and no .bss.  This generates EFAULT.

Here is a small test case.  (Yes, there are other, useful PT_INTERP
which have only .text and no .data/.bss.)

	----- ptinterp.S
	_start: .globl _start
		 nop
		 int3
	-----
	$ gcc -m32 -nostartfiles -nostdlib -o ptinterp ptinterp.S
	$ gcc -m32 -Wl,--dynamic-linker=ptinterp -o hello hello.c
	$ ./hello
	Segmentation fault  # during execve() itself

	After applying the patch:
	$ ./hello
	Trace trap  # user-mode execution after execve() finishes

If the ELF headers are actually self-inconsistent, then dying is fine.
But having no PROT_WRITE segment is perfectly normal and correct if
there is no segment with p_memsz > p_filesz (i.e. bss).  John Reiser
suggested checking for PROT_WRITE in the bss logic.  I think it makes
most sense to simply apply the bss logic only when there is bss.

This patch looks less trivial than it is due to some reindentation.
It just moves the "if (last_bss > elf_bss) {" test up to include the
partial-page bss logic as well as the more-pages bss logic.

Reported-by: John Reiser <jreiser@bitwagon.com>
Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/binfmt_elf.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -501,22 +501,22 @@ static unsigned long load_elf_interp(str
 		}
 	}
 
-	/*
-	 * Now fill out the bss section.  First pad the last page up
-	 * to the page boundary, and then perform a mmap to make sure
-	 * that there are zero-mapped pages up to and including the 
-	 * last bss page.
-	 */
-	if (padzero(elf_bss)) {
-		error = -EFAULT;
-		goto out_close;
-	}
+	if (last_bss > elf_bss) {
+		/*
+		 * Now fill out the bss section.  First pad the last page up
+		 * to the page boundary, and then perform a mmap to make sure
+		 * that there are zero-mapped pages up to and including the
+		 * last bss page.
+		 */
+		if (padzero(elf_bss)) {
+			error = -EFAULT;
+			goto out_close;
+		}
 
-	/* What we have mapped so far */
-	elf_bss = ELF_PAGESTART(elf_bss + ELF_MIN_ALIGN - 1);
+		/* What we have mapped so far */
+		elf_bss = ELF_PAGESTART(elf_bss + ELF_MIN_ALIGN - 1);
 
-	/* Map the last of the bss segment */
-	if (last_bss > elf_bss) {
+		/* Map the last of the bss segment */
 		down_write(&current->mm->mmap_sem);
 		error = do_brk(elf_bss, last_bss - elf_bss);
 		up_write(&current->mm->mmap_sem);


