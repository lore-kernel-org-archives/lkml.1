Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbXDZWEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbXDZWEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbXDZWEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:04:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52026 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100AbXDZWEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:04:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Thu, 26 Apr 2007 23:22:22 +0200
User-Agent: KMail/1.9.5
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Pavel Machek <pavel@ucw.cz>,
       Dumitru Ciobarcianu <Dumitru.Ciobarcianu@ines.ro>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>,
       "suspend2-devel@lists.suspend2.net" 
	<suspend2-devel@lists.suspend2.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
References: <qlG9V8pP.1177603830.8836760.penberg@cs.helsinki.fi> <200704262237.32665.rjw@sisk.pl> <1177620949.4737.61.camel@nigel.suspend2.net>
In-Reply-To: <1177620949.4737.61.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704262322.24048.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 April 2007 22:55, Nigel Cunningham wrote:
> Hi.
> 
> On Thu, 2007-04-26 at 22:37 +0200, Rafael J. Wysocki wrote:
> > On Thursday, 26 April 2007 22:16, Nigel Cunningham wrote:
> > > Hi.
> > > 
> > > On Thu, 2007-04-26 at 21:28 +0200, Rafael J. Wysocki wrote:
> > > > On Thursday, 26 April 2007 18:10, Pekka Enberg wrote:
> > > > > 
> > > > > On 4/26/2007, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > > > In principle, we could add suspend2 as an alternative (in analogy with the I/O
> > > > > > schedulers, for example), but I think for this purpose it should be reviewed
> > > > > > properly.
> > > > > 
> > > > > Yeah, this makes sense.
> > > > > 
> > > > > On 4/26/2007, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > > > There also is a real problem with how it uses the LRU pages.  It _seems_ to
> > > > > > work, but at least to me it seems to be potentially dangerous.
> > > > > 
> > > > > I am new to suspend2 so can you please explain what exactly is dangerous
> > > > > about it?
> > > > 
> > > > After freezing tasks, it first saves the contents of the LRU pages, freezes
> > > > devices and then uses the LRU pages for storing the suspend image (if more
> > > > memory is needed, it's allocated, but that's irrelevant here).  Now, we have no
> > > > warranty that the LRU pages are not updated after we've saved their contents
> > > > (first potential problem here).
> > > > 
> > > > After the image has been created, we have to unfreeze devices and save the
> > > > image.  Now, we have no warranty that no one will be writing to the LRU pages
> > > > that we have used to store the image, for whatever reasons known to him, so the
> > > > image can potentially get corrupted while it's being saved.
> > > > 
> > > > In principle, device drivers can do this and there are some kernel threads that
> > > > also can do this (we don't freeze them, because they're needed for the image
> > > > saving).
> > > > 
> > > > The design is conceptually really really complicated and it makes strong
> > > > assumptions about the behavior of different subsystems.  While these
> > > > assumptions _may_ be satisfied right now, we'd have to ensure the satisfaction
> > > > of them in the future if suspend2 were merged.
> > > 
> > > That's a good description of the issue, although I think _may_ and
> > > _seems_ are stating things a bit more pessimistically than is
> > > necessary. 
> > 
> > I've used them to express my personal concerns.
> > 
> > > You see, we need to remember that the pages which are saved separately
> > > are LRU pages. Because userspace is frozen, their contents are going to
> > > be static. The only possibilities for modifying them come from timer
> > > routines, improperly frozen filesystems and device drivers.
> > 
> > And kernel threads that we don't freeze deliberately.  Currently, these are
> > all worker threads, dm-related kernel threads and some others.
> > 
> > > We have code to check that the LRU isn't changing, and I've only seen
> > > one report of modifications to about 20 LRU pages. I haven't had the
> > > time yet to chase down the cause, but hope to do so soon.
> > 
> > I didn't say that would be common.  If it had been, you'd have seen problems
> > with it.  To me the problem is the lack of warranty that it won't happen.
> > 
> > > The general scheme has been working for four or five years - if there
> > > was a fundamental issue, we would have found it by now.
> > > 
> > > The scheme isn't complicated.
> > 
> > Conceptually, it is complicated just because you're using the LRU.
> 
> Well, I'm willing to look at other ideas. I actually selected LRU
> because it was simple. Prior to this, we did have a try at just
> iterating over the pages of frozen processes, but it didn't yield enough
> pages to be viable. I wouldn't be surprised if hunting down the cause of
> these changing pages leads to doing the opposite - starting with LRU
> pages and then removing all the ones owned by processes. (Am I right in
> thinking the remainder would be anonymous pages? I must learn more mm
> inards :>).

I think we can discuss that, and the other things too.  I'm open to
cooperation. :-)

Greetings,
Rafael
