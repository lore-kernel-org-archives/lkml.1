Return-Path: <linux-kernel-owner+w=401wt.eu-S1761311AbXEaJ30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311AbXEaJ30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760599AbXEaJ3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:29:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59941 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758280AbXEaJ3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:29:04 -0400
Date: Thu, 31 May 2007 11:26:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
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
Message-ID: <20070531092640.GA2504@elte.hu>
References: <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org> <465DE992.6070803@redhat.com> <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org> <Pine.LNX.4.64.0705301443340.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301457350.26602@woody.linux-foundation.org> <20070531061303.GA4436@elte.hu> <20070531093523.a6a62833.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531093523.a6a62833.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> > speedup: i suggested O_ANY 6 years ago as a speedup to Apache - 
> > non-linear fds are cheaper to allocate/map:
> > 
> >   http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg23820.html
> > 
> > (i definitely remember having written code for that too, but i 
> > cannot find that in the archives. hm.) In theory we could avoid 
> > _all_ fd-bitmap overhead as well and use a per-process list/pool of 
> > struct file buffers plus a maximum-fd field as the 'non-linear fd 
> > allocator' (at the price of only deallocating them at process exit 
> > time).
> 
> Only very few apps need to open more than 100.000 files.

yes. I did not list it as a primary reason for private fds, it's just a 
nice side-effect. As long as the other apps are not hurt, i see no 
problem in improving the >100K open files case.

> As these files are likely sockets, O_ANY is not a solution.

why not? It would be a natural thing to extend sys_socket() with a 
'flags' parameter and pass in O_ANY (along with any other possible fd 
parameter like O_NDELAY, which could be inherited over connect()).

> A trick is to try to keep first 64 handles freed, so that kernel wont 
> consume too much cpu time and cache in get_unused_fd()
> 
> http://lkml.org/lkml/2005/9/15/307

this is basically a user-space front-end cache to fd allocation - which 
duplicates data needlessly. I dont see any problem with doing this in 
the kernel. (Also, obviously 'first 64 handles' could easily break with 
certain types of apps so glibc cannot do this.)

	Ingo
