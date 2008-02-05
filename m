Return-Path: <linux-kernel-owner+w=401wt.eu-S1763395AbYBEXqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763395AbYBEXqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761019AbYBEXqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:46:25 -0500
Received: from cantor.suse.de ([195.135.220.2]:40052 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760746AbYBEXqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:46:23 -0500
Date: Tue, 5 Feb 2008 15:44:13 -0800
From: Greg KH <gregkh@suse.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: markus.rechberger@amd.com, "Matt_Domsch@dell.com" <Matt_Domsch@dell.com>,
       Jos?? Luis Tall??n <jltallon@adv-solutions.net>,
       "Douglas_Warzecha@dell.com" <Douglas_Warzecha@dell.com>,
       "Abhay_Salunke@dell.com" <Abhay_Salunke@dell.com>,
       linux-kernel@vger.kernel.org,
       Michael E Brown <Michael_E_Brown@dell.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.24 breaks BIOS updates on all Dell machines
Message-ID: <20080205234413.GA9386@suse.de>
References: <20080129184129.GA23681@kroah.com> <xJSmDwPr.1201644922.4322840.khali@gcu-squad.org> <20080205064547.GA20384@suse.de> <20080205211642.2c49e3d0@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205211642.2c49e3d0@hyperion.delvare>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 09:16:42PM +0100, Jean Delvare wrote:
> On Mon, 4 Feb 2008 22:45:47 -0800, Greg KH wrote:
> > On Tue, Jan 29, 2008 at 11:15:22PM +0100, Jean Delvare wrote:
> > > I'm a bit confused. It seems to me that the "class devices" are named
> > > differently in recent kernels. The i2c-dev class devices were originally
> > > showing as i2c-%d in their parent device directories (causing the
> > > collision), and now show as i2c-dev:i2c-%d. This suggests that the
> > > collision the patch above was trying to solve is in fact already fixed
> > > (by prefixing the device name with the class name). The good news is
> > > that it would mean that we can just revert the patch in question...
> > > 
> > > But quite frankly I'm not really sure, the class devices look different
> > > on every kernel I looked at, depending on the version and whether
> > > CONFIG_SYSFS_DEPRECATED is set or not.
> > 
> > THe naming is different depending on that sysfs variable, yes.  But it
> > should be consistant other than that.  If not, please let me know.
> > 
> > And yes, we did have to add the ":" a while ago to handle the namespace
> > collisions we were having.
> 
> OK, I am officially confused now.

Heh, it is a mess :)

> This is 2.6.24, CONFIG_SYSFS_DEPRECATED=y:
> 
> # ls -l /sys/class/i2c-adapter/i2c-0
> total 0
> lrwxrwxrwx 1 root root    0 f?v  5 18:07 device -> ../../../devices/pci0000:00/0000:00:01.0/0000:01:00.0
> lrwxrwxrwx 1 root root    0 f?v  5 18:17 i2c-dev:i2c-0 -> ../../../class/i2c-dev/i2c-0
> -r--r--r-- 1 root root 4096 f?v  5 18:07 name
> drwxr-xr-x 2 root root    0 f?v  5 18:17 power
> lrwxrwxrwx 1 root root    0 f?v  5 18:07 subsystem -> ../../../class/i2c-adapter
> -rw-r--r-- 1 root root 4096 f?v  5  2008 uevent
> 
> 2.6.24 rebuilt without CONFIG_SYSFS_DEPRECATED:
> 
> # ls -l /sys/class/i2c-adapter/i2c-0/
> total 0
> lrwxrwxrwx 1 root root    0 f?v  5 18:42 device -> ../../../../../../devices/pci0000:00/0000:00:01.0/0000:01:00.0
> drwxr-xr-x 3 root root    0 f?v  5 18:42 i2c-0
> -r--r--r-- 1 root root 4096 f?v  5 18:31 name
> drwxr-xr-x 2 root root    0 f?v  5 18:42 power
> lrwxrwxrwx 1 root root    0 f?v  5 18:31 subsystem -> ../../../../../../class/i2c-adapter
> -rw-r--r-- 1 root root 4096 f?v  5  2008 uevent
> 
> The latter corresponds to what older kernels had ("i2c-0"). This means
> that enabling CONFIG_SYSFS_DEPRECATED causes the i2c-dev class device
> names to change.

Yes.  Well, no, not really.  The class device names are the same, it's
just that it is a symlink in the DEPRECATED=Y name and a real directory
in the =N case.

> Isn't it supposed to be exactly the other way around, i.e. enabling
> CONFIG_SYSFS_DEPRECATED should preserve the names as they were in
> older kernels?

The real name is the same (look above, it's really called "i2c-0" in
both cases, just that the symlink in the =Y case has to have a different
name to handle the fact that there could be duplicate names in this
format.

Does that help?

It's really to keep older programs still work properly.  The =N case is
what you should pay attention to for all modern distros.

thanks,

greg k-h
