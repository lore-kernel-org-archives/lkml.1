Return-Path: <linux-kernel-owner+w=401wt.eu-S964781AbXBEV5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781AbXBEV5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964783AbXBEV5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:57:47 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35513 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964781AbXBEV5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:57:46 -0500
Date: Mon, 5 Feb 2007 13:57:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: bert hubert <bert.hubert@netherlabs.nl>
cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <20070205213618.GA30923@outpost.ds9a.nl>
Message-ID: <Pine.LNX.4.64.0702051350010.8424@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021525370.5219@alien.or.mcafeemobile.com>
 <20070205213618.GA30923@outpost.ds9a.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Feb 2007, bert hubert wrote:
> 
> From my end as an application developer, yes please. Either make it
> perfectly ok to have thousands of outstanding asynchronous system calls (I
> work with thousands of separate sockets), or allow me to select/poll/epoll
> on the "async fd".

No can do.

Allocating an fd is actually too expensive, exactly because a lot of these 
operations are supposed to be a few hundred ns, and taking locks is simply 
a bad idea.

But if you want to, we could have a *separate* "convert async cookie to 
fd" so that you can poll for it, or something.

I doubt very many people want to do that. It would tend to simply be nicer 
to do

	async(poll);
	async(waitpid);
	async(.. wait foranything else ..)

followed by a

	wait_for_async();

That's just a much NICER approach, I would argue. And it automatically 
and very naturally solves the "wait for different kinds of events" 
question, in a way that "poll()" never did (except by turning all events 
into file descriptors or signals).

> Alternatively, something like SIGIO ('SIGASYS'?) might be considered, but,
> well, the fd might be easier.

Again. NO WAY. Signals are just damn expensive. At most, it would be an 
option again, but if you want high performance, signals simply aren't very 
good. They are also a nice way to make your user-space code very racy.

> In fact, perhaps the communication channel might simply *be* an fd. Queueing
> up syscalls sounds remarkably like sending datagrams. 

I'm the first to say that file descriptors is the UNIX way, but so are 
processes, and I think this is MUCH better done as a "process" interface. 
In other words, instead of doing it as a filedescriptor, do it as a 
"micro-fork/exec", and have the "wait()" equivalent. It's just that we 
don't fork a "real process", and we don't exec a "real program", we just 
exec a single system call.

If you think of it in those terms, it all makes sense *without* any file 
descriptors what-so-ever, and the "wait_for_async()" interface also makes 
a ton of sense (it really *is* "waitpid()" for the system call).

		Linus
