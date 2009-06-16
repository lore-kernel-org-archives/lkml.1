Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbZFPIeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbZFPIeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZFPIeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:34:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51161 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbZFPIeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:34:06 -0400
Date: Tue, 16 Jun 2009 10:33:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090616083343.GD16229@elte.hu>
References: <20090615211605.GC27100@elte.hu> <20090615213429.GD12919@Krystal> <4A36BF61.10901@zytor.com> <20090615215420.GE12919@Krystal> <4A36C953.8060906@zytor.com> <20090615223038.GA15903@Krystal> <4A36CCFC.8070908@zytor.com> <20090615224908.GA16661@Krystal> <4A36F520.6020604@zytor.com> <20090616030522.GA22162@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616030522.GA22162@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> I am not asking for the pf handler to handle every possible kind 
> of fault recursively. Just to keep the in-kernel page fault 
> related code for vmalloc (and possibly for prefetch ?) paths 
> NMI-reentrant :
> 
> void do_page_fault(struct pt_regs *regs, unsigned long error_code)
> 
>   address = read_cr2();

Why would this be needed? We read the cr2 as the first thing in 
do_page_fault(). It can be destroyed and re-faulted at will after 
that point, it wont matter a bit - we have already read it.

The only window to be careful about wrt. cr2 is the small window 
starting at <page_fault>, leading into <do_page_fault>:

ffffffff8154085f <do_page_fault>:
ffffffff8154085f:	55                   	push   %rbp
ffffffff81540860:	48 89 e5             	mov    %rsp,%rbp
ffffffff81540863:	41 57                	push   %r15
ffffffff81540865:	41 56                	push   %r14
ffffffff81540867:	49 89 f6             	mov    %rsi,%r14
ffffffff8154086a:	41 55                	push   %r13
ffffffff8154086c:	49 89 fd             	mov    %rdi,%r13
ffffffff8154086f:	41 54                	push   %r12
ffffffff81540871:	53                   	push   %rbx
ffffffff81540872:	48 83 ec 18          	sub    $0x18,%rsp
ffffffff81540876:	65 4c 8b 3c 25 00 b0 	mov    %gs:0xb000,%r15
ffffffff8154087d:	00 00 
ffffffff8154087f:	49 8b 87 48 02 00 00 	mov    0x248(%r15),%rax
ffffffff81540886:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
ffffffff8154088a:	48 83 c0 60          	add    $0x60,%rax
ffffffff8154088e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
ffffffff81540892:	0f 18 08             	prefetcht0 (%rax)
ffffffff81540895:	41 0f 20 d4          	mov    %cr2,%r12

Look how early we read out cr2 - after trapping we read it after 
about 40 straight instructions, with no other function call 
inbetween. Only an NMI (or an MCE and similar deep-atomic contexts) 
can get in that window.

( Btw., a sidenote: the prefetcht0 right before the cr2 read is a 
  real bug. Prefetches can sometimes generate false faults and thus
  destroy the value cr2. I'll send a patch for that soon. )

	Ingo
