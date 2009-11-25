Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbZKYS77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbZKYS77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932331AbZKYS76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:59:58 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:36699 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098AbZKYS74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:59:56 -0500
Date: Wed, 25 Nov 2009 10:59:55 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, hpa@zytor.com,
       Nathan Lynch <nathanl@austin.ibm.com>, haveblue@us.ibm.com,
       Matt Helsley <matthltc@us.ibm.com>, arnd@arndb.de, roland@redhat.com,
       mtk.manpages@googlemail.com, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>
Subject: [v13][PATCH 09/12] Implement sys_eclone for x86_64
Message-ID: <20091125185955.GJ30858@us.ibm.com>
References: <20091125185543.GA30858@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125185543.GA30858@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [v13][PATCH 09/12] Implement sys_eclone for x86_64

Implement sys_eclone() system call for x86_64.

This is based on earlier code from Dave Hansen. Modified to share code
between x86 and x86_64 kernels.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/x86/include/asm/unistd_64.h |    3 +++
 arch/x86/kernel/entry_64.S       |    1 +
 arch/x86/kernel/process_64.c     |    7 +++++++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 8d3ad0a..d2ffc89 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -661,6 +661,9 @@ __SYSCALL(__NR_pwritev, sys_pwritev)
 __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 #define __NR_perf_event_open			298
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
+#define __NR_eclone                   		299
+__SYSCALL(__NR_eclone, stub_eclone)
+
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b5c061f..6d60cd1 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -698,6 +698,7 @@ END(\label)
 	PTREGSCALL stub_vfork, sys_vfork, %rdi
 	PTREGSCALL stub_sigaltstack, sys_sigaltstack, %rdx
 	PTREGSCALL stub_iopl, sys_iopl, %rsi
+	PTREGSCALL stub_eclone, sys_eclone, %r8
 
 ENTRY(ptregscall_common)
 	DEFAULT_FRAME 1 8	/* offset 8: return address */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index eb62cbc..2c306b9 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -540,6 +540,13 @@ sys_clone(unsigned long clone_flags, unsigned long newsp,
 	return do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
 }
 
+asmlinkage long
+sys_eclone(unsigned int flags_low, struct clone_args * __user uca,
+		int args_size, pid_t * __user pids, struct pt_regs *regs)
+{
+	return do_eclone_common(regs, flags_low, uca, args_size, pids);
+}
+
 unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long stack;
-- 
1.6.0.4

