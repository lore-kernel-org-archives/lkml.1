Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZDUIEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZDUIEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZDUIEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:04:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53762 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbZDUIEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:04:09 -0400
Date: Tue, 21 Apr 2009 10:03:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: David VomLehn <dvomlehn@cisco.com>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090421080304.GA12512@elte.hu>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net> <20090421064346.GB8020@elte.hu> <200904210013.48551.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904210013.48551.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Brownell <david-b@pacbell.net> wrote:

> On Monday 20 April 2009, Ingo Molnar wrote:
>
> > The proper approach would be to use one of the 
> > async_synchronize*() facilities in kernel/async.c to properly 
> > order the opening of the console with device init.
> 
> Stepping back a moment from "how" to make sure "what" is agreed 
> on.
> 
> I think I see three scenarios here:
> 
>  - Classic PC or server, where there's a meaningful console;
> 
>  - Deeply embedded systems, where there isn't;
> 
>  - Development stages of "deeply embedded", where there *may* be 
>    one.
> 
> If that's correct, then async_synchronize() isn't a full answer...
> 
> I think a fair number of cases can be papered over with a serial 
> console with no hardware flow control, which isn't hooked up to 
> anything.  Maybe the board needs a test/development jig to get 
> one; without it, the "console" bits spill out into the aether.  
> Linux can dump bits to ttyS0, which will act like /dev/null.
> 
> But the problem case here seems to be one where such un-hooked-up 
> serial ports are not realistic options.  Which is why the 
> regression in USB console functionality has been troublesome.
> 
> Is that correct?

Not sure i understand the complication.

The practical issue addressed by this particular patch i've replied 
to is that if /dev/console is sys_open()-ed by an app "too early", 
an error code is returned and subsequently user-space (and all its 
child tasks) remain console-less.

Whether the console has flow control or not is immaterial. 
Initialization sequence ordering details should be transparent as 
far as sys_open() of a console is concerned.

If there is _no console_, then obviously there's nothing to wait for 
and the async wait will succeed immediately. The console driver 
still returns an error on sys_open() but that is expected behavior.

The solution proposed in the patch i'm replying to is a boot flag 
that causes the kernel to wait N milliseconds. This is incorrect and 
wrong on several levels. If the console can be initialized via a 
proper handshake that should be exposed precisely - we should not 
wait neither longer nor shorter than needed. _If_ there's no proper 
handshake and a magic delay is needed (because there's some 
hardware-internal delay needed at init time) before the console can 
be used then that should be in the console driver itself and the 
async-wait will wait for that automatically.

But never should we have delays like this in generic code. 
Regardless of embedded versus server versus desktop issues.

	Ingo
