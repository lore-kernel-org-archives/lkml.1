Return-Path: <linux-kernel-owner+w=401wt.eu-S932508AbXCANTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbXCANTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933287AbXCANTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:19:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49845 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508AbXCANTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:19:24 -0500
Date: Thu, 1 Mar 2007 14:11:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070301131118.GA30228@elte.hu>
References: <20070301094723.GJ7217@2ka.mipt.ru> <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru> <20070301110022.GA28260@elte.hu> <20070301111629.GA27381@2ka.mipt.ru> <20070301114137.GB897@elte.hu> <20070301114734.GA3508@elte.hu> <20070301121020.GC20773@2ka.mipt.ru> <20070301124336.GA24464@elte.hu> <20070301130135.GA20554@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301130135.GA20554@2ka.mipt.ru>
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

> > i dont care whether they are separate or not - but you have not 
> > replied to the request that there be a handle_web_request() function 
> > in /both/ files, which is precisely the same function. I didnt ask 
> > you to merge the two files - i only asked for the two web handling 
> > functions to be one and the same function.
> 
> They are not the same in general - if kevent is ready immediately, there 
> will not be its removing from kevent tree, but current kevent server has 
> it always not-immediately for lighttpd tests - so functions are the same:
> open()
> sendfile()
> cork_off
> close(fd)
> close(s)
> remove_event_from_the_kernel
> 
> with the same parameters.

you /STILL/ dont understand. I'm only talking about evserver_epoll.c and 
evserver_kevent.c. Not about lighttpd. Not about historic reasons. I 
simply suggested a common-sense change:

| | Would it be so hard to introduce a single handle_web_request() 
| | function that is exactly the same in the two tests? All the queueing 
| | details (which are of course different in the epoll and the kevent 
| | case) should be in the client function, which calls 
| | handle_web_request().

i.e. put remove_event_from_the_kernel() (kweb_kevent_remove()) and 
evtest_remove()) into a SEPARATE client function, which calls the 
/common/ handle_web_request(sock) function. You can do the 
immediate-removal in that separate, kevent-specific client function - 
but the socket function, handle_web_request(sock) should be /perfectly 
identical/ in the two files.

I.e.:

static inline int handle_web_request(int s)
{
	int err, fd, on = 0;
	off_t offset = 0;
	int count = 40960;
	char path[] = "/tmp/index.html";
	char buf[4096];
		
	err = recv(s, buf, sizeof(buf), 0);
	if (err <= 0)
		return err;

	fd = open(path, O_RDONLY);
	if (fd == -1)
		return fd;

	err = sendfile(s, fd, &offset, count);
	if (err < 0) {
		ulog_err("Failed send %d bytes: fd=%d.\n", count, s);
		close(fd);
		return err;
	}

	setsockopt(s, SOL_TCP, TCP_CORK, &on, sizeof(on));
	close(fd);
	close(s); /* No keepalive */

	return 0;
}

And in evserver_epoll.c do this:

static int evtest_callback_client(int s)
{
	int err = handle_web_request(s);
	if (err)
		evtest_remove(s);
	return err;
}

and in evserver_kevent.c do this:

static int kweb_callback_client(struct ukevent *e, int im)
{
	int err = handle_web_request(e->id.raw[0]);
	if (err || !im)
		kweb_kevent_remove(e);
	return err;
}

ok?

Btw., am i correct that in this particular 'ab' test, the 'immediately' 
flag is always zero, i.e. kweb_kevent_remove() is always called?

	Ingo
