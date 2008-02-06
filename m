Return-Path: <linux-kernel-owner+w=401wt.eu-S932172AbYBFNUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbYBFNUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 08:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761574AbYBFNU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 08:20:27 -0500
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:61406 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754739AbYBFNU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:20:26 -0500
Date: Wed, 6 Feb 2008 14:20:23 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <gregkh@suse.de>
Cc: markus.rechberger@amd.com, "Matt_Domsch@dell.com" <Matt_Domsch@dell.com>,
       Jos?? Luis Tall??n <jltallon@adv-solutions.net>,
       "Douglas_Warzecha@dell.com" <Douglas_Warzecha@dell.com>,
       "Abhay_Salunke@dell.com" <Abhay_Salunke@dell.com>,
       linux-kernel@vger.kernel.org,
       Michael E Brown <Michael_E_Brown@dell.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.24 breaks BIOS updates on all Dell machines
Message-ID: <20080206142023.743657c2@hyperion.delvare>
In-Reply-To: <20080205234413.GA9386@suse.de>
References: <20080129184129.GA23681@kroah.com>
	<xJSmDwPr.1201644922.4322840.khali@gcu-squad.org>
	<20080205064547.GA20384@suse.de>
	<20080205211642.2c49e3d0@hyperion.delvare>
	<20080205234413.GA9386@suse.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 15:44:13 -0800, Greg KH wrote:
> On Tue, Feb 05, 2008 at 09:16:42PM +0100, Jean Delvare wrote:
> > This is 2.6.24, CONFIG_SYSFS_DEPRECATED=y:
> > 
> > # ls -l /sys/class/i2c-adapter/i2c-0
> > total 0
> > lrwxrwxrwx 1 root root    0 f?v  5 18:07 device -> ../../../devices/pci0000:00/0000:00:01.0/0000:01:00.0
> > lrwxrwxrwx 1 root root    0 f?v  5 18:17 i2c-dev:i2c-0 -> ../../../class/i2c-dev/i2c-0
> > -r--r--r-- 1 root root 4096 f?v  5 18:07 name
> > drwxr-xr-x 2 root root    0 f?v  5 18:17 power
> > lrwxrwxrwx 1 root root    0 f?v  5 18:07 subsystem -> ../../../class/i2c-adapter
> > -rw-r--r-- 1 root root 4096 f?v  5  2008 uevent
> > 
> > 2.6.24 rebuilt without CONFIG_SYSFS_DEPRECATED:
> > 
> > # ls -l /sys/class/i2c-adapter/i2c-0/
> > total 0
> > lrwxrwxrwx 1 root root    0 f?v  5 18:42 device -> ../../../../../../devices/pci0000:00/0000:00:01.0/0000:01:00.0
> > drwxr-xr-x 3 root root    0 f?v  5 18:42 i2c-0
> > -r--r--r-- 1 root root 4096 f?v  5 18:31 name
> > drwxr-xr-x 2 root root    0 f?v  5 18:42 power
> > lrwxrwxrwx 1 root root    0 f?v  5 18:31 subsystem -> ../../../../../../class/i2c-adapter
> > -rw-r--r-- 1 root root 4096 f?v  5  2008 uevent
> > 
> > The latter corresponds to what older kernels had ("i2c-0"). This means
> > that enabling CONFIG_SYSFS_DEPRECATED causes the i2c-dev class device
> > names to change.
> 
> Yes.  Well, no, not really.  The class device names are the same, it's
> just that it is a symlink in the DEPRECATED=Y name and a real directory
> in the =N case.
>
> > Isn't it supposed to be exactly the other way around, i.e. enabling
> > CONFIG_SYSFS_DEPRECATED should preserve the names as they were in
> > older kernels?
> 
> The real name is the same (look above, it's really called "i2c-0" in
> both cases, just that the symlink in the =Y case has to have a different
> name to handle the fact that there could be duplicate names in this
> format.
> 
> Does that help?

Not really. Why is =Y supposed to be a factor for duplicate names? The
exact same collision can happen in the =N case. This is exactly the
problem Markus and myself tried to address with
109f0e93b6b728f03c1eb4af02bc25d71b646c59. The i2c-dev class names its
class devices i2c-%d, and the firmware class as well (for i2c devices).
If 109f0e93b6b728f03c1eb4af02bc25d71b646c59 is going to be reverted,
then we will see the same collision again, but only for DEPRECATED=N.
That's rather confusing.

To add to the confusion, it seems that, in some cases, the potential
name collision is addressed by inserting a directory (named after the
class name) between the parent device and the class device. For example:

/sys/bus/pci/devices/0000:00:11.0/i2c-adapter/i2c-0

0000:00:11.0 is the PCI device, i2c-0 is the class device and
i2c-adapter is the class name.

So why isn't it done in all cases? This would solve the problem, as the
colliding class devices would finally get their own namespace:

/sys/bus/pci/devices/0000:00:11.0/i2c-adapter/i2c-0/i2c-dev/i2c-0
/sys/bus/pci/devices/0000:00:11.0/i2c-adapter/i2c-0/firmware/i2c-0

> It's really to keep older programs still work properly.  The =N case is
> what you should pay attention to for all modern distros.

Unfortunately the =N case is the one that will break when you revert
109f0e93b6b728f03c1eb4af02bc25d71b646c59.

-- 
Jean Delvare
