Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbYAIWqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbYAIWqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbYAIWqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:46:22 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56976 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754504AbYAIWqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:46:21 -0500
Date: Wed, 9 Jan 2008 17:46:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Johannes Berg <johannes@sipsolutions.net>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
In-Reply-To: <200801092314.49286.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0801091734180.2856-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008, Rafael J. Wysocki wrote:

> > In dpm_resume() you shouldn't need to use dpm_list_mtx at all, because
> > the list_move_tail() comes before the resume_device().  It's the same
> > as in dpm_power_up().
> 
> Still, device_pm_schedule_removal() can (in theory) be called concurrently
> with dpm_resume() by another thread and this might corrupt the list without
> the locking.

Any thread doing that would be in violation of the restrictions you're 
going to add to the kerneldoc for destroy_suspended_device().

However the overhead for the locking isn't critical.  There won't be
any contention (if everything is working right) and it isn't a hot path
anyway.  So you can leave the extra locking in if you want.  But then
you should put it in all the routines where the lists get manipulated,
not just some of them.  That is: device_power_down(), dpm_power_up(),
and even unregister_dropped_devices().

> > Also, the kerneldoc for destroy_suspended_device() should contain an 
> > extra paragraph warning that the routine should never be called except 
> > within the scope of a system sleep transition.  In practice this means 
> > it has to be directly or indirectly invoked by a suspend or resume 
> > method.
> 
> Or by a CPU hotplug notifier (that will be the majority of cases, IMO).

In your patch the call is made in response to a CPU_UP_CANCELED_FROZEN
notification.  Isn't it true that this notification is issued only as
part of a system sleep transition?  We wouldn't want to allow
destroy_suspended_device() to be called when an arbitrary CPU hotplug
notification occurs.

Alan Stern

