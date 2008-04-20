Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbYDTGU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbYDTGU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 02:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbYDTGUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 02:20:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47367 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYDTGUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 02:20:12 -0400
Date: Sat, 19 Apr 2008 23:19:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Woodruff, Richard" <r-woodruff2@ti.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>
Subject: Re: Higer latency with dynamic tick (need for an io-ondemand
 govenor?)
Message-ID: <20080419231948.149f2783@laptopd505.fenrus.org>
In-Reply-To: <3B6D69C3A9EBCA4BA5DA60D91302742904131BED@dlee13.ent.ti.com>
References: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com>
	<1179396659.3764.40.camel@chaos>
	<3B6D69C3A9EBCA4BA5DA60D913027429010258E8@dlee13.ent.ti.com>
	<1179434296.12981.14.camel@chaos>
	<3B6D69C3A9EBCA4BA5DA60D913027429010259ED@dlee13.ent.ti.com>
	<1179474567.12981.53.camel@chaos>
	<3B6D69C3A9EBCA4BA5DA60D91302742904131BED@dlee13.ent.ti.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 10:43:32 -0500
"Woodruff, Richard" <r-woodruff2@ti.com> wrote:

> Hi,
> 
> When capturing some traces with dynamic tick we were noticing the
> interrupt latency seems to go up a good amount. If you look at the
> trace the gpio IRQ is now offset a good amount.  Good news I guess is
> its pretty predictable.
> 
> * If we couple this with progressively higher latency C-States we see
> that IO speed can fall by a good amount, especially for PIO mixes.
> Now if QOS is maintained you may or may-not care.
> 
> I was wondering what thoughts of optimizing this might be.
> 
> One thought was if an io-ondemand of some sort was used.  It could
> track interrupt statistics and be feed back into cpu-idle.  When
> there is a high interrupt load period it could shrink the acceptable
> latency and thus help choose a good a C-State which favors
> throughput.  Some moving average window could be used to track it.
> 
> Perhaps a new interrupt attribute could be attached at irq request
> time to allow the tracking of bandwidth important devices.
> 
> The attached is captured on a .22 kernel.  The same should be
> available in a bit on a .24 kernel.


So right now we have the pmqos framework (and before that we had a simpler version of this);
so if your realtime (or realtime-like) system cannot deal with latency longer then X usec,
you can just tell the kernel,, and the deeper power states that have this latency, just won't get used.

What you're mentioning is sort-of-kinda different. It's the "most of the time go as deep as you can,
but when I do IO, it hurts throughput".
There's two approaches to that in principle
1) Work based on historic behavior, and go less deep when there's lots of activity in the (recent) past
   A few folks at Intel are working on something like this
2) You have the IO layer tell the kernel "heads up, something coming down soon"
   This is more involved, especially since it's harder to predict when the disk will be done.
   (it could be a 10msec seek, but it could also be in the disks cache memory, or it could be an SSD or,
   the disk may have to read the sector 5 times because of weak magnetics... it's all over the map)
   Another complication is that we need to only do this for "synchronous" IO's.. which is known at higher layers
   in the block stack, but I think gets lost towards the bottom.

There's another problem with 2); in a multicore world; all packages EXACPT for the one which will get the irq can go to a deeper state anyway....
but it might be hard to predict which CPU will get the completion irq.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
