Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbXD0X6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbXD0X6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757930AbXD0X6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:58:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59288 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757931AbXD0X6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:58:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Lang <david.lang@digitalinsight.com>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 02:02:33 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280121.08553.rjw@sisk.pl> <Pine.LNX.4.63.0704271550220.10565@qynat.qvtvafvgr.pbz>
In-Reply-To: <Pine.LNX.4.63.0704271550220.10565@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704280202.34040.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 28 April 2007 01:01, David Lang wrote:
> On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
> 
> > On Saturday, 28 April 2007 00:26, David Lang wrote:
> >> On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
> >>
> >>>>> We're freezing many of them just fine. ;-)
> >>>>
> >>>> And can you name a _single_ advantage of doing so?
> >>>
> >>> Yes.  We have a lot less interdependencies to worry about during the whole
> >>> operation.
> >>>
> >>>> It so happens, that most people wouldn't notice or care that kmirrord got
> >>>> frozen (kernel thread picked at random - it might be one of the threads
> >>>> that has gotten special-cased to not do that), but I have yet to hear a
> >>>> single coherent explanation for why it's actually a good idea in the first
> >>>> place.
> >>>
> >>> Well, I don't know if that's a 'coherent' explanation from your point of view
> >>> (probably not), but I'll try nevertheless:
> >>> 1) if the kernel threads are frozen, we know that they don't hold any locks
> >>> that could interfere with the freezing of device drivers,
> >>
> >> does teh process of freezing really wait until all locks have been released?
> >
> > Yes, it does.
> >
> >>> 2) if they are frozen, we know, for example, that they won't call user mode
> >>> helpers or do similar things,
> >>
> >> this won't matter unless the user mode helpers are going to do I/O or other
> >> permanent changes
> >
> > Please note that even accessing a file may be a permanent change.
> 
> if accessing a file on a read-only filesystem changes that filesystem it's a bug
> 
> see the recent thread about ext3 journal replays when mounting read-only as an 
> example.

Oh well.  Is this really wrong to protect users from such bugs, if we can do
that?

> >>> 3) if they are frozen, we know that they won't submit I/O to disks and
> >>> potentially damage filesystems (suspend2 has much more problems with that
> >>> than swsusp, but still.  And yes, there have been bug reports related to it,
> >>> so it's not just my fantasy).
> >>
> >> if you have the filesystems checkpointed then I/O after the freeze won't matter
> >> as you just revert to the checkpoint (and since this is going to be thrown away
> >> it can stay in ram)
> >
> > In that case, I would agree.  Currently, however, we're not even close to this
> > point.
> >
> > The checkpointing of filesystems would be a very welcome feature, but there's
> > no anyone working on it right now, AFAICT.
> >
> >> if we are willing to make a break with the past to implement the new snapshot
> >> capability, we should be able to use the LVM snapshot code to handle the
> >> filesystem
> >
> > Yes, we can do that, in principle, and screw all of the current users in the
> > process.  And finally we'd end up with something similar to what is done now,
> > IMHO.
> 
> however, the result may be a lot less 'special case pwoer management' code and a 

Are you referring to some specific code?

> lot more re-use of code that's in place for other uses.

This already is happening.

> if work on the current versions was stopped (other then trying to avoid 
> regressions) and a new version (with new userspace tools) was built in a way 
> that satisfies everyone the old version could be phased out in a year or two 
> (per the normal feture removal process)

May I say it's not realistic?

> > And no, the things are not just totally broken, as it may follow from these
> > discussions.  The problem is that the people who are discussing them so
> > viciously have never tried to write anything like the hibernation code.
> >
> > This is as though as I were discussing the design of the CPU schedulers,
> > although I only know how they work on a general level.
> >
> > Actually, the really problematic thing with the hibernation _right_ _now_ is
> > what Linus is so concerned about (and rightfully so) - that we use the
> > same device drivers' callbacks for the hibernation and suspend (aka s2ram).
> > The other things work quite well and are really robust.
> 
> if simply splitting the functions cleans everything up enough to satisfy 
> everyone then we're almost done right? ;-)

Practically, yes.  Theoretically, there's no software you can't improve
(except, probably, TeX), but that might not be worth the effort.

> however I think that there are other fundamental disagreements here, and neither 
> the 'do absolutly everything in the kernel' or the 'do almost nothing in the 
> kernel' approaches are going to fly in the long run.

I think we'll have an agreement, though.

> I think the userspace<->kernel interface is going to be different then
> either apprach is doing now,

You're probably right

> and as such it's an oppurtunity to make more drastic changes if they are
> appropriate.

Well, maybe.

> for example, why should we have LVM snapshot code and hibernate 
> snapshot/filesystem checkpoint code instead of just useing the LVM code (which 
> gets excercised and tested far more then the other code ever would be)? saying 
> that if you want to suspend to disk you need to use LVM is a change, but it's 
> a change that people could probably live with.

Well, that's a theory.  Probably a good one, but still. :-)

The positive aspect of all this is that people have started to pay attention to
what we're doing, and gradually they will learn about the problems that they're
just not seeing right now.

Greetings,
Rafael
