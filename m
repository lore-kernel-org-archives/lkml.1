Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYA2KMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYA2KMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 05:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYA2KMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 05:12:46 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:16631 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbYA2KMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 05:12:44 -0500
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Subject: Re: [2.6.24-rc6-mm1]Build failure in drivers/net/ehea/ehea_main.c
Date: Tue, 29 Jan 2008 11:12:40 +0100
User-Agent: KMail/1.8.2
Cc: Greg KH <greg@kroah.com>, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>
References: <20080108163305.GB10026@in.ibm.com> <20080128182423.GC28861@kroah.com> <20080128192204.GO14201@localdomain>
In-Reply-To: <20080128192204.GO14201@localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801291112.41337.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008 20:22, you wrote:
> Greg KH wrote:
> > On Fri, Jan 25, 2008 at 01:10:48PM -0600, Nathan Lynch wrote:
> > > Jan-Bernd Themann wrote:
> > > 
> > > This is now broken in mainline...
> > > 
> > > drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_add':
> > > drivers/net/ehea/ehea_main.c:2812: error: 'struct device_driver' has
> > > no member named 'kobj'
> > > drivers/net/ehea/ehea_main.c:2815: error: 'struct device_driver' has
> > > no member named 'kobj'
> > > drivers/net/ehea/ehea_main.c:2818: error: 'struct device_driver' has
> > > no member named 'kobj'
> > > drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_remove':
> > > drivers/net/ehea/ehea_main.c:2830: error: 'struct device_driver' has
> > > no member named 'kobj'
> > 
> > Does the patch below fix this?  That driver should not have been trying
> > to create symlinks that the driver core has already created for it.
> 
> Yes, it fixes the build error, by just removing the code that got
> broken.  Jan-Bernd gave a rationale for creating the symlink that
> didn't really seem to be answered.
> 

> > > > The eHEA driver tries to orginize its sys-entries as close as possible to
> > > > other ethernet drivers. Each eHEA NIC has multiple ports which is not that
> > > > common in PCI. This means that each port is represented by a subdirectory
> > > > which has not the "driver" sys-link, only the root directory has.
> > > > Some tools expect to have this driver link in each port directory.
> > > > That is the reason why this link is created manually.

In addition to the explaination above:

Just to be sure that we talk about the same thing:
The eHEA driver controlls multiple eHEAs which have multiple
ethernet ports each. So the logical structure looks like this:
eHEA1 ---> port1 (ethX)
        -> port2 (ethX+1)
        -> port3 (ethX+2)
   ...
eHEA2 ---> port1 (eth?)
        -> port2
        -> port3 
   ...
This structure is represented in /sys/bus/ibmebus/devices in the same way
described above.

If you want to determine the driver belonging to an ethX, you would go
the following path:
/sys/class/net/ethX/device/driver


ls /sys/class/net/ethX/device:
drwxr-xr-x 2 root root    0 2008-01-29 10:00 .
drwxr-xr-x 4 root root    0 2008-01-29 10:00 ..
lrwxrwxrwx 1 root root    0 2008-01-29 10:00 bus -> ../../../../bus/ibmebus
-r--r--r-- 1 root root 4096 2008-01-29 10:00 devspec
lrwxrwxrwx 1 root root    0 2008-01-29 10:00 driver -> ../../../../bus/ibmebus/drivers/ehea
                                             ^^^^^
	In our case this one is created by the code that does not work any longer.

The sym-link is not gereated automatically as the device for portX is added
to the eHEA device (as subnode) where the eHEA device is not a bus.

If this sym-link is of interest (which I guess is the case as most devices
have it) we have to create it somehow.

Would the following proposal work?

There is an exported kernel function called 
"device_bind_driver" which creates the same links. However, it does some
additional stuff as well and there is currently no 
"device_unbind_driver" yet. Either "device_unbind_driver" needs to
be added or the following two already existing functions could be exported:

driver_sysfs_add
driver_sysfs_remove


Regards,
Jan-Bernd & Christoph Raisch
