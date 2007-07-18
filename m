Return-Path: <linux-kernel-owner+w=401wt.eu-S933026AbXGRVaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbXGRVaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbXGRVaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:30:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45819 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758742AbXGRVaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:30:22 -0400
Date: Wed, 18 Jul 2007 22:36:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Fulghum <paulkf@microgate.com>,
       James Simmons <jsimmons@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: Re: [PATCH] Use tty_schedule in VT code.
Message-ID: <20070718223613.143bb3b6@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.999.0707181303070.27353@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>
	<alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org>
	<469D2810.9080109@microgate.com>
	<alpine.LFD.0.999.0707171243220.27353@woody.linux-foundation.org>
	<Pine.LNX.4.64.0707172050180.9131@pentafluge.infradead.org>
	<alpine.LFD.0.999.0707171340360.27353@woody.linux-foundation.org>
	<Pine.LNX.4.64.0707181821150.28741@pentafluge.infradead.org>
	<1184783279.3444.15.camel@x2.microgate.com>
	<alpine.LFD.0.999.0707181303070.27353@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If a tty driver has marked itself low-latency, it's still wrong to do the 
> flush_to_ldisc() from interrupt context if a console event happens in 
> interrupt context.

It should be ok nowdays. Calling ld->receive() paths directly from an IRQ
is verboted however.

> I thought that was the whole *point* of the difference between 
> "tty_schedule_flip()" and "con_schedule_flip()", as far as I know. The 
> "con_schedule_flip()" can be called from any context (console messages), 
> while "tty_schedule_flip()" is only called from well-behaved tty layer.

I have no idea of the history of con_schedule_flip and I leave it alone 8)
> 
> But I really don't know. I used to be involved with the tty layer, these 
> days I'd rather avoid it. This "simple" patch seems to be anything but, 
> and I'd like somebody to just make sure that all the issues are taken care 
> of.
> 
> Alan?

For tty it is ok to call tty_flip_buffer_push from an IRQ. It is also ok
for this to do stuff based on the low latency flag. Any private internal
knowledge of that happens is at the drivers peril and may change.

We *need* low latency to do MIDI, Digitrax DCC and a few other things.

A driver which sets ->low_latency must allow its own write() method to be
called back as a result of calling tty_flip_buffer_push, and that
requires care on driver coding. (Arguably we should have a ->echo()
method for this but that opens other cans of worms)

Alan

