Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab0BKWej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 17:34:39 -0500
Received: from cantor.suse.de ([195.135.220.2]:35955 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742Ab0BKWeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 17:34:37 -0500
Date: Thu, 11 Feb 2010 14:27:05 -0800
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/2] Staging: hv: Add proper versioning to HV drivers
Message-ID: <20100211222705.GA30430@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56212E88287@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <20100211213651.GA29557@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56212E8831E@TK5EX14MBXC118.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56212E8831E@TK5EX14MBXC118.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 10:15:08PM +0000, Hank Janssen wrote:
> >>  
> >> -static const char VersionDate[] = __DATE__;
> >> -static const char VersionTime[] = __TIME__;
> >> -static const char VersionDesc[] = "Version 2.0";
> >> +static const char hv_build_date[] = __DATE__;
> >> +static const char hv_build_time[] = __TIME__;
> >
> >This should not be needed at all, as it make absolutely no sense.
> 
> You know, you are actually right. This is leftover from when the drivers
> Where standalone (before we submitted them to mainline) when customers
> Build the drivers on site themselves. It helped them to know when they
> Build it.

Great, then remove it :)

> >> +/*
> >> + * We use the same version numbering for all Hyper-V modules.
> >> + */
> >> +#define HV_DRV_VERSION           "3.0.0"
> >
> >Is this really needed?  Now that the code is in the kernel tree,
> >shouldn't you be tracking this based on kernel release version (like 90%
> >of the drivers are tracked), or is there some requirement for a version
> >number?
> >
> >And what decides when this number is changed?  What does it "mean"?
> >What is it tracking?
> 
> The definition of the versioning for us is as follows;
> 
> Field	Description	Resolution
> 1	Major Number 	Changes for these scenarios;
> 				1.	When a new version of Windows Hyper-V 
> 					is released.
> 				2.	A Major change has occurred in the 
> 					Linux IC's. 
> 				(For example the merge for the first time 
> 				into the kernel) Every time the Major Number 
> 				changes, the Minor Number and Revision number 
> 				are reset to 0.
> 2	Minor Number	Changes when new functionality is added 
> 				to the Linux IC's that is not a bug fix. 
> 				If new functionality is added to the IC's 
> 				that is in effect also a bug fix (in the case 
> 				of SMP). The new functionality will override 
> 				the need for changing the Revision number. 
> 				Every time the Minor Number changes, the 
> 				Revision number will be reset to 0.
> 				For example, The current version is on;
> 						3.0.4
> 				And SMP is added, which fixes a problem as 
> 				well. The new versioning will become;
> 						3.1.0

These two look good.

> 3	Revision		Every time a bug fix or code change is 
> 				done that is not a Minor or Major number 
> 				change, this field increases by 1.

How are you really going to track this?  Do you expect every single
patch to the drivers that changes the code to increment this number?
That's quite unrealistic.

> We have had issues in the past trying to piece together what customers
> Where running.

That is why you can now trigger off of the kernel version used, like
everyone else using Linux drivers does.

Yes, some companies/developers still like to track version numbers,
thinking when they backport things to older kernels for distro releases,
it will somehow properly convey the driver version.  But it turns out,
with the -stable releases, and bugfixes being backported all over the
place, that it doesn't really work out.

In short I would strongly advise against doing this, unless you are
willing to attempt to keep this up to date, and in reality, just ignore
the number as it means nothing.

This is also especially relevant given that Linux drivers are tightly
tied to the kernel version they are running on, as APIs change
constantly over time.  You can not just take one version of a driver on
one release, and drop it in another kernel version, without usually
changing something.  That change then "invalidates" the version number
scheme :)

Does this make sense?

> The importance of the versioning numbering like this will go away over
> Time once we have the code cleaned up and have additional functionality
> In a staged manner. For now we are still trying to catch up.

Catching up doesn't mean fixing the version numbering scheme, you have
much bigger issues to fix, IMHO :)

> Would you like me to re-roll the patch to remove the DATE/TIME stuff
> And add the explanation for versioning as comments to the code?

Yes, please do, and possibly drop the "minor" number, otherwise I am
going to have fun incrementing it with every single code change I do to
the drivers.  That would be what, version 264 or something by now?  :)

thanks,

greg k-h
