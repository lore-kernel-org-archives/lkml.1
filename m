Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab0BVW5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 17:57:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:52133 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554Ab0BVW5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 17:57:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,521,1262592000"; 
   d="scan'208";a="598191610"
Message-Id: <20100222225240.397523600@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 22 Feb 2010 14:51:32 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com,
       suresh.b.siddha@intel.com
Subject: [patch 1/3] ptrace: fix ptrace_regset() comments and diagnose errors specifically
Content-Disposition: inline; filename=better_characterize_ptrace_regset_error.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -EINVAL for the bad size and for unrecognized NT_* type in
ptrace_regset() instead of -EIO.

Also update the comments for this ptrace interface with more clarifications.

Requested-by: Roland McGrath <roland@redhat.com>
Requested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 include/linux/ptrace.h |    5 +++++
 kernel/ptrace.c        |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: tip/kernel/ptrace.c
===================================================================
--- tip.orig/kernel/ptrace.c
+++ tip/kernel/ptrace.c
@@ -537,7 +537,7 @@ static int ptrace_regset(struct task_str
 	int regset_no;
 
 	if (!regset || (kiov->iov_len % regset->size) != 0)
-		return -EIO;
+		return -EINVAL;
 
 	regset_no = regset - view->regsets;
 	kiov->iov_len = min(kiov->iov_len,
Index: tip/include/linux/ptrace.h
===================================================================
--- tip.orig/include/linux/ptrace.h
+++ tip/include/linux/ptrace.h
@@ -30,6 +30,11 @@
 /*
  * Generic ptrace interface that exports the architecture specific regsets
  * using the corresponding NT_* types (which are also used in the core dump).
+ * Please note that the NT_PRSTATUS note type in a core dump contains a full
+ * 'struct elf_prstatus'. But the user_regset for NT_PRSTATUS contains just the
+ * elf_gregset_t that is the pr_reg field of 'struct elf_prstatus'. For all the
+ * other user_regset flavors, the user_regset layout and the ELF core dump note
+ * payload are exactly the same layout.
  *
  * This interface usage is as follows:
  *	struct iovec iov = { buf, len};


