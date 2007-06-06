Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbXFFEIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbXFFEIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 00:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXFFEIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 00:08:44 -0400
Received: from rwcrmhc11.comcast.net ([204.127.192.81]:56369 "EHLO
	rwcrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbXFFEIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 00:08:43 -0400
Subject: Re: signalfd API issues (was Re: [PATCH/RFC] signal races/bugs,
	losing TIF_SIGPENDING and other woes)
From: Nicholas Miell <nmiell@comcast.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <alpine.LFD.0.98.0706052035410.4205@woody.linux-foundation.org>
References: <1181006711.31677.97.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org>
	 <1181009413.31677.117.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0706041935230.30836@alien.or.mcafeemobile.com>
	 <1181013756.31677.123.camel@localhost.localdomain>
	 <1181023787.2785.14.camel@entropy>
	 <1181028453.31677.127.camel@localhost.localdomain>
	 <1181087462.2788.8.camel@entropy>
	 <Pine.LNX.4.64.0706051710140.23673@alien.or.mcafeemobile.com>
	 <1181088936.2788.10.camel@entropy>
	 <Pine.LNX.4.64.0706051736120.23673@alien.or.mcafeemobile.com>
	 <1181091523.2788.28.camel@entropy>
	 <1181098204.31677.158.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0706052022430.23673@alien.or.mcafeemobile.com>
	 <alpine.LFD.0.98.0706052035410.4205@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 21:08:41 -0700
Message-Id: <1181102921.2788.57.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 20:37 -0700, Linus Torvalds wrote:
> 
> On Tue, 5 Jun 2007, Davide Libenzi wrote:
> > On Wed, 6 Jun 2007, Benjamin Herrenschmidt wrote:
> > > 
> > > Yeah, synchronous signals should probably never be delivered to another
> > > process, even via signalfd. There's no point delivering a SEGV to
> > > somebody else :-)
> > 
> > That'd be a limitation. Like you can choose to not handle SEGV, you can 
> > choose to have a signalfd listening to it. Of course, not with the 
> > intention to *handle* the signal, but with a notification intent.
> 
> I agree that it would be a limitation, but it would be a sane one.
> 
> How about we try to live with that limitation, if only to avoid the issue 
> of having the private signals being stolen by anybody else. If we actually 
> find a real-live use-case where that is bad in the future, we can re-visit 
> the issue - it's always easier to _expand_ semantics later than it is to 
> restrict them, so I think this thread is a good argument for starting it 
> out in a more restricted form before people start depending on semantics 
> that can be nasty..
> 
> 		Linus

Proposed semantics:

a) Process-global signals can be read by any thread (inside or outside
of the process receiving the signal).

Rationale:
	This should always work, so there's no reason to limit it.

b) Thread-specific signals can only be read by their target thread.

Rationale:
	This behavior is required by POSIX, and if an application is using
pthread_kill()/tkill()/tgkill()/etc. to specifically direct a signal, it
damn well better get to where the app wants it to go.

c) Synchronous signals ("Naturally" generated SIGILL, SIGFPE, SIGSEGV,
SIGBUS, and SIGTRAP. Did I miss any?) are not delivered via signalfd()
at all. (And by "naturally" generated, I mean signals that would have
the SI_KERNEL flag set.)

Rationale: 
	These are a subset of thread-specific signals, so they can only be read
from a signalfd by their target thread.

However, there's no way for the target thread to get the signal because
it is either:

a) not blocked in a syscall waiting for signal delivery and thus further
execution beyond the instruction causing the signal is impossible
 OR
b) it is blocked in a syscall waiting for signal delivery and the error
is caused by the signal delivery mechanism itself (i.e. a bad pointer
passed to read/select/poll/epoll_wait/etc.) and thus the signal can't be
delivered

-- 
Nicholas Miell <nmiell@comcast.net>

