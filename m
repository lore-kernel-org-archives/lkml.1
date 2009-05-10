Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbZEJO6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbZEJO6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 10:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZEJO6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 10:58:43 -0400
Received: from netrider.rowland.org ([192.131.102.5]:40620 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752087AbZEJO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 10:58:43 -0400
Date: Sun, 10 May 2009 10:58:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Greg KH <greg@kroah.com>, Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Device core removal ordering brokenness
In-Reply-To: <1241911761.19955.8.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0905101035410.31353-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 May 2009, Benjamin Herrenschmidt wrote:

> Hi Alan !

Hi!

> I was looking at git history regarding the various BUS_NOTIFY_*
> notifiers (since David needs some stuff for his DMA debug code that
> isn't provided by the current set) when I noticed that commit of yours:
> 
> ec0676ee28528dc8dda13a93ee4b1f215a0c2f9d
> 
> Unless I'm mistaken, which is very possible, this moves the
> BUS_NOTIFY_DEL_DEVICE callback to -before- the driver remove() callback
> is invoked. This sounds very illogical and potentially dangerous to me.
> 
> In fact, the original ordering and the only one that, to me, makes sense
> in term of semantics is:
> 
> ADD / ->probe() / BOUND ... UNBIND / ->remove() / DEL
> 
> And not the current (since your patch):
> 
> ADD / ->probe() / BOUND ... DEL / UNBIND / ->remove()
> 
> IE. The DEL callback might tear down data structures used by the driver,
> such as DMA mapping stuff etc...  (In fact, that's pretty much the whole
> point of this callback). ADD/DEL should be invoked while no driver is
> active on the device.
> 
> Now if I look at the reason for your change, I discover what look to me
> like added brokenness in the core, but again, I may be missing something
> obvious. IE. The addition and removal path don't look symetric to me,
> and you moved the DEL callback because in the first place, the core
> tears down various things (such as PM or sysfs related data structures)
> before the driver is unbound from the device.
> 
> Whatever you guys think is the right approach for those sysfs and PM
> structures, I do believe that moving around the DEL callback was a
> mistake and I can see that becoming an issue on various platforms (if
> not already).

Before the patch, the ordering was like this:

device_add: 	ADD  dpm_sysfs_add()  ->probe
device_del:	dpm_sysfs_remove()  ->remove  DEL

Now the ordering is like this:

device_add:	dpm_sysfs_add()  ADD  ->probe
device_del:	DEL  dpm_sysfs_remove()  ->remove

Okay, yes, it's not symmetrical.  But the point of the patch was to put
the DEL before the dpm_sysfs_remove(), and in any case the code wasn't
symmetrical even before the patch.  I gather that you'd prefer to see

device_del:	->remove  DEL  dpm_sysfs_remove()

Offhand I can't think of any reason not to do this.  Maybe someone else 
can; this code has a lot of undocumented constraints.  (Hmm, what 
happens if a system suspend occurs after the device has been 
unregistered from its bus but before it has been taken off the dpm 
list?  It's probably okay but worth checking...)

If you'd like to submit a patch moving the "if (dev->bus)...", 
device_pm_remove(), and dpm_sysfs_remove() stuff after the call to 
bus_remove_device(), go ahead.

Alan Stern

