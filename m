Return-Path: <linux-kernel-owner+w=401wt.eu-S1759649AbYGKUi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649AbYGKUi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbYGKUit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:38:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310AbYGKUis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:38:48 -0400
Date: Fri, 11 Jul 2008 13:37:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807111337060.2873@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Jul 2008, Linus Torvalds wrote:
> 
> Btw, did any of the impacted people test -rc9? Edwin's report is about 
> -rc2 and -rc8, and one of the things we fixed since -rc8 is that incorrect 
> and unintentional nr_zones zeroing that effectively disabled kswapd - and 
> made everybody do synchronous memory freeing when they wanted to allocate 
> more memory.. That can play havoc with any interactive stuff.

No, after testing more, I think Edwin is right.

There _does_ seem to be something wrong in signal handling when the signal 
happens during 'D' state (although I guess it could also be an artifact of 
other scheduling activity). I just put my machine under heavy read load by 
having a background process that does

	while : ; do echo 3 > /proc/sys/vm/drop_caches ; sleep 5; done

to flush the caches all the time, and then doing endless loops of "git 
grep" and other things, and I can definitely re-create the bad latency.

The best example is doing just

	[torvalds@woody ~]$ ls -l /usr/bin
	^Ctotal 367720
	-rwxr-xr-x 1 root root       43648 2008-07-04 09:35 [
	[torvalds@woody ~]$

and there are several seconds between the '^C' and the printout of the two 
lines (after which the 'ls' finally dies).

Perhaps more interestingly: when this happens (it doesn't happen all the 
time), it will _always_ die at the first two lines of printout for me, on 
two different machines: ie I *always* get that exact pattern of those two 
lines printed out (except when it reacts immediately, or when I press ^C 
so late that it has printed out much more).

And it's not some single system call latency that is long. I checked with 
strace, and while the IO load is high and causes the whole 'ls' to take a 
long time (up to 10 seconds - /usr/bin is *big*), each individual system 
call never takes very long. The longest system call latency I saw was 0.24 
seconds, which was for some very unlucky lstat() calls. Most of them were 
in the millisecond range, even though they obviously had to do IO.

More tellingly, those two writes are simply not even done with a single 
system call. The 'strace' for an 'ls -l' shows

	...
	write(1, "total 367720\n", 13) = 13 <0.000085>
	open("/etc/localtime", O_RDONLY) = 3 <0.000016>
	fstat(3, {st_mode=S_IFREG|0644, st_size=2819, ...}) = 0 <0.000004>
	fstat(3, {st_mode=S_IFREG|0644, st_size=2819, ...}) = 0 <0.000004>
	mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f6d996dd000 <0.000006>
	read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\4\0\0\0\4\0\0\0\0"..., 4096) = 2819 <0.041416>
	lseek(3, -1802, SEEK_CUR) = 1017 <0.000005>
	read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\5\0\0\0\5\0\0\0\0"..., 4096) = 1802 <0.000006>
	close(3)              = 0 <0.000006>
	munmap(0x7f6d996dd000, 4096) = 0 <0.000014>
	write(1, "-rwxr-xr-x 1 root root       436"..., 54) = 54 <0.000008>
	...

so there is actually *many* system calls in there between the header line 
that does the 'total' and the first line of actual real output, but 
despite that, it reacts to the ^C consistently after the second line.

Very odd.

And the problem definitely happens on x86-32 too.

It also happens on the text console, so this is not some bad interaction 
with X and pty's and xterm or gnome-terminal or something like that. At 
first I thought "no way can that actually happen, I think the terminal is 
broken and only sends the signal after it has seen output", but no, it 
happens for me in text-mode too.

Oleg added to the Cc as the master of signal handling code.

			Linus
