Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYGLUsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYGLUsu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 16:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYGLUsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 16:48:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbYGLUsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 16:48:42 -0400
Date: Sat, 12 Jul 2008 13:47:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>,
       Arjan van de Ven <arjan@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <48791393.1020107@gmail.com>
Message-ID: <alpine.LFD.1.10.0807121339430.2875@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807111337060.2873@woody.linux-foundation.org>
 <alpine.LFD.1.10.0807111617470.3459@woody.linux-foundation.org> <4878883F.10004@gmail.com> <alpine.LFD.1.10.0807121011470.2875@woody.linux-foundation.org> <48791393.1020107@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Jul 2008, Török Edwin wrote:
> 
> A bit off-topic, but something I noticed during the tests:
> In my original test I have rm-ed the files right after launching dd in
> the background, yet it still continued to write to the disk.
> I can understand that if the file is opened O_RDWR, you might seek back
> and read what you wrote, so Linux needs to actually do the write,
> but why does it insist on writing to the disk, on a file opened with
> O_WRONLY, after the file itself got unlinked?

Linux itself doesn't insist on writing to disk. In fact, at least with 
traditional UNIX filesystems (eg minix, ext2) the deleted writes would be 
undone.

But some filesystems can't just invalidate dirty buffers (some won't do it 
for meta-data, others won't do it for _any_ data). So again, this 
behaviour depends on the filesystem. And sadly, the more "advanced" 
filesystem, the worse it usually behaves here.


> I have my filesystems mounted as noatime already.
> But yes, I am using different filesystems, the x86-64 box has reiserfs,
> and the x86-32 box has xfs.
> 
> > You can try to limit the amount of dirty data in flight by tweaking 
> > /proc/sys/vm/dirty*ratio
> 
> I have these in my /etc/rc.local:
> echo 5 > /proc/sys/vm/dirty_background_ratio
> echo 10 >/proc/sys/vm/dirty_ratio

That matches the modern defaults. You can try playing with them if you 
want to. And yes, it's worth testing nr_requests too.

> > Ok, that is definitel not related to signals at all. You're simply stuck 
> > waiting for IO - or perhaps some fundamental filesystem semaphore which is 
> > held while some IO needs to be flushed.
> 
> AFAICT reiserfs still uses the BKL, could that explain why one I/O
> delays another?

The BKL should be ok in this respect - it gets automatically dropped when 
doing synchronous waiting (this is somethign that will possibly go away as 
we try to convince people to get rid of the BKL, but it certainly hasn't 
happened yet).

So it actually gets worse with other locks - semaphores or mutexes - that 
stay held over IO. And reiserfs has a journal lock (and a "commit" lock), 
but I don't know how they are held and whether this could be part of the 
issue.

> > This is also why your trace on just 'kill_pgrp' and 'detach_pid' is not 
> > interesting. It's _normal_ to have a delay between them. It can happen 
> > because the process blocks (or catches) signals, but it will also happen 
> > if some system call waits for disk.
> 
> Is there a way to trace what happens between those 2 functions?

You could try to trace not just those functions, but scheduling events 
too. Or yes, do something special-caed.

Trying to figure out latencies in the block trace is likely also going to 
be interesting (although you won't see any signal issues there - but any 
long read latencies will automatically tend to imply latency issues not 
just for signals, but for pretty much any operations).

		Linus
