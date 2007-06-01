Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbXFAQ7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbXFAQ7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759308AbXFAQ65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:58:57 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33641 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbXFAQ64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:58:56 -0400
Message-ID: <46604F0D.9070806@zytor.com>
Date: Fri, 01 Jun 2007 09:53:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Eric Dumazet <dada1@cosmosbay.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, cotte@de.ibm.com, hugh@veritas.com,
       neilb@suse.de, zanussi@us.ibm.com, hch@infradead.org
Subject: Re: [PATCH] sendfile removal
References: <20070531103316.GO32105@kernel.dk> <20070531124753.a99f713c.dada1@cosmosbay.com> <20070531105321.GQ32105@kernel.dk> <465F9BEF.20504@zytor.com> <20070601054120.GI32105@kernel.dk> <465FB3AD.5030807@zytor.com> <465FC92C.50608@cosmosbay.com> <466040C1.6030004@zytor.com> <alpine.LFD.0.98.0706010904110.3957@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706010904110.3957@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> And the thing is, neither poll nor select work on regular files. And no, 
> that is _not_ just an implementation issue. It's very fundamental: neither 
> poll nor select get the file offset to wait for!
> 
> And that file offset is _critical_ for a regular file, in a way it 
> obviously is _not_ for a socket, pipe, or other special file. Because 
> without knowing the file offset, you cannot know which page you should be 
> waiting for!
> 
> And no, the file offset is not "f_pos". sendfile(), along with 
> pread/pwrite, uses a totally separate file offset, so if select/poll were 
> to base their decision on f_pos, they'd be _wrong_.

This is obviously correct, although at the time those interfaces were
designed, I don't believe either pread/pwrite nor sendfile() existed,
and they still couldn't wait on real files.  That there isn't a suitable
way to wait for a file at an offset is probably a result of that past
history.

Waiting at f_pos is still a possible interface, of course; it would mean
that pread/pwrite/sendfile users would have to seek before waiting.
However, implementing waiting on files in select/poll is prohibited by
POSIX, so it would at least need some sort of Linux-specific flag anyway.

It seems that being able to do nonblocking I/O on files would be a
useful thing.  This really *does* require proper nonblocking I/O and not
just the ability to wait, since you can never know when the kernel
decides to recycle the page you are just about to want from the cache.

> So there's a few things to take away from this:
> 
>  - regular file access MUST NOT return EAGAIN just because a page isn't 
>    in the cache. Doing so is simply a bug. No ifs, buts or maybe's about 
>    it!
> 
>    Busy-looping is NOT ACCEPTABLE!
> 
>  - you *could* make some alternative conventions:
> 
> 	(a) you could make O_NONBLOCK mean that you'll at least 
> 	    guarantee that you *start* the IO, and while you never return 
> 	    EAGAIN, you migth validly return a _partial_ result!
> 
> 	(b) variation on (a): it's ok to return EAGAIN if _you_ were the 
> 	    one who started the IO during this particular time aroudn the 
> 	    loop. But if you find a page that isn't up-to-date yet, and 
> 	    you didn't start the IO, you *must* wait for it, so that you 
> 	    end up returning EAGAIN atmost once! Exactly because 
> 	    busy-looping is simply not acceptable behaviour!

(b) seems really ugly.  (a) is at least well-defined.  Either seems
wrong, though.

	-hpa
