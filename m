Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYKPPYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYKPPYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 10:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYKPPXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 10:23:55 -0500
Received: from science.horizon.com ([192.35.100.1]:16949 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752054AbYKPPXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 10:23:54 -0500
Message-ID: <20081116152352.20261.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Sun, 16 Nov 2008 10:23:52 -0500
To: tytso@mit.edu, alan@lxorguk.ukuu.org.uk
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] serial/8250.c: Use self-adjusting list for port poll
 order.
References: <20081113150308.3590.qmail@science.horizon.com>
 <20081114053042.11532.qmail@science.horizon.com>
 <20081114053314.12093.qmail@science.horizon.com>
 <20081114213449.14960.qmail@science.horizon.com>
 <20081114214711.3c1d1473@lxorguk.ukuu.org.uk>
 <20081115001013.GM25117@mit.edu>
In-Reply-To: <20081115001013.GM25117@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> wrote:
> On Fri, Nov 14, 2008 at 09:47:11PM +0000, Alan Cox wrote:
>>> This code does that by using the previous poll cycles as a hint.
>>> If a port is idle, it will migrate to the end of the list and
>>> only have to be checked once.
>> 
>> Is it really worth the complexity?
>> 
>> - PCI ports are shared IRQ always
>> - Legacy ports are almost never shared IRQ on the LPC bus (and are
>> increasingly going away)
>
> It's worth the complexity only *if* you have enough ports shared on a
> single IRQ and simultaneously such that there a risk that if you don't
> poll them quickly enough, characters will actually get dropped from
> the UART's FIFO.  The question is whether that is likely to happen on
> modern CPUs.  I worred about such things when I tried to make 16
> 115kbps serial ports work at full-speed using relatively primitive
> 16550A UARTs with 16 character FIFOs on a 40 MHz 386.  But (a)
> UARTs generally have deeper FIFOs these days, and (b) CPUs have
> gotten a wee bit faster since 1992.
>
> So color me dubious that this is actually necessary....

First of all, thank you both for the feedback.

Re: shared IRQs and PCI bus...
In desktop hardware, yes.  But PC-104 equipment (for the benefit of
confused bystandaers, that's classic ISA bus in a different form factor)
is still going strong; I just added an 8-port serial card to a little
embedded box.

But even PCI reads are slow, and the current code does not optimize the
case when interrupts are level-sensitive.  (The optimization is trivial,
but detecting whether the interrupt is edge- or level-sensitive looks
messy.)


Regarding the purpose of the patch...
The goal is not fewer dropped characters (although there could be a small
benefit in that direction), and it doesn't improve worst-case timing;
the goal is to reduce the time spent in the interrupt handler _on average_
and thereby make more CPU available for other work.

The idea is that, if you have 4 ports sharing an interrupt, and the fourth
is the one that's busy, you'll check every port twice.  If you could check
the busy port first, you'd only need to to do 5 checks.


The real over-optimization argument that I can think of is that emptying 8 bytes
out of a FIFO involves 16 register reads (LSR + receive data for each byte),
compared to which the time to poll a few IIRs is not too much.  (Of course, then
there's low_latency mode.)
