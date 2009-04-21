Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZDURkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZDURkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbZDURkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:40:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392AbZDURkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:40:05 -0400
Date: Tue, 21 Apr 2009 10:31:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Woodhouse <dwmw2@infradead.org>
cc: David Brownell <david-b@pacbell.net>, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, David VomLehn <dvomlehn@cisco.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
In-Reply-To: <1240333871.3632.70.camel@macbook.infradead.org>
Message-ID: <alpine.LFD.2.00.0904211016190.2199@localhost.localdomain>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net>  <20090421064346.GB8020@elte.hu>  <200904210013.48551.david-b@pacbell.net> <1240333871.3632.70.camel@macbook.infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Apr 2009, David Woodhouse wrote:
> 
> We can provide un-hooked-up /dev/console though. Rather than just
> failing to open it, why can't we make __tty_open() give you a dummy tty
> driver which is basically equivalent to /dev/null? And then 'replace' it
> with the real console driver if/when that later gets registered? The
> latter will be a high-caffeine job, but surely not impossible?

This sounds like a good option. 

Right now we look through all the console_drivers at open time in that

	struct tty_driver *console_device(int *index)

thing, but it should be possible to just do something like

	static struct tty_driver console_driver;

and then just make "console_device()" always return _that_ tty driver 
instead. Then, we could make that console_device tty driver just at 
run-time spread the IO to the proper device(s), rather than fix the one 
particular device at "open()" time.

[ Actually, looking closer we should not use that particular name: we 
  already have something called a "console_driver" which is really the 
  "current VT" driver.

  So we should call it 'system_console_device' or something, but you 
  get the idea. ]

Anybody want to try it? Just make it ignore any IO if there are no 
registered consoles. The patch shouldn't even be all that big, I suspect.

		Linus
