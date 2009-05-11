Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZEKOC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZEKOC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbZEKOCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:02:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41569 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755514AbZEKOCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:02:04 -0400
Date: Mon, 11 May 2009 10:02:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Greg KH <greg@kroah.com>, Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Device core removal ordering brokenness
In-Reply-To: <1241993824.19955.14.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0905111000001.2960-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Benjamin Herrenschmidt wrote:

> On Sun, 2009-05-10 at 10:58 -0400, Alan Stern wrote:
> 
> > Before the patch, the ordering was like this:
> > 
> > device_add: 	ADD  dpm_sysfs_add()  ->probe
> > device_del:	dpm_sysfs_remove()  ->remove  DEL
> 
> Right.
> 
> > Now the ordering is like this:
> > 
> > device_add:	dpm_sysfs_add()  ADD  ->probe
> > device_del:	DEL  dpm_sysfs_remove()  ->remove
> > 
> > Okay, yes, it's not symmetrical.  But the point of the patch was to put
> > the DEL before the dpm_sysfs_remove(), and in any case the code wasn't
> > symmetrical even before the patch.
> 
> How so ? It does definitely look symetrical above :-)

The "ADD / ->probe / ->remove / DEL" sequence is symmetrical, but the
"dpm_sysfs_add() / ->probe / dpm_sysfs_remove() / ->remove" sequence 
isn't.

>  That's not a big
> deal per-se though, it's just that I want to be able to tear down data
> structures in DEL that may be indirectly used by the driver (DMA mapping
> related or even MMIO related internal arch stuff).

Okay, that's understandable.

> >   I gather that you'd prefer to see
> > 
> > device_del:	->remove  DEL  dpm_sysfs_remove()
> 
> I don't actually care that much about where drm_sysfs_remove() is vs.
> DEL, but you seem to want to adjust the sysfs files in ADD and DEL, so
> that would make sense.

Correct.

> > Offhand I can't think of any reason not to do this.  Maybe someone else 
> > can; this code has a lot of undocumented constraints.  (Hmm, what 
> > happens if a system suspend occurs after the device has been 
> > unregistered from its bus but before it has been taken off the dpm 
> > list?  It's probably okay but worth checking...)
> > 
> > If you'd like to submit a patch moving the "if (dev->bus)...", 
> > device_pm_remove(), and dpm_sysfs_remove() stuff after the call to 
> > bus_remove_device(), go ahead.
> 
> I first want to "probe" you guys in case there's some nasty skeleton
> waiting around the corner, but yeah I'll probably do that. One other
> option is to split DEL in two.

There doesn't appear to be any skeleton hanging around.  Go for it!

Alan Stern

