Return-Path: <linux-kernel-owner+w=401wt.eu-S933904AbZFOUbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbZFOUbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934013AbZFOUaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:30:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933919AbZFOUao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:30:44 -0400
Date: Mon, 15 Jun 2009 22:30:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615203007.GA21657@elte.hu>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain> <20090615194344.GA12554@elte.hu> <alpine.LFD.2.01.0906151302200.6276@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906151302200.6276@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 15 Jun 2009, Ingo Molnar wrote:
> > 
> > Well i guess it depends. For server apps it is true - syscalls are a 
> > lot more dominant, MMs are long-running so any startup cost gets 
> > amortized and pagefaults are avoided.
> > 
> > For something like a kernel build we have 7 times as many pagefaults 
> > as syscalls:
> 
> Ingo - calm down.
> 
> This is not about page faults.
> 
> This is purely about taps FROM KERNEL SPACE.
> 
> Yes, for the kernel build we have 7 times as many page faults as 
> system calls, BUT I BET 99.9% of them are from user mode!
> 
> The whole "open-code iret" only works for exceptions that happened 
> in kernel mode. That's a _vanishingly_ small number (outside of 
> device interrupts that happen during idle).

Ah, i misunderstood you, sorry. Yes, you are right.

Btw., we can have a precise number - we can sample all pagefaults 
via a soft-counter:

$ perf record -e page-faults -c 1 -f -m 512 -- make -j32

 [ perf record: Captured and wrote 783.697 MB perf.data (~34240256 samples) ]

#
# (33858154 samples)
#
# Overhead  Symbol
# ........  ......
#
    41.62%  [.] memset
    18.21%  0x007fff07bff634
     5.85%  [.] __GI_memcpy
     5.35%  [.] parse_config_file
     4.34%  [.] _int_malloc
     1.24%  0x0000000000dc90
     1.14%  [k] file_read_actor
     1.10%  [.] _dl_addr
     0.64%  [.] __GI_strlen
     0.47%  [.] _dl_load_cache_lookup
     0.43%  [.] _dl_cache_libcmp

(i dont have debuginfo installed for that gcc build, hence that raw 
entry.)

Kernel triggered pagefaults:

 $ perf report -s s | grep '\[k\]'

     1.14%  [k] file_read_actor
     0.15%  [k] __clear_user
     0.12%  [k] strncpy_from_user
     0.12%  [k] copy_user_generic_string
     0.04%  [k] __put_user_4
     0.04%  [k] pipe_read
     0.02%  [k] load_elf_binary
     0.00%  [k] do_notify_resume
     0.00%  [k] iov_iter_fault_in_readable

so 1.7% of the pagefaults are kernel-initiated - 98.3% via 
user-space. Your 99.9% figure was within 1.6% of the real number :-)

	Ingo
