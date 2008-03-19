Return-Path: <linux-kernel-owner+w=401wt.eu-S1161986AbYCSWl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161986AbYCSWl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764761AbYCSVMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:12:23 -0400
Received: from ns.suse.de ([195.135.220.2]:47644 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936513AbYCSVMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:12:16 -0400
Subject: Re: [PATCH] ACPI: Add sysfs interface for acpi device wakeup
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: yi.y.yang@intel.com
Cc: Zhang Rui <rui.zhang@intel.com>, Maxim Levitsky <maximlevitsky@gmail.com>,
       david-b@pacbell.net, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net, Holger Macht <hmacht@suse.de>
In-Reply-To: <1200009342.5389.12.camel@yangyi-dev.bj.intel.com>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
	 <1199688961.3551.19.camel@yangyi-dev.bj.intel.com>
	 <1199917306.9596.3.camel@yangyi-dev.bj.intel.com>
	 <200801100943.08780.maximlevitsky@gmail.com>
	 <1200039383.3749.124.camel@acpi-sony.sh.intel.com>
	 <1200009342.5389.12.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Wed, 19 Mar 2008 14:06:22 +0100
Message-Id: <1205931982.21619.301.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-11 at 07:55 +0800, Yi Yang wrote:
> > > I think that it would be much much better to place wake-up attributes under
> > > corresponding PCI and PNP devices.
> > > Probably it is even better to link this code to PCI code, so PCI drivers will be aware of ACPI.
> > I like this idea, maxim. :)
> > And that's what we actually did about half a year ago.
> > 
> > Yi,
> > Please refer to http://bugzilla.kernel.org/show_bug.cgi?id=6892
> > and David's patch set here:
> > http://marc.info/?l=linux-mm-commits&m=117701595209299&w=2
> > http://marc.info/?l=linux-mm-commits&m=117701866524935&w=2
> > You can have a look at this thread as well:
> > http://marc.info/?l=linux-acpi&m=119982937409968&w=2
> > 
> I checked those patches you mentioned, they did bind two wakeup flag to
> some extent, but they can't be exchanged to use and they are just partly
> in current linus tree, two flags bind isn't in linus tree.
> 
> According to my test on the latest linus tree, wakeup flag of
> acpi_device hasn't any association with device's, i don't know if they
> are the same thing. if we enbale or disable it manually, what will
> happen? From source code, it is just a flag, it doesn't trigger any
> event or hardware operation.
> 
> > thanks,
> > Rui
> > > For example it will fix the 'EHCI instantly wakes up the system from S4' on my system, since here USB doesn't wake
> > > up anything from S4, and ACPI tables correctly show that.
> > > 
> > > If ehci driver was aware of that it could disable #PME on entrance to S4.
> > > And we even can reuse its 'wakeup' attribute, thus enabling wakeup automatically.
> > > 
> > > Going ever further, I think that it will be great to get rid of ACPI device tree, since
> > > most acpi devices are ether PCI of PNP ones.
> > > 
> > > Or, even better have a small ACPI tree, that will contain 'true' ACPI devices, like cpus
> > > thermal sensors, buttons, etc. 

Any news on this?
I ran into a problem with the current implementation:

If one GPE is tight to several devices you get a message:
echo XYZ >/tmp/acpi/wakeup
ACPI: 'XXX' and 'XYZ' have the same GPE, can't disable/enable one
seperately
ACPI: 'YYY' and 'XYZ' have the same GPE, can't disable/enable one
seperately
and none of the devices are activated to be able to wake the machine up.
Which I expect is wrong, all should be enabled/disabled then IMO, but
it's probably not worth much fixing in /proc/acpi/...

The correct interface to use seem to be:
drivers/base/power/sysfs.c
But this is rather broken?
Here an output of /proc/acpi/wakeup and /sys/...:
for x in `find /sys/ |grep wakeup`;do if [ $(cat $x) ];then echo $x; cat $x;fi;done
/sys/devices/pnp0/00:04/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1d.7/usb4/4-5/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1d.7/usb4/4-1/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1d.7/usb4/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1d.7/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1d.2/usb3/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1d.1/usb2/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1d.0/usb1/power/wakeup
enabled
trenn@stravinsky:/extern/trenn/packages/home:trenn> cat /proc/acpi/wakeup 
Device  S-state   Status   Sysfs node
PCI0      S5     disabled  no-bus:pci0000:00

I still think (from comments in drivers/base/power/sysfs.c, not sure
whether it really is that appropriate) it is wakeup sysfs file that
should be used for this.
I wonder why each device has a wakeup file, it should be enough to
create them dynamically if wakeup enable/disable is supported for a
specific device?
Also a second file is missing from which state (S3,S4,S5) the device can
wake the machine up.

If there can be multiple devices for one GPE, this information (the
power directory of multiple devices) could be linked together in sysfs?
E.g.
/sys/devices/pci0000:00/0000:00:1d.7/usb4/power/wakeup
is a link to:
/sys/devices/pci0000:00/0000:00:1d.2/usb3/power/wakeup
If both are using one wake-up GPE.

Also if the ACPI device caught through acpi_get_physical device is a PCI
bridge, it should get evaluated what is behind the bridge and this
device (e.g. a network card) should get the wakeup stuff set up, not the
bridge?

Does someone still look at this?
If not, shall I or is it on some queue?
Should this be discussed a bit more detailed first?

   Thomas

