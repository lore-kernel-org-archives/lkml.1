Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0CDDMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:12:05 -0500
Received: from netrider.rowland.org ([192.131.102.5]:56388 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753943Ab0CDDLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:11:54 -0500
Date: Wed, 3 Mar 2010 22:11:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm@lists.linux-foundation.org,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Mark Brown <broonie@sirena.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH] PM: add dpm_use_runtime_{suspend, resume}
 helper functions
In-Reply-To: <201003040156.58763.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1003032151581.6963-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Provide generic subsystem-level callbacks
> 
> There are subsystems whose power management callbacks only need to
> invoke the callbacks provided by device drivers.  Still, their system
> sleep PM callbacks should play well with the runtime PM callbacks,
> so that devices suspended at run time can be left in that state for
> a system sleep transition.
> 
> Provide a set of generic PM callbacks for such subsystems and
> define convenience macros for populating dev_pm_ops structures.

This looks pretty good, just a few minor typos and things that could be 
worded better.

> +/**
> + * pm_generic_runtime_suspend - Generic runtime suspend callback for subsystems.
> + * @dev: Device to suspend.
> + *
> + * If PM operations are defined for the driver of @dev and they include

for @dev's driver

> + * ->runtime_suspend(), execute it and return the error code returned by it.

and return its error code.

> + * Otherwise, return zero.

Otherwise, return -EINVAL.

> +/**
> + * pm_generic_runtime_resume - Generic runtime resume callback for subsystems.
> + * @dev: Device to resume.
> + *
> + * If PM operations are defined for the driver of @dev and they include
> + * ->runtime_resume(), execute it and return the error code returned by it.
> + * Otherwise, return zero.

Same as above.

> +/**
> + * __pm_generic_call - Generic suspend/freeze/poweroff/thaw subsystem callback.
> + * @dev: Device to handle.
> + * @event: PM transition of the system under way.
> + *
> + * If the device has not been suspended at run time, execute the
> + * suspend/freeze/poweroff/thaw callback provided by its driver, if defined, and
> + * return the error code returned by it.  Otherwise, return zero.

return its error code.

> +/**
> + * __pm_generic_resume - Generic resume/restore callback for subsystems.
> + * @dev: Device to handle.
> + * @event: PM transition of the system under way.
> + *
> + * Execute the resume/resotre callback provided by the driver of @dev, if

restore, @dev's driver

> + * defined.  If it returns 0, change the device's runtime PM status to 'active'.
> + * Return the error code returned by it.

Return the callback's error code.

> --- linux-2.6.orig/Documentation/power/runtime_pm.txt
> +++ linux-2.6/Documentation/power/runtime_pm.txt
> @@ -335,6 +335,10 @@ drivers/base/power/runtime.c and include
>        'power.runtime_error' is set or 'power.disable_depth' is greater than
>        zero)
>  
> +  bool pm_runtime_suspended(struct device *dev);
> +    - return true if the devices runtime PM status is 'suspended' or false
> +      otherwise

device's run-time, comma before "or"

> +7. Generic subsystem callbacks
> +
> +Subsystems may wish to conserve code space by using the set of generic power
> +management callbacks provided by the PM core, defined in
> +driver/base/power/generic_ops.c:
> +
> +  int pm_generic_runtime_idle(struct device *dev);
> +    - invoke the ->runtime_idle() callback provided by the driver of this
> +      device, if defined, and execute pm_runtime_suspend() for it

and call pm_runtime_suspend() for this device if the return value is 0
or the callback isn't defined

> +  int pm_generic_runtime_suspend(struct device *dev);
> +    - invoke the ->runtime_suspend() callback provided by the driver of this
> +      device and return its result, or return -EINVAL if not defined
> +
> +  int pm_generic_runtime_resume(struct device *dev);
> +    - invoke the ->runtime_resume() callback provided by the driver of this
> +      device and return its result, or return -EINVAL if not defined
> +
> +  int pm_generic_suspend(struct device *dev);
> +    - if the device has not been suspended at run time, invoke the ->suspend()
> +      callback provided by its driver and return the result returned by it, or

return its result (same change for the other functions below)

> +Device drivers that wish to use the same function as a system suspend, freeze,
> +poweroff and run-time suspend callback, and similarly for system resume, thaw,
> +restore, and run-time resume, can achieve this with the help of the
> +UNIVERSAL_DEV_PM_OPS macro defined in include/linux/pm.h, possibly passing NULL
> +as the last argument of it.

(possibly setting its last argument to NULL).

Alan Stern

