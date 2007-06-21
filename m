Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbXFUUvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbXFUUvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756702AbXFUUvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:51:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56043 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755758AbXFUUvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:51:15 -0400
Date: Thu, 21 Jun 2007 13:48:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <20070621203013.GA466@elte.hu>
Message-ID: <alpine.LFD.0.98.0706211342230.3593@woody.linux-foundation.org>
References: <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com>
 <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
 <20070621202917.a2bfbfc7.dada1@cosmosbay.com>
 <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
 <alpine.LFD.0.98.0706211230130.3593@woody.linux-foundation.org>
 <20070621200941.GB22303@elte.hu> <alpine.LFD.0.98.0706211311350.3593@woody.linux-foundation.org>
 <20070621203013.GA466@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Ingo Molnar wrote:
> 
> damn, i first wrote up an explanation about why that ugly __delay(1) is 
> there (it almost hurts my eyes when i look at it!) but then deleted it 
> as superfluous :-/

I'm fine with a delay, but the __delay(1) is simply not "correct". It 
doesn't do anything.

"udelay()" waits for a certain time. Use that. 

> the reason for the __delay(1) was really mundane: to be able to figure 
> out when to print a 'we locked up' message to the user.

No it does not.

You may think it does, but it does nothing of the sort.

Use "udelay()" or somethign that actually takes a *time*.

Just __delay() is nothing but a loop, and calling it with an argument of 1 
is stupid and buggy. 

The only *possibly* valid use of "__delay()" implies using a counter that 
is based on the "loops_per_sec" thing, which depends on what the delay  
function actually is.

For example, the delay function may well turn out to be this:

        __asm__ __volatile__(
                "\tjmp 1f\n"
                ".align 16\n"
                "1:\tjmp 2f\n"
                ".align 16\n"
                "2:\tdecl %0\n\tjns 2b"
                :"=&a" (d0)
                :"0" (loops));

Notice? "Your code, it does nothing!"

When I said that the code was buggy, I meant it.

It has nothing to do with spinlocks. And "__delay(1)" is *always* a bug.

You migth want to replace it with

	smp_rmb();
	udelay(1);

instead, at which point it *does* something: it has that read barrier 
(which is not actually needed on x86, but whatever), and it has a delay 
that is *meaningful*.

A plain "__delay(1)" is neither.

So let me repeat my statement: "What a piece of crap".

		Linus
