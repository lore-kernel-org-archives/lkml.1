Return-Path: <linux-kernel-owner+w=401wt.eu-S1752351AbXJ1UlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbXJ1UlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 16:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbXJ1Uku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 16:40:50 -0400
Received: from khc.piap.pl ([195.187.100.11]:52800 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbXJ1Ukt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 16:40:49 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>
	<4714EF01.2060609@s5r6.in-berlin.de>
	<m3d4vebylw.fsf@maximus.localdomain>
	<471527E5.1050407@s5r6.in-berlin.de>
	<m34pgpmszu.fsf@maximus.localdomain>
	<47166C83.2050207@s5r6.in-berlin.de>
	<m3fy09ffp9.fsf@maximus.localdomain>
	<4719A0C4.3050301@s5r6.in-berlin.de>
	<m3bqausztv.fsf@maximus.localdomain>
	<4719FF0F.3080504@s5r6.in-berlin.de>
	<m3ejfp4bg9.fsf@maximus.localdomain>
	<4724C9DA.7030900@s5r6.in-berlin.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 28 Oct 2007 21:40:41 +0100
In-Reply-To: <4724C9DA.7030900@s5r6.in-berlin.de> (Stefan Richter's message of "Sun, 28 Oct 2007 18:41:46 +0100")
Message-ID: <m33avvdlbq.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

>> Compile with the usual spell: gcc -Wall -O2 vt6307ohciver.c -o vt6307ohciver
>
> I also had to specify "-lpci" on Mandrake 10.1, "-lpci -lz" on Gentoo.

Of course you're right, just typed faster than thought.
Actually I had to add these two on Fedora, too.

> 	00:0c.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394
> 	Host Controller (rev 46)

Ok so it seems rev 80 is VT6307 and (at least) rev 46 is VT6306.
I think my googling for lspci reports confirms that.

> These are both VT6306, one on the motherboard and one on a PCI card.
>
> 	# ./a.out 00:0a.3
> 	I/O region #1 is at C800
> 	It seems your VT6307 chip is connected to 93c46 EEPROM

Interesting, really. Perhaps they aimed at I2C too with 9306 but
screwed up the silicon? Would have to look at the pinout but for
now I'm sick and high fever makes it hard.

It's all consistent, amazingly.

6306#1
> 	00: 00 11 06 00 00 00 E3 32 00 88 00 08 44 00 00 00
> 	10: A1 E4 2F 00 06 11 44 30 03 DF 40 00 00 20 00 73
> 	20: 3C 10 00 00 00 00 FF FF FF FF FF FF D7 57 55 75

Obviously some values are different than these for my 3 vt6307
(not counting GUID + PCI sub IDs). Though data at 0x20+ is equal.

The last 4 bytes are almost certainly rubbish, that asks the question
if the contents hasn't been changed through some tests, works on
the drivers etc, or if the manufacturer did it right (for example
I somehow managed to clear the GUID on I^2C version before I had the
code to write to it, quite a mystery (writing correct I^2C sequence
for it isn't trivial due to the need of non-all-zeros DEVSEL byte
preceded by the start sequence).

I wonder if the EEPROM has more non-FF data? IIRC the chips addresses
0x80 bytes, or maybe 0x100? I limited it to 0x40 in the code because
the rest is never read by the chip, except if requested by the user.
(For 93c46 the program could read any location directly but I didn't
implement that).

6306#2
> 	EEPROM dump:
> 	00: 00 30 1B AC 00 00 2B A4 04 04 32 55 F8 00 A2 02
> 	10: A1 00 40 63 06 11 44 30 03 DF 40 00 00 20 00 73
> 	20: 3C 10 00 00 00 00 FF FF FF FF FF FF FF FF FF FF

Only one different byte (vs my 6307s) at 0x1B if I see correctly.

> The "rev 80" chip is a VT6307 on the motherboard.
> 	00: 00 10 DC 56 00 FE D2 D4 04 04 32 55 F8 00 A2 02
> 	10: A1 00 40 63 20 63 62 14 03 DF 40 80 00 20 00 73
> 	20: 3C 10 08 00 00 00 FF FF FF FF FF FF FF FF FF FF

Same as mine.

> The "rev 46" chip is on a CardBus card.  So far I believed it to be a
> VT6306 but I can't easily open the card's casing...

> 	It seems your VT6307 chip is connected to I^2C (24c01 or
> 	similar) EEPROM

Hmm... They say 6306 only supports 93c46, perhaps I should force
it based on revision.
Or the datasheet doesn't know.

> 	00: 00 11 06 00 00 00 41 CC 04 04 32 55 F8 00 92 02
> 	10: A1 00 40 63 06 11 44 30 03 DF 40 80 00 20 00 73
> 	20: 3C 10 00 00 00 00 A0 00 FF FF FF FF FF FF FF FF

It seems a difference at 0x1e only, that A0 00 at the end - who
knows (would require an analyzer).

>> and, if you tried "upgrading" or "downgrading", if it worked.
>
> I haven't tried it yet.

I guess chances for the last card are lower.
-- 
Krzysztof Halasa
