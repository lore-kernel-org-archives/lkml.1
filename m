Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYAIVCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYAIVCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbYAIVBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:01:50 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38127 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755530AbYAIVBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:01:49 -0500
Date: Wed, 9 Jan 2008 16:01:48 -0500 (EST)
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
In-Reply-To: <200801080125.38080.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0801091543300.2856-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008, Rafael J. Wysocki wrote:

> Appended is what I managed to put together today.
> 
> It probably still has some problems, but I'm not seeing them right now (too
> tired).  At least, it doesn't break my system. ;-)
> 
> Please review.

Okay, this seems to be better.  I like the way the complicated tests 
are all localized in power/main.c.

In dpm_resume() you shouldn't need to use dpm_list_mtx at all, because
the list_move_tail() comes before the resume_device().  It's the same
as in dpm_power_up().

The same is true for dpm_suspend().  Once all the device have been 
locked, there shouldn't be any other tasks accessing the dpm lists.  
Hence there should be no need to protect the list.

Which reminds me, the kerneldoc for device_pm_schedule_removal() is 
inaccurate.  The routine always just moves the device to dpm_destroy 
list for later processing.

Also, the kerneldoc for destroy_suspended_device() should contain an 
extra paragraph warning that the routine should never be called except 
within the scope of a system sleep transition.  In practice this means 
it has to be directly or indirectly invoked by a suspend or resume 
method.

It looks good.

Alan Stern

