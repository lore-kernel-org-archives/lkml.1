Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbXE3Ujl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbXE3Ujl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbXE3Ujc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:39:32 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:37813 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbXE3Uja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:39:30 -0400
Message-ID: <465DDF0A.8080107@cosmosbay.com>
Date: Wed, 30 May 2007 22:31:06 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Drepper <drepper@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 30 May 2007 22:31:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds a écrit :
> 
> On Wed, 30 May 2007, Davide Libenzi wrote:
>> Here I think we are forgetting that glibc is userspace and there's no 
>> separation between the application code and glibc code. An application 
>> linking to glibc can break glibc in thousand ways, indipendently from fds 
>> or not fds. Like complaining that glibc is broken because printf() 
>> suddendly does not work anymore ;)
> 
> No, Davide, the problem is that some applications depend on getting 
> _specific_ file descriptors.
> 

Fix the application, and not adding kernel bloat ?

> For example, if you do
> 
> 	close(0);
> 	.. something else ..
> 	if (open("myfile", O_RDONLY) < 0)
> 		exit(1);
> 
> you can (and should) depend on the open returning zero.

Then you can also exclude multi-threading, since a thread (even not inside 
glibc) can also use socket()/pipe()/open()/whatever and take the zero file 
descriptor as well.

Frankly I dont buy this fd namespace stuff.

The only hardcoded thing in Unix is 0, 1 and 2 fds.
People usually take care of these, or should use a Microsoft OS.

POSIX mandates that open() returns the lowest available fd.
But this obviously works only if you dont have another thread messing with 
fds, or if you dont call a library function that opens a file.

Thats all.

> 
> So library routines *must not* open file descriptors in the normal space.
> 
> (The same is true of real applications doing the equivalent of
> 
> 	for (i = 0; i < NR_OPEN; i++)
> 		close(i);

Quite buggy IMHO

This hack was to avoid bugs coming from ancestors applications, 
forking/execing a shell, and at times where one process could not open more 
than 20 files (AT&T Unix, 21 years ago)

Unix has fcntl(fd, F_SETFD, FD_CLOEXEC). A library should use this to make 
sure fd is not propagated at exec() time.

> 
> to clean up all file descriptors before doing something new. And yes, I 
> think it was bash that used to *literally* do something like that a long 
> time ago.
> 
> Another example of the same thing: people open file descriptors and know 
> that they'll be "dense" in the result, and then use "select()" on them.

poll() is nice. Even AT&T Unix had it 21 years ago :)

> 
> So it's true that file descriptors can't be used randomly by the standard 
> libraries - they'd need to have some kind of separate "private space".
> 
> Which *could* be something as simple as saying "bit 30 in the file 
> descriptor specifies a separate fd space" along with some flags to make 
> open and friends return those separate fd's. That makes them useless for 
> "select()" (which assumes a flat address space, of course), but would be 
> useful for just about anything else.
> 

Please dont do that. Second class fds.

Then what about having ten different shared libraries ? Third class fds ?


