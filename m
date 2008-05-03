Return-Path: <linux-kernel-owner+w=401wt.eu-S932904AbYECBoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbYECBoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 21:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759746AbYECBoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 21:44:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759690AbYECBoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 21:44:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Markus Metzger <markus.t.metzger@intel.com>
X-Fcc: ~/Mail/linus
Cc: andi-suse@firstfloor.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com, eranian@googlemail.com, juan.villacis@intel.com
Subject: Re: [patch] x86, ptrace: in-kernel BTS interface
In-Reply-To: Markus Metzger's message of  Wednesday, 30 April 2008 13:54:40 +0200 <20080430135440.A359@sedona.ch.intel.com>
References: <20080430135440.A359@sedona.ch.intel.com>
Emacs: where editing text is like playing Paganini on a glass harmonica.
Message-Id: <20080503014342.3882226FA07@magilla.localdomain>
Date: Fri,  2 May 2008 18:43:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are various nits to fix, some of which Andi mentioned.
I'll just mention a couple of those and look closer on the next round.

For the configured-out cases, don't make e.g. ds_init_intel() a macro.
Make it a static inline with an empty body.  This follows the rule of,
"Don't make it a macro unless you have to," and in specific it ensures that
callers' get argument type checking in all configurations (reduces future
bit rot potential).

Any #ifdef CONFIG_* in a user-visible header (outside #ifdef __KERNEL__)
is wrong.  Users don't have those definitions.  If you are defining
user-visible ABI bits, they have to be unconditional.

Now, on more substantive concerns.  This is heading in the right general
direction, to having a well-specified internal interface to build from.

      * Not all processors support all variants.
      * If a variant is not supported, the respective flag is ignored.
      ...
     #define BTS_O_TRACE	(1<<0)	/* record branch trace */
     #define BTS_O_TIMESTAMP	(1<<1)	/* record scheduling timestamps */
     #define BTS_O_USER_OFF	(1<<2)	/* do not trace user mode */
     #define BTS_O_KERNEL_OFF	(1<<3)	/* do not trace kernel mode */

The three +-- flags are not the natural interface (even if that is what the
hardware bits look like).  Just have two bits: trace kernel branches, trace
user branches.  Also, the style of silently ignoring flags is generally
bad.  I recognize that you have bts_status() to tell what took.  But still,
it's awkward.  In this case I don't think we need to worry about interface
details for what's not supported, because we can just expose a consistent
interface on all the hardware.

Since we are already transcribing each BTS entry into the ABI form anyway,
it's easy to weed out the ones for the wrong mode along the way.  We can
distinguish user from kernel entries with ip < TASK_SIZE.  So what I'd do
is code it that way and make it work with ignoring the unwanted entries in
software.  Then, add the support for ds_cpl hardware to let the CPU do it,
but that is just an optimization that doesn't change the interface.

This relates to the major thing I find missing in the interface:
multiplexing.  I'd like to support an in-kernel global tracing request
at the same time as a user-mode request for tracing on an individual
task.  In fact, all permutations and multiple of each.  For the
in-kernel interface, I'd like to see an interface to request a new
"tracing context" that can be one task or global and kernel-only or
user-only or both.  The hardware setup is to trace the union of all
those requests for the current task plus all the global requests.  When
delivering samples from the buffer, we sort them out to who wants to see
what.  It seems pretty straightforward.  The main thing is deciding how
big a buffer to use.

For global tracing simultaneous with per-task tracing, there are two
ways to go.  You can use a single hardware buffer and just write markers
into it at context switch time to distinguish which task each stretch of
entries was in.  Or you can switch buffers on context switch, and then
collecting global samples means collecting samples from every task
buffer that's been active since last collection, plus a global buffer
that's switched in for any task that doesn't have anyone doing per-task
tracing.

The implementation of all that would go in the bts.c layer.
Now, a few things about the ds.c layer.

I don't think ds_request should do the buffer allocation, just the
ds_context.  This keeps the DS layer just what it has to be: programming
and switching the DS MSR and managing the ds_context for one BTS caller
and one PEBS caller to cooperate.  The caller can supply the BTS/PEBS
buffer address and be responsible for meeting the requirements: it has
to be wired and in kernel address space, and aligned (the manual
recommends cacheline-aligned, so might as well make that the interface
requirement) and not odd-sized.

What is ds_validate_access for?  I don't think this level of code should
be thinking about concepts like permission at all.  What the current
task is making the calls into the ds.c layer should not matter.  It's
the job of higher-level code to decide if this is a proper thing to be
doing.


Thanks,
Roland
