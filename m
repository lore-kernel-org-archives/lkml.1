Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358AbXLKJwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbXLKJwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 04:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbXLKJv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 04:51:57 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:34617 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbXLKJv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 04:51:56 -0500
Message-ID: <475E5D4B.8020101@keyaccess.nl>
Date: Tue, 11 Dec 2007 10:50:03 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Paul Rolland <rol@as2917.net>
CC: David Newall <david@davidnewall.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net>
In-Reply-To: <20071211084059.3d03e11d@tux.DEF.witbe.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-07 08:40, Paul Rolland wrote:

> Well, if the delay is so much unspecified, what about _reading_ port 0x80 ?
> Will the delay be shorter ?

The delay is completely and fully specified in terms of the ISA/LPC clock 
which certainly for anything modern means a fixed, unchanging value 
(something very close to 1 us) and even on older PCs that allow some 
tweaking just means a delay synced to the actual bus clock which is what the 
_p variants should normally want to accomplish.

Yes, as far as I'm aware, an inb() means the same delay but clobbers 
register al meaning you need a bloating save/restore sequence around it.

> And if so, what about reading port 0x80 and writing the value back ? inb
> al,0x80 outb 0x80,al

See? Moreover, this also only makes sense if there's in fact something 
responding to reads at 0x80 and with port 0x80 being a well-known legacy PC 
port, a POST monitor would be just about that and writing to _that_ would 
seem unlikely to have any ill effects other than turning your POST board LED 
display into a christmas tree. The problem more likely is some piece of 
hardware getting upset at LPC bus aborts and your suggestion wouldn't fix that.

In earlier incarnations of this thread it's been reported that various 
implementations of the legacy PC timer, DMA controller and PIC needed the 
delay but just replacing the outb with a udelay(1) would seem very likely to 
have the desired effect also for those.

The only problem with _that_ is that you need a calibrated timing loop first 
which means not-very-early boot (ie, not while you try to program the timer 
to calibrate the loop for example). Pavel Machek already posted a patch, 
although with an overly pessimistic delay value.

The problem here is with an x86-64 machine that very likely does not need 
any delay at all in fact. One thing to do would be to make _any_ delay 
dependent on 32-bit but given that 64-bit machines can run 32-bit kernels 
this doesn't fix things fully, although it probably does in practice.

Keying of DMI for any delay could be possible. But if the simple udelay(1) 
just works, all the better.

Rene.

