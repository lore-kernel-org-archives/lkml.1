Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbZBJTSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbZBJTSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZBJTEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:15 -0500
Received: from kroah.org ([198.145.64.141]:33907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755935AbZBJTEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:13 -0500
Date: Tue, 10 Feb 2009 11:01:19 -0800
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
Subject: [patch 42/53] elf core dump: fix get_user use
Message-ID: <20090210190119.GQ14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="elf-core-dump-fix-get_user-use.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Roland McGrath <roland@redhat.com>

commit 92dc07b1f988e8c237a38e23be660b9b8533e6fd upstream.

The elf_core_dump() code does its work with set_fs(KERNEL_DS) in force,
so vma_dump_size() needs to switch back with set_fs(USER_DS) to safely
use get_user() for a normal user-space address.

Checking for VM_READ optimizes out the case where get_user() would fail
anyway.  The vm_file check here was already superfluous given the control
flow earlier in the function, so that is a cleanup/optimization unrelated
to other changes but an obvious and trivial one.

Reported-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/binfmt_elf.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1196,9 +1196,11 @@ static unsigned long vma_dump_size(struc
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
@@ -1211,7 +1213,15 @@ static unsigned long vma_dump_size(struc
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
 

