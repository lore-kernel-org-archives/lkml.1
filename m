Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbYF1FCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbYF1FCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 01:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbYF1FCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 01:02:09 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:36693 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751200AbYF1FCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 01:02:06 -0400
Date: Sat, 28 Jun 2008 13:59:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: monstr@seznam.cz
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 28/60] microblaze_v4: ptrace support
Message-ID: <20080628045908.GG25492@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>, monstr@seznam.cz,
	linux-kernel@vger.kernel.org, arnd@arndb.de,
	linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
	John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
	will.newton@gmail.com, drepper@redhat.com,
	microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
	linuxppc-dev@ozlabs.org, vapier.adi@gmail.com,
	alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
	Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-20-git-send-email-monstr@seznam.cz> <1214483429-32360-21-git-send-email-monstr@seznam.cz> <1214483429-32360-22-git-send-email-monstr@seznam.cz> <1214483429-32360-23-git-send-email-monstr@seznam.cz> <1214483429-32360-24-git-send-email-monstr@seznam.cz> <1214483429-32360-25-git-send-email-monstr@seznam.cz> <1214483429-32360-26-git-send-email-monstr@seznam.cz> <1214483429-32360-27-git-send-email-monstr@seznam.cz> <1214483429-32360-28-git-send-email-monstr@seznam.cz> <1214483429-32360-29-git-send-email-monstr@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214483429-32360-29-git-send-email-monstr@seznam.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:29:57PM +0200, monstr@seznam.cz wrote:
> +long arch_ptrace(struct task_struct *child, long request, long addr, long data)
> +{
> +	int rval;
> +
> +	switch (request) {
> +		unsigned long val, copied;
> +
> +	case PTRACE_PEEKTEXT: /* read word at location addr. */
> +	case PTRACE_PEEKDATA:
> +		pr_debug("PEEKTEXT/PEEKDATA at %08lX\n", addr);
> +		copied = access_process_vm(child, addr, &val, sizeof(val), 0);
> +		rval = -EIO;
> +		if (copied != sizeof(val))
> +			break;
> +		rval = put_user(val, (unsigned long *)data);
> +		goto out;
> +
> +	case PTRACE_POKETEXT: /* write the word at location addr. */
> +	case PTRACE_POKEDATA:
> +		pr_debug("POKETEXT/POKEDATA to %08lX\n", addr);
> +		rval = 0;
> +		if (access_process_vm(child, addr, &data, sizeof(data), 1)
> +			== sizeof(data))
> +			break;
> +		rval = -EIO;
> +		goto out;
> +
You can use generic_ptrace_peekdata()/generic_ptrace_pokedata() for
these. Or kill them off and let ptrace_request() handle it.

> +	/* Continue and stop at next (return from) syscall */
> +	case PTRACE_SYSCALL:
> +		pr_debug("PTRACE_SYSCALL\n");
> +	case PTRACE_SINGLESTEP:
> +		pr_debug("PTRACE_SINGLESTEP\n");
> +	/* Restart after a signal. */
> +	case PTRACE_CONT:
> +		pr_debug("PTRACE_CONT\n");
> +		rval = -EIO;
> +		if (!valid_signal(data))
> +			break;
> +
> +		if (request == PTRACE_SYSCALL)
> +			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
> +		else
> +			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
> +
> +		child->exit_code = data;
> +		pr_debug("wakeup_process\n");
> +		wake_up_process(child);
> +		rval = 0;
> +		break;
> +
This is a reimplementation of ptrace_resume(), you can kill all of these
off as well, as they are also handled generically these days.

> +	/*
> +	 * make the child exit. Best I can do is send it a sigkill.
> +	 * perhaps it should be put in the status that it wants to
> +	 * exit.
> +	 */
> +	case PTRACE_KILL:
> +		pr_debug("PTRACE_KILL\n");
> +		rval = 0;
> +		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
> +			break;
> +		child->exit_code = SIGKILL;
> +		wake_up_process(child);
> +		break;
> +
> +	case PTRACE_DETACH: /* detach a process that was attached. */
> +		pr_debug("PTRACE_DETACH\n");
> +		rval = ptrace_detach(child, data);
> +		break;
> +
> +	default:
> +		rval = -EIO;
> +		goto out;
> +	}
> + out:
> +	return rval;
> +}
> +
Or rather, they would be, if you defaulted to ptrace_request() for the
unhandled cases.
