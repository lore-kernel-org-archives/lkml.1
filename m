Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbXFIXfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbXFIXfR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 19:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbXFIXfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 19:35:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46134 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756667AbXFIXfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 19:35:04 -0400
Date: Sat, 9 Jun 2007 16:33:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Kyle Moffett <mrmacman_g4@mac.com>, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070609204907.GH4095@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.98.0706091623090.20321@woody.linux-foundation.org>
References: <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com>
 <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com>
 <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com>
 <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com>
 <20070609200645.GG4095@ftp.linux.org.uk> <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
 <20070609204907.GH4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 9 Jun 2007, Al Viro wrote:
> 
> Eww...  Idea of pipe(2) taking flags as argument...

Right. That was one of the patches, and it was one that I said was too 
damn ugly to live.

So I instead suggested the alternate approach of adding a single new 
system call that runs another system call indirectly, with a set of flags 
and/or other behaviour modifications.

And I actually think that's a great idea, because we have *multiple* uses 
of this kind of "run system call with special flags" issues:

 - the whole "async" thing, and as Matt reminded me, this is the perfect 
   interface for also saying "run this system call asynchronously"

 - things like FD_CLOEXEC, but also things like O_NOFOLLOW and O_NDELAY 
   (which currently only "open()" supports, even though it makes sense for 
   a lot of other ops too)

 - extended flags like LOOKUP_NOSYMLINK and LOOKUP_NOMOUNT for any system 
   call that does path lookup (to make it return errors if you *ever* 
   traverse a symlink or a mount-point respectively: security conscious 
   programs tend to want this - think about apache that exports per-user 
   "public_html" stuff, but does *not* want to export /etc, and thus 
   doesn't like following symlinks).

> I don't know if your indirect is a good idea in that respect, actually.
> AFAICS, you are suggesting per-syscall meanings of the flags, so it really
> smells like YAMultiplexor, free for abuse.

Well, the actual _setup_ would be global (ie we would have no per-system 
call actions: we'd just copy the "flags" into the thread 
"system_call_flags" thing).

But yes, different system calls could decide to *interpret* the flags 
differently. Quite frankly, I'd rather have that kind of overloaded flag 
bitmap, than try to create something "extensible". 

That said, I don't think there really will be all that many flags, and we 
could even just decide that the bits have to be totally unique (and simply 
limited to 32 flags). The whole point of the flags, after all, would be 
things that *do* make sense for a whole group of system calls: if that's 
not true, and it's some single-system-call thing, then you might as well 
just always add the new system call itself!

So it makes sense for generic flags (like ASYNC and path lookup rules: not 
every system call takes a path, of course, but it's conceptually still 
pretty damn generic). but it wouldn't really make sense to do for a very 
specific system call - it would be faster and easier to just create the 
new system call in the first place.

		Linus
