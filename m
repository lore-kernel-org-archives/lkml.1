Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYLME3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYLME3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 23:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYLME3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 23:29:49 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:47942 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbYLME3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 23:29:49 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 12 Dec 2008 20:29:31 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Scott James Remnant <scott@netsplit.com>
cc: Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] waitfd: file descriptor to wait on child processes
In-Reply-To: <1229124491.12618.5.camel@warcraft>
Message-ID: <alpine.DEB.1.10.0812122025180.27751@alien.or.mcafeemobile.com>
References: <493EA441.1070706@redhat.com>  <alpine.DEB.1.10.0812091127160.17144@alien.or.mcafeemobile.com> <1229124491.12618.5.camel@warcraft>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008, Scott James Remnant wrote:

> On Tue, 2008-12-09 at 11:41 -0800, Davide Libenzi wrote:
> 
> > On Tue, 9 Dec 2008, Casey Dahlin wrote:
> > 
> > > Linux already has signalfd, timerfd, and eventfd to expose signals, timers,
> > > and events via a file descriptor. This patch is a working prototype for a
> > > fourth: waitfd. It pretty much does what the name suggests: reading from it
> > > yields a series of status ints (as would be written into the second argument
> > > of waitpid) for child processes that have changed state. It takes essentially
> > > the same arguments as waitpid (for now) and supports the same set of features.
> > > 
> > What's wrong in having a signalfd on SIGCHLD, than doing waitpid() once 
> > you get the signal?
> > 
> Because SIGCHLD isn't a POSIX realtime signal, only one copy of it will
> be queued at any one time -- even with signalfd(), and even though they
> have different (useful) siginfo_t.
> 
> So if you have three children die in rapid succession, you only get the
> siginfo for the first one.  Thus you still have to call
> waitid()/waitpid() in a loop, and wait on everything.
> 
> Could the fact that you don't get signalfd notification of the
> additional signals be considered a bug?  Or possibly a useful additional
> feature?
> 
> If we were able to read all the queued SIGCHLD signals with signalfd
> (preserving the one pending only behaviour of ordinary delivery), then a
> loop like the following would be possible:
> 
>   sigemptyset (&mask);
>   sigaddset (&mask, SIGCHLD);
> 
>   sfd = signalfd (-1, &mask, 0);
> 
>   for (;;) {
>     read (sfd, &fdsi, sizeof (struct signalfd_siginfo));
> 
>     waitpid (fdsi.ssi_pid, 0, 0);
>   }

And how about this?

	sfd = signalfd(SIGCHLD);
	for (;;) {
		poll(sfd, POLLIN);
		while ((pid = waitpid(0, &status, WNOHANG)) != -1)
			process_child_death(pid);
	}



- Davide


