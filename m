Return-Path: <linux-kernel-owner+w=401wt.eu-S934281AbXFFDw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934281AbXFFDw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 23:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765433AbXFFDwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 23:52:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:37448 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765329AbXFFDwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 23:52:20 -0400
Subject: Re: signalfd API issues (was Re: [PATCH/RFC] signal races/bugs,
	losing TIF_SIGPENDING and other woes)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <Pine.LNX.4.64.0706052022430.23673@alien.or.mcafeemobile.com>
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
Content-Type: text/plain
Date: Wed, 06 Jun 2007 13:52:00 +1000
Message-Id: <1181101920.31677.172.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That'd be a limitation. Like you can choose to not handle SEGV, you can 
> choose to have a signalfd listening to it. Of course, not with the 
> intention to *handle* the signal, but with a notification intent.

Hrm.. either you handle it or you are dead ... I fail to see how
signalfd can sneak in to catch it just at the right time...

> > I'm actually thinking we shoud -also- only handle shared signals in
> > dequeue_signal() when called from a different task.
> 
> Why do you want to impose this? signalfd is a "sniffer", and the user 
> controls what it can dequeue/sniff or what not. I don't see a reason of 
> imposing such limits, unless there're clear technical issues.

Well, a synchronous signal such a SIGSEGV, SIGILL or SIGFPE generally
means that execution cannot continue unless the signal handler does
something about it...

I think you are opening a whole can of worms here.

> > Well.. you certainly need to instanciate a signalfd for every thread in
> > the process if you want to get shared signals for sure.
> 
> Why? Or better, what do you mean for "instanciate"?

Well, because the kernel makes the decision of which thread to target
the signal for a shared signal at emission time (though it -can- be
caught by another thread).

/me reads more code to be sure..

Oh well, a read from signalfd created on one thread -will- catch any
shared signal that was already pending, whatever thread the kernel
decided to target it at, it seems (that is, whatever thread actually got
TIF_SIGPENDING set), but will only catch private signals for _that_
thread (and I still think catching private signals is a wrong thing).

However, I'm not sure about the wakeup condition. signalfd_deliver will
wakeup anybody in the signalfd_list, which is -not- whoever is blocked
in signalfd_read() unless I'm missing something.

For your scheme to work, signalfd_read() you probably need to keep a
separate list of people to be nofified of signals and add current to it
from signalfd_list().

Ben.


