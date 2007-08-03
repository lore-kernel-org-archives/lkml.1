Return-Path: <linux-kernel-owner+w=401wt.eu-S1762682AbXHCXVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762682AbXHCXVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 19:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXHCXV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 19:21:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbXHCXV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 19:21:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add linux/elfcore-compat.h
X-Fcc: ~/Mail/linus
X-Windows: sometimes you fill a vacuum and it still sucks.
Message-Id: <20070803232121.A252E4D04BC@magilla.localdomain>
Date: Fri,  3 Aug 2007 16:21:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This adds the linux/elfcore-compat.h header file, which is the
CONFIG_COMPAT analog of the linux/elfcore.h header.  Each arch
that needs to fake out fs/binfmt_elf.c for its compat code can
use this header to replace the hand-copied definitions of the
compat variants of struct elf_prstatus et al.  Only the pr_reg
field varies by arch, so asm/{compat,elf}.h must define
compat_elf_gregset_t before linux/elfcore-compat.h can be used.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/elfcore-compat.h |   55 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/elfcore-compat.h

diff --git a/include/linux/elfcore-compat.h b/include/linux/elfcore-compat.h
new file mode 100644
index 0000000..532d13a
--- /dev/null
+++ b/include/linux/elfcore-compat.h
@@ -0,0 +1,55 @@
+#ifndef _LINUX_ELFCORE_COMPAT_H
+#define _LINUX_ELFCORE_COMPAT_H
+
+#include <linux/elf.h>
+#include <linux/elfcore.h>
+#include <linux/compat.h>
+
+/*
+ * Make sure these layouts match the linux/elfcore.h native definitions.
+ */
+
+struct compat_elf_siginfo
+{
+	compat_int_t			si_signo;
+	compat_int_t			si_code;
+	compat_int_t			si_errno;
+};
+
+struct compat_elf_prstatus
+{
+	struct compat_elf_siginfo	pr_info;
+	short				pr_cursig;
+	compat_ulong_t			pr_sigpend;
+	compat_ulong_t			pr_sighold;
+	compat_pid_t			pr_pid;
+	compat_pid_t			pr_ppid;
+	compat_pid_t			pr_pgrp;
+	compat_pid_t			pr_sid;
+	struct compat_timeval		pr_utime;
+	struct compat_timeval		pr_stime;
+	struct compat_timeval		pr_cutime;
+	struct compat_timeval		pr_cstime;
+	compat_elf_gregset_t		pr_reg;
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	compat_ulong_t			pr_exec_fdpic_loadmap;
+	compat_ulong_t			pr_interp_fdpic_loadmap;
+#endif
+	compat_int_t			pr_fpvalid;
+};
+
+struct compat_elf_prpsinfo
+{
+	char				pr_state;
+	char				pr_sname;
+	char				pr_zomb;
+	char				pr_nice;
+	compat_ulong_t			pr_flag;
+	compat_uid_t			pr_uid;
+	compat_gid_t			pr_gid;
+	compat_pid_t			pr_pid, pr_ppid, pr_pgrp, pr_sid;
+	char				pr_fname[16];
+	char				pr_psargs[ELF_PRARGSZ];
+};
+
+#endif /* _LINUX_ELFCORE_COMPAT_H */
