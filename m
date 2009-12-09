Return-Path: <linux-kernel-owner+w=401wt.eu-S1757692AbZLIUPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbZLIUPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757663AbZLIUO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:14:57 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60177 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757589AbZLIUO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:14:56 -0500
Date: Wed, 9 Dec 2009 15:15:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ rwsems (was: Re: [GIT PULL] PM
 updates for 2.6.33)
In-Reply-To: <200912082355.00711.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912091451250.4120-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:

> For completness, below is the full async suspend/resume patch with rwlocks,
> that has been (very slightly) tested and doesn't seem to break things.
> 
> [Note to Alan: lockdep doesn't seem to complain about the not annotated nested
> locks.]

I can't imagine why not.  And wouldn't lockdep get confused by the fact
that in the async case, the rwsems are released by a different process
from the one that acquired them?


> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c

Should we have an attribute under /sys/power to disable async
suspend/resume?  It would make testing easier and give people a way to
work around problems.

> @@ -334,25 +337,53 @@ static void pm_dev_err(struct device *de
>   * The driver of @dev will not receive interrupts while this function is being
>   * executed.
>   */
> -static int device_resume_noirq(struct device *dev, pm_message_t state)
> +static int __device_resume_noirq(struct device *dev, pm_message_t state)
>  {

Do you want to use async tasks in the late-suspend/early-resume stages?  
I know that USB won't use it, not even for the PCI host controllers --
not unless the PCI core specifically wants it.  Doing just the regular
suspend/resume stages may be enough.

> +static int device_resume_noirq(struct device *dev)
> +{
> +	down_write(&dev->power.rwsem);
> +
> +	if (dev->power.async_suspend && !pm_trace_is_enabled()) {

If the sysfs attribute exists, then maybe we _should_ allow async with 
PM tracing enabled.  I don't know; it's your decision.

			atomic_set(&async_error, error);
	}


> @@ -683,10 +835,12 @@ static int dpm_suspend(pm_message_t stat
>  
>  	INIT_LIST_HEAD(&list);
>  	mutex_lock(&dpm_list_mtx);
> +	pm_transition = state;
>  	while (!list_empty(&dpm_list)) {
>  		struct device *dev = to_device(dpm_list.prev);
>  
>  		get_device(dev);
> +		dev->power.status = DPM_OFF;

What's that for?  dev->power.status is supposed to be DPM_SUSPENDING 
until the suspend method is successfully completed.

>  		mutex_unlock(&dpm_list_mtx);
>  
>  		error = device_suspend(dev, state);
> @@ -694,16 +848,22 @@ static int dpm_suspend(pm_message_t stat
>  		mutex_lock(&dpm_list_mtx);
>  		if (error) {
>  			pm_dev_err(dev, state, "", error);
> +			dev->power.status = DPM_SUSPENDING;

And then this isn't needed.

>  			put_device(dev);
>  			break;
>  		}
> -		dev->power.status = DPM_OFF;

This line has to be moved into __device_suspend(), even though it won't 
be protected by dpm_list_mtx.  The same sort of thing applies to 
dpm_suspend_noirq() (although nothing needs to be moved if you don't 
make it async).

The rest looks okay.

How about exporting a wait_for_device_to_resume() routine?  Drivers
could call it for non-tree resume constraints:

	void wait_for_device_to_resume(struct device *other)
	{
		down_read(&other->power.rwsem);
		up_read(&other->power.rwsem);
	}

Unfortunately there is no equivalent for non-tree suspend constraints.

Alan Stern

