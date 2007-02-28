Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbXB1QuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbXB1QuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 11:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbXB1QuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 11:50:00 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33327 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbXB1Qt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 11:49:59 -0500
Date: Wed, 28 Feb 2007 08:42:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0702280836080.12485@woody.linux-foundation.org>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com>
 <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Feb 2007, Davide Libenzi wrote:
> 
> At this point, given how threadlets can be easily/effectively dispatched 
> from userspace, I'd argue the presence of either single/parallel or syslet 
> submission altogether. Threadlets allows you to code chains *way* more 
> naturally than syslets, and since they basically are like functions calls 
> in the fast path, they can be used even for single/parallel submissions. 

Well, I agree, except for one thing:
 - user space execution is *inherently* more expensive.

Why? Stack. Stack. Stack.

If you support threadlets with user space code, it means that you need a 
separate user-space stack for each threadlet. That's a potentially *big* 
cost to bear, both from a setup standpoint and from simply a memory 
allocation standpoint.

Quite frankly, I think threadlets are a great idea, but I think the lack 
of user-level footprint is *also* a great idea, and you should support 
both.

In short - the only thing I *don't* think is a great idea are those linked 
lists of atoms. I still think it's a pretty horrible interface, and I 
still don't think it really buys us very much. The only way it would buy 
us a lot is to change the linked lists dynamically (ie add new events at 
the end while old events are still executing), but quite frankly, that 
just makes the whole interface *even*worse* and just makes me have 
debugging nightmares (I'm also not even convinced it really would help 
us: we might avoid some costs of adding new events, but it would only 
avoid them for serial execution, and if the whole point of this is to 
execute things in parallel, that's a stupid thing to do).

So I would repeat my call for getting rid of the atoms, and instead just 
do a "single submission" at a time. Do the linking by running a threadlet 
that has user space code (and the stack overhead), which is MUCH more 
flexible. And do nonlinked single system calls without *either* atoms *or* 
a user-space stack footprint.

Please? 

What am I missing?

		Linus
