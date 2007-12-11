Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbXLKPnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbXLKPnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbXLKPnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:43:41 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:4999 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbXLKPnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:43:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 11 Dec 2007 15:41:53.0941 (UTC) FILETIME=[5AB90C50:01C83C0C]
Content-class: urn:content-classes:message
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Date: Tue, 11 Dec 2007 10:41:42 -0500
Message-ID: <Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com>
in-reply-to: <475E95A3.3070801@davidnewall.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
thread-index: Acg8DFrHV2LGAR2uTcumhVCw7Nt53g==
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu> <20071209125458.GB4381@ucw.cz> <20071209165908.GA15910@one.firstfloor.org> <20071209212513.GC24284@elf.ucw.cz> <475CBDD7.5050602@keyaccess.nl> <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <475E95A3.3070801@davidnewall.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "David Newall" <david@davidnewall.com>
Cc: "Rene Herman" <rene.herman@keyaccess.nl>, "Paul Rolland" <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Pavel Machek" <pavel@ucw.cz>, "Andi Kleen" <andi@firstfloor.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, <rol@witbe.net>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 11 Dec 2007, David Newall wrote:

> Rene Herman wrote:
>> This particular discussion isn't about anything in general but solely
>> about the delay an outb_p gives you on x86 since what is under
>> discussion is not using an output to port 0x80 on that platform to
>> generate it.
>
> That could be true if outb_p were used only in architecture dependent
> code, but it's not.  It's used in drivers that are supposed to run on
> all sorts of platforms.  Why does a megaraid controller need delays on
> i386 but not on Sparc, PowerPC, Alpha and others?  Is it buggy on most
> platforms, or just unnecessarily slow on Intel?
>
>>> is needed, wouldn't you use a real delay; one that says how long it
>>> should be?
>> Thinking that _p gives a pause is perhaps too PC-centric. Why, if a delay
>>
>> Because any possible outb_p delay should be synced to the bus-clock,
>> not to any wall-clock.
>
> You misunderstand.  A delay can be counted in bus cycles.
>
>> In the real world, driver authors aren't perfect and will have used
>> outb_p as a wall-clock delay which they have gotten away with since
>> it's a nicely specified delay in terms of the ISA/LPC clock and the
>> ISA/LPC clock being fairly (old) to very (new) constant.
>
> It's most commonly a zero delay.  Only in the minority of architectures
> is it otherwise.  If a delay is needed, then put one in, but don't put
> in a paper promise that's more likely to be ignored than observed.
>
> Plenty of doubt has been expressed as to whether _p is widely used
> without need.  Not surprising since it has such a vague specific
> meaning.  One could say, Linux on i386 is liberally sprinkled with
> needless delays.  I suppose it has the advantage that Microsoft will be
> hard pressed to catch up when finally we remove them. :-)
>
> I really prefer accurate code, but I'm also pragmatic and realise that
> it's far too much work to fix this any time soon.  But if it were to be
> fixed, then perhaps _p would take an additional parameter, measured in
> cycles of delay.
> --

Most, probably most-all, of the delays to port operations
on modern ix86 machines are not needed at all. Certainly
machines that use bridges to expand port I/O to the ISA
bus do need any such delays. There are exactly two (and
only two) problems with removing the delays.

(1) Older machines which have an actual ISA bus with its
attendent capacity that needs to be charged long enough
for the data to become valid --before being overwritten
by new data.

(2) I/O operations that have two ports, one an index
port and the other a data port, like the CMOS RTC. Once
you set the index port, it takes about 300 ns for it to
propigate to the hardware, so there needs to be some
delay between the back-to-back CPU operations which can
occur much faster than that.

On this machine, I have changed all the _p macros so
they don't do anything. Since it is a modern machine
with N/S bridges, which provide their own delays,
everything works. Such would not be the case if I
was using a machine that had an actual ISA (or PC-104)
bus. Those are not terminated busses, but open-ended
capacitors made up of connectors and PC traces. It
takes about 300 ns to charge one of those (so 1us is
a good dalay).

BYW, there are no "transactions" on the ISA or EISA
bus. It works by using a sequence of operations
with minimum setup and hold times. It's very primative.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
