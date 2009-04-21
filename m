Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbZDURNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbZDURNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZDURNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:13:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:56129 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbZDURNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:13:08 -0400
Subject: Re: Wait for console to become available, v3.2
From: David Woodhouse <dwmw2@infradead.org>
To: David Brownell <david-b@pacbell.net>, alan@lxorguk.ukuu.org.uk
Cc: Ingo Molnar <mingo@elte.hu>, David VomLehn <dvomlehn@cisco.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200904210013.48551.david-b@pacbell.net>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net>
	 <20090421064346.GB8020@elte.hu>  <200904210013.48551.david-b@pacbell.net>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 18:11:11 +0100
Message-Id: <1240333871.3632.70.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 00:13 -0700, David Brownell wrote:
> 
> Stepping back a moment from "how" to make sure "what" is agreed on.
> 
> I think I see three scenarios here:
> 
>  - Classic PC or server, where there's a meaningful console;
> 
>  - Deeply embedded systems, where there isn't;
> 
>  - Development stages of "deeply embedded", where there *may* be one.
> 
> If that's correct, then async_synchronize() isn't a full answer...
> 
> I think a fair number of cases can be papered over with a serial
> console with no hardware flow control, which isn't hooked up to
> anything.  Maybe the board needs a test/development jig to get one;
> without it, the "console" bits spill out into the aether.  Linux
> can dump bits to ttyS0, which will act like /dev/null.
> 
> But the problem case here seems to be one where such un-hooked-up
> serial ports are not realistic options.  Which is why the regression
> in USB console functionality has been troublesome.

We can provide un-hooked-up /dev/console though. Rather than just
failing to open it, why can't we make __tty_open() give you a dummy tty
driver which is basically equivalent to /dev/null? And then 'replace' it
with the real console driver if/when that later gets registered? The
latter will be a high-caffeine job, but surely not impossible?

The kernel output is going to be spewed when a console registers with
CON_PRINTBUFFER anyway, and if we printk a warning about userspace
console output being lost, that ought to be good enough to notify the
user that something may have been lost. For bonus points, we could even
make that 'dummy' tty driver buffer a limited amount of userspace
output, maybe.

If userspace cares, let _it_ wait, by using an ioctl to see what tty
device it's _really_ attached to.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

