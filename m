Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbYKPQ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbYKPQ5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYKPQ5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:57:13 -0500
Received: from science.horizon.com ([192.35.100.1]:18436 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752391AbYKPQ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:57:13 -0500
Message-ID: <20081116165711.17768.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Sun, 16 Nov 2008 11:57:11 -0500
To: alan@lxorguk.ukuu.org.uk
Cc: tytso@mit.edu, linux@horizon.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] serial/8250.c: Use self-adjusting list for port poll
 order.
References: <20081113150308.3590.qmail@science.horizon.com>
 <20081114053042.11532.qmail@science.horizon.com>
 <20081114053314.12093.qmail@science.horizon.com>
 <20081114213449.14960.qmail@science.horizon.com>
 <20081114214711.3c1d1473@lxorguk.ukuu.org.uk>
 <20081115001013.GM25117@mit.edu>
 <20081116152352.20261.qmail@science.horizon.com>
 <20081116155103.22e09a9a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081116155103.22e09a9a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>> In desktop hardware, yes.  But PC-104 equipment (for the benefit of
>> confused bystandaers, that's classic ISA bus in a different form factor)
>> is still going strong; I just added an 8-port serial card to a little
>
> Oh dear. I thought the compact PCI people had exterminated that dinosaur.

Oh, I agree that it's dying, but it'll take longer to die that the third
act of Tristan und Isolde.  (Or the even more gruesome tale of Erasmus
of Formiae.)

This is PC hardware; the long tail is very long indeed.  Didn't you just
read that Microsoft stopped selling Windows 3.1 licenses just this month?
And the people upset because they're still using it in production?
http://news.bbc.co.uk/1/hi/technology/7707016.stm

>> But even PCI reads are slow, and the current code does not optimize the
>> case when interrupts are level-sensitive.  (The optimization is trivial,
>> but detecting whether the interrupt is edge- or level-sensitive looks
>> messy.)
>
> I think you would need to remember that when the port was configured
> initially, but yes that would be a much more useful change for most users.
>
>> The real over-optimization argument that I can think of is that emptying 8 bytes
>> out of a FIFO involves 16 register reads (LSR + receive data for each byte),
>> compared to which the time to poll a few IIRs is not too much.  (Of course, then
>> there's low_latency mode.)
>
> So perhaps the right way to approach this is to use two IRQ handlers, one
> for level triggered interrupts which doesn't keep polling, and one for
> edge triggered which expects the single device case but can re-order your
> device scans as you propose.

That's possible, but is it really worth two separate code paths?
The entire idea is based on the fact that even uncached memory accesses
are faster than I/O reads, so a few more conditions in the polling loop
should not be a problem.  The rearrangement is already conditional (on
whether it would just be an effective no-op), and there is already a
test for reaching the end of the ports list.

> That would make PCI handling faster, keep normal ISA handling the same
> (and with no extra complexity for a list of length one device) and speed
> up the case you care about ?
>
> Does that seem practical ?

Yes it does, but I could use some help figuring out how to distinguish
different interrupt types at run-time.  Is there a way that doesn't involve
arch-specific code?

Thank you!
