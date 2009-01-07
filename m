Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbZAGCnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbZAGCnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 21:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbZAGCm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 21:42:57 -0500
Received: from ozlabs.org ([203.10.76.45]:46004 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849AbZAGCm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 21:42:56 -0500
Date: Wed, 7 Jan 2009 13:42:48 +1100
From: David Gibson <hermes@gibson.dropbear.id.au>
To: Dave <kilroyd@googlemail.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, orinoco-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Orinoco-devel] 2.6.28: warn_slowpath in orinoco receive path
Message-ID: <20090107024248.GA14990@yookeroo.seuss>
Mail-Followup-To: Dave <kilroyd@googlemail.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <200901052005.12428.arvidjaar@mail.ru> <49626E4D.3010705@gmail.com> <200901061251.41628.arvidjaar@mail.ru> <4963B8BE.9000204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4963B8BE.9000204@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 08:02:06PM +0000, Dave wrote:
> Andrey Borzenkov wrote:
> > On 05 January 2009 23:32:13 Dave wrote:
[snip]
> > By the way. Agere driver takes different approach. The only thing it 
> > does in interrupt handler directly is to turn off Hermes interrupts and 
> > start off another thread to process pending events. After all events are 
> > processed interrupts are enabled again. It means the bulk of code is 
> > executed in non-interrupt context; and looking how much is done in 
> > orinoco driver during interrupt processing, this does not sound like bad 
> > idea. Do you see any obvious cons here?
> 
> When I moved the RX handling into a tasklet I had a go at moving all the
> interrupt handling code into the tasklet, and just couldn't get the card
> to play nice. It might have worked if I disabled the interrupts (which I
> didn't try), but my personal preference is not to touch interrupt
> enables if we don't have to. Anyway, cons I can think of? :

Heh.  Glad to see it wasn't just me that had perrennial problems with
locking in the orinoco driver due to trouble with the hardware.

Incidentally, the approach descibed in the Agere driver sounds
not-dissimilar to an approach I thought about, which I think would fix
most of the problems we've seen, but I never got around to
implementing.

That is to run all the guts of the driver in a single kernel thread,
which just loops most of the time sending any queued packets,
receiving any available packets and otherwise sleeping.  The interrupt
path and the userland entry points would do nothing except flag and
wakeup the main thread.

Because everything would be single threaded, we'd no longer need any
locks for hardware contention, which sidesteps all the problems we've
seen with the hardware taking too damn long to respond for operations
that could contend.  Even for reset, which takes ages, and on Prism
firmware with WEP enabled when the BAP occasionally takes ages to
respond.  The only locks would be to protect the flags/queues that are
used to signal the master thread, and since that's entirely under
software control we can make sure the critical sections are small
enough.

I suspect it would also allow support for USB orinoco hardware to be
integrated more sanely than the current organization.

It's not exactly a high throughput approach, but given the hardware's
so crappy anyway, I don't think it would be a significant problem.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
