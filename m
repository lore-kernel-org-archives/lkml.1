Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbXHBO52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbXHBO52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 10:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbXHBO5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 10:57:20 -0400
Received: from rtr.ca ([64.26.128.89]:3190 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbXHBO5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 10:57:19 -0400
Message-ID: <46B1F0CB.9060106@rtr.ca>
Date: Thu, 02 Aug 2007 10:57:15 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Robert Hancock <hancockr@shaw.ca>, Lee Howard <faxguy@howardsilvan.com>,
       linux-serial@vger.kernel.org, tytso@mit.edu,
       linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no> <46A84B4A.6070902@shaw.ca> <46A8C6F1.4080309@howardsilvan.com> <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl> <46AA2748.80703@howardsilvan.com> <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl> <46AA3801.7090204@shaw.ca> <20070728092842.GC26443@flint.arm.linux.org.uk> <Pine.LNX.4.64N.0707301040320.12082@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0707301040320.12082@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Sat, 28 Jul 2007, Russell King wrote:
> 
>> Essentially, any complex interrupt handler (such as an IDE interrupt
>> doing a multi-sector PIO transfer _in interrupt context_) can cause this
>> kind of starvation.  That's why Linux 1.x had bottom halves - so that
>> the time consuming work could be moved out of the interrupt handler,
>> thereby causing minimal the blockage of other interrupts.
>>
>> Unfortunately, that kind of design has been long since forgotten.
>> Apparantly modern machines are fast enough that it doesn't have to be
>> worried about anymore...  Or are they?
> 
>  I would guess it is not that the machines are fast enough, but that this 
> two-level processing makes things more complicated.  Enough that most 
> people would not bother digging into it unless really forced.  Only 
> occasional latency problems are probably not enough of a force.

I don't believe the speed of the machine has much to do with it,
as IDE PIO is always at pretty much the same speed (or slower)
regardless of the CPU speed.

Best case is about .120 usec per 16-bit word, but that doesn't often pan out
in practice.  More typical is something closer to 1 usec per 16-bit word.

So, for multcount=16 (very common), best case is 16 * 256 * .120 = 491 usec,
plus extra overhead for reading the IDE status register (another usec or so),
and other stuff.  Figure maybe 500usec total per interrupt for multcount=16
in the best case, or 4000usec in the worst case.

At 115200bps, we get a byte every 86 usec or so.  Assuming the UART FIFO
is set to interrupt (warn) us at 12/16 full, we have 4*86 = 344 usec to
respond and de-assert RTS.  Less than that in practice.

Conclusion:  using IDE multisector PIO is not a good idea with high speed
serial transfers happening, since we cannot respond quickly enough.

It might be possible to set the buffer underrun threshold lower in the UART (?).

All that said, I doubt that his system is using IDE PIO in the first place.
Dunno how long IDE DMA interrupts take, but it's probably in the 20-50 usec range.
