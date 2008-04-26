Return-Path: <linux-kernel-owner+w=401wt.eu-S1761881AbYDZTsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761881AbYDZTsP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759196AbYDZTsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:48:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37609 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbYDZTr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:47:59 -0400
Date: Sat, 26 Apr 2008 21:47:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [git pull] x86 fix
Message-ID: <20080426194745.GA11557@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull this x86 fix from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-fixes2.git for-linus

Thanks,

	Ingo

------------------>
Venki Pallipadi (1):
      x86, PAT: disable /dev/mem mmap RAM with PAT

 arch/x86/mm/pat.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 9851265..e7ca7fc 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -16,6 +16,7 @@
 #include <asm/msr.h>
 #include <asm/tlbflush.h>
 #include <asm/processor.h>
+#include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/pat.h>
 #include <asm/e820.h>
@@ -477,6 +478,33 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 	return vma_prot;
 }
 
+#ifdef CONFIG_NONPROMISC_DEVMEM
+/* This check is done in drivers/char/mem.c in case of NONPROMISC_DEVMEM*/
+static inline int range_is_allowed(unsigned long pfn, unsigned long size)
+{
+	return 1;
+}
+#else
+static inline int range_is_allowed(unsigned long pfn, unsigned long size)
+{
+	u64 from = ((u64)pfn) << PAGE_SHIFT;
+	u64 to = from + size;
+	u64 cursor = from;
+
+	while (cursor < to) {
+		if (!devmem_is_allowed(pfn)) {
+			printk(KERN_INFO
+		"Program %s tried to access /dev/mem between %Lx->%Lx.\n",
+				current->comm, from, to);
+			return 0;
+		}
+		cursor += PAGE_SIZE;
+		pfn++;
+	}
+	return 1;
+}
+#endif /* CONFIG_NONPROMISC_DEVMEM */
+
 int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t *vma_prot)
 {
@@ -485,6 +513,9 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 	unsigned long ret_flags;
 	int retval;
 
+	if (!range_is_allowed(pfn, size))
+		return 0;
+
 	if (file->f_flags & O_SYNC) {
 		flags = _PAGE_CACHE_UC;
 	}
