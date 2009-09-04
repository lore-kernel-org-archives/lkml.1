Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbZIDTfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbZIDTfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbZIDTfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:35:38 -0400
Received: from bu3sch.de ([62.75.166.246]:48444 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbZIDTfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:35:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded interrupt handlers broken?
Date: Fri, 4 Sep 2009 21:35:37 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200908161153.14081.mb@bu3sch.de> <200909042055.55385.mb@bu3sch.de> <200909042105.53944.mb@bu3sch.de>
In-Reply-To: <200909042105.53944.mb@bu3sch.de>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909042135.38874.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 September 2009 21:05:51 Michael Buesch wrote:
> On Friday 04 September 2009 20:55:52 Michael Buesch wrote:
> > On Monday 17 August 2009 14:30:31 Michael Buesch wrote:
> > > Also works. Thanks.
> > > 
> > > Tested-by: Michael Buesch <mb@bu3sch.de>
> > 
> > Hm, I've got a strange problem here related to threaded IRQs and rmmod.
> > 
> > If I do this sequence, it crashes the machine:
> > request_threaded_irq();
> > free_irq();
> > rmmod module
> > modprobe module
> > request_threaded_irq();
> > *boom*
> > 
> > Here are some oops messages. These are almost always different, so I
> > guess it crashes in IRQ context at random places when the IRQ triggers.
> > http://bu3sch.de/misc/irq_crash1.JPG
> > http://bu3sch.de/misc/irq_crash2.JPG
> > 
> > It seems to be a NULL pointer dereference somewhere, but I can't locate it.
> > Note that it does not happen, if I omit the rmmod.
> > 
> 
> Ok, what I see now is that the IRQ thread that belongs to the driver is not
> destroyed on free_irq(). So it is dangling and after rmmod/modprobe it will crash
> on interrupt, because the module is relocated.
> Bringing the device up and down several times (without reloading the module), which
> does several request_threaded_irq(); free_irq() sequences in a row, creates a new
> IRQ thread each time but does not destroy the old one.

Whoopsy, I think I messed up my driver and did not call free_irq(). Sorry for the noise. :(

-- 
Greetings, Michael.
