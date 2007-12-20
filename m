Return-Path: <linux-kernel-owner+w=401wt.eu-S1760903AbXLTL4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903AbXLTL4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760130AbXLTL4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:56:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760711AbXLTL4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:56:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 08/43] compat_ptrace_request
Message-Id: <20071220115539.AA1C426F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:55:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a compat_ptrace_request that is the analogue of ptrace_request
for the things that 32-on-64 ptrace implementations can share in common.
So far there are just a couple of requests handled generically.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/compat.h |    4 ++++
 kernel/ptrace.c        |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index ba29d4c..e70a2a1 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -271,5 +271,9 @@ asmlinkage long compat_sys_signalfd(int ufd,
 asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
 				const struct compat_itimerspec __user *utmr);
 
+extern int compat_ptrace_request(struct task_struct *child,
+				 compat_long_t request,
+				 compat_ulong_t addr, compat_ulong_t data);
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index e521042..bc1a764 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -605,3 +605,41 @@ int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data)
 	copied = access_process_vm(tsk, addr, &data, sizeof(data), 1);
 	return (copied == sizeof(data)) ? 0 : -EIO;
 }
+
+#ifdef CONFIG_COMPAT
+#include <linux/compat.h>
+
+int compat_ptrace_request(struct task_struct *child, compat_long_t request,
+			  compat_ulong_t addr, compat_ulong_t data)
+{
+	compat_ulong_t __user *datap = compat_ptr(data);
+	compat_ulong_t word;
+	int ret;
+
+	switch (request) {
+	case PTRACE_PEEKTEXT:
+	case PTRACE_PEEKDATA:
+		ret = access_process_vm(child, addr, &word, sizeof(word), 0);
+		if (ret != sizeof(word))
+			ret = -EIO;
+		else
+			ret = put_user(word, datap);
+		break;
+
+	case PTRACE_POKETEXT:
+	case PTRACE_POKEDATA:
+		ret = access_process_vm(child, addr, &data, sizeof(data), 1);
+		ret = (ret != sizeof(data) ? -EIO : 0);
+		break;
+
+	case PTRACE_GETEVENTMSG:
+		ret = put_user((compat_ulong_t) child->ptrace_message, datap);
+		break;
+
+	default:
+		ret = ptrace_request(child, request, addr, data);
+	}
+
+	return ret;
+}
+#endif	/* CONFIG_COMPAT */
-- 
1.5.3.6

