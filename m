Return-Path: <linux-kernel-owner+w=401wt.eu-S1422769AbXCWKPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422769AbXCWKPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 06:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422778AbXCWKPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 06:15:38 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54055 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422769AbXCWKPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 06:15:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <hansendc@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       menage@google.com, Andrew Morton <akpm@linux-foundation.org>,
       xemul@sw.ru
Subject: Re: controlling mmap()'d vs read/write() pages
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	<20070306140036.4e85bd2f.akpm@linux-foundation.org>
	<45F3F581.9030503@sw.ru>
	<20070311045111.62d3e9f9.akpm@linux-foundation.org>
	<20070312010039.GC21861@MAIL.13thfloor.at>
	<1173724979.11945.103.camel@localhost.localdomain>
	<20070312224129.GC21258@MAIL.13thfloor.at>
	<20070312220439.677b4787.akpm@linux-foundation.org>
	<1173806793.6680.44.camel@localhost.localdomain>
	<20070313190931.1417c012@lxorguk.ukuu.org.uk>
	<m1mz2enh0u.fsf@ebiederm.dsl.xmission.com>
	<1174062660.8184.8.camel@localhost.localdomain>
	<m1tzwlm33i.fsf@ebiederm.dsl.xmission.com>
	<1174074412.8184.29.camel@localhost.localdomain>
	<m1zm6ajvns.fsf@ebiederm.dsl.xmission.com>
	<1174407335.26166.146.camel@localhost.localdomain>
	<m13b3zmx4b.fsf@ebiederm.dsl.xmission.com>
	<46036C54.6030502@yahoo.com.au>
Date: Fri, 23 Mar 2007 04:12:09 -0600
In-Reply-To: <46036C54.6030502@yahoo.com.au> (Nick Piggin's message of "Fri,
	23 Mar 2007 16:57:40 +1100")
Message-ID: <m1tzwc5kw6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> Eric W. Biederman wrote:
>> Dave Hansen <hansendc@us.ibm.com> writes:
>>
>>
>>>So, I think we have a difference of opinion.  I think it's _all_ about
>>>memory pressure, and you think it is _not_ about accounting for memory
>>>pressure. :)  Perhaps we mean different things, but we appear to
>>>disagree greatly on the surface.
>>
>>
>> I think it is about preventing a badly behaved container from having a
>> significant effect on the rest of the system, and in particular other
>> containers on the system.
>
> That's Dave's point, I believe. Limiting mapped memory may be
> mostly OK for well behaved applications, but it doesn't do anything
> to stop bad ones from effectively DoSing the system or ruining any
> guarantees you might proclaim (not that hard guarantees are always
> possible without using virtualisation anyway).
>
> This is why I'm surprised at efforts that go to such great lengths
> to get accounting "just right" (but only for mmaped memory). You
> may as well not even bother, IMO.
>
> Give me an RSS limit big enough to run a couple of system calls and
> a loop...

Would any of them work on a system on which every filesystem was on
ramfs, and there was no swap?  If not then they are not memory attacks
but I/O attacks.

I completely concede that you can DOS the system with I/O if that is
not limited as well.

My point is that is not a memory problem but a disk I/O problem which is
much easier to and cheaper to solve.  Disk I/O is fundamentally a slow
path which makes it hard to modify it in a way that negatively affects
system performance.

I don't think with a memory RSS limit you can DOS the system in a way
that is purely about memory.  You have to pick a different kind of DOS
attack.

As for virtualization that is what a kernel is about virtualizing it's
resources so you can have multiple users accessing them at the same
time.  You don't need some hypervisor or virtual machine to give you
that.  That is where we start.  However it was found long ago that
global optimizations give better system through put then the rigid
systems you can get with hypervisors.  Although things are not
quite as deterministic when you optimize globally.  They should be
sufficiently deterministic you can avoid the worst of the DOS
attacks.

The real practical problem with the current system is that nearly
all of our limits are per process and applications now span more than
one process so the limits provided by linux are generally useless
to limit real world applications.  This isn't generally a problem
until we start trying to run multiple applications on the same system
because the hardware is so powerful.  Which the namespace work which
will allow you to run several different instances of user space
simultaneously is likely to allow.

At the moment I very much in a position of doing review not
implementing this part of it.  I'm trying to get the people doing the
implementation to make certain they have actually been paying
attention to how their proposed limits will interact with the rest of
the system.  So far generally the conversation has centered on memory
limits because it seems that is where people have decided the
conversation should focus.  What I haven't seen is people with the
limitations coming back to me tearing my arguments apart and showing
or telling me where I'm confused.  In general I can challenge even the
simplest things and not get a good response.  All of which tells me
the implementations are not ready.

I do have some practical use cases and I have some clue how these
subsystems work, and I do care.   Which puts in a decent position to
at least to high level design review.

My biggest disappointment is that none of this is new, and that we
seem to have forgotten a lot of the lessons of the past.

Eric
