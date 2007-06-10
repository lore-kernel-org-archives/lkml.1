Return-Path: <linux-kernel-owner+w=401wt.eu-S1762184AbXFJDuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762184AbXFJDuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 23:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759692AbXFJDt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 23:49:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41259 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759401AbXFJDt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 23:49:58 -0400
Date: Sat, 9 Jun 2007 20:48:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Kyle Moffett <mrmacman_g4@mac.com>, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070610031922.GC21478@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.98.0706092036500.20321@woody.linux-foundation.org>
References: <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com>
 <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com>
 <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com>
 <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com>
 <20070609200645.GG4095@ftp.linux.org.uk> <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
 <20070610031922.GC21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 10 Jun 2007, Al Viro wrote:
> > 
> > And that means that libraries currently MUST NOT open their own file 
> > descriptors, exactly because they mess with the "application file 
> > descriptor namespace", namely the linear POSIX-defined fd allocation 
> > rules!
> 
> Unless it does so in a thread that has unshared its descriptor table.

Agreed. That was actually part of the reason why I thought clone() was
much better than the pthreads interface.

That said, the Linux !CLONE_FILES does have downsides:

 - it is potentially much slower to do than sharing everything (if you 
   have lots of file descriptors, incrementing the refcounts etc is 
   actually a real overhead)

 - it simply doesn't work, if the library wants to run in the same 
   execution context, and just wants to open one (or more) file 
   descriptors for some helper thing.

IOW, the most common case for libraries is not that they get invoced to do 
one thing, but that they get loaded and then used over and over and over 
again, and the _reason_ for wanting to have a file descriptor open may 
well be that the library wants to cache the file descriptor, rather than 
having to open a file over and over again!

For example, a library routine that does a full

	fd = open();
	.. do something with it ..
	close(fd);

generally doesn't need any private file descriptors at all (although there 
are the threading issues with exec etc) - it will temporarily use a normal 
file descriptor, and the caller won't be any wiser. Lots of current 
library routines do this all the time.

But let's say that you want to do a library that does name resolution, and 
you actually want to create the socket that binds to the DNS server just 
once, and then re-use that socket across library calls. It's not that the 
library is a thread of its own - it's not - but with the normal linear fd 
space it really cannot do this. Sure, it could try to hide it up somewhere 
in high fd space, but that would slow down other operations, and there's 
no way to guarantee it doesn't clash with some _other_ library doing the 
same thing, so it really isn't a good idea.

Now, when you do a DNS query, the setup cost of opening the socket is the 
least of your worries, so the above example is not a very good one. I'm 
really just giving it as a concrete example of a _conceptual_ problem, 
where some other library really had more pressing performance reasons why 
they cannot keep re-opening a file descriptor and closing it each time.

So _that_ is the kind of situation where I think "anonymous file 
descriptors" make sense. 

		Linus
