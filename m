Return-Path: <linux-kernel-owner+w=401wt.eu-S1030296AbXCAV2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030296AbXCAV2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 16:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030297AbXCAV2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 16:28:16 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42212 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030296AbXCAV2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 16:28:15 -0500
Date: Thu, 1 Mar 2007 13:27:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>,
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
In-Reply-To: <20070228231228.GA12328@elte.hu>
Message-ID: <Pine.LNX.4.64.0703011322390.12485@woody.linux-foundation.org>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com>
 <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0702280836080.12485@woody.linux-foundation.org>
 <20070228231228.GA12328@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Mar 2007, Ingo Molnar wrote:
> 
> wrt. one-shot syscalls, the user-space stack footprint would still 
> probably be there, because even async contexts that only do single-shot 
> processing need to drop out of kernel mode to handle signals.

Why?

The easiest thing to do with signals is to just not pick them up. If the 
signal was to that *particular* threadlet (ie a "cancel"), then we just 
want to kill the threadlet. And if the signal was to the thread group, 
there is no reason why the threadlet should pick it up.

In neither case is there *any* reason to handle the signal in the 
threadlet, afaik.

And having to have a stack allocation for each threadlet certainly means 
that you complicate things a lot. Suddenly you have allocations that can't 
just go away. Again, I'm pointing to the problems I already pointed out 
with the allocations of the atom structures - quite often you do *not* 
want to keep track of anything specific for completion time, and that 
means that you MUST NOT have to de-allocate anythign either.

Again, think aio_read(). With the *exact* current binary interface. 
PLEASE. If you cannot emulate that with threadlets, then threadlets are 
*pointless*. On eof the major reasons for the whole exercise was to get 
rid of the special code in fs/aio.c.

So I repeat: if you cannot do that, and remain binary compatible, don't 
even bother.

		Linus
