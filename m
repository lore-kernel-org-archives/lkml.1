Return-Path: <linux-kernel-owner+w=401wt.eu-S965054AbXBYSBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965054AbXBYSBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 13:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932980AbXBYSBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 13:01:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54208 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932635AbXBYSBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 13:01:12 -0500
Date: Sun, 25 Feb 2007 18:54:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070225175437.GA9480@elte.hu>
References: <20070221211355.GA7302@elte.hu> <20070224183421.GA6835@2ka.mipt.ru> <20070225172337.GB4998@elte.hu> <20070225174438.GA13647@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225174438.GA13647@2ka.mipt.ru>
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


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> > hm, what tree are you using as a base? The syslet patches are 
> > against v2.6.20 at the moment. (the x86 PDA changes will probably 
> > interfere with it on v2.6.21-rc1-ish kernels) Note that otherwise 
> > the syslet/threadlet patches are for x86 only at the moment (as i 
> > mentioned in the announcement), and the generic code itself contains 
> > some occasional x86-ishms as well. (None of the concepts are 
> > x86-specific though - multi-stack architectures should work just as 
> > well as RISC-ish CPUs.)
> 
> It is rc1 - and crashes.

yeah. I'm not surprised. The PDA is not set up in create_async_thread() 
for example.

> > if you create a threadlet based test-webserver, could you please do 
> > a comparable kevents implementation as well? I.e. same HTTP parser 
> > (or non-parser, as usually the case is with prototypes ;). Best 
> > would be something that one could trigger between threadlet and 
> > kevent mode, using the same binary :-)
> 
> Ok, I will create such a monster tomorrow :)
> 
> I will use the same base for threadlet as for kevent/epoll - there is 
> no parser, just sendfile() of the static file which contains http 
> header and actual page.
> 
> threadlet1 {
> 	accept() 
> 	create threadlet2 {
> 		send data
> 	}
> }
> 
> Is above scheme correct for threadlet scenario?

yep, this is a good first cut. Doing this after the listen() is useful:

        int one = 1;

        ret = setsockopt(listen_sock_fd, SOL_SOCKET, SO_REUSEADDR,
			 (char *)&one, sizeof(int));

and i'd suggest to do this after every accept()-ed socket:

        int flag = 1;

        setsockopt(sock_fd, IPPROTO_TCP, TCP_NODELAY,
                            (char *) &flag, sizeof(int));

Do you have any link where i could check the type of HTTP parsing and 
send transport you are (or will be) using? What type of http client are 
you using to measure, with precisely what options?

> But note, that on my athlon64 3500 test machine kevent is about 7900 
> requests per second compared to 4000+ epoll, so expect a challenge.

single-core CPU i suspect?

> lighhtpd is about the same 4000 requests per second though, since it 
> can not be easily optimized for kevents.

mean question: do you promise to post the results even if they are not 
unfavorable to threadlets? ;-)

if i want to test kevents on a v2.6.20 kernel base, do you have an URL 
for me to try?

	Ingo
