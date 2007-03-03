Return-Path: <linux-kernel-owner+w=401wt.eu-S1750923AbXCCXze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750923AbXCCXze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 18:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbXCCXze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 18:55:34 -0500
Received: from tapsys.com ([72.36.178.242]:35866 "EHLO tapsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbXCCXzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 18:55:33 -0500
Message-ID: <45EA0AD3.9080104@madrabbit.org>
Date: Sat, 03 Mar 2007 15:54:59 -0800
From: Ray Lee <ray-lk@madrabbit.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Ihar `Philips` Filipau <thephilips@gmail.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
References: <efa6f5910703021120ia0b8d18ne0c806eb2e73da4c@mail.gmail.com>	 <20070303103427.GC22557@2ka.mipt.ru>	 <efa6f5910703030258ne76cd8as8a3900fc22456a91@mail.gmail.com>	 <2c0942db0703031312g15726e69gcce7a1d0b955ab76@mail.gmail.com> <efa6f5910703031414m7fa70bean4fa33609eb01b62@mail.gmail.com>
In-Reply-To: <efa6f5910703031414m7fa70bean4fa33609eb01b62@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ihar `Philips` Filipau wrote:
> On 3/3/07, Ray Lee <madrabbit@gmail.com> wrote:
>> On 3/3/07, Ihar `Philips` Filipau <thephilips@gmail.com> wrote:
>> > What I'm trying to get to: keep things simple. The proposed
>> > optimization by Ingo does nothing else but allowing AIO to probe file
>> > cache - if data there to go with fast path. So why not to implement
>> > what the people want - probing of cache? Because it sounds bad? But
>> > they are in fact proposing precisely that just masked with "fast
>> > threads".
>>
>>
>> Servers want to never, ever block. Not on a socket, not on a stat, not
>> on anything. (I have an embedded server I wrote that has to fork
>> internally just to watch the damn serial port signals in parallel with
>> handling network I/O, audio, and child processes that handle H323.)
>> There's a lot of things that can block out there, and it's not just
>> disk I/O.
>>
> 
> Why select/poll/epoll/friends do not work? I have programmed on both
> sides - user-space network servers and in-kernel network protocols -
> and "never blocking" thing was implemented in *nix in the times I was
> walking under table.
> 

Then you've never had to write something that watches serial port
signals. Google on TIOCMIWAIT to see what I'm talking about. The only
option for a userspace programmer to deal with that is to fork() or poll
the signals every so many milliseconds. There are probably more easy
examples, but that's the one off the top of my head that affected me.

In short, this isn't just about network IO, this isn't just about file IO.

> One can poll() more or less *any* device in system. With frigging
> exception of - right - files.

The problem is the "more or less." Say you're right, and 95% of the
system calls are either already asynchronous or non-blocking/poll()able.
One of the questions on the table is how to extend it to the last 5%.

> User-space-wise, check how squid (caching http proxy) does it: you
> have several (forked) instances to serve network requests and you have
> one/several disk I/O daemons. (So called "diskd storeio") Why? Because
> you cannot poll() file descriptors, but you can poll unix socket
> connected to diskd. If diskd blocks, squid still can serve requests.
> How threadlets are better then pool of diskd instances? All nastiness
> of shared memory set loose...

Samba/lighttpd/git want to issue dozens of stats in parallel so that the
kernel can have an opportunity to sort them better. Are you saying they
should fork() a process per stat that they want to issue in parallel?

> What I'm trying to get to. Threadlets wouldn't help existing
> single-threaded applications - what is about 95% of all applications.

Eh, I don't think that's right. Part of the reason threadlets and
syslets are on the table because it may be a more efficient way to do
AIO. And the differences between the syslet API and the current kernel
Async IO API can be abstracted away by glibc, so that today's apps that
do AIO would immediately benefit.

> What's more, as having some limited experience of kernel programming,
> I fail to see what threadlets would simplify on kernel side.

You can yank the entire separate AIO path, and just treat them as
another blocking API that syslets makes nonblocking. Immediate reduction
of code, and everybody is now using the same code paths, which means
higher test coverage and reduced maintenance cost.

This last point is really important. Even if no extra functionality
eventually makes it to userspace, this last point would still be enough
to make the powers that be consider inclusion.

Ray
