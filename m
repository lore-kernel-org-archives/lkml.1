Return-Path: <linux-kernel-owner+w=401wt.eu-S932567AbXBWLTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbXBWLTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932571AbXBWLTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:19:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42462 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932567AbXBWLS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:18:58 -0500
Date: Fri, 23 Feb 2007 12:12:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: johnpol@2ka.mipt.ru, arjan@infradead.org, drepper@redhat.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       hch@infradead.org, akpm@zip.com.au, alan@lxorguk.ukuu.org.uk,
       zach.brown@oracle.com, suparna@in.ibm.com, davidel@xmailserver.org,
       jens.axboe@oracle.com, tglx@linutronix.de
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070223111245.GF22870@elte.hu>
References: <20070222143145.GA3246@elte.hu> <20070222.064704.71093028.davem@davemloft.net> <20070222151509.GA13670@elte.hu> <20070222.091735.30182079.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222.091735.30182079.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> > furthermore, in a real webserver there's a whole lot of other stuff 
> > happening too: VFS blocking, mutex/lock blocking, memory pressure 
> > blocking, filesystem blocking, etc., etc. Threadlets/syslets cover 
> > them /all/ and never hold up the primary context: as long as there's 
> > more requests to process, they will be processed. Plus other 
> > important networked workloads, like fileservers are typically on 
> > fast LANs and those requests are very much a fire-and-forget matter 
> > most of the time.
> 
> I expect clients of a fileserver to cause the server to block in 
> places such as tcp_sendmsg() as much if not more so than a webserver
> :-)

yeah, true. But ... i'd still like to midly disagree with the 
characterisation that due to blocking being the norm in networking, that 
this goes against the concept of syslets/threadlets.

Networking has a 'work cache' too, in an abstract sense, which works in 
favor of syslets: the socket buffers. If there is a reasonably sized 
output queue for sockets (not extremely small like 4k per socket but 
something at least 16k), then user-space can chunk up its workload along 
pretty reasonable lines without assuming too much, and turn one such 
'chunk' into one atomic step done in the 'syslet/threadlet request'. In 
the rare cases where blocking happens in an unexpected way, the 
syslet/threadlet 'goes async' but that only holds up that particular 
request, and only for that chunk, not the main loop of processing and 
doesnt force the request into an async thread forever.

the kevent model is very much about: /never every/ block the main 
thread. If you ever block, performance goes down the drain.

the syslet performance model is: if you block less than say 10-20% of 
the time, you are basically as fast as the most extreme kevents based 
model. Syslets/threadlets also avoids the fundamental workflow problem 
that nonblocking designs have in a natural way: 'how do we guarantee 
that the system progresses forward', which problem makes nonblocking 
code quite fragile.

another property is that the performance curve is alot less sensitive to 
blocking in the syslet model - and real user-space servers will always 
have unexpected points of blockage - unless all of userspace code is 
perfectly converted into state machines - which is not reasonable. So 
with syslets we are not forced to program everything as state-machines 
in user-space, such techniques are only needed to reduce the amount of 
context-switching and to reduce the RAM footprint - they wont change 
fundamental scalability.

plus there's the hidden advantage of having a 'constructed state' on the 
kernel stack: thread that blocks in the middle of tcp_sendmsg() has 
quite some state: the socket has been looked up in the hash(es), all 
input parameters have been validated, the timer has been set, skbs have 
been allocated ahead, etc. Those things do add up especially if you are 
after a long wait and all those things are scattered around the memory 
map cache-cold - not nicely composed into a single block of memory on 
the stack (generating only a single cachemiss in essence).

All in one, i'm cautiosly optimistic that even a totally naive, 
blocks-itself-for-every-request syslet application would perform pretty 
close to a Tux/kevents type of nonblock+event-queueing based application 
- with a vastly higher generic utility benefit. So i'm not dismissing 
this possibility and i'm not writing off syslet performance just because 
they do context-switches :-)

	Ingo
