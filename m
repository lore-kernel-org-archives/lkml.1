Return-Path: <linux-kernel-owner+w=401wt.eu-S1767291AbXCINoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767291AbXCINoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 08:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767292AbXCINoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 08:44:06 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:35147 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767291AbXCINoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 08:44:04 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Subject: Re: sys_write() racy for multi-threaded append?
Date: Fri, 9 Mar 2007 14:44:10 +0100
User-Agent: KMail/1.9.5
Cc: "Benjamin LaHaise" <bcrl@kvack.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <f2b55d220703081508r3d8d033cu99f53104943d16cb@mail.gmail.com> <20070309013405.GI6209@kvack.org> <f2b55d220703090419w755d42d0mea4f220e3caaa59a@mail.gmail.com>
In-Reply-To: <f2b55d220703090419w755d42d0mea4f220e3caaa59a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703091444.10622.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 13:19, Michael K. Edwards wrote:
> On 3/8/07, Benjamin LaHaise <bcrl@kvack.org> wrote:
> > Any number of things can cause a short write to occur, and rewinding the
> > file position after the fact is just as bad.  A sane app has to either
> > serialise the writes itself or use a thread safe API like pwrite().
>
> Not on a pipe/FIFO.  Short writes there are flat out verboten by
> 1003.1 unless O_NONBLOCK is set.  (Not that f_pos is interesting on a
> pipe except as a "bytes sent" indicator  -- and in the multi-threaded
> scenario, if you do the speculative update that I'm suggesting, you
> can't 100% trust it unless you ensure that you are not in
> mid-read/write in some other thread at the moment you sample f_pos.
> But that doesn't make it useless.)
Hello Michael

When was the last time you checked standards ? Please read them again, and 
stop disinforming people.

http://www.opengroup.org/onlinepubs/007908775/xsh/write.html

	"On a file not capable of seeking, writing always takes place starting at the
	 current position. The value of a file offset associated with such a device
	is undefined."

A pipe/FIFO is not capable of seeking.

I let you make the conclusion of these two points.

A conformant kernel is free to not touch f_pos for non capable seeking files 
(pipes, sockets, ...), or to put any value in it.

Current code does that not because of lazy programmers, but because its 
generic, and adding special cases (tests + conditional branches) just slow 
down the code and make it larger.

>
> As to what a "sane app" has to do: it's just not that unusual to write
> application code that treats a short read/write as a catastrophic
> error, especially when the fd is of a type that is known never to
> produce a short read/write unless something is drastically wrong.  For
> instance, I bomb on short write in audio applications where the driver
> is known to block until enough bytes have been read/written, period.
> When switching from reading a stream of audio frames from thread A to
> reading them from thread B, I may be willing to omit app
> serialization, because I can tolerate an imperfect hand-off in which
> thread A steals one last frame after thread B has started reading --
> as long as the fd doesn't get screwed up.  There is no reason for the
> generic sys_read code to leave a race open in which the same frame is
> read by both threads and a hardware buffer overrun results later.

Don't assume your app is sane while the kernel is not. It's not very fair :

Show us the source code so that we can agree with you or disagree.

Also, I've seen some Unixes (namely AIX IBM) that could return a partial write 
even on a regular file on regular file system. An easy way to trigger this 
was to launch a debugger/syscall_tracer on the live process while it was 
doing a big write(). Most 'sane apps' were ignoring the partial return or 
just throw an exception.

Even on 'cleaner Unixes', a write() near the ulimit -f may return a partial 
count on a regular file.

>
> In short, I'm not proposing that the kernel perfectly serialize
> concurrent reads and writes to arbitrary fd types.  I'm proposing that
> it not do something blatantly stupid and easily avoided in generic
> code that makes it impossible for any fd type to guarantee that, after
> 10 successful pipelined 100-byte reads or writes, f_pos will have
> advanced by 1000.
>

Before saying current linux code is "blatantly stupid and easily avoided", 
just post your patches so that we can check them and eventually say : 

Oh yes, Michael was right and {we|they} were "stupid" all these years

Thank you
