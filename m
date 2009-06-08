Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZFHMD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZFHMD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 08:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbZFHMDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 08:03:19 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:43068 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbZFHMDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 08:03:19 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Mon, 8 Jun 2009 14:04:03 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <200906080005.23304.oliver@neukum.org> <200906081329.27047.rjw@sisk.pl>
In-Reply-To: <200906081329.27047.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906081404.04118.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 8. Juni 2009 13:29:26 schrieb Rafael J. Wysocki:

> But I need to be able to call __pm_schedule_resume() (at least) from
> interrupt context and I can't use a mutex from there.  Otherwise I'd have
> used a mutex. :-)

I see.

> Anyway, below is a version with synchronous resume.

You are assuming autosuspend should always be with a delay. Why?

Secondly, you are not using a counter. Therefore only one driver can
control the PM state of a device at a given time. Is that wise?

> + * __pm_schedule_suspend - Schedule run-time suspend of given device.
> + * @dev: Device to suspend.
> + * @delay: Time to wait before attempting to suspend the device.

In which unit of time? If this is to go into kerneldoc that must be specified.

> + * @autocancel: If set, the request will be cancelled during a resume from
> a + *	system-wide sleep state if it happens before @delay elapses.

Why is this needed?

> + */
> +void __pm_schedule_suspend(struct device *dev, unsigned long delay,
> +			   bool autocancel)

[..]


> +
> +/**
> + * __pm_schedule_resume - Schedule run-time resume of given device.
> + * @dev: Device to resume.
> + * @autocancel: If set, the request will be cancelled during a resume from
> a + *	system-wide sleep state if it happens before pm_autoresume() can be
> run. + */

Eeek! This is a bad idea. You never want to a resume to be cancelled.

> +void __pm_schedule_resume(struct device *dev, bool autocancel)

[..]
> +int pm_resume_sync(struct device *dev)
> +{
> +	int error = 0;
> +
> +	pm_lock_device(dev);
> +	if (dev->power.runtime_status == RPM_IDLE) {
> +		/* ->autosuspend() hasn't started yet, no need to resume. */
> +		pm_cancel_suspend(dev);
> +		goto out;
> +	}
> +
> +	if (dev->power.runtime_status == RPM_SUSPENDING) {
> +		/*
> +		 * The ->autosuspend() callback is being executed right now,
> +		 * wait for it to complete.
> +		 */
> +		pm_unlock_device(dev);
> +		cancel_delayed_work_sync(&dev->power.suspend_work);

That is the most glorious abuse of an API I've seen this year :-)

	Regards
		Oliver

