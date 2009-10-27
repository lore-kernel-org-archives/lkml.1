Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZJ0NiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZJ0NiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZJ0NiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:38:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45316 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754428AbZJ0NiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:38:22 -0400
Date: Tue, 27 Oct 2009 09:38:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Dasgupta, Romit" <romit@ti.com>
cc: "Hilman, Kevin" <khilman@ti.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH] PM: Fixes warning on suspend errors
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59301DE0DC96A@dbde02.ent.ti.com>
Message-ID: <Pine.LNX.4.44L0.0910270936450.2882-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009, Dasgupta, Romit wrote:

> Hi,
>      I get the following errors when I choose devices in /sys/power/pm_test. It also shows that if 'dpm_suspend_start' fails somewhere down the line then the kernel does not reset the 'transition_started' variable and we can get warning similar to below. IMHO 'dpm_resume_noirq' is not the right place for setting this variable. Please see the patch below which fixes the issue.

> Fixes the location where we decide that our power transition is complete.
> Signed-off-by: Romit Dasgupta <romit@ti.com>
> ---
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index e0dc407..6b9e991 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -365,7 +365,6 @@ void dpm_resume_noirq(pm_message_t state)
>  	struct device *dev;
>  
>  	mutex_lock(&dpm_list_mtx);
> -	transition_started = false;
>  	list_for_each_entry(dev, &dpm_list, power.entry)
>  		if (dev->power.status > DPM_OFF) {
>  			int error;
> @@ -529,6 +528,7 @@ static void dpm_complete(pm_message_t state)
>  		put_device(dev);
>  	}
>  	list_splice(&list, &dpm_list);
> +	transition_started = false;
>  	mutex_unlock(&dpm_list_mtx);
>  }

The second hunk is okay, but the first hunk isn't.  We want to set 
transition_started to false as soon as devices start resuming, because 
once a resume has begun it's okay to add new devices.

Alan Stern

