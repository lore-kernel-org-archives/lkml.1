Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbYLMSj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbYLMSj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 13:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYLMSjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 13:39:20 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:45419 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYLMSjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 13:39:19 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 13 Dec 2008 10:39:13 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Scott James Remnant <scott@netsplit.com>
cc: Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] waitfd: file descriptor to wait on child processes
In-Reply-To: <1229157789.6128.0.camel@warcraft>
Message-ID: <alpine.DEB.1.10.0812131026120.28976@alien.or.mcafeemobile.com>
References: <493EA441.1070706@redhat.com>  <alpine.DEB.1.10.0812091127160.17144@alien.or.mcafeemobile.com>  <1229124491.12618.5.camel@warcraft>  <alpine.DEB.1.10.0812122025180.27751@alien.or.mcafeemobile.com> <1229157789.6128.0.camel@warcraft>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008, Scott James Remnant wrote:

> On Fri, 2008-12-12 at 20:29 -0800, Davide Libenzi wrote:
> 
> > And how about this?
> > 
> > 	sfd = signalfd(SIGCHLD);
> > 
> > 	for (;;) {
> > 		poll(sfd, POLLIN);
> > 		while ((pid = waitpid(0, &status, WNOHANG)) != -1)
> > 			process_child_death(pid);
> > 	}
> > 
> At this point, why have signalfd()'s read() return siginfo_t at all?
> 
> You have to discard the entire information since it's only ever the
> first signal that matched, all subsequent ones are thrown away.

Signalfd is a wakeup gate available to the poll/select/epoll subsystems.
Signals that are queued inside the kernel, get de-queueing behavior, while 
signals that are overlapping, get overlapping behavior.
The code above enable you to wait for signals inside a poll/select/epoll 
dispatch loop, and get all the info waitpid() can return to you - w/out 
missing anything.
In a real app case, you're probably waiting for more than simple SIGCHLD, 
so you likely will have one (or more) read(2) of the signalfd to find out 
which signal you got, and do the waitpid(WNOHANG) loop in case of SIGCHLD.



- Davide


