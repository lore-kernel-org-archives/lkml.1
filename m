Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbZADSyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbZADSyl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZADSy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:54:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbZADSy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:54:27 -0500
Date: Sun, 4 Jan 2009 10:54:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
In-Reply-To: <20090104103104.6fdda9f2@infradead.org>
Message-ID: <alpine.LFD.2.00.0901041038570.3179@localhost.localdomain>
References: <20090104092430.7ffd2c41@infradead.org> <alpine.LFD.2.00.0901041009060.3179@localhost.localdomain> <20090104103104.6fdda9f2@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 4 Jan 2009, Arjan van de Ven wrote:
> > 
> > I _think_ it's the irq auto-probing, but that's just a guess.
> 
> I kinda was hoping that in part it was a scaling thing with the number
> of ports (4 in my .config) so that I could do the ports
> asynchronous compared to eachother ;-)

Since it seems to be the irq auto-probing, then doing it asynchronously 
won't help. Not only will it happen only for ports that you actually have 
(rather than the number you have configured), but even if you actually 
have multiple physical ports, the irq autoprobing is all serialized (and 
has to be - it depends on).

It's serialized by the 'probing_active' mutex.

In fact, I suspect we should entirely disallow asynchronous irq probing, 
because while the probing itself is serialized wrt _other_ autoprobing, 
it's not necessarily safe wrt other drivers allocating interrupts in a 
non-probing manner.

So not only should we not bother to do irq autoprobing asynchronously 
(because it won't help), we also probably should make sure that there is 
no other driver doing any asynchronous "request_irq()" _while_ we probe. 
IOW, we should consider the "request_irq()" to be a globally ordered 
event, like requesting a major/minor number or registering a driver.

Of course, the way your asynchronous setup is done, there should never 
really be a reason for a driver to do the "request_irq()" asynchronously. 

The driver _should_ have already requested the irq in its synchronous 
part, and then do only the actual IO probing asynchronously. So I think 
we're all fine, but it may be worth pointing this out.

It might also be worth it to have some debug facilities for this, and have 
things like request_irq(), device_register() and driver_register() etc all 
verify that they are not called from "async context".

> > Does this patch make any difference to you? I'm not at all sure that
> > it's the irq probing, but if it is, then this should make the serial
> > probe go much faster.
> 
> it turned it into a 25 msec deal .. pretty good improvement in my book.

Ok, that certainly makes it a non-issue. It's a scary change in the sense 
that it's touching code that we _never_ touch, and it's magic irq 
autoprobing stuff, but at the same time, 0.1 seconds for testing whether 
some spurious irq happens is a pretty ridiculous cost. Especially since 
we're only talking legacy ISA interrupts anyway. If we have screaming 
interrupts, they'll happen immediately, not after a tenth of a second.

That said, I also wonder if we really even need to autoprobe the 
interrupts on any modern hardware. Rather than trying to speed up irq 
probing, maybe we could figure it out some other way.. The only thing that 
matters on 99% of all machines are the one or two standard ports that 
normally show up on 2f8h/irq3 and 3f8h/irq4 or something like that. 

			Linus
