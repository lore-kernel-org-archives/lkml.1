Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbYA2NXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbYA2NXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763920AbYA2NXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:23:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46639 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278AbYA2NXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:23:30 -0500
Date: Tue, 29 Jan 2008 05:23:09 -0800
From: Greg KH <greg@kroah.com>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: Nathan Lynch <ntl@pobox.com>, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>
Subject: Re: [2.6.24-rc6-mm1]Build failure in drivers/net/ehea/ehea_main.c
Message-ID: <20080129132309.GA10898@kroah.com>
References: <20080108163305.GB10026@in.ibm.com> <20080128182423.GC28861@kroah.com> <20080128192204.GO14201@localdomain> <200801291112.41337.ossthema@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801291112.41337.ossthema@de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 11:12:40AM +0100, Jan-Bernd Themann wrote:
> On Monday 28 January 2008 20:22, you wrote:
> > Greg KH wrote:
> > > On Fri, Jan 25, 2008 at 01:10:48PM -0600, Nathan Lynch wrote:
> > > > Jan-Bernd Themann wrote:
> > > > 
> > > > This is now broken in mainline...
> > > > 
> > > > drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_add':
> > > > drivers/net/ehea/ehea_main.c:2812: error: 'struct device_driver' has
> > > > no member named 'kobj'
> > > > drivers/net/ehea/ehea_main.c:2815: error: 'struct device_driver' has
> > > > no member named 'kobj'
> > > > drivers/net/ehea/ehea_main.c:2818: error: 'struct device_driver' has
> > > > no member named 'kobj'
> > > > drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_remove':
> > > > drivers/net/ehea/ehea_main.c:2830: error: 'struct device_driver' has
> > > > no member named 'kobj'
> > > 
> > > Does the patch below fix this?  That driver should not have been trying
> > > to create symlinks that the driver core has already created for it.
> > 
> > Yes, it fixes the build error, by just removing the code that got
> > broken.  Jan-Bernd gave a rationale for creating the symlink that
> > didn't really seem to be answered.
> > 
> 
> > > > > The eHEA driver tries to orginize its sys-entries as close as possible to
> > > > > other ethernet drivers. Each eHEA NIC has multiple ports which is not that
> > > > > common in PCI. This means that each port is represented by a subdirectory
> > > > > which has not the "driver" sys-link, only the root directory has.
> > > > > Some tools expect to have this driver link in each port directory.
> > > > > That is the reason why this link is created manually.
> 
> In addition to the explaination above:
> 
> Just to be sure that we talk about the same thing:
> The eHEA driver controlls multiple eHEAs which have multiple
> ethernet ports each. So the logical structure looks like this:
> eHEA1 ---> port1 (ethX)
>         -> port2 (ethX+1)
>         -> port3 (ethX+2)
>    ...
> eHEA2 ---> port1 (eth?)
>         -> port2
>         -> port3 
>    ...
> This structure is represented in /sys/bus/ibmebus/devices in the same way
> described above.
> 
> If you want to determine the driver belonging to an ethX, you would go
> the following path:
> /sys/class/net/ethX/device/driver
> 
> 
> ls /sys/class/net/ethX/device:
> drwxr-xr-x 2 root root    0 2008-01-29 10:00 .
> drwxr-xr-x 4 root root    0 2008-01-29 10:00 ..
> lrwxrwxrwx 1 root root    0 2008-01-29 10:00 bus -> ../../../../bus/ibmebus
> -r--r--r-- 1 root root 4096 2008-01-29 10:00 devspec
> lrwxrwxrwx 1 root root    0 2008-01-29 10:00 driver -> ../../../../bus/ibmebus/drivers/ehea
>                                              ^^^^^
> 	In our case this one is created by the code that does not work any longer.
> 
> The sym-link is not gereated automatically as the device for portX is added
> to the eHEA device (as subnode) where the eHEA device is not a bus.

Then please fix that, no other driver has this kind of problem, right?
Are you just passing the wrong "device" to the networking subsystem?

> If this sym-link is of interest (which I guess is the case as most devices
> have it) we have to create it somehow.

Why would you have to do this by hand?  What makes this driver so unique
in the kernel that it would have to do this?  We have lots of other
multi-port ethernet drivers today without this issue, right?

confused,

greg k-h
