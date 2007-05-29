Return-Path: <linux-kernel-owner+w=401wt.eu-S1763968AbXE2F06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763968AbXE2F06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 01:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbXE2F0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 01:26:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51574 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbXE2F0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 01:26:50 -0400
Date: Mon, 28 May 2007 22:23:14 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Chris Wright <chrisw@sous-sol.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Romano Giannetti <romanol@upcomillas.es>,
       Randy Dunlap <rdunlap@xenotime.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] pcmcia resume 60 second hang. Re: [patch 00/69]
	-stable review
Message-ID: <20070529052314.GA15067@kroah.com>
References: <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org> <20070524220017.GC9604@elf.ucw.cz> <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org> <20070524221743.GD9604@elf.ucw.cz> <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org> <20070527155738.GA20006@srcf.ucam.org> <alpine.LFD.0.98.0705270924310.26602@woody.linux-foundation.org> <20070528100448.GB18276@elf.ucw.cz> <alpine.LFD.0.98.0705280935560.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705280935560.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 09:53:50AM -0700, Linus Torvalds wrote:
> 
> Before we suspend a device, we call the subsystem that that device has 
> been registered with. Ie, we have code like this:
> 
> 	if (dev->class && dev->class->suspend)
> 		error = dev->class->suspend(dev, state);
> 
> which was very much designed so that individual devices wouldn't have to 
> always know - if the upper layer devices for that class can handle these 
> things, they should.
> 
> Do people actually _do_ this, right now? No. But we do actually have the 
> infrastructure, and I think we have one or two classes that actually do 
> use it (at least the "rfkill_class" has a suspend member, dunno how well 
> this model actually works).
> 
> I think Greg had some patches to make network drivers use this, for 
> example. Network drivers right now all end up doing stuff that really 
> doesn't belong in the driver at all when they suspend, and the 
> infrastructure _should_ just do it for them (ie do all the _network_ 
> related stuff, as opposed to the actual hardware-related stuff).

Yes, I started to work on it, as it is the correct thing to do, but got
sidetracked, sorry :(

> (Examples of things that we probably _should_ do for network devices on a 
> class level:
> 
> 	suspend:
> 		netif_poll_disable()
> 		if (netif_running(dev))
> 			dev->stop(dev);
> 
> 	resume:
> 		if (netif_running(dev))
> 			dev->start(dev);
> 		netif_poll_enable(dev);
> 
> or something similar).

I'll try to hack something together later this week along this line and
see how it works...

thanks,

greg k-h
