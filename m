Return-Path: <linux-kernel-owner+w=401wt.eu-S1753039AbZK3Os2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbZK3Os2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 09:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZK3Os1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 09:48:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48954 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752154AbZK3Os0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 09:48:26 -0500
Date: Mon, 30 Nov 2009 14:47:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Uwe =?ISO-8859-14?B?S2xlaW5l?= =?ISO-8859-14?B?LUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.infradead.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
 IRQF_SHARED|IRQF_DISABLED)
Message-ID: <20091130144702.14bea0ee@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0911301519120.24119@localhost.localdomain>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>
	<1259589780.26472.18.camel@laptop>
	<alpine.LFD.2.00.0911301519120.24119@localhost.localdomain>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 15:24:40 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 30 Nov 2009, Peter Zijlstra wrote:
> > On Mon, 2009-11-30 at 14:54 +0100, Thomas Gleixner wrote:
> > > The correct solution IMNSHO is to get rid of IRQF_DISABLED and run
> > > interrupt handlers always with interrupts disabled and require them
> > > not to reenable interrupts themself.
> > > 
> > > Thoughts ?
> > 
> > I'm all for removing that brain damage:
> > 
> >   http://lkml.org/lkml/2009/3/2/33
> 
> Darn, I knew that we discussed that before, but my memory tricked me
> into believing that it was years ago :)

Well the patch listed there is utterly bogus and will cause hangs at
startup. The problem case is IRQF_SHARED|IRQF_DISABLED. The patch messes
up all the unshared cases too - and lots of non sharable IRQ hardware just
jams the IRQ line high until you beat it into sense (8530's are notorious
for getting into that kind of state at init for example). You can't simply
remove the disabled from those drivers, you need to be able to allocate a
non-shared IRQ, and then enable it or do major driver restructuring of
obscure old driver code.

SHARED|DISABLED ought to WARN_ON() and if that doesn't motivate people
then return -EINVAL. And with any luck that'll prove 6 months later that
most of the offenders are not used and we can delete them wholesale.

DISABLE without SHARED is fine, and saves waking the dead.

