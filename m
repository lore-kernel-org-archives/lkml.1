Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbYDYDdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbYDYDdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 23:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYDYDdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 23:33:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45249 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbYDYDdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 23:33:14 -0400
Message-ID: <481150EE.3040103@garzik.org>
Date: Thu, 24 Apr 2008 23:33:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: MSI, fun for the whole family (was Re: [git patch] free_irq() fixes)
References: <20080422221733.GA16260@havoc.gtf.org>	<alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org>	<480E6DE5.6010103@garzik.org>	<alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org>	<480E796E.4070001@garzik.org>	<alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org>	<20080423000529.GG28933@cs181133002.pp.htv.fi>	<alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org>	<480F3ECC.1090809@keyaccess.nl> <480FEC1B.6040102@garzik.org>	<alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org>	<m1od7zkd2s.fsf@frodo.ebiederm.org> <481066C1.1030805@garzik.org>	<alpine.LFD.1.10.0804240806500.2779@woody.linux-foundation.org>	<4810A9E6.1080201@garzik.org>	<alpine.LFD.1.10.0804240847230.2779@woody.linux-foundation.org>	<m1r6cvgpw2.fsf@frodo.ebiederm.org> <4810C3B5.3020605@garzik.org> <m11w4u8x1c.fsf@frodo.ebiederm.org>
In-Reply-To: <m11w4u8x1c.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeff Garzik <jeff@garzik.org> writes:
> 
>> Eric W. Biederman wrote:
>>> And on x86 at least the hardware maps the MSI write into an interrupt.
>>> So there is not an opportunity to get any metdata/OOB data from the
>>> MSI message.  Instead we just potentially get a boatload more irq
>>> sources.  Which is one of the things making a static NR_IRQS painful.
>>>
>>> To be safe we have to make NR_IRQS 10x+ or so bigger then people use
>>> today.  Just in case they decide to plug in some really irq hungry
>>> cards.
>>
>> Just to be clear, irq_chip/irq_desc and metadata/OOB data are two very different
>> beasts.  irq_chip/irq_desc is more a system attribute as Linus notes.  Also, it
>> doesn't change very often.
>>
>> metadata/OOB, on the other hand, is different -for each interrupt-, and is
>> highly relevant to drivers.  Thus should be part of the driver API somehow.
> 
> I'm not certain I follow so I will ask.
> 
> Do you mean information that is different each time an interrupt is fires?
> 
> Or do you mean information that differs for each different interrupt?
> Something like the current dev_id?
> 
> To my knowledge there is not any information that varies each time an
> interrupt fires.

Absolutely there is!  This is why MSI is so cool.

You get a tiny chunk of data from the hardware, across the PCI bus in a 
single PCI transaction, sent [well, basically...] straight to the driver 
__for each MSI interrupt__.  Rather than having a separate interrupt 
line -- really an ugly OOB mechanism -- you get a bus transaction as God 
intended, a bus transaction just like all the others going across the 
PCI bus.


Let's illustrate with a real world example, with hardware you probably 
already have in your hands today.


Download AHCI 1.1 SATA controller specification from 
http://www.intel.com/technology/serialata/ahci.htm

and check out Section 2.3 and MSI-related bits of Section 10.6.2 for the 
usage of those PCI MSI registers on the PCI device.

An AHCI PCI device uses MSI messages to inform the driver which <mask> 
of 32 SATA ports have asserted an activity indication.

This MSI message varies _for each interrupt_, and replaces the standard 
driver idiom of reading a hardware Interrupt-Status register.

Thus you can see increased performance with MSI messages because the 
hardware "pushes" useful information to the driver, using an in-band 
mechanism (PCI bus transaction) rather than an out-of-band mechanism ($N 
SATA ports sharing a single interrupt line).

This is the reverse of the standard model, where the driver receives the 
knowledge "your interrupt line asserted... maybe" and it must deduce 
activity from there by reading an Interrupt-Status register.


That is one fundamental of MSI messages:  they carry data.  To 
illustrate with "kernel pseudocode", this equates to

	irqreturn_t irq_handler(int irq, void *dev_id,
				const void *metadata,
				size_t metadata_len)

You have a fundamentally new model for interrupt handling with MSI...

You are no longer managing an interrupt line that is asserted and 
cleared.  It is now an asynchronous flow of data blobs from hardware to 
various per-driver "mailboxes".

	Jeff


