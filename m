Return-Path: <linux-kernel-owner+w=401wt.eu-S1759611AbZADTE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbZADTE1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZADTEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:04:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:51109 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZADTEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:04:09 -0500
Date: Sun, 4 Jan 2009 11:05:59 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Message-ID: <20090104110559.306186c4@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0901041038570.3179@localhost.localdomain>
References: <20090104092430.7ffd2c41@infradead.org>
	<alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
	<20090104103104.6fdda9f2@infradead.org>
	<alpine.LFD.2.00.0901041038570.3179@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009 10:54:15 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> Since it seems to be the irq auto-probing, then doing it
> asynchronously won't help. Not only will it happen only for ports
> that you actually have (rather than the number you have configured),
> but even if you actually have multiple physical ports, the irq
> autoprobing is all serialized (and has to be - it depends on).
> 
> It's serialized by the 'probing_active' mutex.
> 
> In fact, I suspect we should entirely disallow asynchronous irq
> probing, because while the probing itself is serialized wrt _other_
> autoprobing, it's not necessarily safe wrt other drivers allocating
> interrupts in a non-probing manner.
> 
> So not only should we not bother to do irq autoprobing asynchronously 
> (because it won't help), we also probably should make sure that there
> is no other driver doing any asynchronous "request_irq()" _while_ we
> probe. IOW, we should consider the "request_irq()" to be a globally
> ordered event, like requesting a major/minor number or registering a
> driver.

well.
or we declare the irq probing stuff "rare" and just make THAT fully
serializing....
do a full synchronization before starting a probe 
(at that point no new async stuff can show up if it wouldn't show up
already right now), and be done with it.

> > > Does this patch make any difference to you? I'm not at all sure
> > > that it's the irq probing, but if it is, then this should make
> > > the serial probe go much faster.
> > 
> > it turned it into a 25 msec deal .. pretty good improvement in my
> > book.
> 
> Ok, that certainly makes it a non-issue. It's a scary change in the
> sense that it's touching code that we _never_ touch, and it's magic
> irq autoprobing stuff, but at the same time, 0.1 seconds for testing
> whether some spurious irq happens is a pretty ridiculous cost.
> Especially since we're only talking legacy ISA interrupts anyway. If
> we have screaming interrupts, they'll happen immediately, not after a
> tenth of a second.
> 
> That said, I also wonder if we really even need to autoprobe the 
> interrupts on any modern hardware. Rather than trying to speed up irq 
> probing, maybe we could figure it out some other way.. The only thing
> that matters on 99% of all machines are the one or two standard ports
> that normally show up on 2f8h/irq3 and 3f8h/irq4 or something like
> that. 

too bad this stuff isn't PCI enumerated.
but if someone really still maintains this code, it could probably be
rewritten in a "we think it's likely irq 3. how about we test that. Oh
no? then we do expensive probing" kind of way.

Right now I don't think I have time for it (this is going to take time..
there's so many weird things with serial ports that it's bound to break
stuff in the beginning etc)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
