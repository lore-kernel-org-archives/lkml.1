Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbZIDThv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbZIDThv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbZIDThu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:37:50 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:37720 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757219AbZIDThs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:37:48 -0400
Date: Fri, 4 Sep 2009 21:37:49 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Michael Buesch <mb@bu3sch.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Threaded interrupt handlers broken?
Message-ID: <20090904193749.GA1130@Chamillionaire.breakpoint.cc>
References: <200908161153.14081.mb@bu3sch.de> <200908171430.32146.mb@bu3sch.de> <200909042055.55385.mb@bu3sch.de> <200909042105.53944.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200909042105.53944.mb@bu3sch.de>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Buesch | 2009-09-04 21:05:51 [+0200]:

>> Hm, I've got a strange problem here related to threaded IRQs and rmmod.
>> 
>> If I do this sequence, it crashes the machine:
>> request_threaded_irq();
>> free_irq();
>> rmmod module
>> modprobe module
>> request_threaded_irq();
>> *boom*
>> 
>> Here are some oops messages. These are almost always different, so I
>> guess it crashes in IRQ context at random places when the IRQ triggers.
>> http://bu3sch.de/misc/irq_crash1.JPG
>> http://bu3sch.de/misc/irq_crash2.JPG
>> 
>> It seems to be a NULL pointer dereference somewhere, but I can't locate it.
>> Note that it does not happen, if I omit the rmmod.
>> 
>
>Ok, what I see now is that the IRQ thread that belongs to the driver is not
>destroyed on free_irq(). So it is dangling and after rmmod/modprobe it will crash
>on interrupt, because the module is relocated.
>Bringing the device up and down several times (without reloading the module), which
>does several request_threaded_irq(); free_irq() sequences in a row, creates a new
>IRQ thread each time but does not destroy the old one.

The threaded interrupt infrastructure is okay as far as I can see it. My
currently OOT driver uses request_threaded_irq() and I can
modprobe/rmmod it with no problems. I just rebased it on top of -rc8 and
see no problems.

>Greetings, Michael.

Sebastian
