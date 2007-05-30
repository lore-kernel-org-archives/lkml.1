Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbXE3UVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbXE3UVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbXE3UVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:21:13 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3625 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbXE3UVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:21:13 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 30 May 2007 13:21:11 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
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
In-Reply-To: <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705301315310.6272@alien.or.mcafeemobile.com>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com>
 <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Linus Torvalds wrote:

> On Wed, 30 May 2007, Davide Libenzi wrote:
> > 
> > Here I think we are forgetting that glibc is userspace and there's no 
> > separation between the application code and glibc code. An application 
> > linking to glibc can break glibc in thousand ways, indipendently from fds 
> > or not fds. Like complaining that glibc is broken because printf() 
> > suddendly does not work anymore ;)
> 
> No, Davide, the problem is that some applications depend on getting 
> _specific_ file descriptors.
> 
> For example, if you do
> 
> 	close(0);
> 	.. something else ..
> 	if (open("myfile", O_RDONLY) < 0)
> 		exit(1);
> 
> you can (and should) depend on the open returning zero.
> 
> So library routines *must not* open file descriptors in the normal space.
> 
> (The same is true of real applications doing the equivalent of
> 
> 	for (i = 0; i < NR_OPEN; i++)
> 		close(i);
> 
> to clean up all file descriptors before doing something new. And yes, I 
> think it was bash that used to *literally* do something like that a long 
> time ago.

Right. I misunderstood Uli and Ingo. I thought it was like trying to 
protect glibc from intentional application mis-behaviour.



> Another example of the same thing: people open file descriptors and know 
> that they'll be "dense" in the result, and then use "select()" on them.
> 
> So it's true that file descriptors can't be used randomly by the standard 
> libraries - they'd need to have some kind of separate "private space".
> 
> Which *could* be something as simple as saying "bit 30 in the file 
> descriptor specifies a separate fd space" along with some flags to make 
> open and friends return those separate fd's. That makes them useless for 
> "select()" (which assumes a flat address space, of course), but would be 
> useful for just about anything else.

I think it can be solved in a few ways. Yours or Ingo's (or something 
else) can work, to solve the above "legacy" fd space expectations.



- Davide


