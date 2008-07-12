Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbYGLRbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbYGLRbg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 13:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYGLRb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 13:31:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502AbYGLRb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 13:31:26 -0400
Date: Sat, 12 Jul 2008 10:29:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>,
       Arjan van de Ven <arjan@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <4878883F.10004@gmail.com>
Message-ID: <alpine.LFD.1.10.0807121011470.2875@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807111337060.2873@woody.linux-foundation.org>
 <alpine.LFD.1.10.0807111617470.3459@woody.linux-foundation.org> <4878883F.10004@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Jul 2008, Török Edwin wrote:
> 
> On my 32-bit box (slow disks, SMP, XFS filesystem) 2.6.26-rc9 behaves
> the same as 2.6.26-rc8, I can reliably reproduce a 2-3 second latency
> [1] between pressing ^C the first time, and the shell returning (on the
> text console too).
> Using ftrace available from tip/master, I see up to 3 seconds of delay
> between kill_pgrp and detach_pid (and during that time I can press ^C
> again, leading to 2-3 kill_pgrp calls)

The thing is, it's important to see what happens in between. 

In particular, 2-3 second latencies can be entirely _normal_ (although 
obviously very annoying) with most log-based filesystems when they decide 
they have to flush the log. A lot of filesystems are not designed for 
latency - every single filesystem test I have ever seen has always been 
either a throughput test, or a "average random-seek latency" kind of test.

The exact behavior will depend on the filesystem, for example. It will 
also easily depend on things like whether you update 'atime' or not. Many 
ostensibly read-only loads end up writing some data, especially inode 
atimes, and that's when they can get caught up in having to wait for a log 
to flush (to make up for that atime thing).

You can try to limit the amount of dirty data in flight by tweaking 
/proc/sys/vm/dirty*ratio, but from a latency standpoint the thing that 
actually matters more is often not the amount of dirty data, but the size 
of the requests queues - because you often care about read latency, but if 
you have big requests and especially if you have a load that does lots of 
big _contiguous_ writes (like your 'dd's would do), then what can easily 
happen is that the read ends up being behind a really big write in the 
request queues. 

And 2-3 second latencies by no means means that each individual IO is 2-3 
seconds long. No - it just means that you ended up having to do multiple 
reads synchronously, and since the reads depended on each other (think a 
pathname lookup - reading each directory entry -> inode -> data), you can 
easily have a single system call causing 5-10 reads (bad cases are _much_ 
more, but 5-10 are perfectly normal for even well-behaved things), and now 
if each of those reads end up being behind a fairly big write...

> On my 64-bit box (2 disks in raid-0, UP, reiserfs filesystem) 2.6.25 and
> 2.6.26-rc9 behave the same, and most of the time (10-20 times in a row)
> find responds to ^C instantly.
>
> However in _some_ cases find doesn't respond to ^C for a very long time 
> (~30 seconds), and when this happens I can't do anything else but switch 
> consoles, starting another process (latencytop -d) hangs, and so does 
> any other external command.

Ok, that is definitel not related to signals at all. You're simply stuck 
waiting for IO - or perhaps some fundamental filesystem semaphore which is 
held while some IO needs to be flushed. That's why _unrelated_ processes 
hang: they're all waiting for a global resource.

And it may be worse on your other box for any number of reasons: raid 
means, for example, that you have two different levels of queueing, and 
thus effectively your queues are longer. And while raid-0 is better for 
throughput, it's not necessarily at all better for latency. The filesystem 
also makes a difference, as does the amount of dirty data under write-back 
(do you also have more memory in your x86-64 box, for example? That makes 
the kernel do bigger writeback buffers by default)

> I haven't yet tried ftrace on this box, and neither did I try Roland's
> patch yet. I will try that now, and hopefuly come back with some numbers
> shortly.

Trust me, roland's patch will make no difference what-so-ever. It's purely 
a per-thread thing, and your behaviour is clearly not per-thread.

Signals are _always_ delayed until non-blocking system calls are done, and 
that means until the end of IO. 

This is also why your trace on just 'kill_pgrp' and 'detach_pid' is not 
interesting. It's _normal_ to have a delay between them. It can happen 
because the process blocks (or catches) signals, but it will also happen 
if some system call waits for disk.

(The waiting for disk may be indirect - it might be due to needing more 
memory and needing to write out dirty studd. So it's not necessarily doing 
IO per se, although it's quite likely that that is part of it).

You could try 'noatime' and see if that helps behaviour a bit.

		Linus
