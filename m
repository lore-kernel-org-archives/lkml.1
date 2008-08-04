Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYHDVyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYHDVyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765354AbYHDVkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:40:22 -0400
Received: from mail.suse.de ([195.135.220.2]:55076 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763684AbYHDVkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:40:19 -0400
Date: Mon, 4 Aug 2008 14:30:36 -0700
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
       alan@lxorguk.ukuu.org.uk, Andreas Schwab <schwab@suse.de>,
       Paul Mackerras <paulus@samba.org>
Subject: [patch 18/25] Add compat handler for PTRACE_GETSIGINFO
Message-ID: <20080804213036.GR8014@suse.de>
References: <20080804203506.816201392@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="add-compat-handler-for-ptrace_getsiginfo.patch"
In-Reply-To: <20080804212725.GA7944@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Andreas Schwab <schwab@suse.de>

commit e4cc58944c1e2ce41e3079d4eb60c95e7ce04b2b upstream

Current versions of gdb require a working implementation of
PTRACE_GETSIGINFO for proper watchpoint support.  Since struct siginfo
contains pointers it must be converted when passed to a 32-bit debugger.

Signed-off-by: Andreas Schwab <schwab@suse.de>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/ppc32.h    |    2 ++
 arch/powerpc/kernel/ptrace32.c |   27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

--- a/arch/powerpc/kernel/ppc32.h
+++ b/arch/powerpc/kernel/ppc32.h
@@ -135,4 +135,6 @@ struct ucontext32 { 
 	struct mcontext32	uc_mcontext;
 };
 
+extern int copy_siginfo_to_user32(struct compat_siginfo __user *d, siginfo_t *s);
+
 #endif  /* _PPC64_PPC32_H */
--- a/arch/powerpc/kernel/ptrace32.c
+++ b/arch/powerpc/kernel/ptrace32.c
@@ -29,12 +29,15 @@
 #include <linux/security.h>
 #include <linux/signal.h>
 #include <linux/compat.h>
+#include <linux/elf.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
 
+#include "ppc32.h"
+
 /*
  * does not yet catch signals sent when the child dies.
  * in exit.c or in signal.c.
@@ -64,6 +67,27 @@ static long compat_ptrace_old(struct tas
 	return -EPERM;
 }
 
+static int compat_ptrace_getsiginfo(struct task_struct *child, compat_siginfo_t __user *data)
+{
+	siginfo_t lastinfo;
+	int error = -ESRCH;
+
+	read_lock(&tasklist_lock);
+	if (likely(child->sighand != NULL)) {
+		error = -EINVAL;
+		spin_lock_irq(&child->sighand->siglock);
+		if (likely(child->last_siginfo != NULL)) {
+			lastinfo = *child->last_siginfo;
+			error = 0;
+		}
+		spin_unlock_irq(&child->sighand->siglock);
+	}
+	read_unlock(&tasklist_lock);
+	if (!error)
+		return copy_siginfo_to_user32(data, &lastinfo);
+	return error;
+}
+
 long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 			compat_ulong_t caddr, compat_ulong_t cdata)
 {
@@ -282,6 +306,9 @@ long compat_arch_ptrace(struct task_stru
 			0, PT_REGS_COUNT * sizeof(compat_long_t),
 			compat_ptr(data));
 
+	case PTRACE_GETSIGINFO:
+		return compat_ptrace_getsiginfo(child, compat_ptr(data));
+
 	case PTRACE_GETFPREGS:
 	case PTRACE_SETFPREGS:
 	case PTRACE_GETVRREGS:

-- 
