Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbXEUQ16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbXEUQ16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759148AbXEUQ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:27:34 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:44568 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758913AbXEUQ1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:27:32 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH]serial: make early_uart to use early_prarm instead of console_initcall
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <Yinghai.Lu@sun.com>,
       Gerd Hoffmann <kraxel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <200705181900.17101.yinghai.lu@sun.com> <20070520202332.145d93a6.akpm@linux-foundation.org> <20070521104221.GU2012@bingen.suse.de>
In-Reply-To: <20070521104221.GU2012@bingen.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 21 May 2007 10:27:38 -0600
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705211027.38958.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 May 2007 04:42:21 am Andi Kleen wrote:
> On Sun, May 20, 2007 at 08:23:32PM -0700, Andrew Morton wrote:
> > I'll queue this up for some testing, but I'd be a bit reluctant to send it
> > into Linus due to my poor understanding of what it actually does.  What
> > _is_ an early console, and how does it differ from a non-early one?
> 
> It is someone's reimplemention of earlyprintk= for another architecture

I implemented 8250_early for ia64.  It is based on early_printk and
is quite similar to it.

One important difference is that early_printk has the "ttyS0 is at
0x3f8" knowledge compiled into it.  That doesn't work for ia64
because ttyS0 may be anywhere.

Since 8250_early doesn't assume the ttyS locations, you have to tell
it the device address, not the name.  Some ia64 firmware tells the OS
the address of the console device.  With 8250_early, if the user wants
the OS to use the same console as the firmware, he doesn't need any
"console=" argument at all.

The other important difference is that 8250_early tries to coordinate
with the normal 8250 console driver.  For example, if you use
"console=uart,io,0x3f8", 8250_early works like early_printk does,
and then automatically switches to the normal 8250 driver later.  With
early_printk, I think you would have to use "earlyprintk=serial,ttyS0
console=ttyS0" to do the same thing.

> that happens to mostly work on x86 too because the code is not ifdeffed.

8250_early has no arch dependency, so there's no reason to ifdef it.
It only depends on ioremap/inb/outb/readb/writeb.

> I don't think it makes much sense on x86 though because earlyprintk exists.

There are two reasons 8250_early might make sense on x86:

  - x86 firmware might someday tell the OS where the console is
    (e.g., via drivers/firmware/pcdp.c).  That requires a way to
    locate the device by its address, not by the name.

  - You only have to specify the console device once, not twice.

On the other hand, maybe you *want* the earlyprintk device to be
a different device than the regular console.  8250_early wouldn't
handle that very well.

Bjorn
