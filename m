Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbZEWU6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbZEWU6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 16:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZEWU6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 16:58:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59069 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbZEWU6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 16:58:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] pm: remove bus_type suspend_late()/resume_early() V2
Date: Sat, 23 May 2009 22:58:26 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, stern@rowland.harvard.edu,
       akpm@linux-foundation.org, pavel@ucw.cz,
       LKML <linux-kernel@vger.kernel.org>
References: <20090521082754.1020.73349.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090521082754.1020.73349.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905232258.27407.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 May 2009, Magnus Damm wrote:
> From: Magnus Damm <damm@igel.co.jp>
> 
> Remove the ->suspend_late() and ->resume_early() callbacks
> from struct bus_type V2. These callbacks are legacy stuff
> at this point and since there seem to be no in-tree users
> we may as well remove them. New users should use dev_pm_ops.

I'd like to apply this patch as is.

Greg, is it fine with you?

Best,
Rafael


> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  Changes since V1:
>  - Documentation/power/devices.txt changes
> 
>  Documentation/power/devices.txt |   34 +++++-----------------------------
>  drivers/base/power/main.c       |    7 -------
>  include/linux/device.h          |    2 --
>  3 files changed, 5 insertions(+), 38 deletions(-)
> 
> --- 0001/Documentation/power/devices.txt
> +++ work/Documentation/power/devices.txt	2009-05-21 17:19:48.000000000 +0900
> @@ -75,9 +75,6 @@ may need to apply in domain-specific way
>  struct bus_type {
>  	...
>  	int  (*suspend)(struct device *dev, pm_message_t state);
> -	int  (*suspend_late)(struct device *dev, pm_message_t state);
> -
> -	int  (*resume_early)(struct device *dev);
>  	int  (*resume)(struct device *dev);
>  };
>  
> @@ -226,20 +223,7 @@ The phases are seen by driver notificati
>  
>  	This call should handle parts of device suspend logic that require
>  	sleeping.  It probably does work to quiesce the device which hasn't
> -	been abstracted into class.suspend() or bus.suspend_late().
> -
> -   3	bus.suspend_late(dev, message) is called with IRQs disabled, and
> -	with only one CPU active.  Until the bus.resume_early() phase
> -	completes (see later), IRQs are not enabled again.  This method
> -	won't be exposed by all busses; for message based busses like USB,
> -	I2C, or SPI, device interactions normally require IRQs.  This bus
> -	call may be morphed into a driver call with bus-specific parameters.
> -
> -	This call might save low level hardware state that might otherwise
> -	be lost in the upcoming low power state, and actually put the
> -	device into a low power state ... so that in some cases the device
> -	may stay partly usable until this late.  This "late" call may also
> -	help when coping with hardware that behaves badly.
> +	been abstracted into class.suspend().
>  
>  The pm_message_t parameter is currently used to refine those semantics
>  (described later).
> @@ -351,19 +335,11 @@ devices processing each phase's calls be
>  
>  The phases are seen by driver notifications issued in this order:
>  
> -   1	bus.resume_early(dev) is called with IRQs disabled, and with
> -   	only one CPU active.  As with bus.suspend_late(), this method
> -	won't be supported on busses that require IRQs in order to
> -	interact with devices.
> -
> -	This reverses the effects of bus.suspend_late().
> -
> -   2	bus.resume(dev) is called next.  This may be morphed into a device
> -   	driver call with bus-specific parameters; implementations may sleep.
> -
> -	This reverses the effects of bus.suspend().
> +   1	bus.resume(dev) reverses the effects of bus.suspend().  This may
> +	be morphed into a device driver call with bus-specific parameters;
> +	implementations may sleep.
>  
> -   3	class.resume(dev) is called for devices associated with a class
> +   2	class.resume(dev) is called for devices associated with a class
>  	that has such a method.  Implementations may sleep.
>  
>  	This reverses the effects of class.suspend(), and would usually
> --- 0001/drivers/base/power/main.c
> +++ work/drivers/base/power/main.c	2009-05-21 17:19:42.000000000 +0900
> @@ -334,9 +334,6 @@ static int __device_resume_noirq(struct 
>  	if (dev->bus->pm) {
>  		pm_dev_dbg(dev, state, "EARLY ");
>  		error = pm_noirq_op(dev, dev->bus->pm, state);
> -	} else if (dev->bus->resume_early) {
> -		pm_dev_dbg(dev, state, "legacy EARLY ");
> -		error = dev->bus->resume_early(dev);
>  	}
>   End:
>  	TRACE_RESUME(error);
> @@ -591,10 +588,6 @@ static int __device_suspend_noirq(struct
>  	if (dev->bus->pm) {
>  		pm_dev_dbg(dev, state, "LATE ");
>  		error = pm_noirq_op(dev, dev->bus->pm, state);
> -	} else if (dev->bus->suspend_late) {
> -		pm_dev_dbg(dev, state, "legacy LATE ");
> -		error = dev->bus->suspend_late(dev, state);
> -		suspend_report_result(dev->bus->suspend_late, error);
>  	}
>  	return error;
>  }
> --- 0001/include/linux/device.h
> +++ work/include/linux/device.h	2009-05-21 17:19:42.000000000 +0900
> @@ -62,8 +62,6 @@ struct bus_type {
>  	void (*shutdown)(struct device *dev);
>  
>  	int (*suspend)(struct device *dev, pm_message_t state);
> -	int (*suspend_late)(struct device *dev, pm_message_t state);
> -	int (*resume_early)(struct device *dev);
>  	int (*resume)(struct device *dev);
>  
>  	struct dev_pm_ops *pm;
