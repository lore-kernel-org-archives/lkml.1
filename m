Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbZIWPlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbZIWPlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZIWPlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:41:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39522 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbZIWPlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:41:46 -0400
Date: Wed, 23 Sep 2009 17:41:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       jan.kratochvil@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] x86: clean up orig_ax handling
Message-ID: <20090923154118.GB6105@elte.hu>
References: <20090923004651.2D99513F37@magilla.sf.frob.com> <alpine.LFD.2.01.0909221757200.4950@localhost.localdomain> <20090923024049.AA85913F37@magilla.sf.frob.com> <20090923061834.BE13A22@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923061834.BE13A22@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> Here is the aforementioned other tack on this.  
> 
> I said earlier that getreg() (i.e. 64-bit ptrace/core-dump fetches)
> should sign-extend the low 32 bits of orig_ax up.  But I've changed my
> mind.  It's true that today you can store 0xffffffff via either 64-bit
> ptrace or 32-bit ptrace and then read back -1 via 64-bit ptrace.  (This
> wasn't always so, and so we can hope that no debugger really depends on
> it.)  What seems more important is that tracing and core dumps correctly
> show the full orig_ax value incoming in %rax from userland, since
> %rax=__NR_foo|(1UL<<32) behaves differently (i.e. -ENOSYS) than
> %eax=_NR_foo in actual fact when user-mode does "syscall" with those
> values.  In a bogon case like that, you would like to have traces/dumps
> tell you why the task is not making a proper syscall rather than lie
> about what register bits it entered the kernel with.
> 
> Patches 1-3 change no ptrace-tests outcomes, i.e. don't regress on the
> test cases that went with the original sign-extension changes.  They
> reintroduce e.g. the ability to blindly read and write back the whole
> regset when at syscall-entry tracing with %rax=__NR_foo|(1UL<<32) and
> have that fail with -ENOSYS as it would without tracing rather than
> perturb the tracee to call sys_foo instead.  (Not that this is useful.)
> 
> Patch 4 does Linus's fix for the outstanding bug.  I've verified it works.
> 
> 
> Thanks,
> Roland
> ---
> The following changes since commit 7fa07729e439a6184bd824746d06a49cca553f15:
>   Linus Torvalds (1):
>         Merge branch 'perf-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git x86/orig_ax
> 
> Roland McGrath (4):
>       asm-generic: syscall_get_nr returns int
>       x86: syscall_get_nr returns int
>       x86: ptrace: do not sign-extend orig_ax on write
>       x86: ptrace: set TS_COMPAT when 32-bit ptrace sets orig_eax>=0
> 
>  arch/x86/include/asm/syscall.h |   14 +++++++-------
>  arch/x86/kernel/ptrace.c       |   21 ++++++++-------------
>  include/asm-generic/syscall.h  |    8 ++++++--
>  3 files changed, 21 insertions(+), 22 deletions(-)

Linus, this series looks good to me. Do you want to pull this directly 
or should we test this for a few days in the x86 tree? (either solution 
is fine to me)

	Ingo
