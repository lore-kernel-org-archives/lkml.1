Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbXE3JGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbXE3JGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 05:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbXE3JG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 05:06:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43229 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbXE3JG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 05:06:26 -0400
Date: Wed, 30 May 2007 11:05:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Ulrich Drepper <drepper@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070530090537.GB17744@elte.hu>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <20070530085159.GC21528@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530085159.GC21528@2ka.mipt.ru>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> On Wed, May 30, 2007 at 10:42:52AM +0200, Ingo Molnar (mingo@elte.hu) wrote:
> > it is a serious flexibility issue that should not be ignored. The 
> > unified fd space is a blessing on one hand because it's simple and 
> > powerful, but it's also a curse because nested use of the fd space for 
> > libraries is currently not possible. But it should be detached from any
> > fundamental question of kevent vs. epoll. (By improving library use of
> > file descriptors we'll improve the utility of all syscalls - by ducking
> > to a memory based API we only solve that particular event based usage.)
> 
> There is another issue with file descriptors - userspace must dig into 
> kernel each time it wants to get a new set of events, while with 
> memory based approach it has them without doing so. After it has 
> returned from kernel and know that there are some evetns, kernel can 
> add more of them into the ring (if there is a place) and userspace 
> will process them withouth additional syscalls.

Firstly, this is not a fundamental property of epoll. If we wanted to, 
it would be possible to extend epoll to fill in a ring of events from 
the wakeup handler. It's an incremental add-on to epoll that should not 
impact the design. How much info to put into a single event is another 
incremental thing - for most of the high-performance cases all the 
information we need is the type of the event and the fd it occured on. 
Currently epoll supports that minimal approach.

Secondly, our current syscall overhead is below 0.1 usecs on latest 
hardware:

  dione:~/l> ./lat_syscall null
  Simple syscall: 0.0911 microseconds

so you need millions of events _per cpu_ for the syscall overhead to 
show up.

Thirdly, our main problem was not the structure of epoll, our main 
problem was that event APIs were not widely available, so applications 
couldnt go to a pure event based design - they always had to handle 
certain types of event domains specially, due to lack of coverage. The
latest epoll patches largely address that. This was a huge barrier
against adoption of epoll.

	Ingo
