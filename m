Return-Path: <linux-kernel-owner+w=401wt.eu-S932194AbZKMTZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbZKMTZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbZKMTZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:25:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757186AbZKMTZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:25:52 -0500
Date: Fri, 13 Nov 2009 11:25:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Roland McGrath <roland@redhat.com>,
       Srinivasa Ds <srinivasa@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] ptrace: change tracehook_report_syscall_exit()
 to handle stepping
Message-Id: <20091113112530.c10a3743.akpm@linux-foundation.org>
In-Reply-To: <20091112173853.GA12279@redhat.com>
References: <20091112173853.GA12279@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 18:38:53 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> Change tracehook_report_syscall_exit() to look at step flag and send
> the trap signal if needed.
> 
> This change affects ia64, microblaze, parisc, powerpc, sh.  They pass
> nonzero "step" argument to tracehook but since it was ignored the tracee
> reports via ptrace_notify(), this is not right and not consistent.

This patch conflicts with utrace-core.patch a bit:

***************
*** 134,139 ****
   */
  static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
  {
        ptrace_report_syscall(regs);
  }
  
--- 140,147 ----
   */
  static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
  {
+       if (task_utrace_flags(current) & UTRACE_EVENT(SYSCALL_EXIT))
+               utrace_report_syscall_exit(regs);
        ptrace_report_syscall(regs);
  }

I did this:

  static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
  {
        if (step) {
                siginfo_t info;
                user_single_step_siginfo(current, regs, &info);
                force_sig_info(SIGTRAP, &info, current);
                return;
        }

+       if (task_utrace_flags(current) & UTRACE_EVENT(SYSCALL_EXIT))
+               utrace_report_syscall_exit(regs);
        ptrace_report_syscall(regs);
  }


utrace-core.patch is getting rather old.  What is its status?
