Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189Ab0AYBmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab0AYBmf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 20:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795Ab0AYBme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 20:42:34 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:37360 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0AYBmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 20:42:33 -0500
MIME-Version: 1.0
In-Reply-To: <20100123194820.GM21263@thunk.org>
References: <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> 
	<20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> 
	<20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> 
	<alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> 
	<f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> 
	<20100123112333.GA15455@elte.hu> <20100123114729.GA7828@redhat.com> 
	<20100123194820.GM21263@thunk.org>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sun, 24 Jan 2010 20:42:13 -0500
Message-ID: <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com>
Subject: Re: linux-next: add utrace tree
To: tytso@mit.edu, "Frank Ch. Eigler" <fche@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Kyle Moffett <kyle@moffetthome.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 14:48,  <tytso@mit.edu> wrote:
> The fundamental issue which Ingo is trying to say (and which you
> apparently don't seem to be understanding) is that utrace doesn't
> export a syscall (which is an ABI that we are willing to promise will
> be stable), but rather a set of kernel API's (which we never promise
> to be stable),

The point that's being missed is that there is a chicken-and-egg
problem here.  The "chicken" is a replacement or extension to the
debugger interface that would make it possible for me to do things
like GDB a process while it's being strace'd or vice versa.  The "egg"
is the "utrace" bits, an unstable but somewhat arch-generic ABI that
abstracts out ptrace() to make it possible to stack both in-kernel and
userspace debuggers/tracers/etc and have multiple simultaneous users.

> and the fact that there will be out-of-tree programs
> that are going to be trying to depend on that interface (much like
> Systemtap does today when it creates kernel modules) is something that
> is considered on par with Nvidia trying to ship proprietary video
> drivers.

Ugh... perhaps we should derive a variation of Godwin's law for this:

"As an LKML discussion grows longer, the probability of an unfavorable
comparison involving nVidia or Microsoft approaches 1."


> If you want to try to slide utrace in, such that we're able to ignore
> the fact that there will be this external house that will be built on
> quicksand, pointing at how nice the external house will be isn't going
> to be helpful.  Nor is pointing at the ability that other people will
> be able to build other really nice houses on the aforementioned
> quicksand (i.e., out-of-tree kernel modules that depend on kernel
> API's).

Personally I don't give a flying **** about SystemTap; I'm interested
in things like the ability to stack gdb with strace, the RFC gdb-stub
posted a week ago, etc.  None of those abilities would be out-of-tree
modules at all, and therefore the "quicksand" analogy is specious.


> A simple "code cleanup" argument is not carrying the day (Look!  We
> can cleanup the ptree code!).  It's going to have to be a **really**
> cool in-tree kernel funtionality that provides a killer feature (in
> Linus's words), enough so that people are willing to overlook the fact
> that there's this monster external out-of-tree project that wants to
> be depend on API's that may not be stable, and which, even if the
> developers don't grump at us, users will grump at us when we change
> API's that we had never guaranteed will be stable, and then Systemtap
> breaks.

I would be willing to guess that something like 95% of the people
using SystemTap or other tools are doing so on Red Hat Enterprise
Linux or other enterprise supported platforms, and so when something
breaks they go whinge at Red Hat, etc.  If I recall correctly Red Hat
and many of the other vendors already heavily fiddle with kernel
patches they apply to provide some amount of binary module
compatibility.


> This is probably why Ingo invited you to think about ways of doing
> some kind of safe in-kernel bytecode approach.  That has the advantage
> of doing away with external kernel modules, with all of their many
> downsides: its dependency on unstable kernel API's, the fact that many
> financial customers have security policies that prohibit C compilers
> on production machines, the inherent security risk of allowing
> external random kernel modules to be delivered and loaded into a
> system, etc.

There are substantial non-SystemTap uses for utrace that would *not*
be satisfied by an "in-kernel bytecode approach", starting with
stacking debuggers and tracers.  Furthermore, let's say they did go
off and build the in-kernel bytecode interpreter.  I can pretty much
guarantee that people would say the hooks into the rest of the kernel
are too invasive and they should be abstracted out into an API.  *This
is that API!*

Cheers,
Kyle Moffett
