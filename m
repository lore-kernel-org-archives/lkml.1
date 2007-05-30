Return-Path: <linux-kernel-owner+w=401wt.eu-S1761349AbXE3V53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349AbXE3V53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbXE3V5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:57:19 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:50787 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759313AbXE3V5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:57:18 -0400
Message-ID: <465DF272.3000108@cosmosbay.com>
Date: Wed, 30 May 2007 23:53:54 +0200
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
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org> <465DDF0A.8080107@cosmosbay.com> <alpine.LFD.0.98.0705301341480.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705301341480.26602@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 30 May 2007 23:54:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds a écrit :
> 
> On Wed, 30 May 2007, Eric Dumazet wrote:
>>> No, Davide, the problem is that some applications depend on getting
>>> _specific_ file descriptors.
>> Fix the application, and not adding kernel bloat ?
> 
> No. The application is _correct_. It's how file descriptors are defined to 
> work. 
> 
>> Then you can also exclude multi-threading, since a thread (even not inside
>> glibc) can also use socket()/pipe()/open()/whatever and take the zero file
>> descriptor as well.
> 
> Totally different. That's an application internal issue. It does *not* 
> mean that we can break existing standards.
> 
>> The only hardcoded thing in Unix is 0, 1 and 2 fds.
> 
> Wrong. I already gave an example of real code that just didn't bother to 
> keep track of which fd's it had open, and closed them all. Partly, in 
> fact, because you can't even _know_ which fd's you have open when somebody 
> else just execve's you.

If someone really cares, /proc/self/fd can help. But one shouldn't care at all.

About the things that the process can do before execing() a process, file 
descriptors outside of 0,1,2 are the most obvious thing, but you also have 
alarm(), or stupid rlimits.

> 
> You can call it buggy, but the fact is, if you do, you're SIMPLY WRONG. 
> 
> You cannot just change years and years of coding practice, and standard 
> documentations. The behaviour of file descriptors is a fact. Ignoring that 
> fact because you don't like it is naïve and simply not realistic.

I want to change nothing. Current situation is fine and well documented, thank 
you.

If a program does "for (i = 0; i < NR_OPEN; i++) close(i);", this 
*will*/*should* work as intended : close all files descriptors from 0 to 
NR_OPEN. Big deal.

But you wont find in a program :

FILE *fp = fopen("somefile", "r");
for (i = 0; i < NR_OPEN; i++)
     close(i);
while (fgets(buff, sizeof(buff), fp)) {
}


You and/or others want to add fd namespaces and other hacks.

I saw on this thread suspicious examples, I am waiting for a real one, 
justifying all this stuff.

After file descriptors separation, I guess we'll need memory space separation 
as well, signal separations (SIGALRM comes to mind), uid/gid separation, cpu 
time separation, and so on... setrlimit() layered for every shared lib.


