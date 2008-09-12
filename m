Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbYILNGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbYILNGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 09:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbYILNFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 09:05:55 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:54725 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752852AbYILNFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 09:05:54 -0400
Date: Fri, 12 Sep 2008 22:05:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Roland McGrath <roland@redhat.com>
Cc: linux-arch@vger.kernel.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HAVE_ARCH_TRACEHOOK and you
Message-ID: <20080912130511.GA11375@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Roland McGrath <roland@redhat.com>, linux-arch@vger.kernel.org,
	utrace-devel@redhat.com, linux-kernel@vger.kernel.org
References: <20080912025733.E55F415420D@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080912025733.E55F415420D@magilla.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 07:57:33PM -0700, Roland McGrath wrote:
> The comment in arch/Kconfig lists the items:
> 
> #	task_pt_regs()		in asm/processor.h or asm/ptrace.h
> #	arch_has_single_step()	if there is hardware single-step support
> #	arch_has_block_step()	if there is hardware block-step support
> #	arch_ptrace()		and not #define __ARCH_SYS_PTRACE
> #	compat_arch_ptrace()	and #define __ARCH_WANT_COMPAT_SYS_PTRACE
> #	asm/syscall.h		supplying asm-generic/syscall.h interface
> #	linux/regset.h		user_regset interfaces
> #	CORE_DUMP_USE_REGSET	#define'd in linux/elf.h
> #	TIF_SYSCALL_TRACE	calls tracehook_report_syscall_{entry,exit}
> #	TIF_NOTIFY_RESUME	calls tracehook_notify_resume()
> #	signal delivery		calls tracehook_signal_handler()
> 
[snip]

> Here's the text that's on that wiki:
> 
>     1. task_pt_regs()
> 
>           * Define this inline function in asm/processor.h or asm/ptrace.h.
> 
user_stack_pointer() is apparently a requirement, too. Although given
that you already have a task_struct pointer the only place you currently
use it (lib/syscall.c), it makes more sense to use KSTK_ESP/KSTK_EIP
which is provided by almost everyone already.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 lib/syscall.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/syscall.c b/lib/syscall.c
index a4f7067..888c36a 100644
--- a/lib/syscall.c
+++ b/lib/syscall.c
@@ -11,8 +11,8 @@ static int collect_syscall(struct task_struct *target, long *callno,
 	if (unlikely(!regs))
 		return -EAGAIN;
 
-	*sp = user_stack_pointer(regs);
-	*pc = instruction_pointer(regs);
+	*sp = KSTK_ESP(target);
+	*pc = KSTK_EIP(target);
 
 	*callno = syscall_get_nr(target, regs);
 	if (*callno != -1L && maxargs > 0)

