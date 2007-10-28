Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbXJ1XMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbXJ1XMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 19:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbXJ1XMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 19:12:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46331 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbXJ1XMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 19:12:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47251744.6090206@s5r6.in-berlin.de>
Date: Mon, 29 Oct 2007 00:12:04 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>	<4714EF01.2060609@s5r6.in-berlin.de>	<m3d4vebylw.fsf@maximus.localdomain>	<471527E5.1050407@s5r6.in-berlin.de>	<m34pgpmszu.fsf@maximus.localdomain>	<47166C83.2050207@s5r6.in-berlin.de>	<m3fy09ffp9.fsf@maximus.localdomain>	<4719A0C4.3050301@s5r6.in-berlin.de>	<m3bqausztv.fsf@maximus.localdomain>	<4719FF0F.3080504@s5r6.in-berlin.de>	<m3ejfp4bg9.fsf@maximus.localdomain>	<4724C9DA.7030900@s5r6.in-berlin.de> <m33avvdlbq.fsf@maximus.localdomain>
In-Reply-To: <m33avvdlbq.fsf@maximus.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Stefan Richter <stefanr@s5r6.in-berlin.de> writes:
>> 	# ./a.out 00:0a.3
>> 	I/O region #1 is at C800
>> 	It seems your VT6307 chip is connected to 93c46 EEPROM
> 
> Interesting, really. Perhaps they aimed at I2C too with 9306 but
> screwed up the silicon? Would have to look at the pinout but for
> now I'm sick and high fever makes it hard.
> 
> It's all consistent, amazingly.
> 
> 6306#1
>> 	00: 00 11 06 00 00 00 E3 32 00 88 00 08 44 00 00 00
>> 	10: A1 E4 2F 00 06 11 44 30 03 DF 40 00 00 20 00 73
>> 	20: 3C 10 00 00 00 00 FF FF FF FF FF FF D7 57 55 75
> 
> Obviously some values are different than these for my 3 vt6307
> (not counting GUID + PCI sub IDs). Though data at 0x20+ is equal.
> 
> The last 4 bytes are almost certainly rubbish, that asks the question
> if the contents hasn't been changed through some tests, works on
> the drivers etc, or if the manufacturer did it right (for example
> I somehow managed to clear the GUID on I^2C version before I had the
> code to write to it, quite a mystery (writing correct I^2C sequence
> for it isn't trivial due to the need of non-all-zeros DEVSEL byte
> preceded by the start sequence).
> 
> I wonder if the EEPROM has more non-FF data? IIRC the chips addresses
> 0x80 bytes, or maybe 0x100? I limited it to 0x40 in the code because
> the rest is never read by the chip, except if requested by the user.
> (For 93c46 the program could read any location directly but I didn't
> implement that).

This device is a somewhat buggy PCI card which somebody sent me after
unsuccessful attempts to get it properly working under Linux.  Among
more serious trouble, ohci1394 reads a bogus maximum async payload (a
zero value) from the BusOptions register during startup.  This has
occasionally been reported for some VT6306 in the past.  I haven't
really tested this card myself yet, it's currently stuck in a PC which I
don't use anymore.

Bad VT6306 card:

PCI: Found IRQ 11 for device 0000:00:0a.3
PCI: Sharing IRQ 11 with 0000:00:0a.0
PCI: Sharing IRQ 11 with 0000:00:10.1
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[11]
MMIO=[ec101000-ec1017ff]  Max Packet=[2]  IR/IT contexts=[4/8]
ohci1394: fw-host0: Serial EEPROM has suspicious values, attempting to
set max_packet_size to 512 bytes
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001106000000e332]

VT6306 onboard controller:

PCI: setting IRQ 5 as level-triggered
PCI: Found IRQ 5 for device 0000:00:0c.0
PCI: Sharing IRQ 5 with 0000:00:0a.2
ohci1394: fw-host1: OHCI-1394 1.0 (PCI): IRQ=[5]
MMIO=[ec103000-ec1037ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
ieee1394: Host added: ID:BUS[1-00:1023]  GUID[00301bac00002ba4]

VT6306 CardBus card in my main PC:

ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 17 (level, low) -> IRQ 18
ohci1394: fw-host2: OHCI-1394 1.0 (PCI): IRQ=[18]
MMIO=[80000000-800007ff]  Max Packet=[1024]  IR/IT contexts=[4/8]
ieee1394: Host added: ID:BUS[2-00:1023]  GUID[00110600000041cc]

The Max Packet value of the CardBus card is OK; all CardBus cards seem
to have this limitation regardless of their link layer chip.

I wonder what's up with the varying number of IR contexts.  The
datasheet talks about 8 IR contexts and 8 IR context registers, but also
has a sentence "These registers are Context Control registers for
isochronous Receive Contexts 0-3" which may be an editorial error.
-- 
Stefan Richter
-=====-=-=== =-=- ===--
http://arcgraph.de/sr/
