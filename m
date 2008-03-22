Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbYCVX2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbYCVX2b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 19:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbYCVX2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 19:28:07 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4305 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754784AbYCVX2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 19:28:04 -0400
Date: Sat, 22 Mar 2008 19:28:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation
 callbacks (rev. 2)
In-Reply-To: <200803222317.58206.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803221920150.8044-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008, Rafael J. Wysocki wrote:

> > Yep.  The only thing to watch out for is in device_pm_remove(); it
> > would be a disaster if somehow a device was removed while it was being
> > prepared/suspended/resumed/completed/whatever.  I know that's not
> > supposed to happen but there's nothing to prevent it, especially if
> > the device in question doesn't have a driver.  No doubt you can invent
> > a way to allow this to happen safely.
> 
> Well, that's a separate issue that IMO should be addressed in a separate patch.
> Something like the one below comes to mind.
> 
> The comment removed by the patch is wrong IMO, because it implies that
> device_add() may be called with the device semaphore held and that might
> deadlock in bus_attach_device().

Are you talking about this comment?

> - * Since device_pm_add() may be called with a device semaphore held,
> - * we must never try to acquire a device semaphore while holding
> - * dpm_list_mutex.

It isn't wrong.  device_add() may indeed be called with a device 
semaphore held -- just not the semaphore for the device being added.  
Quite often it is called with device's parent's semaphore held.  The 
implication is not that we may deadlock in bus_attach_device(); rather 
it is that the order of acquisition must always be device semaphore 
first, dev_list_mutex second.

>  Thus, I think we can acquire dev->sem
> in device_pm_add() and in device_pm_remove().

No, you have missed the entire point.  The problem doesn't exist in the
current code; it exists only if we switch over to using a single list.  
Routines like dpm_suspend() won't be able to use list_for_each_entry()
to traverse the list because entries may be removed by other threads
during the traversal.  Even list_for_each_entry_safe() won't work
correctly without careful attention to details.

Alan Stern

