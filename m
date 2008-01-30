Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYA3O2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYA3O2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763455AbYA3O2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:28:31 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:42696 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763430AbYA3O23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:28:29 -0500
Date: Wed, 30 Jan 2008 09:28:19 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 02/22 -v7] Add basic support for gcc profiler instrumentation
In-Reply-To: <Pine.LNX.4.58.0801300845180.29020@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.58.0801300921020.29020@gandalf.stny.rr.com>
References: <20080130031521.258552785@goodmis.org> <20080130031840.337019504@goodmis.org>
 <47A079BD.8020106@siemens.com> <Pine.LNX.4.58.0801300845180.29020@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 30 Jan 2008, Steven Rostedt wrote:
> well, actually, I disagree. I only set mcount_enabled=1 when I'm about to
> test something. You're right that we want the impact of the test least
> affected, but when we have mcount_enabled=1 we usually also have a
> function that's attached and in that case this change is negligible. But
> on the normal case where mcount_enabled=0, this change may have a bigger
> impact.
>
> Remember CONFIG_MCOUNT=y && mcount_enabled=0 is (15% overhead)
>          CONFIG_MCOUNT=y && mcount_enabled=1 dummy func (49% overhead)
>          CONFIG_MCOUNT=y && mcount_enabled=1 trace func (500% overhead)
>
> The trace func is the one that will be most likely used when analyzing. It
> gives hackbench a 500% overhead, so I'm expecting this change to be
> negligible in that case. But after I find what's wrong, I like to rebuild
> the kernel without rebooting so I like to have mcount_enabled=0 have the
> smallest impact ;-)
>
> I'll put back the original code and run some new numbers.

I just ran with the original version of that test (on x86_64, the same box
as the previous tests were done, with the same kernel and config except
for this change)

Here's the numbers with the new design (the one that was used in this
patch):

mcount disabled:
 Avg: 4.8638 (15.934498% overhead)

mcount enabled:
 Avg: 6.2819 (49.736610% overhead)

function tracing:
 Avg: 25.2035 (500.755607% overhead)

Now changing the code to:

ENTRY(mcount)
        /* likely(mcount_enabled) */
        cmpl $0, mcount_enabled
        jz out

        /* taken from glibc */
        subq $0x38, %rsp
        movq %rax, (%rsp)
        movq %rcx, 8(%rsp)
        movq %rdx, 16(%rsp)
        movq %rsi, 24(%rsp)
        movq %rdi, 32(%rsp)
        movq %r8, 40(%rsp)
        movq %r9, 48(%rsp)

        movq 0x38(%rsp), %rsi
        movq 8(%rbp), %rdi

        call   *mcount_trace_function

        movq 48(%rsp), %r9
        movq 40(%rsp), %r8
        movq 32(%rsp), %rdi
        movq 24(%rsp), %rsi
        movq 16(%rsp), %rdx
        movq 8(%rsp), %rcx
        movq (%rsp), %rax
        addq $0x38, %rsp

out:
        retq


mcount disabled:
 Avg: 4.908 (16.988058% overhead)

mcount enabled:
 Avg: 6.244. (48.840369% overhead)

function tracing:
 Avg: 25.1963 (500.583987% overhead)


The change seems to cause a 1% overhead difference. With mcount disabled,
the newer code has a 1% performance benefit. With mcount enabled as well
as with tracing on, the old code has the 1% benefit.

But 1% has a bigger impact on something that is 15% than it does on
something that is 48% or 500%, so I'm keeping the newer version.

-- Steve

