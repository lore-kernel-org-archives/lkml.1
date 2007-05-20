Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbXETUrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbXETUrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 16:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756279AbXETUr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 16:47:26 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:39746 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186AbXETUrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 16:47:25 -0400
Date: Sun, 20 May 2007 22:38:08 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Folkert van Heusden <folkert@vanheusden.com>
cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Andi Kleen <ak@suse.de>,
       Rik van Riel <riel@redhat.com>, righiandr@users.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
In-Reply-To: <20070520161159.GD22452@vanheusden.com>
Message-ID: <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr>
References: <464C81B5.8070101@users.sourceforge.net> <464C9D82.60105@redhat.com>
 <Pine.LNX.4.61.0705180825280.3231@yvahk01.tjqt.qr> <200705181347.14256.ak@suse.de>
 <Pine.LNX.4.61.0705190946430.9015@yvahk01.tjqt.qr> <20070520001418.GJ14578@vanheusden.com>
 <464FC6AA.2060805@cosmosbay.com> <20070520112111.GN14578@vanheusden.com>
 <20070520090809.4f42d71d@freepuppy> <20070520161159.GD22452@vanheusden.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 20 2007 18:12, Folkert van Heusden wrote:
>> >  
>> > +	if (unlikely(sig == SIGQUIT || sig == SIGILL  || sig == SIGTRAP ||
>> > +	    sig == SIGABRT || sig == SIGBUS  || sig == SIGFPE  ||
>> > +	    sig == SIGSEGV || sig == SIGXCPU || sig == SIGXFSZ ||
>> > +	    sig == SIGSYS  || sig == SIGSTKFLT))
>> > +	{
>> > +		printk(KERN_WARNING "Sig %d send to %d owned by %d.%d (%s)\n",
>> > +			sig, t->pid, t->uid, t->gid, t->comm);
>> > +	}
>> > +
>> >  	/*
>> >  	 * fast-pathed signals for kernel-internal things like SIGSTOP
>> >  	 * or SIGKILL.
>> 
>> Would turning that into a switch() generate better code.

Yes, this time.

>Doubt it: in the worst case you still nee to check for each possibility.
>Furthermore a.f.a.i.k. with switch you cannot do 'unlinkely()'.

With if(), it generates a ton of "CMP, JE" instructions.
With switch(), I would assume gcc transforms it into using
a jump table (aka "JMP [table+sig]")

I tried it: with switch(), gcc transforms this into a
bitmap comparison ("MOV eax, 1; SHL eax, sig; TEST eax, 0x830109f8"),
which seems even cheaper than a jump table.


	Jan
-- 
