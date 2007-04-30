Return-Path: <linux-kernel-owner+w=401wt.eu-S1422963AbXD3ECg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422963AbXD3ECg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 00:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422947AbXD3ECg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 00:02:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965085AbXD3ECc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 00:02:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Christoph Hellwig <hch@lst.de>
X-Fcc: ~/Mail/utrace
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utrace: remove indirections
In-Reply-To: Christoph Hellwig's message of  Wednesday, 18 April 2007 20:03:32 +0200 <20070418180332.GB18485@lst.de>
Emacs: because one operating system isn't enough.
Message-Id: <20070430040226.1A4AF1801A4@magilla.sf.frob.com>
Date: Sun, 29 Apr 2007 21:02:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am not in favor of this change.

Previously you said:

> 	This shows very nicely why the tracehooks vs utrace abstraction
> 	is utter madness.  Every tracehook 'abstraction' just conatains
> 	an ifdef block.  Just kill CONFIG_UTRACE as there is no point
> 	in making this functionality conditional an opencode the
> 	utrace functionality at the callers (or add a utrace_ helper
> 	for the few cases where it makes sense)

Since then I have gotten rid of the #ifdef's there so it is easier on the
eyes.  But that is not the crux of the issue.

> Currently generic code calls into tracehook_* which then alls into
> utrace_* to do the actual work.  With utrace as the new singing dancing
> framework there's little point in that, and readability would be greatly
> improved by getting rid of this.  The few places where tracehook_*
> was more than a one-liner and used in multiple places in arch code
> I renamed the call to utrace_*.

I've never meant to claim that tracehook is, or should be, an abstraction
layer in the sense of multiplexing across different implementations
simultaneously.  It's always been intended to compile away completely.
The purpose of the tracehook layer is to be "abstract" in the sense that
it is all that any other kernel code should need to know about the
tracing infrastructure.  I believe it helps readability, not of
tracehook.h, but of the rest of the kernel, and maintainability too.

The first phase of my work, and an arduous one, was to untangle and
document all the interwinings of the old ptrace implementation with core
code and the implicit assumptions between them.  utrace-tracehook.patch
is the product of this work.  Noone should ever have to deal with that
again.  Now, when someone is modifying kernel code and stumbles across a
tracehook_* call, there is a single obvious place to go looking for what
that's about.  Each call's documentation in tracehook.h gives explicit
details about the expectations of the call, including locking conditions
and so forth.  Someone modifying those documented expectations, e.g. by
changing the locking calls in the surrounding core code, knows that this
tracehook call has to be updated to resolve the conflict, and will ask
around for the right people to update the tracing infrastructure to match
the new core code.  All the while, this poor kernel hacker was never
required to think about utrace and what its implementation might need.
(People who don't care what utrace is, shouldn't have to find out.
People who didn't care what ptrace was, knew they were supposed to be afraid.)

Certainly the benefits of simple entry points from core code whose
expectations of their callers are thoroughly documented can be retained
with everything named utrace_* and tracehook.h removed.  In either event,
keeping all the entry points clean and their documentation complete and
correct requires continuous diligent maintenance effort.  Nonetheless, I
do believe the separation helps.  Those only interested in what they must
avoid breaking incidentally have something simple to contend with in
tracehook.h, rather than feeling obliged to digest utrace.txt and
utrace.h to get up to speed.  It may turn out that utrace is no good, or
winds up being drastically different (at the least, maybe I'll think of a
decent name for something, for a change).  In any event, the set of
tracehook entry points is unlikely to change very much, and new work
won't need to touch core code all over the kernel to change the tracing
infrastructure completely.

> Also kill the CONFIG_UTRACE config option, there's very little reason
> in not having a core debugging mechanisms, and this allows to get rid
> of another layer of wrapping again.

I spend most of my time debugging, so a configuration with fewer
debugging facilities rather than more is somewhat hypothetical to me
personally too.  But I don't buy the rationale for not making this
configurable.  CONFIG_PROC_FS can be turned off, and I dare say /proc is
used by more people more often, for what they would broadly term
debugging, than is ptrace.  If someone builds a special-purpose
configuration for a fixed installation that has no way to attach any kind
of debugger, then why should they have to compile in more dead code?
Moreover, it's a good test that the interfaces between core code and the
tracing infrastructure remain simple and clean that you can build a
working kernel without it.


Thanks,
Roland

