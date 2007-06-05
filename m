Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbXFEGRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbXFEGRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 02:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760032AbXFEGRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 02:17:23 -0400
Received: from alnrmhc15.comcast.net ([204.127.225.95]:48025 "EHLO
	alnrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbXFEGRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 02:17:23 -0400
Subject: Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other
	woes
From: Nicholas Miell <nmiell@comcast.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1181013756.31677.123.camel@localhost.localdomain>
References: <1181006711.31677.97.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org>
	 <1181009413.31677.117.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0706041935230.30836@alien.or.mcafeemobile.com>
	 <1181013756.31677.123.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 04 Jun 2007 23:09:47 -0700
Message-Id: <1181023787.2785.14.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 13:22 +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2007-06-04 at 19:38 -0700, Davide Libenzi wrote:
> > >  - I still think there's something wrong with dequeue_signal() being
> > > potentially called with a task different than current by signalfd, since
> > > __dequeue_signal() (among others) mucks around with current regardless.
> > > I'd love to just make signalfd's read() only do anything if current ==
> > > ctx->tsk and remove the task argument from dequeue_signal... that would
> > > fix it nicely too no ?
> > 
> > There's got to be a clean solution that does not limit signalfd, no? I 
> > have no time to look at it immediately, but I can look into it in the 
> > next few days, if someone else does not do it before...
> 
> Is there a real usage to dequeuing somebody else signals with signalfd ?
> If yes, then we can do something around the lines of passing task down
> to __dequeue_signal, though I'm not too sure waht this notifier is about
> and wether it might rely on being called from within the affected task
> context...
> 
> Ben.
> 

signalfd() doesn't deliver thread-targeted signals to the wrong threads,
does it?

Hmm.

It looks like reading from a signalfd will give you either
process-global signals or the thread-specific signals that are targeted
towards the thread that originally created the signalfd (regardless of
which thread actually calls read()).

Which is weird, to say the least. Definitely needs to be noted in the
man page, which doesn't seem to exist yet.

Is there a reason why signalfd() doesn't behave like regular signals in
this regard?

-- 
Nicholas Miell <nmiell@comcast.net>

