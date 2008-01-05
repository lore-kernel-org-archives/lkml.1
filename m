Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbYAEVlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbYAEVlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 16:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbYAEVlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 16:41:12 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1411 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757246AbYAEVlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 16:41:11 -0500
Date: Sat, 5 Jan 2008 16:41:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
In-Reply-To: <200801052213.39891.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0801051634500.29588-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008, Rafael J. Wysocki wrote:

> On Saturday, 5 of January 2008, Alan Stern wrote:
> > On Sat, 5 Jan 2008, Rafael J. Wysocki wrote:
> > 
> > > > Another thing to watch out for: Just in case somebody ends up calling
> > > > destroy_suspended_device(dev) from within dev's own resume method, you 
> > > > should interchange the resume_device() and the list_move_tail() 
> > > > calls in dpm_resume().
> > > 
> > > However, if we unregister them all at once after releasing pm_sleep_rwsem,
> > > that shouldn't be necessary, right?
> > 
> > It's still necessary, because destroy_suspended_device() still has to
> > move the device from one list to another.  You don't want it to end up 
> > on the dpm_locked list.
> 
> Hmm.  That means we'd have to do the same thing in dpm_power_up() in case
> someone calls destroy_suspended_device() from resume_device_early(dev).

Yes.

> Still, even doing that is not enough, since someone can call
> destroy_suspended_device() from a .suspend() routine and then the device
> will end up on a wrong list just as well.

That should never happen.  The whole idea of destroy_suspended_device()
is that the device couldn't be resumed and in fact should be
unregistered because it is no longer working or no longer present.  A
suspend routine won't detect this sort of thing since it doesn't try to
resume the device.

But it wouldn't hurt to mention in the kerneldoc that 
destroy_suspended_device() is meant to be called only during a system 
resume.

Alan Stern

