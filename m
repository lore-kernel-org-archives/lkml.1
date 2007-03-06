Return-Path: <linux-kernel-owner+w=401wt.eu-S965940AbXCFQ5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965940AbXCFQ5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965945AbXCFQ5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:57:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47342 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965940AbXCFQ5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:57:05 -0500
Date: Tue, 6 Mar 2007 08:52:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
In-Reply-To: <1173198401.24738.340.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703060845480.5963@woody.linux-foundation.org>
References: <20070225175559.GC12392@stusta.de>  <20070227100202.GV3822@kernel.dk>
 <20070227102109.GG6745@elf.ucw.cz>  <20070227103021.GA2250@kernel.dk>
 <20070227103407.GA17819@elte.hu>  <20070227105922.GD2250@kernel.dk>
 <20070227111515.GA4271@kernel.dk>  <20070301093450.GA8508@elte.hu>
 <20070302100704.GB2293@elf.ucw.cz>  <20070305084257.GA4464@mellanox.co.il>
  <20070305101120.GA23032@elte.hu> <1173198401.24738.340.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Mar 2007, Thomas Gleixner wrote:
> 
> SATA has another nice feature. Somehow there is an interrupt pending on
> the SATA controller, which comes in somewhere in the middle of resume.
> If it happens before the SATA code resumed, the SATA code ignores the
> interrupt and the interrupt is disabled due to "nobody cared", which in
> turn prevents SATA to ever become functional again.

Jeff - that sounds like a SATA bug.

If you have an interrupt handler registered, you'd better handle the 
interrupt regardless of whether you think the hardware might be gone or 
not.

It's generally *not* ok to do

	if (device_offline())
		return IRQ_NONE;

at the top of an interrupt handler. 

Of course, if you think the hardware is supposed to be quiescent, then the 
only thing you should do is generally just do the "shut up" operation (ie 
read status, write it back or whatever). You must generally *not* try to 
pass any data upwards (ie if the higher layers have told you to shut up, 
you may need to handle the hardware, but you must not involve the higher 
layers themselves any more, because they expect you to be quiet).

And if you cannot do that because you need to resume in order to have the 
status register mapped, then you need to have an "early_resume()" function 
which gets called *before* interrupts are enabled. That's what 
early-resume (and late-suspend) are designed for: doing things that happen 
very early in the resume sequence before everything is up.

And if you don't want to do any of these things (or are unable to, because 
of some ordering constraint or bad design), then you simply need to 
unregister and re-register the interrupt handler over sleep.

> Any idea on that one ?

Jeff, Auke, does this ring any bells?

		Linus
