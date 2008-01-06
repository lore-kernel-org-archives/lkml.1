Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbYAFWji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbYAFWji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 17:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbYAFWj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 17:39:29 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2467 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755067AbYAFWj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 17:39:28 -0500
Date: Sun, 6 Jan 2008 17:39:28 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
In-Reply-To: <200801062334.05982.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0801061734150.20032-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008, Rafael J. Wysocki wrote:

> > No -- the whole idea here is to print an error message in the system
> > log if a driver's resume method tries to call device_del().  Deadlock 
> > is unavoidable in this case, but at least we'll know which driver is 
> > guilty.
> 
> Still, if we do that, we won't need to acquire dev->sem in device_pm_remove()
> any more.

There's a window in lock_all_devices() when dpm_list_mtx isn't held.  
We don't want device_pm_remove() taking an already-locked device off 
the dpm_locked list at that time.  So we do need to acquire dev->sem in 
device_pm_remove().

> Apart from this, by acqiring pm_sleep_rwsem for reading in
> device_del() we can prevent a suspend from starting while the device is being
> removed.
> 
> Consider, for example, the scenario possible with the $subject patch:
> - device_del() starts and notices pm_sleep_rwsem unlocked, so the warning is
>   not printed
> - it proceeds and everything before device_pm_remove() succeeds
> - now, device_suspend() is called and locks dev->sem
> - device_del() calls device_pm_remove() and blocks on that with the device
>   partialy removed
> I think we should prevent this from happening.

I don't see anything wrong with it.  All that will happen is that the 
removal will start before the suspend and finish after the resume.

Alan Stern

