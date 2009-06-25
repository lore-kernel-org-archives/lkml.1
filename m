Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbZFYO5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbZFYO5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZFYO5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:57:35 -0400
Received: from mail-yx0-f186.google.com ([209.85.210.186]:41787 "EHLO
	mail-yx0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZFYO5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V3m4wjf1ukQQLh6H2c10XCUEsF5qEEtQSao53X91B4hqowi4z+s/wnjuSGkYm1AjbA
         68sbiXCxzXiw24nDTHXt+5C2EQRTmh6ZlxaOPvLgUhG4vHkNzISjsf4x2QDkxGAXNUER
         V30QfYRHsZgZBJdupMY9PuRwXVn1Yi28aLlf8=
MIME-Version: 1.0
In-Reply-To: <200906242124.05511.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0906231303390.3209-100000@iolanthe.rowland.org>
	 <200906240208.23482.rjw@sisk.pl> <200906240236.41526.rjw@sisk.pl>
	 <200906242124.05511.rjw@sisk.pl>
Date: Thu, 25 Jun 2009 23:57:36 +0900
Message-ID: <aec7e5c30906250757m437df51fla032afbadc0261f8@mail.gmail.com>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of 
	I/O devices (rev. 5)
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org, Oliver Neukum <oliver@neukum.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 4:24 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Introduce core framework for run-time PM of I/O devices (rev. 5)
>
> Introduce a core framework for run-time power management of I/O
> devices.  Add device run-time PM fields to 'struct dev_pm_info'
> and device run-time PM callbacks to 'struct dev_pm_ops'.  Introduce
> a run-time PM workqueue and define some device run-time PM helper
> functions at the core level.  Document all these things.
>
> Not-yet-signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Hi Rafael,

Thanks for your work on this. I've built some code for SuperH on top
of this today, and with that behind me I have a few questions and a
little bit of code feedback.

Questions:

1) Which functions are device drivers supposed to use?

I simply added pm_runtime_resume() and pm_runtime_suspend() where
clk_enable() and clk_disable() normally are used. In interrupt
handlers I used pm_request_suspend() instead of pm_runtime_suspend().

I'm not sure if the v5 patch does the right thing around
really_probe() like Alan pointed out. Basically, I'd like to be able
to call my bus callback for ->runtime_resume() from the driver
probe(), but power.resume_count seems stuck at 1 which leads to
pm_runtime_resume() returning -EAGAIN before invoking the bus
callback.

This leads to question number two...

2) What's the default state in probe()?

We touched this subject briefly before. I'd like to compare the
Runtime PM default state with the clock framework default state. The
clock framework requires you to use clk_enable() to enable the clock
to a hardware block before it is allowed to access the hardware
registers. At least that's how we handle stop bits on SuperH. So
clocks come up disabled from boot and should be enabled and disabled
by the device driver to save power.

I'd like to change our Module Stop Bits code on SuperH (once again)
from being handled by the clock framework to being managed by the
Runtime PM framework. Having the clock framework deal with the stop
bits works fine today, they are off by default after boot, and the
driver often enables the clock with clk_enable() in probe() or
hopefully in some more finegrained fashion.

I'm not sure how the Module Stop Bits should fit with the Runtime PM
code though. The default state for a device at probe() time seems to
be RPM_ACTIVE. Should drivers call pm_runtime_enable() to enable
Runtime PM?

One part of me likes the idea that Runtime PM-enabled drivers start in
RPM_SUSPENDED so they are forced to put pm_runtime_resume() before
actually using the hardware. This makes the Runtime PM behaviour
pretty close to the clock framework.

If you dislike starting from RPM_SUSPENDED (most likely) then I wonder
how I should set the state to RPM_SUSPENDED in the driver. I'd like to
make sure that pm_runtime_resume() can invoke the bus callback so the
hardware can be turned on for the first time somehow. Should I do a
dummy suspend?

3) Should drivers use pm_suspend_ignore_children(dev, true)?

It turns out that I can't suspend my I2C master driver out of the box
since it becomes the parent of all slaves on the I2C bus. The I2C
master driver is just a platform driver, and the children are I2C
devices (90% sure). I want to do Runtime PM regardless if the child
devices are suspended or not, I guess I should use
pm_suspend_ignore_children(dev, true) then?

> +/**
> + * __pm_runtime_resume - Run a device bus type's runtime_resume() callback.
> + * @dev: Device to resume.
> + * @sync: If unset, the funtion has been called via pm_wq.
> + *
> + * Check if the device is really suspended and run the ->runtime_resume()
> + * callback provided by the device's bus type driver.  Update the run-time PM
> + * flags in the device object to reflect the current status of the device.  If
> + * runtime suspend is in progress while this function is being run, wait for it
> + * to finish before resuming the device.  If runtime suspend is scheduled, but
> + * it hasn't started yet, cancel it and we're done.
> + */
> +int __pm_runtime_resume(struct device *dev, bool sync)
> +{
[snip]
> +}
> +EXPORT_SYMBOL_GPL(pm_runtime_resume);

You're missing "__" here unless you're aiming for something very exotic. =)

> +/**
> + * pm_runtime_work - Run __pm_runtime_resume() for a device.
> + * @work: Work structure used for scheduling the execution of this function.
> + *
> + * Use @work to get the device object the resume has been scheduled for and run
> + * __pm_runtime_resume() for it.
> + */
> +static void pm_runtime_work(struct work_struct *work)
> +{
> +       __pm_runtime_resume(work_to_device(work), false);
> +}

Anything wrong with the name pm_runtime_resume_work()?

Looking forward to v6, I'll switch task now, will be back to this late Monday.

Cheers,

/ magnus
