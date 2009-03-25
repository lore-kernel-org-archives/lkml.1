Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbZCYL2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbZCYL2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbZCYL1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:27:52 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:58899 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbZCYL1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:27:50 -0400
Date: Wed, 25 Mar 2009 12:27:38 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
Message-ID: <20090325122738.42d105b7@skybase>
In-Reply-To: <49C8FAC4.6060508@kernel.org>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
 <20090316190132.7965a49a@skybase>
 <49C300D8.5080204@kernel.org>
 <49C8FAC4.6060508@kernel.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 00:22:44 +0900
Tejun Heo <tj@kernel.org> wrote:

> Tejun Heo wrote:
> > Hello, Martin.
> > 
> > Sorry about the delay.

Yes, dito..

> > Martin Schwidefsky wrote:
> >> We do have a problem with #2, the dynamic percpu patches currently
> >> breaks s390. But the nice thing is that we can now get rid of the GOTENT
> >> relocation for the percpu symbols. If the code is changed to use
> >> RELOC_HIDE for the SHIFT_PERCPU_PTR define, everything works just fine.
> >> Patch attached. Nice works guys.
> >>
> >> Subject: [PATCH] s390: percpu access.
> >>
> >> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> >>
> >> With the dynamic percpu allocator there is no need anymore to play
> >> tricks with the GOTENT relocation for the access to the percpu
> >> symbols. A simple RELOC_HIDE gets the job done.
> > 
> > Hmm... I don't quite get it.  The GOTENT was to work around large
> > offsets for modules, right?  Can you please explain what changed by
> > the dynamic percpu allocator?

Unfortunately it didn't change. The problem is still there, only with
my particular configuration (and the correct patch) the system did
work because the problematic modules were not in use. But in general it
won't work.

The reason for the GOTENT indirection are static per-cpu variables that
are defined inside a module. The compiler considers these to be local.
For locally defined per_cpu__#var symbols the compiler uses an
instruction that is limited to the scope of a single object, which is
+-4 GB. The trick with GOTENT introduced an indirection which hid the
problem.

Without the GOTENT indirection the access to a static per cpu variable
will look like this:

0000000000000000 <test_fn>:
   0:   e3 30 03 30 00 04       lg      %r3,816
   6:   c0 10 00 00 00 00       larl    %r1,6 <test_fn+0x6>
                        8: R_390_PC32DBL        .data.percpu+0x2
   c:   e3 23 10 00 00 04       lg      %r2,0(%r3,%r1)

The R_390_PC32DBL relocation in the module relocation will fail if the
per-cpu area is farther than 4GB away from the vmalloc area.

With your patches and a RELOC_HIDE version that uses the GOTENT
indirection the kernel won't compile because the "X" constraint for
the GOTENT access needs a symbol and there are quite a few users that
pass a pointer. I do not see a simple solution for that problem yet.

> >> +#define SHIFT_PERCPU_PTR(var, offset) RELOC_HIDE(&per_cpu_var(var), (offset))
> > 
> > Hmm... @var already has per_cpu__ prefix when the above macro is
> > invoked, so doing per_cpu_var() on it again wouldn't work.  If simple
> > RELOC_HIDE works, you should be able to simply drop the above
> > definition.  The generic percpu.h will define it.

That is true, in my working version of the oatch the second
per_cpu_var() wasn't there.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

