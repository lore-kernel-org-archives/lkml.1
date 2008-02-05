Return-Path: <linux-kernel-owner+w=401wt.eu-S1760408AbYBEUQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408AbYBEUQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757861AbYBEUQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:16:47 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:1467 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757680AbYBEUQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:16:46 -0500
Date: Tue, 5 Feb 2008 21:16:42 +0100
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
Message-ID: <20080205211642.2c49e3d0@hyperion.delvare>
In-Reply-To: <20080205064547.GA20384@suse.de>
References: <20080129184129.GA23681@kroah.com>
	<xJSmDwPr.1201644922.4322840.khali@gcu-squad.org>
	<20080205064547.GA20384@suse.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 22:45:47 -0800, Greg KH wrote:
> On Tue, Jan 29, 2008 at 11:15:22PM +0100, Jean Delvare wrote:
> > I'm a bit confused. It seems to me that the "class devices" are named
> > differently in recent kernels. The i2c-dev class devices were originally
> > showing as i2c-%d in their parent device directories (causing the
> > collision), and now show as i2c-dev:i2c-%d. This suggests that the
> > collision the patch above was trying to solve is in fact already fixed
> > (by prefixing the device name with the class name). The good news is
> > that it would mean that we can just revert the patch in question...
> > 
> > But quite frankly I'm not really sure, the class devices look different
> > on every kernel I looked at, depending on the version and whether
> > CONFIG_SYSFS_DEPRECATED is set or not.
> 
> THe naming is different depending on that sysfs variable, yes.  But it
> should be consistant other than that.  If not, please let me know.
> 
> And yes, we did have to add the ":" a while ago to handle the namespace
> collisions we were having.

OK, I am officially confused now.

This is 2.6.24, CONFIG_SYSFS_DEPRECATED=y:

# ls -l /sys/class/i2c-adapter/i2c-0
total 0
lrwxrwxrwx 1 root root    0 fév  5 18:07 device -> ../../../devices/pci0000:00/0000:00:01.0/0000:01:00.0
lrwxrwxrwx 1 root root    0 fév  5 18:17 i2c-dev:i2c-0 -> ../../../class/i2c-dev/i2c-0
-r--r--r-- 1 root root 4096 fév  5 18:07 name
drwxr-xr-x 2 root root    0 fév  5 18:17 power
lrwxrwxrwx 1 root root    0 fév  5 18:07 subsystem -> ../../../class/i2c-adapter
-rw-r--r-- 1 root root 4096 fév  5  2008 uevent

2.6.24 rebuilt without CONFIG_SYSFS_DEPRECATED:

# ls -l /sys/class/i2c-adapter/i2c-0/
total 0
lrwxrwxrwx 1 root root    0 fév  5 18:42 device -> ../../../../../../devices/pci0000:00/0000:00:01.0/0000:01:00.0
drwxr-xr-x 3 root root    0 fév  5 18:42 i2c-0
-r--r--r-- 1 root root 4096 fév  5 18:31 name
drwxr-xr-x 2 root root    0 fév  5 18:42 power
lrwxrwxrwx 1 root root    0 fév  5 18:31 subsystem -> ../../../../../../class/i2c-adapter
-rw-r--r-- 1 root root 4096 fév  5  2008 uevent

The latter corresponds to what older kernels had ("i2c-0"). This means
that enabling CONFIG_SYSFS_DEPRECATED causes the i2c-dev class device
names to change. Isn't it supposed to be exactly the other way around,
i.e. enabling CONFIG_SYSFS_DEPRECATED should preserve the names as they
were in older kernels?

If the "$class:" prefix was added to prevent collisions (and this
sounds like a good idea), then why wasn't it added in the regular case
(CONFIG_SYSFS_DEPRECATED=n) as well?

Someone please clarify the situation.

Thanks,
-- 
Jean Delvare
