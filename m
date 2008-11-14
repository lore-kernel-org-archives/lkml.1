Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbYKNVLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbYKNVLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbYKNVKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:10:49 -0500
Received: from mail.queued.net ([207.210.101.209]:3983 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbYKNVKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:10:47 -0500
Date: Fri, 14 Nov 2008 16:10:35 -0500
From: Andres Salomon <dilinger@queued.net>
To: Jeremy Katz <katzj@redhat.com>
Cc: jordan@cosmicpenguin.net, Pavel Machek <pavel@suse.cz>,
       Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org,
       dsaxena@laptop.org
Subject: Re: [PATCH] ALSA: cs5535audio: only build OLPC support if MGEODE_LX
 is defined
Message-ID: <20081114161035.786f89ba@ephemeral>
In-Reply-To: <1226688350.13086.61.camel@aglarond.local>
References: <1226547898.13077.83.camel@aglarond.local>
	<s5h63msru7z.wl%tiwai@suse.de>
	<20081113153714.GA1520@ucw.cz>
	<s5h3ahvhb9w.wl%tiwai@suse.de>
	<20081113111428.59aa36cb@ephemeral>
	<20081113163802.GA1734@ucw.cz>
	<20081113120147.2ecde3c8@ephemeral>
	<20081113190339.GE17851@elte.hu>
	<s5hzlk3kxuf.wl%tiwai@suse.de>
	<20081113213852.16561ed2@ephemeral>
	<20081114075248.GB8397@atrey.karlin.mff.cuni.cz>
	<491DB6B9.7030209@cosmicpenguin.net>
	<1226688350.13086.61.camel@aglarond.local>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 13:45:50 -0500
Jeremy Katz <katzj@redhat.com> wrote:

> On Fri, 2008-11-14 at 10:34 -0700, Jordan Crouse wrote:
> > Pavel Machek wrote:
> > >>>> i've zapped this patch meanwhile:
> > >>>>
> > >>>>  1355c96: x86/olpc: make CONFIG_OLPC dependent on
> > >>>> CONFIG_MGEODE_LX
> > >>>>
> > >>>> because it cripples the ability to run distribution kernels on
> > >>>> the OLPC.
> > >>> OK, I reverted also all relevant changes for cs5535audio driver
> > >>> now. The patches are saved in topic/cs5535audio branch, though.
> > >>>
> > >>> Let's fix OLPC-geode coupling first.
> > >> Hm, I'd really rather prefer this to be upstream.  The patch I
> > >> sent adds no regressions, allows the driver to happily coexist
> > >> with existing stuff, and *does* add support if you configure
> > >> OLPC with MGEODE_LX (generic kernels don't get the additional
> > >> benefits, but those configured specifically for OLPC do).
> > > 
> > > Yes, but the patch is also not a good way of going forward, so it
> > > should not be in mainline.
> > 
> > For the moment, this is a reasonable intermediate solution.  I
> > think the way forward will involve a great deal more work.
> 
> It's the work that should have been done from the beginning.  And once
> code is upstream, the motivation to make things "correct" drops

Wow.  You have it so backwards, it's not even funny.

When stuff is upstream, there is pressure from lots of people to make
things "correct".  When stuff isn't upstream, there's very little pressure;
that's how the ALSA stuff has managed to sit outside of the upstream
kernel for ages.  It's a tiny bit of code, easy to port to new kernels,
and therefore can happily be forgotten about in an out-of-tree kernel.

You say "it's work that should have been done from the beginning", and
yet this is the first time that I've heard anyone request it.  If
the geode code had remained out of mainline, I wouldn't have heard the
request at all.

I *really* don't want this to turn into OFW/promfs mess; attempts at
mainline inclusion fail, relevant parties who we contact ignore us
regarding the "correct" way forward, and therefore things sit outside
of mainline for ages with no progress whatsoever.


[...]
> > Also, while we are at it, we should be more specific and rename the 
> > hooks from geode_ to cs5536_, since there will soon be a system in
> > the wild with a MIPS processor and a CS5536.
> > 
> > But needless to say, this will be a goodly amount of work and churn
> > that will need some heavy testing in the OLPC kernel.  In the
> > meantime, Andres' fix will make the upstream kernel happier.
> 
> It is work, but I'm not sure it's huge amounts.  And by doing it
> *upstream first*, you benefit from the feedback and testing of the
> wider community.  Development of things in a silo is what tends to
> lead to these sorts of threads :/
> 

It is huge amounts, because it's API work.  If we were just twiddling
hardware bits, that would be easy.  However, we're trying to come up
with an interface that works not only with existing upstream drivers, but
also the remaining out-of-mainline drivers that we maintain.  I also
expressed interest in perhaps using the generic GPIO API for geode,
but that's something that requires a good deal of thinking about.  I
don't want to rush through it just to get the ALSA driver upstream.

The DCON driver has not gone upstream exactly because the GPIO API
does not work well for it right now (and out of tree, we were banging
on GPIO pins directly).  Obviously, any changes to the API should also
take the DCON into account; I'd rather fix this all the *right* way
than to just write a quick patch that munges the API to make you happy,
and then have to have even more code churn later to completely redo
the API.

