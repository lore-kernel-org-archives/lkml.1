Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbZK2VMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbZK2VMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 16:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZK2VMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 16:12:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbZK2VMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 16:12:53 -0500
Date: Sun, 29 Nov 2009 22:07:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Veaceslav Falico <vfalico@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: powerpc: syscall_dotrace() && retcode (Was: powerpc: fork &&
	stepping)
Message-ID: <20091129210716.GA19205@redhat.com>
References: <20091125154052.GA6734@redhat.com> <20091126075335.GA18508@in.ibm.com> <20091126145051.GB4382@redhat.com> <20091126172524.GA14768@redhat.com> <20091126182226.GF12355@darkmag.usersys.redhat.com> <20091126202312.GA21945@redhat.com> <19214.63688.860929.962005@cargo.ozlabs.ibm.com> <20091126223703.GA28556@redhat.com> <20091127174627.GB26193@darkmag.usersys.redhat.com> <20091128073049.GD23108@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091128073049.GD23108@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Ananth N Mavinakayanahalli wrote:
>
> syscall-reset is the only failure I see on
> powerpc:
>
> errno 14 (Bad address)
> syscall-reset: syscall-reset.c:95: main: Assertion `(*__errno_location
> ()) == 38' failed.
> unexpected child status 67f
> FAIL: syscall-reset

(to remind, it also fails without utrace)

Once again, I know nothing about powerc, perhaps I misread the code,
but I believe this test-case is just wrong on powerpc and should be
fixed.

On powerpc, syscall_get_nr() returns regs->gpr[0], this means this
register is used to pass the syscall number.

This matches do_syscall_trace_enter(), it returns regs->gpr[0] as a
(possibly changed by tracer) syscall nr.

arch/powerpc/kernel/entry_64.S does

	syscall_dotrace:

		 bl      .do_syscall_trace_enter
		 mr      r0,r3	// I guess, r3 = r0 ?
		 ...
		 b       syscall_dotrace_cont

	syscall_dotrace_cont:

		syscall_dotrace_cont:

			cmpldi  0,r0,NR_syscalls
			bge-    syscall_enosys

	syscall_enosys:

		li      r3,-ENOSYS
		b       syscall_exit


Now return to the test-case, syscall-reset.c. The tracee does
l = syscall (-23, 1, 2, 3) and stops.

The tracer does

	#define RETREG	offsetof(struct pt_regs, gpr[0])
	#define NEWVAL	((long) ENOTTY)

	l = ptrace(PTRACE_PEEKUSER, child, RETREG, 0l);

l == -23, this is correct, note syscall(-23) above.

	l = ptrace(PTRACE_POKEUSER, child, RETREG, NEWVAL);

And expects the tracee will see NEWVAL==ENOTTY after return from
the systame call.

Of course this can't happen. We changed the syscall number, the
new value is ENOTTY == 25 == __NR_stime, sys_stime() correctly
returns -EFAULT.

-----------------------------------------------------------------

If I change the test-case to use NEWVAL == 1000 (or any other value
greater than NR_syscalls), then the tracee sees ENOSYS and this is
correct too.

But I do not see how it is possible to change the retcode on powerpc.
Unlike x86, powepc doesn't set -ENOSYS "in advance", before doing
do_syscall_trace_enter() logic. This means that if the tracer "cancels"
syscall, r3 will be overwritten by syscall_enosys.

This probably means the kernel should be fixed too, but I am not
brave enough to change the asm which I can't understand ;)

Oleg.

