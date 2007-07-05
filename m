Return-Path: <linux-kernel-owner+w=401wt.eu-S1761793AbXGEOww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761793AbXGEOww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759695AbXGEOwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:52:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53953 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761308AbXGEOwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:52:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 16:59:59 +0200
User-Agent: KMail/1.9.5
Cc: Oliver Neukum <oliver@neukum.org>, Miklos Szeredi <miklos@szeredi.hu>,
       paulus@samba.org, stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051609.25887.rjw@sisk.pl> <20070705142318.GA22598@srcf.ucam.org>
In-Reply-To: <20070705142318.GA22598@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051700.01158.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 16:23, Matthew Garrett wrote:
> On Thu, Jul 05, 2007 at 04:09:24PM +0200, Rafael J. Wysocki wrote:
> > On Thursday, 5 July 2007 15:46, Matthew Garrett wrote:
> > > I have a model for STD that avoids the need to freeze the entirity of 
> > > userspace, but I need to find some more time to flesh it out.
> > 
> > You can just describe it, as far as I'm concerned. :-)
> 
> The basic model is that nobody's really described a use-case where we 
> actually care about restoring system state. What people want is to be 
> able to restore application state. So, arguably, what we want isn't to 
> save the entire kernel state and application state in one go because we 
> can reconstruct a huge amount of that afterwards.

Hmm, I think that will take more time than just restoring the entire system
state.

> This isn't too much of a problem. All we actually need to be able to do 
> is to atomically dump process state (which requires the freezer, but 
> doesn't require freezing the entire system),

Once you've frozen processes, the freezing of the rest of the system is
pretty straightforward.  Currently, we do a bit too much for that, because we
suspend devices instead of just quiescing them before creating the image,
bu that's going to change (I hope).

> shut down, get the system back into approximately the correct state (remount
> filesystems, start X, whatever) and then restore the processes.
>
> Now, obviously, there's actually quite a lot of complexity here that I'm 
> neatly eliding :) The biggest issue is restoring hardware state. We'd 
> require quite a different model to the existing one, but I think there 
> are arguments there for it being helpful anywy. Keeping state in the 
> midlevels rather than the low-level drivers would give us much more 
> ability to deal with hardware issues, and potentially allow the 
> replacement of faulty hardware without userspace caring (freeze your 
> mission-critical application, hotplug the network card, let the kernel 
> restore state and resume it)

Sounds neat, but what about the processes that depend on the hardware
(like hal)?

> There's other advantages to this. As long as the kernel hasn't changed 
> too much it would be possible to restore userspace across kernel 
> security upgrades. You end up saving less to disk so performance should 
> be better.

Well, not that much less. :-)

> Touching filesystems between suspend and resume doesn't result in the entire
> world ending.

Yes, that would be an advantege.

> I've mocked up a basic implementation using cryopid, but it's somewhat 
> limited by the lack of support for sockets. I'd like to move more of the 
> smarts into the kernel (Hurray, checkpointing!) and then see how much 
> hardware support ends up horifically broken.

There's one more thing, I'm not sure if that's possible to separate the kernel
state from the processes state entirely (think shared memory, LRU lists,
situations in which the application has been frozen while waiting for an
event in the kernel space etc.).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
