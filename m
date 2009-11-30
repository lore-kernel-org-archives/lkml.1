Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZK3XaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZK3XaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 18:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZK3XaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 18:30:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52750 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752542AbZK3XaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 18:30:19 -0500
Date: Mon, 30 Nov 2009 23:30:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Uwe =?ISO-8859-14?B?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.y.miao@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@marvell.com>,
       Jamie Lokier <jamie@shareable.org>, LKML <linux-kernel@vger.kernel.org>,
       Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-arm-kernel@lists.infradead.org,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
 IRQF_SHARED|IRQF_DISABLED)
Message-ID: <20091130233035.2a404f62@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0911302255590.24119@localhost.localdomain>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>
	<20091130143703.GA7028@n2100.arm.linux.org.uk>
	<20091130145122.7057a1e3@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0911302255590.24119@localhost.localdomain>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Either that or we decide to push such beasts into the threaded irq
> space to keep them working until the last card hits the trashcan. I
> know that this would still need to disable the interrupt on the PIC
> level, but we have already mechanisms for that in the threaded code.

The 8390 is essentially a single thread device so treating interrupts as
events indicating work is to be done might make sense

Unfortunately you cannot check the interrupt flags on the chip without
switching to page 0, which will cause any parallel tx to crap itself and
potentially hang the box. It's a design from single CPU days and the
programming model is solely around 'stack the register window selected,
do stuff in irq, put it back', so any parallel execution ends in tears,
even peeking to see if the IRQ is ours.

These chips still keep popping up in old boxes although the rtl8139 seems
to have exterminated them at last in all the ultra-cheap devices.

Pushing them into threaded IRQ space with PIC masking seems to make
complete sense. The wonderously gothic IRQ magic becomes a mutex, the IRQ
handler may sleep blocking the IRQ during a transmit and the transmit
path may block during an IRQ thread execution. Reset works as a mutex and
all the crap and magic goes away.

