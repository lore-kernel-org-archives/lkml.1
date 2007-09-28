Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbXI1LCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbXI1LCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 07:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbXI1LCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 07:02:09 -0400
Received: from hu-out-0506.google.com ([72.14.214.225]:32395 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbXI1LCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 07:02:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=qkR15D231SjiM9HGI0LIJxIWfMamlpo0nF9Cy0zVpcnR2GQrEMAqkDsBRnwiJbMnwy4pMZvlW8meGXCLjbwIJC8O9Li1CnFr8IRmA8qpji70roR80Vhh6/KvbmsrUs3ohu5qwRx/NJa7exxiozJ8aiZadrs+xsWFo8VPkjznpPs=
Message-ID: <46FCDEA3.20205@gmail.com>
Date: Fri, 28 Sep 2007 12:59:47 +0200
From: Franck Bui-Huu <fbuihuu@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Ralf Baechle <ralf@linux-mips.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Break ELF_PLATFORM and stack pointer randomization dependency
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently arch_align_stack() is used by fs/binfmt_elf.c to randomize
stack pointer inside a page. But this happens only if ELF_PLATFORM
symbol is defined.

ELF_PLATFORM is normally set if the architecture wants ld.so to load
implementation specific libraries for optimization. And currently a
lot of architectures just yield this symbol to NULL.

This is the case for MIPS architecture where ELF_PLATFORM is NULL but
arch_align_stack() has been redefined to do stack inside page
randomization. So in this case no randomization is actually done.

This patch breaks this dependency which seems to be useless and allows
platforms such MIPS to do the randomization.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---

	Andrew,

   I tried several times to poke people on the list to understand why
   this dependency exists at all, but unfortunately got no answers.

   So I'm submitting this patch to at least have some feedbacks. An
   easier solution would be to define ELF_PLATFORM to a dummy string
   for MIPS but it sounds very hackish.

   Thanks,
		Franck

 fs/binfmt_elf.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 4482a06..760d53d 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -151,6 +151,14 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	struct vm_area_struct *vma;
 
 	/*
+	 * In some cases (e.g. Hyper-Threading), we want to avoid L1
+	 * evictions by the processes running on the same package. One
+	 * thing we can do is to shuffle the initial stack for them.
+	 */
+
+	p = arch_align_stack(p);
+
+	/*
 	 * If this architecture has a platform capability string, copy it
 	 * to userspace.  In some cases (Sparc), this info is impossible
 	 * for userspace to get any other way, in others (i386) it is
@@ -160,14 +168,6 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	if (k_platform) {
 		size_t len = strlen(k_platform) + 1;
 
-		/*
-		 * In some cases (e.g. Hyper-Threading), we want to avoid L1
-		 * evictions by the processes running on the same package. One
-		 * thing we can do is to shuffle the initial stack for them.
-		 */
-
-		p = arch_align_stack(p);
-
 		u_platform = (elf_addr_t __user *)STACK_ALLOC(p, len);
 		if (__copy_to_user(u_platform, k_platform, len))
 			return -EFAULT;
-- 
1.5.3.1

