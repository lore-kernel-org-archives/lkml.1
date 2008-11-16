Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbYKPPvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbYKPPvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 10:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYKPPv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 10:51:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56003 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750988AbYKPPv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 10:51:27 -0500
Date: Sun, 16 Nov 2008 15:51:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "George Spelvin" <linux@horizon.com>
Cc: tytso@mit.edu, linux@horizon.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] serial/8250.c: Use self-adjusting list for port poll
 order.
Message-ID: <20081116155103.22e09a9a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081116152352.20261.qmail@science.horizon.com>
References: <20081113150308.3590.qmail@science.horizon.com>
	<20081114053042.11532.qmail@science.horizon.com>
	<20081114053314.12093.qmail@science.horizon.com>
	<20081114213449.14960.qmail@science.horizon.com>
	<20081114214711.3c1d1473@lxorguk.ukuu.org.uk>
	<20081115001013.GM25117@mit.edu>
	<20081116152352.20261.qmail@science.horizon.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In desktop hardware, yes.  But PC-104 equipment (for the benefit of
> confused bystandaers, that's classic ISA bus in a different form factor)
> is still going strong; I just added an 8-port serial card to a little

Oh dear. I thought the compact PCI people had exterminated that dinosaur.

> But even PCI reads are slow, and the current code does not optimize the
> case when interrupts are level-sensitive.  (The optimization is trivial,
> but detecting whether the interrupt is edge- or level-sensitive looks
> messy.)

I think you would need to remember that when the port was configured
initially, but yes that would be a much more useful change for most users.

> The real over-optimization argument that I can think of is that emptying 8 bytes
> out of a FIFO involves 16 register reads (LSR + receive data for each byte),
> compared to which the time to poll a few IIRs is not too much.  (Of course, then
> there's low_latency mode.)

So perhaps the right way to approach this is to use two IRQ handlers, one
for level triggered interrupts which doesn't keep polling, and one for
edge triggered which expects the single device case but can re-order your
device scans as you propose.

That would make PCI handling faster, keep normal ISA handling the same
(and with no extra complexity for a list of length one device) and speed
up the case you care about ?

Does that seem practical ?

Alan
