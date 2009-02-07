Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZBGB4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZBGB4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 20:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZBGB4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 20:56:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbZBGB4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 20:56:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko.Carstens@de.ibm.com
Subject: [PATCH] elf core dump: fix get_user use
In-Reply-To: Linus Torvalds's message of  Friday, 6 February 2009 14:19:31 -0800 <alpine.LFD.2.00.0902061416070.3048@localhost.localdomain>
X-Fcc: ~/Mail/linus
References: <1233940235.22140.9.camel@localhost.localdomain>
	<20090206134410.d548b72c.akpm@linux-foundation.org>
	<20090206220717.AE750FC3AD@magilla.sf.frob.com>
	<alpine.LFD.2.00.0902061416070.3048@localhost.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090207015549.71A30FC3AD@magilla.sf.frob.com>
Date: Fri,  6 Feb 2009 17:55:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6cec50838ed04a9833fb5549f698d3756bbe7e72:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../tiwai/sound-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git to-linus

Roland McGrath (1):
      elf core dump: fix get_user use

 fs/binfmt_elf.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

Thanks,
Roland

---
[PATCH] elf core dump: fix get_user use

The elf_core_dump() code does its work with set_fs(KERNEL_DS) in force,
so vma_dump_size() needs to switch back with set_fs(USER_DS) to safely
use get_user() for a normal user-space address.

Checking for VM_READ optimizes out the case where get_user() would fail
anyway.  The vm_file check here was already superfluous given the control
flow earlier in the function, so that is a cleanup/optimization unrelated
to other changes but an obvious and trivial one.

Reported-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/binfmt_elf.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index e3ff2b9..33b7235 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1208,9 +1208,11 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 	 * check for an ELF header.  If we find one, dump the first page to
 	 * aid in determining what was mapped here.
 	 */
-	if (FILTER(ELF_HEADERS) && vma->vm_file != NULL && vma->vm_pgoff == 0) {
+	if (FILTER(ELF_HEADERS) &&
+	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ)) {
 		u32 __user *header = (u32 __user *) vma->vm_start;
 		u32 word;
+		mm_segment_t fs = get_fs();
 		/*
 		 * Doing it this way gets the constant folded by GCC.
 		 */
@@ -1223,7 +1225,15 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 		magic.elfmag[EI_MAG1] = ELFMAG1;
 		magic.elfmag[EI_MAG2] = ELFMAG2;
 		magic.elfmag[EI_MAG3] = ELFMAG3;
-		if (get_user(word, header) == 0 && word == magic.cmp)
+		/*
+		 * Switch to the user "segment" for get_user(),
+		 * then put back what elf_core_dump() had in place.
+		 */
+		set_fs(USER_DS);
+		if (unlikely(get_user(word, header)))
+			word = 0;
+		set_fs(fs);
+		if (word == magic.cmp)
 			return PAGE_SIZE;
 	}
 
