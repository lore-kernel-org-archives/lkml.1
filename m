Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbYFIELu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbYFIELu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 00:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbYFIELk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 00:11:40 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:27032 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750699AbYFIELj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 00:11:39 -0400
Date: Mon, 9 Jun 2008 13:09:26 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       Uwe.Kleine-Koenig@digi.com, gregkh@suse.de, akpm@linux-foundation.org,
       tglx@linutronix.de
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080609040926.GA9492@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Hans J. Koch" <hjk@linutronix.de>,
	Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
	Uwe.Kleine-Koenig@digi.com, gregkh@suse.de,
	akpm@linux-foundation.org, tglx@linutronix.de
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se> <20080604101144.GA3207@local> <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com> <20080605090916.GA3198@local> <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com> <20080605112744.GB3198@local> <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com> <20080608205455.GA3191@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608205455.GA3191@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 10:54:57PM +0200, Hans J. Koch wrote:
> On Sun, Jun 08, 2008 at 07:19:25PM +0900, Magnus Damm wrote:
> > >>
> > >> So your main objection against this patch is that you cannot use it
> > >> with shared interrupts?
> > >
> > > I think I've explained my objections detailed enough.
> > 
> > It's still unclear to me. Please make a brief summary of your objections.
> 
> The objection is that your code offers no advantages. What can we do
> with your patch applied that we cannot do with uio_pdrv alone?
> 
Re-use it across similar devices, without endless duplication for one.
This point has been re-iterated multiple times in these threads, yet
seems to be completely ignored each time it is brought up. There is zero
point in reproducing the same code over and over and over again for each
CPU variant, especially when the existing UIO framework is a pretty good
match for the problem.

This is behaviour that we both need and wish to take advantage of through
UIO. You constantly advocate uio_pdrv as the one-stop solution, which
might even fit this case if the unique IRQ mode was factored in to it. If
you're not able to live with that, then a separate driver is necessary.

> > > If it's a device within the SoC, you won't use UIO for that. If you did,
> > > your platform would depend on certain userspace software which is simply
> > > crap. And devices outside the SoC are board specific.
> > 
> > Why wouldn't we use UIO for device within the Soc? 
> 
> Can't you read? I've answered that in the lines above your question.
> 
> > I've been doing
> > that for quite some time now.
> 
> Really? I haven't seen any such driver yet. IMO, support for everything
> inside a SoC should be completely within the kernel, I wouldn't do it
> with UIO. But it's up to the arch maintainer to decide that. Did you ask
> him?
> 
Yes, and this was the conclusion we came to. There is simply no in-kernel
infrastructure for dealing with the class of devices that are being
exposed to userspace. A small amount of refcounting and management glue
in the kernel is necessary, but the rest is userspace's problem. It's
also hardly architecture-specific, anyone with a complex SoC containing
equally complex IP blocks where no in-kernel infrastructure exists that
still needs to do basic accounting on the kernel side is going to be
faced with this situation.

UIO is generally a pretty good match for this problem, and I'd really
rather not have something buried in my architecture directory to work
around this because the subsystem people decide to be resistant to other
approaches.

> Once more (for the last time): The technical argument against your patch
> is that it offers no advantages. It makes other code more complicated,
> less obvious, and less consistent. This might be OK if we had big
> advantages in return, but this isn't the case.

Great, so lets throw an ifdef around it and be done with it. Some people
need this functionality, while others do not. The only way this can be
perceived as confusing is if it's default-enabled, which then also
requires the semantics to be documented. Having said that, there are
plenty of places in the kernel where we flip between IRQ and polling mode
based on IRQ specifier automatically, so it's not obvious that this sort
of use would qualify as a source of confusion.

> Furthermore, your approach works only on certain platforms. But that
> doesn't matter anymore, because the above is already enough to NAK your
> patch. We won't add code just because it could be done.
> 
I'm not sure what your point is. Your uio_pdrv approach only works on
certain platforms too, so what? We add code because it solves a
particular problem, not for the hell of it.

> If I post a patch, it is my job to make it clear what advantages we have
> if we apply it. And no, nothing is unclear with your patch.

The advantages are primarly around reusability. UIO offers a fairly clean
interface to work with, and the only thing that needs to be addressed is
how to deal with the "unique" IRQ mode. For the blocks Magnus is
exposing, they all have this quality, and none of them have any place in
the kernel outside of the bare management bits. While Magnus could easily
run off and create yet another user interface for these things, it would
be nice to have this solved in a more generic fashion. I'm not sure
what's confusing about any of this or why you don't see these reasons as
an advantage.

All of the code you've wanted to see has been posted in previous threads.

> > > Unfortunately, I'm one of the two UIO maintainers, so I feel obliged to
> > > review your patch and give my opinion. That doesn't mean I'm
> > > the big boss who makes the final decision. I can be critized and
> > > overridden. If Greg loves your patch and merges it, fine. Try it.
> > 
> > Maybe I will. =)
> 
> Did you notice that in this thread nobody spoke up to support your
> patch?
> 
It's difficult to jump in and support a patch when it's unclear what the
technical arguments against it are. Usually if there's a need for a
driver and no technical arguments against it, the problem works itself
out. Whether we go with this patch or the "other" driver approach is
immaterial, if you aren't going to allow uio_pdrv to be modified, then
please stop peddling it as the solution to the given problem.
