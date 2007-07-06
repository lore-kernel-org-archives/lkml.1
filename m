Return-Path: <linux-kernel-owner+w=401wt.eu-S1762209AbXGFDzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762209AbXGFDzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 23:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761250AbXGFDy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 23:54:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:40052 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760930AbXGFDy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 23:54:58 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <200707060935.12706.nigel@nigel.suspend2.net>
References: <20070703042916.GA17240@srcf.ucam.org>
	 <200707060913.05644.nigel@nigel.suspend2.net>
	 <1183677643.3388.105.camel@localhost.localdomain>
	 <200707060935.12706.nigel@nigel.suspend2.net>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 13:54:15 +1000
Message-Id: <1183694055.3388.108.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 09:35 +1000, Nigel Cunningham wrote:
> 
> Nice try :) Okay then, you remove the freezer, try hibernating, then get back 
> to me after you've fixed your filesystem because some process that wasn't 
> frozen started writing things after the atomic copy (making the on disk 
> filesystem inconsistent with the snapshot).
> 
> As Pavel rightly said, you can get rid of the freezer, but you're only going 
> to have to implement another one that does the essentially the same thing, 
> even if it is at some other level.

I was mostly talking about STR... Regarding STD, we have a different
problem and we all know it. The freezer is one somewhat horrible way to
get it working for now, I would prefer something more along the way that
blocks the page cache from writing out new dirty pages though, except
those specifically flagged by the snapshot.

That is, some kind of proper snapshotting facility, as linus was
describing some time ago.

Ben.

> > > >  - Silently add GFP_NOIO to all allocations, to avoid having things
> > > > blocking in kmalloc() with a mutex held that will deadlock with
> > > > suspend() in a driver for example. Or set some way to have all GFP
> > > > waiters wakeup and fail rather than wait for IOs. It's hard/bizarre but
> > > > necessary, again, with or without a freezer.
> > > 
> > > GFP_ATOMIC? (In driver suspend, they shouldn't be sleeping either, right?)
> > 
> > NOIO should be enough I think but ATOMIC would do).
> >  
> > That's one of the reason why I used to have the pre-suspend and
> > post-resume hooks in my original powermac implementation, for those few
> > drivers complicated enough to require some pre-allocations.
> >  
> > > >  - Deal with the firmware problem. The best way is probably to have an
> > > > async request_firmware interface(). Another thing is, drivers may want
> > > > to cache their firmware in main memory, that sort of thing...
> > > >
> > 
> > Note that the above firmware problem could be dealt with also with the
> > pre-suspend/post-resume. Allowing to pre-request firmware etc... and
> > keep it around until after resume, because we know we will need it.
> > Gives a chance to drivers to perform things while the system is still
> > live, filesystems still working, etc... (big memory allocations for
> > example).
> > 
> > > > And that's just a small list off the top of my mind, of known problems
> > > > that will cause deadlocks or misbehaviours today, with or without the
> > > > freezer, and that need to be addressed.
> > > 
> > > Userspace device drivers too?
> > 
> > Maybe but they are less of an issue, most of the time, they don't do DMA
> > or whatever harmful things. If they are USB drivers, for example, they
> > are an non-issues at that level.
> 
> (Leaving the rest of the message intact so we don't have to fragment the 
> discussion into a million subthreads).
> 
> Regards,
> 
> Nigel
> 
> 
> Invalid signature
> 
> 

