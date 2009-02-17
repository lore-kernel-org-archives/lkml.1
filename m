Return-Path: <linux-kernel-owner+w=401wt.eu-S1751377AbZBQKuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbZBQKuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:50:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZBQKtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:49:53 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:40503 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbZBQKtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:49:53 -0500
Date: Tue, 17 Feb 2009 13:49:56 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: binfmt_aout fix
Message-ID: <20090217104956.GC25856@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the problem introduced by commit 3bfacef412 (get rid of
special-casing the /sbin/loader on alpha): osf/1 ecoff binary
segfaults when binfmt_aout built as module. That happens because
aout binary handler gets on the top of the binfmt list due to late
registration, and kernel attempts to execute the binary without
preparation work that must be done by binfmt_loader.

So I had to add a check for bprm->loader in load_aout_binary()
which makes a search order irrelevant.

Also, do not build the binfmt_loader when CONFIG_BINFMT_AOUT
is not set.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/kernel/Makefile |    6 +++++-
 fs/binfmt_aout.c           |    6 ++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/Makefile b/arch/alpha/kernel/Makefile
index b469775..e203713 100644
--- a/arch/alpha/kernel/Makefile
+++ b/arch/alpha/kernel/Makefile
@@ -8,7 +8,7 @@ EXTRA_CFLAGS	:= -Werror -Wno-sign-compare
 
 obj-y    := entry.o traps.o process.o init_task.o osf_sys.o irq.o \
 	    irq_alpha.o signal.o setup.o ptrace.o time.o \
-	    alpha_ksyms.o systbls.o err_common.o io.o binfmt_loader.o
+	    alpha_ksyms.o systbls.o err_common.o io.o
 
 obj-$(CONFIG_VGA_HOSE)	+= console.o
 obj-$(CONFIG_SMP)	+= smp.o
@@ -43,6 +43,10 @@ else
 # Misc support
 obj-$(CONFIG_ALPHA_SRM)		+= srmcons.o
 
+ifdef CONFIG_BINFMT_AOUT
+obj-y	+= binfmt_loader.o
+endif
+
 # Core logic support
 obj-$(CONFIG_ALPHA_APECS)	+= core_apecs.o
 obj-$(CONFIG_ALPHA_CIA)		+= core_cia.o
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index b639dcf..c890e5f 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -226,6 +226,12 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 	int retval;
 
 	ex = *((struct exec *) bprm->buf);		/* exec-header */
+#ifdef __alpha__
+	/* Check whether the OSF/1 loader is required and present. */
+	if (ex.fh.f_magic == 0x183 && (ex.fh.f_flags & 0x3000) == 0x3000 &&
+	    !bprm->loader)
+		return -ENOEXEC;
+#endif
 	if ((N_MAGIC(ex) != ZMAGIC && N_MAGIC(ex) != OMAGIC &&
 	     N_MAGIC(ex) != QMAGIC && N_MAGIC(ex) != NMAGIC) ||
 	    N_TRSIZE(ex) || N_DRSIZE(ex) ||
