Return-Path: <linux-kernel-owner+w=401wt.eu-S967017AbYCSWws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967017AbYCSWws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965997AbYCSVVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:21:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765597AbYCSVVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:21:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Cc: Richard Henderson <rth@twiddle.net>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 6/8] ptrace: arch_ptrace -ENOSYS return
In-Reply-To: Roland McGrath's message of  Wednesday, 19 March 2008 14:17:14 -0700 <20080319211714.8B14226F995@magilla.localdomain>
References: <20080319211714.8B14226F995@magilla.localdomain>
X-Windows: more than enough rope.
Message-Id: <20080319212024.EA03126F995@magilla.localdomain>
Date: Wed, 19 Mar 2008 14:20:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arch_ptrace and compat_arch_ptrace functions can now return
-ENOSYS for requests they do not actually implement in arch
code.  Returning -ENOSYS replaces the calls to ptrace_request
and compat_ptrace_request.  This leaves more latitude for the
machine-independent ptrace implementation code to change without
requiring any more updates in the arch code.

This change has no effect on the old arch code that still calls
ptrace_request or compat_ptrace_request.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/ptrace.c |   42 ++++++++++++++++++++++++++----------------
 1 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 67e392e..60b2b57 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -574,18 +574,21 @@ asmlinkage long sys_ptrace(long request, long pid, long addr, long data)
 		 */
 		if (!ret)
 			arch_ptrace_attach(child);
-		goto out_put_task_struct;
+	} else {
+		ret = ptrace_check_attach(child, request == PTRACE_KILL);
+		/*
+		 * Let the arch handler inspect it first.  It returns
+		 * -ENOSYS if this is not an arch-specific request.
+		 */
+		if (!ret) {
+			ret = arch_ptrace(child, request, addr, data);
+			if (ret == -ENOSYS &&
+			    !forced_successful_syscall_return())
+				ret = ptrace_request(child, request,
+						     addr, data);
+		}
 	}
 
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
-	if (ret < 0)
-		goto out_put_task_struct;
-
-	ret = arch_ptrace(child, request, addr, data);
-	if (ret < 0)
-		goto out_put_task_struct;
-
- out_put_task_struct:
 	put_task_struct(child);
  out:
 	unlock_kernel();
@@ -697,14 +700,21 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 		 */
 		if (!ret)
 			arch_ptrace_attach(child);
-		goto out_put_task_struct;
+	} else {
+		ret = ptrace_check_attach(child, request == PTRACE_KILL);
+		/*
+		 * Let the arch handler inspect it first.  It returns
+		 * -ENOSYS if this is not an arch-specific request.
+		 */
+		if (!ret) {
+			ret = compat_arch_ptrace(child, request, addr, data);
+			if (ret == -ENOSYS &&
+			    !forced_successful_syscall_return())
+				ret = compat_ptrace_request(child, request,
+							    addr, data);
+		}
 	}
 
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
-	if (!ret)
-		ret = compat_arch_ptrace(child, request, addr, data);
-
- out_put_task_struct:
 	put_task_struct(child);
  out:
 	unlock_kernel();
