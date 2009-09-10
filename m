Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbZIJFRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbZIJFRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 01:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZIJFRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 01:17:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48689 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbZIJFRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 01:17:09 -0400
Date: Thu, 10 Sep 2009 07:16:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stable Kernel <stable@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] Xen bugfixes
Message-ID: <20090910051648.GA1335@elte.hu>
References: <4AA83F99.5040401@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA83F99.5040401@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi,
> 
> Here's 3 patches which fix two Xen PV spinlock bugs, and makes 
> CONFIG_CC_STACKPROTECTOR work on both 32- and 64-bit.
> 
> The spinlock bugs are both rare races:
>  - lock can briefly hold the lock while interrupts are enabled, allowing an ISR to deadlock
>  - unlock doesn't enforce CPU memory ordering between the actual unlock write and the check
>    to see if there are any pending waiters, so it can end up deciding there's nobody to
>    kick on unlock, leaving another CPU hanging.  It needs a full mb() to guarantee the correct
>    ordering.
> 
> The stack-protector fix bites the bullet and does a full GDT setup 
> early so that we can load %gs for the stack-protector canary 
> segment on i386.  This also removes the assumption that the 
> initial percpu %fs segment has a zero base.
> 
> x86-64 still just needs the GS_BASE MSR written, but that now 
> happens using the same code as i386 rather than being special 
> cased.
> 
> Thanks,
> 	J
> 
> The following changes since commit e07cccf4046978df10f2e13fe2b99b2f9b3a65db:
>   Linus Torvalds (1):
>         Linux 2.6.31-rc9
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git bugfix
> 
> Jeremy Fitzhardinge (2):
>       xen: make -fstack-protector work under Xen
>       xen: only enable interrupts while actually blocking for spinlock
> 
> Yang Xiaowei (1):
>       xen: use stronger barrier after unlocking lock
> 
>  arch/x86/mm/Makefile     |    4 ++
>  arch/x86/xen/Makefile    |    2 +
>  arch/x86/xen/enlighten.c |  131 +++++++++++++++++++++++++++++++++++++++-------
>  arch/x86/xen/smp.c       |    1 +
>  arch/x86/xen/spinlock.c  |   28 ++++++----
>  drivers/xen/Makefile     |    3 +
>  6 files changed, 140 insertions(+), 29 deletions(-)

Pulled, thanks a lot Jeremy!

A few comments:

> +# Make sure __phys_addr has no stackprotector
> +nostackp := $(call cc-option, -fno-stack-protector)
> +CFLAGS_ioremap.o		:= $(nostackp)
> +

Sure we could move __phys_addr into its own file and thus avoid 
turning off stackprotector for the rest of ioremap.c?

> --- a/arch/x86/xen/Makefile
> +++ b/arch/x86/xen/Makefile
> @@ -8,6 +8,7 @@ endif
>  # Make sure early boot has no stackprotector
>  nostackp := $(call cc-option, -fno-stack-protector)
>  CFLAGS_enlighten.o		:= $(nostackp)
> +CFLAGS_mmu.o			:= $(nostackp)

A similar argument could be made here - what proportion of mmu.c is 
affected?

Also, once the commits have hit upstream feel free bounce them to 
stable@kernel.org - they dont have Cc: <stable@kernel.org> tags for 
automatic back-merging requests. The fixes narrowly missed v2.6.31.

	Ingo
