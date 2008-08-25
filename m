Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYHYQd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYHYQd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 12:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYHYQdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 12:33:18 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44137 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbYHYQdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 12:33:17 -0400
Subject: Re: [RFC] [Patch 1/1] [Self Ptrace] System call notification with
	self_ptrace
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Pierre Morel <pmorel@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <48B26083.8080506@linux.vnet.ibm.com>
References: <48B26083.8080506@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 09:33:12 -0700
Message-Id: <1219681992.20559.196.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-25 at 09:34 +0200, Pierre Morel wrote:
> +       if ((current->ptrace & PT_SELF)
> +               && (regs->orig_ax != __NR_rt_sigreturn)
> +               && (regs->orig_ax != __NR_ptrace)) {
> +               if (!entryexit) {
> +               struct siginfo info;
> +
> +               memset(&info, 0, sizeof(struct siginfo));
> +               info.si_signo = SIGSYS;
> +               info.si_code = SYS_SYSCALL;
> +               info.si_addr = (void *) regs->orig_ax;
> +               send_sig_info(SIGSYS, &info, current);
> +               }
> +               return 1; /* Skip system call, deliver signal. */
> +       }

The indenting here looks messed up.

Also, there looks to be a pretty substantial amount of copy-and-paste
code in those little if()s.  It's only going to get worse as we add more
architectures.  If there's ever a little buglet in that bit of code, or
we need to tweak it it some way, it'll be a bitch to fix.

For instance, if you have a little arch-independent helper like this:

static inline int is_self_ptracing(unsigned long syscall_reg)
{
	if (!(current->ptrace & PT_SELF))
		return 0;
	if (syscall_reg == __NR_rt_sigreturn)
		return 0;
	if (syscall_reg == __NR_ptrace)
		return 0;
	return 1;
}

You can call it like this:

	if (is_self_ptracing(regs->gprs[2]))
...
	if (is_self_ptracing(regs->orig_ax))
...
	if (is_self_ptracing(regs->orig_rax))

Something similar can probably be done for the siginfo construction.

You should basically try and think of ways to abstract this stuff every
single time you touch arch code.  

Why don't you also mention why you really want this feature.  That's
missing from the description. 

-- Dave

