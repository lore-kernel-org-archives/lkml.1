Return-Path: <linux-kernel-owner+w=401wt.eu-S932895AbXCCWOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbXCCWOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 17:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932931AbXCCWOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 17:14:31 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:59804 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895AbXCCWOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 17:14:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GXf0SwBNk1/th4/57AaIqadXbYi446Hcy6H/IMglMnTBezd4TvZrEOXG82Tnfl3GZ+pY0hE3oy9CilWJue2YxTinCc8ZywC2s0qQgNC7Ls2oXkkNDqYm9ybk1RbrwLa2e5CQSFd78GaIfOF19z2FU+0ru0v53KYuD3/6Ap+emw4=
Message-ID: <efa6f5910703031414m7fa70bean4fa33609eb01b62@mail.gmail.com>
Date: Sat, 3 Mar 2007 23:14:29 +0100
From: "Ihar `Philips` Filipau" <thephilips@gmail.com>
To: ray-gmail@madrabbit.org
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
In-Reply-To: <2c0942db0703031312g15726e69gcce7a1d0b955ab76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <efa6f5910703021120ia0b8d18ne0c806eb2e73da4c@mail.gmail.com>
	 <20070303103427.GC22557@2ka.mipt.ru>
	 <efa6f5910703030258ne76cd8as8a3900fc22456a91@mail.gmail.com>
	 <2c0942db0703031312g15726e69gcce7a1d0b955ab76@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/07, Ray Lee <madrabbit@gmail.com> wrote:
> On 3/3/07, Ihar `Philips` Filipau <thephilips@gmail.com> wrote:
> > What I'm trying to get to: keep things simple. The proposed
> > optimization by Ingo does nothing else but allowing AIO to probe file
> > cache - if data there to go with fast path. So why not to implement
> > what the people want - probing of cache? Because it sounds bad? But
> > they are in fact proposing precisely that just masked with "fast
> > threads".
>
>
> Servers want to never, ever block. Not on a socket, not on a stat, not
> on anything. (I have an embedded server I wrote that has to fork
> internally just to watch the damn serial port signals in parallel with
> handling network I/O, audio, and child processes that handle H323.)
> There's a lot of things that can block out there, and it's not just
> disk I/O.
>

Why select/poll/epoll/friends do not work? I have programmed on both
sides - user-space network servers and in-kernel network protocols -
and "never blocking" thing was implemented in *nix in the times I was
walking under table.

One can poll() more or less *any* device in system. With frigging
exception of - right - files. IOW for 75% of I/O problem doesn't
exists since there is proper interface - e.g. sockets - in place.

User-space-wise, check how squid (caching http proxy) does it: you
have several (forked) instances to serve network requests and you have
one/several disk I/O daemons. (So called "diskd storeio") Why? Because
you cannot poll() file descriptors, but you can poll unix socket
connected to diskd. If diskd blocks, squid still can serve requests.
How threadlets are better then pool of diskd instances? All nastiness
of shared memory set loose...

What I'm trying to get to. Threadlets wouldn't help existing
single-threaded applications - what is about 95% of all applications.
And multi-threaded applications would gain little because few real
application create threads dynamically: creation need resources and
can fail, uncontrollable thread spawning hurts overall manageability
and additional care is needed regarding deadlocks/lock contentions
proofing. (The category of applications which want the performance
gain are also the applications which need to ensure greater stability
over long non-stop runs. Uncontrollable dynamism helps nothing.)

Having implemented several "file servers" - daemons serving file I/O
to other daemons - I honestly hardly see any improvements. Now people
configure such file servers to issue e.g. 10 file operations
simultaneously - using pool of 10 threads. What threadlets change? In
the end just to keep in check with threadlets I would need to issue
pthread_join() after some number of threadlets created. And the latter
number is the former "e.g. 10". IOW, programmer-wise the
implementation remain same - and all the limitations remain the same.
And all overhead of user-space locking remain the same. (*)

What's more, as having some limited experience of kernel programming,
I fail to see what threadlets would simplify on kernel side. End
result as I see it: user space becomes bit more complicated because of
dynamic multi-threading and kernel-space becomes also more complicated
because of the same added dynamism.

(*) Hm... On other side, if application would be able to tell kernel
to limit number of issued threadlets to N, then it might simplify the
job. Application can tell kernel "I need at most 10 blocking
threadlets, block me if there are more" and then dumbly throw I/O
threadlets at kernel as they are coming in. And kernel would then put
process to sleep if N+1 thredlets are blocking. That would definitely
simplify the job in user-space: it wouldn't need to call
pthread_join(). But it is still no replacement to poll()able file
descriptor or truly async mmap().

-- 
Don't walk behind me, I may not lead.
Don't walk in front of me, I may not follow.
Just walk beside me and be my friend.
    -- Albert Camus (attributed to)
