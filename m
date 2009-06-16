Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbZFPKYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbZFPKYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZFPKYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:24:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42815 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbZFPKY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:24:29 -0400
Date: Tue, 16 Jun 2009 12:24:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] WARNING: at drivers/char/tty_io.c:1266
	tty_open+0x1ea/0x388()
Message-ID: <20090616102418.GC28204@elte.hu>
References: <20090614081052.GA9276@elte.hu> <20090614115428.1127ed2d@lxorguk.ukuu.org.uk> <20090616071057.GA29862@elte.hu> <20090616111316.6b3bb078@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616111316.6b3bb078@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > I have applied your patch from yesterday (attached further below for 
> > reference) and the SLAB corruption has not triggered - instead i'm 
> > now getting this warning, after 96 reboots
> 
> That one is interesting btw - however its not a new bug. The 
> WARN_ON() was added in the new patches to catch cases where the 
> tty open/close locking was broken and see if all the ldisc related 
> ones were nailed.
> 
> Apparently on a very SMP box they are not. It's not however a new 
> bug - just the result of checking for the problem.
> 
> +        WARN_ON(!test_bit(TTY_LDISC, &tty->flags));
> 
> 
> ..
> 
> which means that someone cleared the ldisc behind our back despite 
> us holding tty_mutex. That would suggest a hangup/reopen race 
> which shouldn't be too hard to find.
> 
> Dunno what you feed your SMP box but its very useful 8)

it's plain old-fashioned brute force plus a randconfig search: if a 
race is possible it will trigger eventually here, given the right 
hardware (i use a number of different systems), given the right 
user-space (i use heterogenous installations), given the right 
compiler/binutils (that too is heterogenous) and the right timing 
and kernel feature combo via a huge, 2^1000 randconfig space.

Plus this system is an old P4 HyperThreading dual-socket system: 
pretty much the only thing HyperThreading is good for on that box is 
finding SMP races: that CPU can (and will) yield between 
hyperthreads on arbitrary instruction boundaries - opening up races 
wide open.

In fact we had races in the past that would only trigger on that 
box, ever. (note that this warning did trigger on another box as 
well - after 350+ bootups ...) And we thought P4-HT is pure crap ;-)

	Ingo
