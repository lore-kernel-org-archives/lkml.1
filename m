Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbZLUVPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbZLUVPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 16:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756998AbZLUVPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 16:15:52 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39945 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756274AbZLUVPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 16:15:51 -0500
Date: Mon, 21 Dec 2009 16:15:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/5] PM: Make the initcall_debug style timing for
 suspend/resume complete
In-Reply-To: <200912212203.15198.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912211612340.3328-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Commit f2511774863487e61b56a97da07ebf8dd61d7836
> (PM: Add initcall_debug style timing for suspend/resume) introduced
> basic timing instrumentation, needed for a scritps/bootgraph.pl
> equivalent or humans, but it missed the fact that bus types and
> device classes which haven't been switched to using struct dev_pm_ops
> objects yet need special handling.  As a result, the suspend/resume
> timing information is only available for devices whose bus types or
> device classes use struct dev_pm_ops objects, so the majority of
> devices is not covered.
> 
> Fix this by adding basic suspend/resume timing instrumentation for
> devices whose bus types and device classes still don't use struct
> dev_pm_ops objects for power management.  To reduce code duplication
> move the timing code to helper functions.

A minor complaint...

> +/**
>   * device_resume - Execute "resume" callbacks for given device.
>   * @dev: Device to handle.
>   * @state: PM transition of the system being carried out.
> @@ -427,7 +465,7 @@ static int device_resume(struct device *
>  			error = pm_op(dev, dev->bus->pm, state);
>  		} else if (dev->bus->resume) {
>  			pm_dev_dbg(dev, state, "legacy ");
> -			error = dev->bus->resume(dev);
> +			error = legacy_resume(dev, dev->bus->resume);
>  		}
>  		if (error)
>  			goto End;
> @@ -448,7 +486,7 @@ static int device_resume(struct device *
>  			error = pm_op(dev, dev->class->pm, state);
>  		} else if (dev->class->resume) {
>  			pm_dev_dbg(dev, state, "legacy class ");
> -			error = dev->class->resume(dev);
> +			error = legacy_resume(dev, dev->class->resume);
>  		}
>  	}

If none of the method callbacks are non-NULL, this won't print 
anything.  The same is true for device_suspend().

Now maybe you don't _want_ to print anything in that case, but for
debugging purposes it could be useful.

Alan Stern

