Return-Path: <linux-kernel-owner+w=401wt.eu-S1762327AbXGMVBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327AbXGMVBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 17:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbXGMVAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 17:00:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33210 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbXGMVAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 17:00:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Fri, 13 Jul 2007 23:08:23 +0200
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, david@lang.hm,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707131402001.2684-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707131402001.2684-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707132308.24323.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 13 July 2007 20:15, Alan Stern wrote:
> On Fri, 13 Jul 2007, Eric W. Biederman wrote:
> 
> > > I doubt that re-probing devices will work.  The probe routine won't 
> > > expect there to be any registered children, so it will try to 
> > > re-register them.
> > 
> > So really unregister the children.  All we really need to do is disassociate
> > the drivers from the devices (to reuse the existing code) we don't
> > need to rescan for the devices.  The associating the device drivers
> > with devices takes human measurable amount of time.  The only thing
> > that takes time is waiting on hardware.  Maybe things will suck
> > and associating the drivers with the device tree with take a whole
> > second on a bad day, I don't think that is enough time to add
> > complicated new code paths for the drivers to maintain.
> 
> This would be even worse!
> 
> Suppose you unbind (or unregister, either way) a disk driver.  It's 
> unbind method will unregister the gendisk structure, thereby deleting 
> all the partitions and block devices associated with the disk.  This 
> will leave any and all memory mappings dangling in the breeze.  When 
> the kernel resumes from hibernation, nothing will work.
> 
> > > On the other hand, post_restore methods could be written to expect 
> > > something like this.
> > 
> > Please Please Plaese do not start with the existing software suspend
> > to disk code and thinking.
> 
> Ha!  Gotcha.  You evidently haven't been reading the linux-pm mailing 
> list for the last few months.  :-)
> 
>      1. post_restore isn't "existing software suspend to disk code"
> 	(you're supposed to call it "hibernation" now, BTW).
> 
>      2. post_restore isn't new.  It has already been proposed and
> 	generally accepted.  It is part of the movement to untangle
> 	and separate the suspend and hibernate code paths.
> 
>      3. post_restore hasn't been implemented yet.  It's barely past
> 	the proposal stage.
> 
>      4. Maybe _you_ like to discuss complicated issues such as this
> 	one without thinking, but the rest of us prefer a little 
> 	cerebration.
> 
> >  We are not implementing suspend to ram
> > here or anything like it.
> 
> One of the topics in this discussion has been "suspend-to-both", which
> includes suspend-to-RAM.  
> 
> But anyway, so what?  I wasn't talking about suspend-to-RAM; I was
> talking about hibernation.
> 
> >  We already have proven code paths that
> > know how to quiesce hardware.  We already have proven code paths
> > that know how to take quite hardware and make it run.  Please let's
> > just use them.  At least until we can see that they are insufficient
> > to the task.
> 
> Was this request directed at me or at Rafael?  It's hard to tell.

Yeah.

Anyway, IMO, unregistering of devices in the hibernated kernel won't work,
because it doesn't know how to register them back after the restore.  Sure,
we can teach it do do that, but I think it's simpler to just keep devices
registered and have a .post_restore() or .reprobe() callbacks for handling
the reinitialization of hardware.

And yes, we've discussed this in detail for many times on linux-pm.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
