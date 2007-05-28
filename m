Return-Path: <linux-kernel-owner+w=401wt.eu-S1762114AbXE1Q4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762114AbXE1Q4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbXE1Q4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:56:12 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbXE1Q4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:56:11 -0400
Date: Mon, 28 May 2007 09:53:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
In-Reply-To: <20070528100448.GB18276@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0705280935560.26602@woody.linux-foundation.org>
References: <1180008394.15600.26.camel@localhost>
 <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
 <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
 <20070524220017.GC9604@elf.ucw.cz> <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
 <20070524221743.GD9604@elf.ucw.cz> <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
 <20070527155738.GA20006@srcf.ucam.org> <alpine.LFD.0.98.0705270924310.26602@woody.linux-foundation.org>
 <20070528100448.GB18276@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 May 2007, Pavel Machek wrote:
> 
> I guess we should warn the driver authors, then; and decide what driver 
> authors should do.

Drivers really shouldn't do anythign at all.

> If I'm video4linux driver for grabbing screen, have been suspended, and 
> someone asks me to read a frame, should I
> 
> a) return -ESORRYIMSUSPENDED
> 
> b) just block the caller

The "subsystem" thing should have stopped the queues, and the device 
should never even _see_ this.

Before we suspend a device, we call the subsystem that that device has 
been registered with. Ie, we have code like this:

	if (dev->class && dev->class->suspend)
		error = dev->class->suspend(dev, state);

which was very much designed so that individual devices wouldn't have to 
always know - if the upper layer devices for that class can handle these 
things, they should.

Do people actually _do_ this, right now? No. But we do actually have the 
infrastructure, and I think we have one or two classes that actually do 
use it (at least the "rfkill_class" has a suspend member, dunno how well 
this model actually works).

I think Greg had some patches to make network drivers use this, for 
example. Network drivers right now all end up doing stuff that really 
doesn't belong in the driver at all when they suspend, and the 
infrastructure _should_ just do it for them (ie do all the _network_ 
related stuff, as opposed to the actual hardware-related stuff).

(Examples of things that we probably _should_ do for network devices on a 
class level:

	suspend:
		netif_poll_disable()
		if (netif_running(dev))
			dev->stop(dev);

	resume:
		if (netif_running(dev))
			dev->start(dev);
		netif_poll_enable(dev);

or something similar).

			Linus
