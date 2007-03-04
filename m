Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbXCDQXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbXCDQXj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 11:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXCDQXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 11:23:38 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:29728 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbXCDQXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 11:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VsLoOs+TVwglnx9/iGMTNlj/k7ACXNT9qKHamuaV5FoLylUpPUdDowe1EzbTAtrJYxJg87yJOsJSDOstWfPTGAChUmQqxZMTP0w2HKg7me5WJZo3I38QgnDwq63GbBt7iIWLXyQ0R9MSi9nrIRhysmOmO6D2fxAtqLwHyliSCDU=
Message-ID: <ca9528de0703040823x340b0b7fw923b9bae8bcf0e7@mail.gmail.com>
Date: Sun, 4 Mar 2007 13:23:37 -0300
From: "Kirk Kuchov" <kirk.kuchov@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, "Ingo Molnar" <mingo@elte.hu>,
       "Eric Dumazet" <dada1@cosmosbay.com>, "Pavel Machek" <pavel@ucw.cz>,
       "Theodore Tso" <tytso@mit.edu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070301131118.GA30228@elte.hu> <20070301141637.GA20006@elte.hu>
	 <20070301145454.GB12684@2ka.mipt.ru>
	 <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com>
	 <20070302081047.GA27122@2ka.mipt.ru>
	 <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com>
	 <20070303100625.GA22557@2ka.mipt.ru>
	 <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com>
	 <20070303203140.GA756@2ka.mipt.ru>
	 <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> <snip>
>
> Those *other* (tons?!?) interfaces can be created *when* the need comes
> (see Linus signalfd [1] example to show how urgent that was). *When*
> the need comes, they will work with existing POSIX interfaces, without
> requiring your own just-another event interface. Those other interfaces
> could also be more easily adopted by other Unix cousins, because of
> the fact that they rely on existing POSIX interfaces.

Please stop with this crap, this chicken or the egg argument of yours is utter
BULLSHIT! Just because Linux doesn't have a decent kernel event
notification mechanism it does not mean that users don't need. Nobody
cared about Linus's
signalfd because it wasn't mainline.

Look at any event notification libraries out there, it makes me sick how much
kludge they have to go thru to get near the same functionality of
kqueue on Linux.

Solaris has the Event Ports mechanism since 2003. FreeBSD, NetBSD, OpenBSD
and Mac OS X support kqueue since around 2000. Windows has had event
notification for ages now. These _facilities_ are all widely used,
given the platforms
popularity.

So here we are, 2007. epoll() works with files, pipes, sockets,
inotify and anything
pollable (file descriptors) but aio, timers, signals and user-defined
event. Can we
please get those working with epoll ? Something as simple as:

struct epoll_event ev;

ev.events = EV_TIMER | EPOLLONESHOT;
ev.data.u64 = 1000; /* timeout */

epoll_ctl(epfd, EPOLL_CTL_ADD, 0 /* ignored */, &ev);

or

struct sigevent ev;

ev.sigev_notify = SIGEV_EPOLL;
ev.sigev_signo = epfd;
ev.sigev_value = &ev;

timer_create(CLOCK_MONOTONIC, &ev, &timerid);

AIO:

struct sigevent ev;
int fd = io_setup(..); /* oh boy, I wish... but it works */

ev.events = EV_AIO | EPOLLONESHOT;
/* event.data.ptr returns pointer to the iocb */
epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev);

or

struct iocb iocb;

iocb.aio_fildes = fileno(stdin);
iocb.aio_lio_opcode = IO_CMD_PREAD;
iocb.c.notify = IO_NOTIFY_EPOLL; /* __pad3/4 */

Would this be acceptable? Can we finally move on?

--
Kirk Kuchov
