Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbXB1SXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbXB1SXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932215AbXB1SXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:23:00 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4774 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213AbXB1SW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:22:59 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Feb 2007 10:22:56 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
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
In-Reply-To: <Pine.LNX.4.64.0702280836080.12485@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702281011220.6806@alien.or.mcafeemobile.com>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com>
 <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0702280836080.12485@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Linus Torvalds wrote:

> On Wed, 28 Feb 2007, Davide Libenzi wrote:
> > 
> > At this point, given how threadlets can be easily/effectively dispatched 
> > from userspace, I'd argue the presence of either single/parallel or syslet 
> > submission altogether. Threadlets allows you to code chains *way* more 
> > naturally than syslets, and since they basically are like functions calls 
> > in the fast path, they can be used even for single/parallel submissions. 
> 
> Well, I agree, except for one thing:
>  - user space execution is *inherently* more expensive.
> 
> Why? Stack. Stack. Stack.
> 
> If you support threadlets with user space code, it means that you need a 
> separate user-space stack for each threadlet. That's a potentially *big* 
> cost to bear, both from a setup standpoint and from simply a memory 
> allocation standpoint.

Right, point taken.



> In short - the only thing I *don't* think is a great idea are those linked 
> lists of atoms. I still think it's a pretty horrible interface, and I 
> still don't think it really buys us very much. The only way it would buy 
> us a lot is to change the linked lists dynamically (ie add new events at 
> the end while old events are still executing), but quite frankly, that 
> just makes the whole interface *even*worse* and just makes me have 
> debugging nightmares (I'm also not even convinced it really would help 
> us: we might avoid some costs of adding new events, but it would only 
> avoid them for serial execution, and if the whole point of this is to 
> execute things in parallel, that's a stupid thing to do).
> 
> So I would repeat my call for getting rid of the atoms, and instead just 
> do a "single submission" at a time. Do the linking by running a threadlet 
> that has user space code (and the stack overhead), which is MUCH more 
> flexible. And do nonlinked single system calls without *either* atoms *or* 
> a user-space stack footprint.

Here we very much agree. The way I'd like it:

struct async_syscall {
	unsigned long nr_sysc;
	unsigned long params[8];
	long result;
};

int async_exec(struct async_syscall *a, int n);

or:

int async_exec(struct async_syscall **a, int n);

At this point I'm ok even with the userspace ring buffer, returning 
back pointers to "struct async_syscall".




- Davide


