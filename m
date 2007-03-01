Return-Path: <linux-kernel-owner+w=401wt.eu-S965544AbXCATr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965544AbXCATr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965546AbXCATr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:47:28 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1993 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965544AbXCATr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:47:27 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 1 Mar 2007 11:47:24 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <200703011632.37756.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703011131530.23932@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org>
 <20070301144717.GA24079@elte.hu> <20070301152323.GA8217@2ka.mipt.ru>
 <200703011632.37756.dada1@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Oh boy, wasn't this thread supposed to focus the syslets/threadlets ... :)



On Thu, 1 Mar 2007, Eric Dumazet wrote:

> On Thursday 01 March 2007 16:23, Evgeniy Polyakov wrote:
> > They are there, since ab runs only 50k requests.
> > If I change it to something noticebly more than 50/80k, ab crashes:
> > # ab -c8000 -t 600 -n800000000 http://192.168.0.48/
> > This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
> > Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
> > Copyright 2006 The Apache Software Foundation, http://www.apache.org/
> >
> > Benchmarking 192.168.0.48 (be patient)
> > Segmentation fault
> >
> > Are there any other tool suitable for such loads?
> > I only tested httperf (which is worse, since it uses poll/select) and
> > 'ab'.
> >
> > Btw, host machine runs 100% too, so it is possible that client side is
> > broken (too).
> 
> I have similar problems here, ab test just doesnt complete...
> 
> I am still investigating with strace and tcpdump.
> 
> In the meantime you could just rewrite it (based on epoll please :) ), since 
> it should be quite easy to do this (reverse of evserver_epoll)

I have a simple one based on coroutines and epoll. You need libpcl and 
coronet. Debian hs a package named libpcl1-dev for libpcl, otherwise:

http://www.xmailserver.org/libpcl.html

and 'configure --prefix=/usr && sudo make install'.
Coronet is here:

http://www.xmailserver.org/coronet-lib.html

here just 'configure && make'.
Inside the "test" directory there a simple loader named cnhttpload:

  cnhttpload -s HOST -n NCON [-p PORT (80)] [-r NREQS (1)] [-S STKSIZE (8192)]
             [-M MAXCONNS] [-t TMUPD (1000)] [-a NACTIVE] [-T TMSAMP (200)]
             [-h] URL ...

HOST      = Target host
PORT      = Target host port
NCON      = Number of connections to the server
NACTIVE   = Number of active (live) connections
STKSIZE   = Stack size for coroutines
NREQS     = Number of request done for each connection (better be 1 if 
            your server do not support keep-alive)
MAXCONNS  = Maximum number of total connections done to the server. If not 
            set, the test will continue forever (well, till a ^C)
TMUPD     = Millisec time of stats update
TMSAMP    = Millisec internal average-update time
URL       = Target doc (not http:// or host, just doc path)

So for the particular test my inbox was flooded with :), you'd use:

cnhttpload -s HOST -n 80000 -a 8000 -S 4096




- Davide


