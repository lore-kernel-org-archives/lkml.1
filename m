Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZEXOae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZEXOae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 10:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbZEXOa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 10:30:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38736 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752951AbZEXOa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 10:30:26 -0400
Date: Sun, 24 May 2009 10:30:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Johannes Berg <johannes@sipsolutions.net>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: INFO: possible circular locking dependency at cleanup_workqueue_thread
In-Reply-To: <200905240120.30336.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0905241016410.7718-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 May 2009, Rafael J. Wysocki wrote:

> The patch is appended for reference (Alan, please have a look; I can't recall
> why exactly we have called device_pm_lock() from the core suspend/hibernation
> code instead of acquiring the lock locally in drivers/base/power/main.c) and
> I'll attach it to the bug entry too.

I can't remember the reason either.  Probably there wasn't any.  The 
patch looks fine, and it has the nice added benefit that now the only 
user of device_pm_lock() will be device_move().

> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Do not hold dpm_list_mtx while disabling/enabling nonboot CPUs
> 
> We shouldn't hold dpm_list_mtx while executing
> [disable|enable]_nonboot_cpus(), because theoretically this may lead
> to a deadlock as shown by the following example (provided by Johannes
> Berg):
> 
> CPU 3       CPU 2                     CPU 1
>                                       suspend/hibernate
>             something:
>             rtnl_lock()               device_pm_lock()
>                                        -> mutex_lock(&dpm_list_mtx)
> 
>             mutex_lock(&dpm_list_mtx)
> 
> linkwatch_work
>  -> rtnl_lock()
>                                       disable_nonboot_cpus()
>                                        -> flush CPU 3 workqueue
> 
> Fortunately, device drivers are supposed to stop any activities that
> might lead to the registration of new device objects and/or to the
> removal of the existing ones way before disable_nonboot_cpus() is

Strictly speaking, drivers are still allowed to unregister existing 
devices.  They are forbidden only to register new ones.  This shouldn't 
hurt anything, though.

> called, so it shouldn't be necessary to hold dpm_list_mtx over the
> entire late part of device suspend and early part of device resume.
> 
> Thus, during the late suspend and the early resume of devices acquire
> dpm_list_mtx only when dpm_list is going to be traversed and release
> it right after that.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

