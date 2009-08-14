Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZHOQVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZHOQVt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 12:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbZHOQVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:21:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60921 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZHOQVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:21:47 -0400
Date: Fri, 14 Aug 2009 18:33:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC][PATCH 1/3] PM: Asynchronous resume of devices
Message-ID: <20090814163328.GF1626@ucw.cz>
References: <200908122218.13975.rjw@sisk.pl> <200908122220.03363.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908122220.03363.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The patch below introduces a mechanism allowing some devices to be
> resumed asynchronously, using completions with the following rules:
> (1) There is a completion, dev->power.comp, for each device object.
> (2) All of these completions are reset before suspend as well as
>     each resume stage (dpm_resume_noirq(), dpm_resume()).
> (3) If dev->power.async_suspend is set for dev or for its parent, the
>     PM core waits for the parent's completion before attempting to
>     run the resume callbacks, appropriate for this particular stage
>     of resume, for dev.

at least this needs to go in as a comment.

> (4) dev->power.comp is completed for each device after running its
> @@ -411,9 +412,12 @@ struct dev_pm_info {
>  	pm_message_t		power_state;
>  	unsigned int		can_wakeup:1;
>  	unsigned int		should_wakeup:1;
> +	unsigned		async_suspend:1;
>  	enum dpm_state		status;		/* Owned by the PM core */

unsigned int? Or bool?

Should it go under config_pm_sleep?

>  #ifdef CONFIG_PM_SLEEP
>  	struct list_head	entry;
> +	struct completion	comp;
> +	pm_message_t		async_state;
>  #endif
>  }
>  
> +static inline void device_enable_async_suspend(struct device *dev, bool enable)
> +{
> +	if (dev->power.status == DPM_ON)
> +		dev->power.async_suspend = enable;
> +}
> +
> @@ -163,6 +166,34 @@ void device_pm_move_last(struct device *
>  	list_move_tail(&dev->power.entry, &dpm_list);
>  }
>  
> +static void dpm_synchronize_noirq(void)
> +{
> +	struct device *dev;
> +
> +	async_synchronize_full();
> +
> +	list_for_each_entry(dev, &dpm_list, power.entry)
> +		INIT_COMPLETION(dev->power.comp);
> +}
> +
> +static void dpm_synchronize(void)
> +{
> +	struct device *dev;
> +
> +	async_synchronize_full();
> +
> +	mutex_lock(&dpm_list_mtx);
> +	list_for_each_entry(dev, &dpm_list, power.entry)
> +		INIT_COMPLETION(dev->power.comp);
> +	mutex_unlock(&dpm_list_mtx);
> +}

Why is it ok to avoid locking in noirq case? Do we really need async for
noirq handlers?


>  /**
> - *	device_resume_noirq - Power on one device (early resume).
> - *	@dev:	Device.
> - *	@state: PM transition of the system being carried out.
> + * __device_resume_noirq - Execute an "early resume" callback for given device.
> + * @dev: Device to resume.
> + * @state: PM transition of the system being carried out.
>   *
> - *	Must be called with interrupts disabled.
> + * The driver of the device won't receive interrupts while this function is
> + * being executed.
>   */

You still want it called with interrupts disabled, right?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
