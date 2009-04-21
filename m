Return-Path: <linux-kernel-owner+w=401wt.eu-S1757717AbZDUT1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbZDUT1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbZDUT1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:27:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38422 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755111AbZDUT1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:27:01 -0400
Date: Tue, 21 Apr 2009 20:25:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       David Brownell <david-b@pacbell.net>, Ingo Molnar <mingo@elte.hu>,
       David VomLehn <dvomlehn@cisco.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090421202501.26a44f9d@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0904211016190.2199@localhost.localdomain>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net>
	<20090421064346.GB8020@elte.hu>
	<200904210013.48551.david-b@pacbell.net>
	<1240333871.3632.70.camel@macbook.infradead.org>
	<alpine.LFD.2.00.0904211016190.2199@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > failing to open it, why can't we make __tty_open() give you a dummy tty
> > driver which is basically equivalent to /dev/null? And then 'replace' it
> > with the real console driver if/when that later gets registered? The
> > latter will be a high-caffeine job, but surely not impossible?
> 
> This sounds like a good option. 

Don't confuse "/dev/console" and "the console device" in printk terms.
The two are not the same thing and the latter is subject to stuff like
redirection.

> thing, but it should be possible to just do something like
> 
> 	static struct tty_driver console_driver;

No - a console device can fail to open so you need to try the next one in
that situation. Some platforms use this feature.

> Anybody want to try it? Just make it ignore any IO if there are no 
> registered consoles. The patch shouldn't even be all that big, I suspect.

It will work, but on its own it won't actually fix the problem people
have, which is wanting to wait for a real console to appear. Extending it
to sleep (if not O_NDELAY) and loop back through the list when the list
changes would however do the trick, that or a tty device that buffers
then spews into the real device when it appears.

Definitely the right path, and we almost have every tty device in
existance containing a struct tty_port, at which point it gets even
cleaner.

The printk() console needs to buffer up data and replay it but we already
pretty much do what is needed even for vt consoles because the fb isn't
ready before the first printk.
