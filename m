Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab0BWVtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 16:49:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:35504 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab0BWVtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 16:49:12 -0500
Date: Tue, 23 Feb 2010 21:48:43 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       roland@redhat.com, suresh.b.siddha@intel.com, oleg@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       oleg@redhat.com
In-Reply-To: <20100222225240.397523600@sbs-t61.sc.intel.com>
References: <20100222225240.397523600@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/ptrace] ptrace: Fix ptrace_regset() comments and diagnose errors specifically
Message-ID: <tip-c6a0dd7ec6fb2d4927979ed4dc562fc5c122d826@git.kernel.org>
Git-Commit-ID: c6a0dd7ec6fb2d4927979ed4dc562fc5c122d826
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 23 Feb 2010 21:48:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6a0dd7ec6fb2d4927979ed4dc562fc5c122d826
Gitweb:     http://git.kernel.org/tip/c6a0dd7ec6fb2d4927979ed4dc562fc5c122d826
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 22 Feb 2010 14:51:32 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 23 Feb 2010 13:45:26 -0800

ptrace: Fix ptrace_regset() comments and diagnose errors specifically

Return -EINVAL for the bad size and for unrecognized NT_* type in
ptrace_regset() instead of -EIO.

Also update the comments for this ptrace interface with more clarifications.

Requested-by: Roland McGrath <roland@redhat.com>
Requested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100222225240.397523600@sbs-t61.sc.intel.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/linux/ptrace.h |    5 +++++
 kernel/ptrace.c        |    2 +-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index dbfa821..c5eab89 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
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
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 13b4554..42ad8ae 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -537,7 +537,7 @@ static int ptrace_regset(struct task_struct *task, int req, unsigned int type,
 	int regset_no;
 
 	if (!regset || (kiov->iov_len % regset->size) != 0)
-		return -EIO;
+		return -EINVAL;
 
 	regset_no = regset - view->regsets;
 	kiov->iov_len = min(kiov->iov_len,
