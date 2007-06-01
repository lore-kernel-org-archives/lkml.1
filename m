Return-Path: <linux-kernel-owner+w=401wt.eu-S1761448AbXFAQU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761448AbXFAQU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757648AbXFAQUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:20:17 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755159AbXFAQUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:20:15 -0400
Date: Fri, 1 Jun 2007 09:18:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Eric Dumazet <dada1@cosmosbay.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, cotte@de.ibm.com, hugh@veritas.com,
       neilb@suse.de, zanussi@us.ibm.com, hch@infradead.org
Subject: Re: [PATCH] sendfile removal
In-Reply-To: <466040C1.6030004@zytor.com>
Message-ID: <alpine.LFD.0.98.0706010904110.3957@woody.linux-foundation.org>
References: <20070531103316.GO32105@kernel.dk> <20070531124753.a99f713c.dada1@cosmosbay.com>
 <20070531105321.GQ32105@kernel.dk> <465F9BEF.20504@zytor.com>
 <20070601054120.GI32105@kernel.dk> <465FB3AD.5030807@zytor.com>
 <465FC92C.50608@cosmosbay.com> <466040C1.6030004@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, H. Peter Anvin wrote:
> 
> Fair enough.  Unix has traditionally not acknowledged the possibility of
> nonblocking I/O on conventional files, for some odd reason.

It's not odd at all.

If you return EAGAIN, you had better have a way to _wait_ for that EAGAIN 
to go away, otherwise the EAGAIN is just a total waste of time.

So the rule about EAGAIN is very simple:
 (a) the file descriptor must be O_NONBLOCK
 (b) the access must otherwise block
AND
 (c) the condition must be something we can wait for with poll/select

I don't know why people continually ignore that (c) point, even though 
it's obvious and very very important!

If you cannot wait for it, tell me why the kernel should _ever_ return 
EAGAIN? The only option for the user is to just do the operation again 
immediately.

And the thing is, neither poll nor select work on regular files. And no, 
that is _not_ just an implementation issue. It's very fundamental: neither 
poll nor select get the file offset to wait for!

And that file offset is _critical_ for a regular file, in a way it 
obviously is _not_ for a socket, pipe, or other special file. Because 
without knowing the file offset, you cannot know which page you should be 
waiting for!

And no, the file offset is not "f_pos". sendfile(), along with 
pread/pwrite, uses a totally separate file offset, so if select/poll were 
to base their decision on f_pos, they'd be _wrong_.

This really is very fundamental. 

Now, you can argue that you can always just return -EAGAIN anyway, but 
then the calling process will basically be busy-looping, calling 
sendfile() (or splice()) over and over again. That's _horrible_. It's much 
better to just not return EAGAIN, and sleep like a good process should!

So there's a few things to take away from this:

 - regular file access MUST NOT return EAGAIN just because a page isn't 
   in the cache. Doing so is simply a bug. No ifs, buts or maybe's about 
   it!

   Busy-looping is NOT ACCEPTABLE!

 - you *could* make some alternative conventions:

	(a) you could make O_NONBLOCK mean that you'll at least 
	    guarantee that you *start* the IO, and while you never return 
	    EAGAIN, you migth validly return a _partial_ result!

	(b) variation on (a): it's ok to return EAGAIN if _you_ were the 
	    one who started the IO during this particular time aroudn the 
	    loop. But if you find a page that isn't up-to-date yet, and 
	    you didn't start the IO, you *must* wait for it, so that you 
	    end up returning EAGAIN atmost once! Exactly because 
	    busy-looping is simply not acceptable behaviour!

I have to admit that I didn't look at what raw splice() itself does these 
days. I would not be surprised if Jens also didn't realize this very 
fundamental issue. It seems too easy to miss, because people think 
that EAGAIN stands on its own, and don't realize that EAGAIN must be 
paired with select/poll to make sense.

Jens?

		Linus
