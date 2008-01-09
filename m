Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbYAIWMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbYAIWMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbYAIWMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:12:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48948 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbYAIWMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:12:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
Date: Wed, 9 Jan 2008 23:14:48 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Johannes Berg <johannes@sipsolutions.net>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0801091543300.2856-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801091543300.2856-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801092314.49286.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 of January 2008, Alan Stern wrote:
> On Tue, 8 Jan 2008, Rafael J. Wysocki wrote:
> 
> > Appended is what I managed to put together today.
> > 
> > It probably still has some problems, but I'm not seeing them right now (too
> > tired).  At least, it doesn't break my system. ;-)
> > 
> > Please review.
> 
> Okay, this seems to be better.  I like the way the complicated tests 
> are all localized in power/main.c.
> 
> In dpm_resume() you shouldn't need to use dpm_list_mtx at all, because
> the list_move_tail() comes before the resume_device().  It's the same
> as in dpm_power_up().

Still, device_pm_schedule_removal() can (in theory) be called concurrently
with dpm_resume() by another thread and this might corrupt the list without
the locking.

> The same is true for dpm_suspend().  Once all the device have been 
> locked, there shouldn't be any other tasks accessing the dpm lists.  
> Hence there should be no need to protect the list.

Except for against theoretical races with device_pm_schedule_removal().

> Which reminds me, the kerneldoc for device_pm_schedule_removal() is 
> inaccurate.  The routine always just moves the device to dpm_destroy 
> list for later processing.

Correct.

> Also, the kerneldoc for destroy_suspended_device() should contain an 
> extra paragraph warning that the routine should never be called except 
> within the scope of a system sleep transition.  In practice this means 
> it has to be directly or indirectly invoked by a suspend or resume 
> method.

Or by a CPU hotplug notifier (that will be the majority of cases, IMO).

> It looks good.

Thanks for the review.

I'll fix the comments and repost the patch from scratch for merging in a
separate thread.

Greetings,
Rafael
