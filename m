Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbZIJK0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbZIJK0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbZIJK0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:26:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56218 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbZIJK0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:26:50 -0400
Date: Thu, 10 Sep 2009 12:26:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/9] PM: Add a switch for disabling/enabling asynchronous suspend/resume
Message-ID: <20090910102653.GA30778@atrey.karlin.mff.cuni.cz>
References: <200909100127.11252.rjw@sisk.pl> <200909100138.25839.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909100138.25839.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Add sysfs attribute kernel/power/pm_async allowing the user space to
> disable and enable async suspend/resume of devices.

for bisect reasons, should this go before 5?

> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/main.c  |   13 +++++++------
>  drivers/base/power/power.h |    6 +++---
>  kernel/power/main.c        |   31 ++++++++++++++++++++++++++++++-
>  3 files changed, 40 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/kernel/power/main.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/main.c
> +++ linux-2.6/kernel/power/main.c
> @@ -44,6 +44,32 @@ int pm_notifier_call_chain(unsigned long
>  			== NOTIFY_BAD) ? -EINVAL : 0;
>  }
>  
> +/* If set, devices may be suspended and resumed asynchronously. */
> +int pm_async_enabled = 1;
> +
> +static ssize_t pm_async_show(struct kobject *kobj, struct kobj_attribute *attr,
> +			     char *buf)
> +{
> +	return sprintf(buf, "%d\n", pm_async_enabled);
> +}
> +
> +static ssize_t pm_async_store(struct kobject *kobj, struct kobj_attribute *attr,
> +			      const char *buf, size_t n)
> +{
> +	unsigned long val;
> +
> +	if (strict_strtoul(buf, 10, &val))
> +		return -EINVAL;
> +
> +	if (val > 1)
> +		return -EINVAL;
> +
> +	pm_async_enabled = val;
> +	return n;
> +}
> +
> +power_attr(pm_async);
> +
>  #ifdef CONFIG_PM_DEBUG
>  int pm_test_level = TEST_NONE;
>  
> @@ -208,9 +234,12 @@ static struct attribute * g[] = {
>  #ifdef CONFIG_PM_TRACE
>  	&pm_trace_attr.attr,
>  #endif
> -#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_PM_DEBUG)
> +#ifdef CONFIG_PM_SLEEP
> +	&pm_async_attr.attr,
> +#ifdef CONFIG_PM_DEBUG
>  	&pm_test_attr.attr,
>  #endif
> +#endif
>  	NULL,
>  };
>  
> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c
> @@ -235,7 +235,7 @@ static int device_pm_wait_fn(struct devi
>   */
>  static void device_pm_wait_for_masters(struct device *slave)
>  {
> -	if (!pm_trace_enabled)
> +	if (pm_async_enabled && !pm_trace_enabled)
>  		device_for_each_master(slave, slave, device_pm_wait_fn);
>  }
>  
> @@ -245,7 +245,8 @@ static void device_pm_wait_for_masters(s
>   */
>  static void device_pm_wait_for_slaves(struct device *master)
>  {
> -	device_for_each_slave(master, master, device_pm_wait_fn);
> +	if (pm_async_enabled)
> +		device_for_each_slave(master, master, device_pm_wait_fn);
>  }
>  
>  /**
> @@ -560,7 +561,7 @@ static int device_resume_noirq(struct de
>  	if (pm_op_started(dev))
>  		return 0;
>  
> -	if (dev->power.async_suspend && !pm_trace_enabled) {
> +	if (pm_async_enabled && !pm_trace_enabled && dev->power.async_suspend) {
>  		async_schedule(async_resume_noirq, dev);
>  		return 0;
>  	}
> @@ -719,7 +720,7 @@ static int device_resume(struct device *
>  	if (pm_op_started(dev))
>  		return 0;
>  
> -	if (dev->power.async_suspend && !pm_trace_enabled) {
> +	if (pm_async_enabled && !pm_trace_enabled && dev->power.async_suspend) {
>  		get_device(dev);
>  		async_schedule(async_resume, dev);
>  		return 0;
> @@ -965,7 +966,7 @@ static int device_suspend_noirq(struct d
>  	if (pm_op_started(dev))
>  		return 0;
>  
> -	if (dev->power.async_suspend) {
> +	if (pm_async_enabled && dev->power.async_suspend) {
>  		async_schedule(async_suspend_noirq, dev);
>  		return 0;
>  	}
> @@ -1139,7 +1140,7 @@ static int device_suspend(struct device 
>  	if (pm_op_started(dev))
>  		return 0;
>  
> -	if (dev->power.async_suspend) {
> +	if (pm_async_enabled && dev->power.async_suspend) {
>  		get_device(dev);
>  		async_schedule(async_suspend, dev);
>  		return 0;
> Index: linux-2.6/drivers/base/power/power.h
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/power.h
> +++ linux-2.6/drivers/base/power/power.h
> @@ -16,10 +16,10 @@ static inline void pm_runtime_remove(str
>  
>  #ifdef CONFIG_PM_SLEEP
>  
> -/*
> - * main.c
> - */
> +/* kernel/power/main.c */
> +extern int pm_async_enabled;
>  
> +/* drivers/base/power/main.c */
>  extern struct list_head dpm_list;	/* The active device list */
>  
>  static inline struct device *to_device(struct list_head *entry)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
