Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZGJMIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZGJMIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZGJMIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:08:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54233 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbZGJMIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:08:05 -0400
Date: Fri, 10 Jul 2009 01:22:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH] PM: Introduce core framework for run-time PM of
	I/O devices (rev. 8)
Message-ID: <20090709232239.GG1469@ucw.cz>
References: <200907060252.12755.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907060252.12755.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi!

> +/**
> + * Device run-time power management request types.
> + *
> + * RPM_REQ_NONE		Do nothing.
> + *
> + * RPM_REQ_IDLE		Run the device bus type's ->runtime_idle() callback
> + *
> + * RPM_REQ_SUSPEND	Run the device bus type's ->runtime_suspend() callback
> + *
> + * RPM_REQ_RESUME	Run the device bus type's ->runtime_resume() callback
> + */
> +
> +enum rpm_request {
> +	RPM_REQ_NONE = 0,
> +	RPM_REQ_IDLE,
> +	RPM_REQ_SUSPEND,
> +	RPM_REQ_RESUME,
> +};
> +
>  struct dev_pm_info {
>  	pm_message_t		power_state;
> -	unsigned		can_wakeup:1;
> -	unsigned		should_wakeup:1;
> +	unsigned int		can_wakeup:1;
> +	unsigned int		should_wakeup:1;
>  	enum dpm_state		status;		/* Owned by the PM core */
> -#ifdef	CONFIG_PM_SLEEP
> +#ifdef CONFIG_PM_SLEEP
>  	struct list_head	entry;
>  #endif
> +#ifdef CONFIG_PM_RUNTIME
> +	struct timer_list	suspend_timer;
> +	unsigned long		timer_expires;
> +	struct work_struct	work;
> +	wait_queue_head_t	wait_queue;
> +	spinlock_t		lock;
> +	atomic_t		usage_count;
> +	atomic_t		child_count;
> +	unsigned int		ignore_children:1;
> +	unsigned int		runtime_disabled:1;
> +	unsigned int		runtime_failure:1;
> +	unsigned int		idle_notification:1;
> +	unsigned int		request_pending:1;
> +	unsigned int		deferred_resume:1;
> +	enum rpm_request	request;
> +	enum rpm_status		runtime_status;

runtime_status seems to be accessed outside spinlocks. Should it be of
type atomic_t?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
