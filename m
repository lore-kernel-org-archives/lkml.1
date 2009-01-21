Return-Path: <linux-kernel-owner+w=401wt.eu-S1764283AbZAULyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764283AbZAULyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758371AbZAULyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:54:41 -0500
Received: from ns2.suse.de ([195.135.220.15]:56374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758134AbZAULyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:54:40 -0500
Date: Wed, 21 Jan 2009 12:54:38 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep and debug objects together are broken?
Message-ID: <20090121115438.GT24891@wotan.suse.de>
References: <20090120085559.GB19505@wotan.suse.de> <19f34abd0901201311t2425056dia6182812f7270297@mail.gmail.com> <20090121071950.GM24891@wotan.suse.de> <20090121114229.GA10606@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121114229.GA10606@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 12:42:29PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > On Tue, Jan 20, 2009 at 10:11:47PM +0100, Vegard Nossum wrote:
> > > On Tue, Jan 20, 2009 at 9:55 AM, Nick Piggin <npiggin@suse.de> wrote:
> > > > Hi,
> > > >
> > > > I've had a problem frustrating my testing because lockdep was silently turning
> > > > itself off... I patched out the code to disable lockdep after the first error,
> > > > and it started showing up weird errors. kernel/fork.c:990 seemed to be the
> > > > first to trigger (hard irqs disabled) from a call_usermodehelper call. Later,
> > > > migration thread was reported to try to unlock rq->lock although it was
> > > > holding no locks. Then init was reported to return to userspace without
> > > > releasing an objectdebug hash lock.
> > > >
> > > > All that went away and everything seemed to work properly with debug objects
> > > > configured out.
> > > >
> > > > I didn't get too far in trying to debug the problem. But it should be easy
> > > > enough to reproduce (if not, I can post traces or test patches).
> > > 
> > > I just built a kernel with lockdep and debugobjects enabled, and
> > > everything seemed fine. I think you should post your kernel version,
> > > config, and the lockdep patch (if needed -- it didn't seem to turn
> > > itself off here).
> > 
> > Are you sure? Ie. sysrq+D a still works properly? In that case, you
> > wouldn't need the lockdep patch because it just prevents the feature from being
> > switched off.
> > 
> > I'll have to dig a bit further, then. The annoying thing is that
> > lockdep turns itself off at the drop of a hat (and this particular
> > problem seems to happen without any backtraces), so it invalidates
> > all your lockdep testing if you don't realise it has turned itself
> > off.
> > 
> > Is there a way to re-arm lockdep? That would be neat.
> 
> Not at the moment, and it looks somewhat complicated. All lock state 
> freezes the moment lockdep disarms itself. That's very much a key design 
> element: rarely will you see any real lockdep-inflicted crash - even if it 
> has a bug it is self-disabling itself and running for the door very 
> efficiently.

Lockdep isn't exactly for production systems though, is it? If you
want to debug some problem but you have other code (that you don't
have knowledge to debug) is switching it off...

Also, I'd guess that most bugs in lockdep would probably fall pretty
neatly into either the "pretty harmless" or "completely take down the
system" categories ;)
