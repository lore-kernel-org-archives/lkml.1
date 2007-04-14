Return-Path: <linux-kernel-owner+w=401wt.eu-S1030892AbXDNOqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030892AbXDNOqJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 10:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030893AbXDNOqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 10:46:09 -0400
Received: from 1wt.eu ([62.212.114.60]:1863 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030892AbXDNOqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 10:46:08 -0400
Date: Sat, 14 Apr 2007 16:45:44 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414144544.GO943@1wt.eu>
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <20070414132732.GA22103@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414132732.GA22103@1wt.eu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 03:27:32PM +0200, Willy Tarreau wrote:
> On Sat, Apr 14, 2007 at 03:01:01PM +0200, Willy Tarreau wrote:
> > 
> > Well, I'll stop heating the room for now as I get out of ideas about how
> > to defeat it.
> 
> Ah, I found something nasty.
> If I start large batches of processes like this :
> 
> $ for i in $(seq 1 1000); do ./scheddos2 4000 4000 & done
> 
> the ramp up slows down after 700-800 processes, but something very
> strange happens. If I'm under X, I can switch the focus to all xterms
> (the WM is still alive) but all xterms are frozen. On the console,
> after one moment I simply cannot switch to another VT anymore while
> I can still start commands locally. But "chvt 2" simply blocks.
> SysRq-K killed everything and restored full control. Dmesg shows lots
> of :
> SAK: killed process xxxx (scheddos2): process_session(p)==tty->session.
> 
> I wonder if part of the problem would be too many processes bound to
> the same tty :-/

Does not seem easy to reproduce, it looks like some resource pools are
kept pre-allocated after a first run, because if I kill scheddos during
the ramp up then start it again, it can go further. The problem happens
when the parent is forking. Also, I modified scheddos to close(0,1,2)
and to perform the forks itself and it does not cause any problem, even
with 4000 processes running. So I really suspect that the problem I
encountered above was tty-related.

BTW, I've tried your fork patch. It definitely helps forking because it
takes below one second to create 4000 processes, then the load slowly
increases. As you said, the children have to earn their share, and I
find that it makes it easier to conserve control of the whole system's
stability.

Regards,
Willy

