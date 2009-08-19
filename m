Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbZHSSuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbZHSSuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZHSSuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:50:11 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:53964 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZHSSuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:50:10 -0400
Date: Wed, 19 Aug 2009 13:50:10 -0500
From: Scott Wood <scottwood@freescale.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] spinlock: __raw_spin_is_locked() should return true for UP
Message-ID: <20090819185010.GA12304@b07421-ec1.am.freescale.net>
References: <1250635343-32546-1-git-send-email-galak@kernel.crashing.org> <alpine.LFD.2.01.0908181618420.3158@localhost.localdomain> <alpine.DEB.2.00.0908181931180.28398@gandalf.stny.rr.com> <alpine.LFD.2.01.0908181640120.3158@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908181640120.3158@localhost.localdomain>
User-Agent: Mutt/1.4.1i
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 04:52:20PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 18 Aug 2009, Steven Rostedt wrote:
> >
> > > The thing is, some people may assert that a lock is held, but others could 
> > > easily be looping until it's not held using something like
> > > 
> > > 	while (spin_is_locked(lock))
> > > 		cpu_relax();
> > 
> > Wouldn't something like that be really racey? And anyone doing such a 
> > thing had better have that code within an #ifdef CONFIG_SMP.
> 
> Sure, it's hopefully inside a #ifdef CONFIG_SMP.
> 
> And no, it's not necessarily racy. Sure, it's race in itself if that's all 
> you are doing, but I could imagine writing that kind of code if I knew 
> some lock was likely held, and I wanted to avoid doing a "try_lock()" 
> until it got released.

So you'd basically have the effect of a spin_lock(), except with the
bonus of breaking RT hacks that do something other than spin, and
preventing arch code from doing certain types of relaxation that are only
appropriate when waiting on a lock (such as mdors on powerpc, which
de-emphasizes until a reservation is broken).

Not exactly something we should encourage, IMHO.

-Scott
