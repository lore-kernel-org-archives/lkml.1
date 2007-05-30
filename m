Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbXE3UGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbXE3UGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbXE3UGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:06:11 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbXE3UGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:06:10 -0400
Date: Wed, 30 May 2007 13:00:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
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
In-Reply-To: <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com>
 <20070530084252.GA15708@elte.hu>
 <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Davide Libenzi wrote:
> 
> Here I think we are forgetting that glibc is userspace and there's no 
> separation between the application code and glibc code. An application 
> linking to glibc can break glibc in thousand ways, indipendently from fds 
> or not fds. Like complaining that glibc is broken because printf() 
> suddendly does not work anymore ;)

No, Davide, the problem is that some applications depend on getting 
_specific_ file descriptors.

For example, if you do

	close(0);
	.. something else ..
	if (open("myfile", O_RDONLY) < 0)
		exit(1);

you can (and should) depend on the open returning zero.

So library routines *must not* open file descriptors in the normal space.

(The same is true of real applications doing the equivalent of

	for (i = 0; i < NR_OPEN; i++)
		close(i);

to clean up all file descriptors before doing something new. And yes, I 
think it was bash that used to *literally* do something like that a long 
time ago.

Another example of the same thing: people open file descriptors and know 
that they'll be "dense" in the result, and then use "select()" on them.

So it's true that file descriptors can't be used randomly by the standard 
libraries - they'd need to have some kind of separate "private space".

Which *could* be something as simple as saying "bit 30 in the file 
descriptor specifies a separate fd space" along with some flags to make 
open and friends return those separate fd's. That makes them useless for 
"select()" (which assumes a flat address space, of course), but would be 
useful for just about anything else.

		Linus
