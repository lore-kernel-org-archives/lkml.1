Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYAEDL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYAEDL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 22:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbYAEDLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 22:11:18 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1404 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754804AbYAEDLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 22:11:17 -0500
Date: Fri, 4 Jan 2008 22:11:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/4] PM: Introduce destroy_suspended_device()
In-Reply-To: <200801042305.35089.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0801042202070.22169-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2008, Rafael J. Wysocki wrote:

> I have rebased gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
> on top of the $subject series, the result is appended.  It has only been
> compilation tested for now, but I'll be testing it for the next couple of days.
> 
> Please review.

I would prefer it if you could also merge in this patch at the same 
time:

https://lists.linux-foundation.org/pipermail/linux-pm/2007-December/015921.html

> +void device_resume(void)
>  {
> -	sysdev_resume();
> -	dpm_power_up();
> +	might_sleep();
> +	dpm_resume();
> +	unlock_all_devices();
> +	unregister_dropped_devices();
> +	up_write(&pm_sleep_rwsem);
>  }

With the aforementioned patch merged in, this will generate a 
warning for each dropped device.  The call to 
unregister_dropped_devices() should come after the up_write().

You might also consider adding a call to unregister_dropped_devices()  
in the error path of device_suspend() -- in theory even an aborted 
suspend might cause a device to malfunction.

Otherwise this looks okay.

Alan Stern

