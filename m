Return-Path: <linux-kernel-owner+w=401wt.eu-S1751805AbYLWOeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbYLWOeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 09:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbYLWOeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 09:34:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46965 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYLWOeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 09:34:03 -0500
Date: Tue, 23 Dec 2008 15:33:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Hugh Dickins <hugh@veritas.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: linux-next: parsing mem=700M broken
Message-ID: <20081223143327.GF29151@elte.hu>
References: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils> <86802c440812222152yd000009yf890f5cd303860e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440812222152yd000009yf890f5cd303860e4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Mon, Dec 22, 2008 at 7:06 PM, Hugh Dickins <hugh@veritas.com> wrote:
> > Hi Rusty,
> >
> > I find that bootparam "mem=700M" isn't working in linux-next or mmotm,
> > and have bisected it down to your patch below; but now I'm off to bed
> > without working out just what goes wrong (I'll bet it's the "=").
> >
> > Hugh
> >
> > commit 5c886584a758edba7e25ad9df974cf15a4a1f59d
> > Author: Rusty Russell <rusty@rustcorp.com.au>
> > Date:   Wed Dec 3 13:34:34 2008 +1030
> >
> >    Call early_param earlier.
> >
> >    We delete all the arch calls: we call it from start_kernel earlier
> >    now.  We also no longer take a temporary copy, but parse in place.
> >
> >    Note: IA64 needs to parse "machvec=" before other commandline options
> >    but machvec_init_from_cmdline() needs efi_init() and io_port_init(),
> >    so they are all moved into arch_get_boot_command_line().
> >
> 
> yeah, you are right.
> 
> static int __init parse_memopt(char *p)
> {
>         u64 mem_size;
> 
>         if (!p)
>                 return -EINVAL;
> 
> #ifdef CONFIG_X86_32
>         if (!strcmp(p, "nopentium")) {
>                 setup_clear_cpu_cap(X86_FEATURE_PSE);
>                 return 0;
>         }
> #endif
> 
>         userdef = 1;
>         mem_size = memparse(p, &p);
>         e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
> 
>         return 0;
> }
> early_param("mem", parse_memopt);
> 
> 
> in x86 we use that param analyser much later ( after we check the e820 
> table..)
> 
> other cpu flag will be overwrite too..
> 
> anyway, this patch is not go through x86 tip..., some strange!

the x86 impact is incidental:

 arch/avr32/kernel/setup.c   |    2 --
 arch/ia64/kernel/setup.c    |   18 ++++++++----------
 arch/m68k/kernel/setup.c    |    2 --
 arch/mips/kernel/setup.c    |    2 --
 arch/powerpc/kernel/prom.c  |    1 -
 arch/s390/kernel/setup.c    |    2 --
 arch/sh/kernel/setup.c      |    2 --
 arch/sparc/kernel/setup.c   |    3 ---
 arch/sparc64/kernel/setup.c |    3 ---
 arch/x86/kernel/setup.c     |    3 ---
 include/linux/init.h        |    2 --
 init/main.c                 |   21 ++++-----------------
 12 files changed, 12 insertions(+), 49 deletions(-)

we generally do not require patches to go via the x86 tree that just 
happen to touch it with the intention of not breaking anything.

Rusty, will you fix or revert it?

	Ingo
