Return-Path: <linux-kernel-owner+w=401wt.eu-S1762108AbXGFHGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762108AbXGFHGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759990AbXGFHGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:06:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56902 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758413AbXGFHGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:06:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 09:13:22 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, Miklos Szeredi <miklos@szeredi.hu>,
       pavel@ucw.cz, paulus@samba.org, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
References: <Pine.LNX.4.44L0.0707051713440.2753-100000@iolanthe.rowland.org> <200707052337.27066.oliver@neukum.org>
In-Reply-To: <200707052337.27066.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707060913.24131.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 23:37, Oliver Neukum wrote:
> Am Donnerstag, 5. Juli 2007 schrieb Alan Stern:
> > On Thu, 5 Jul 2007, Miklos Szeredi wrote:
> > 
> > > I fear, that your efforts to "save" the freezer are in vain.  It is
> > > already moderately hackish with that PF_FREEZER_SKIP and the kernel
> > > dotted randomly with try_to_freeze() calls, but adding bandaids to try
> > > to order freezing userspace processes in the right order would just
> > > make it a horrible mess.
> > 
> > I agree that bandaids won't work.  What's needed is something more 
> > radical.  Things like FUSE must be written so that the kernel parts 
> > _can_ freeze even while they are waiting for a response from a user 
> > thread.
> 
> OK, some radical ideas.
> 
> In principle we want a deadlock here. Tasks that are frozen due to fuse
> are as good as frozen, there's no need to formally freeze them.
> The bad uninterruptible tasks are those waiting for hardware.
> 
> Can we detect the difference? Perhaps we can label those crucial locks
> and when only tasks in the refrigerator and tasks waiting on these locks
> are left we are content and go on to suspending the device tree.

Well, I think we can just make the freezer handle uninterruptible tasks.

If an uninterruptible task is stuck holding a lock that's needed for suspend,
the freezerless suspend will deadlock anyway. :-)

The only reason (I know of) why we don't handle uninterruptible tasks in the
freezer is that we're afraid of the suspend process deadlocking with an
uninterruptible task holding a lock, but AFAICS the probability of such an
event is extremely small.

Also, the powermac suspend will deadlock in such cases, so the fact that
it doesn't deadlock means that they don't occur very often (if at all).

I have a patch for that, will post it in a separate thread in a while.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
