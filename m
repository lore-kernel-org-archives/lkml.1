Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbXLKUaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbXLKUaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 15:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbXLKUae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 15:30:34 -0500
Received: from spirit.analogic.com ([204.178.40.4]:4404 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbXLKUad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 15:30:33 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 11 Dec 2007 20:28:05.0987 (UTC) FILETIME=[560F5330:01C83C34]
Content-class: urn:content-classes:message
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Date: Tue, 11 Dec 2007 15:27:51 -0500
Message-ID: <Pine.LNX.4.61.0712111513490.23653@chaos.analogic.com>
in-reply-to: <475EE2CA.6020601@reed.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
thread-index: Acg8NFYbQkzuFAKbRLS2Ph5BGlqgAQ==
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu> <20071209125458.GB4381@ucw.cz> <20071209165908.GA15910@one.firstfloor.org> <20071209212513.GC24284@elf.ucw.cz> <475CBDD7.5050602@keyaccess.nl> <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <20071211143224.15900995@tux.DEF.witbe.net> <475E9B9B.2050709@keyaccess.nl> <475EACB8.7080608@keyaccess.nl> <20071211163706.2dc82275@tux.DEF.witbe.net> <475EB263.2050405@keyaccess.nl> <475EC1C0.2040000@reed.com> <20071211173231.2b87a81f@the-village.bc.nu> <475EE2CA.6020601@reed.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "David P. Reed" <dpreed@reed.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Rene Herman" <rene.herman@keyaccess.nl>,
       "Paul Rolland" <rol@as2917.net>, "David Newall" <david@davidnewall.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Pavel Machek" <pavel@ucw.cz>, "Andi Kleen" <andi@firstfloor.org>,
       <linux-kernel@vger.kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, <rol@witbe.net>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 11 Dec 2007, David P. Reed wrote:

>
>
> Alan Cox wrote:
>>
>> The vga driver is somewhat misnamed. In console mode we handle everything
>> back to MDA/HGA and some HGA adapters do need delays.
>>
>>
> No they don't.   I really, really, really know this for a fact.  I wrote
> ASM drivers for every early video adapter and ran them all through Lotus
> QA and Software Arts QA.   Personally.  The only delay needed is caused
> by not having dual-ported video frame buffers on the original CGA in
> high res character mode. This caused "snow" when a memory write was done
> concurrently with the read being done by the scanline character
> generator. And that delay was done by waiting for a bit in the I/O port
> space to change.  There was NO reason to do waits between I/O
> instructions.  Produce a spec sheet, or even better a machine.   I may
> have an original PC-XT still lying around in the attic, don't know if I
> can fire it up, but it had such graphics cards.  I also have several
> early high-speed clones that were "overclocked".
>
>>> I do remind all that 0x80 is a BIOS-specific standard, and is per BIOS -
>>> other ports have been used in the history of the IBM PC family by some
>>> vendors, and some machines have used it for DMA port mapping!!  And
>>>
>>
>> All do -thats why it is suitable.
>>
> Not true.  Again, I can produce machines that don't use 0x80.  Perhaps
> that is because I am many years older than you are, and have been
> writing code for PC compatibles since 1981.  (not a typo - this was
> before the first IBM PC was released to the public).

Hmmm,
I didn't know you worked in Boca Raton for Don Estrage on
the IBM 5150. I must have missed you --somehow.

[Snipped...]

You do remember that the X86 can do back-to-back port
instructions faster than the ISA bus capacity can be
charged, don't you? You do remember the admonishment
about:
 	intel asm

 	mov	dx, port	; One of two adjacent ports
 	mov	al,ffh		; All bits set
 	out	dx,al		; Output to port, bits start charging bus
 	inc	al		; Al becomes 0
 	inc	dx		; Next port
 	out	dx,al		; Write 0 there, data bits discharged

When the port at 'port' gets its data, it will likely
be 0, not 0xff, because the intervening instructions
can execute faster than a heavily-loaded ISA bus.

So, with a true ISA/EISA bus, not an emulated one off
a bridge, you have to worry about this. In the IBM/PC
BIOS listing, supplied with every early real PC, it
was called "bus settle time." Remember? If not, you
never wrote code for that platform.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
