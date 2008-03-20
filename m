Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbYCTEoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbYCTEoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 00:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbYCTEn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 00:43:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:44141 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYCTEn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 00:43:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,528,1199692800"; 
   d="scan'208";a="536804712"
Subject: Re: [PATCH] ACPI: Add sysfs interface for acpi device wakeup
From: Zhao Yakui <yakui.zhao@intel.com>
To: yi.y.yang@intel.com
Cc: trenn@suse.de, Zhang Rui <rui.zhang@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, david-b@pacbell.net,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       lenb@kernel.org, acpi-bugzilla@lists.sourceforge.net,
       Holger Macht <hmacht@suse.de>
In-Reply-To: <1205937444.3842.82.camel@yangyi-dev>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
	 <1199688961.3551.19.camel@yangyi-dev.bj.intel.com>
	 <1199917306.9596.3.camel@yangyi-dev.bj.intel.com>
	 <200801100943.08780.maximlevitsky@gmail.com>
	 <1200039383.3749.124.camel@acpi-sony.sh.intel.com>
	 <1200009342.5389.12.camel@yangyi-dev.bj.intel.com>
	 <1205931982.21619.301.camel@queen.suse.de>
	 <1205937444.3842.82.camel@yangyi-dev>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 12:32:51 +0800
Message-Id: <1205987571.4061.55.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-19 at 22:37 +0800, Yi Yang wrote:
> > Any news on this?
> > I ran into a problem with the current implementation:
> > 
> > If one GPE is tight to several devices you get a message:
> > echo XYZ >/tmp/acpi/wakeup
> > ACPI: 'XXX' and 'XYZ' have the same GPE, can't disable/enable one
> > seperately
> > ACPI: 'YYY' and 'XYZ' have the same GPE, can't disable/enable one
> > seperately
> > and none of the devices are activated to be able to wake the machine up.
> > Which I expect is wrong, all should be enabled/disabled then IMO, but
> > it's probably not worth much fixing in /proc/acpi/...
> "Can't disable/enable one seperately" is just a warning, all the devices
> with the same GPE can be disabled/enabled once.
> 
> > 
> > The correct interface to use seem to be:
> > drivers/base/power/sysfs.c
> wakeup flag in this driver is a generic software flag in "struct
> device", but the wakeup flag you see in /proc/acpi/wakeup is a hardware
> wakeup flag in ACPI device, all the wakeup events triggered by hardware
> devices are handled by ACPI driver.
> 
In current kernel the wakeup flag in /proc/acpi/wakeup means whether the
device can wakeup the sleeping system. It is only used to wake the
system from S1/S3/S4. 
Now the power/wakeup sys I/F is created for every device. Maybe it is
better that  the power/wakeup sys I/F is only created for the device
that can wake up the sleeping system. In order to determine whether the
device can wake up the sleeping system, it is necessary to check whether
the associated ACPI device can support wakeup  and whether the native
device can support wakeup (For example: PCI device should support PME
function.)
> But i indeed regret wakeup flags in /sys/... and /proc/acpi/wakeup
> haven't any association. They should be consolidated in my opinion.

> Zhang Rui said they are doing it, but i didn't get any information about
> progress, i completely agree it should be done ASAP.

Now I am trying to do them. But the difficulty is that we should support
the runtime wakeup. 
> If you need to enbale wakeup, you.d better enable wakeup flag in
> both /proc/acpi/wakeup and /sys/..., i can use USB mouse to wake up my
> machine from S3.
> 
> > But this is rather broken?
> > Here an output of /proc/acpi/wakeup and /sys/...:
> > for x in `find /sys/ |grep wakeup`;do if [ $(cat $x) ];then echo $x; cat $x;fi;done
> > /sys/devices/pnp0/00:04/power/wakeup
> > enabled
> > /sys/devices/pci0000:00/0000:00:1d.7/usb4/4-5/power/wakeu
> > enabled
> > /sys/devices/pci0000:00/0000:00:1d.7/usb4/4-1/power/wakeup
> > enabled
> > /sys/devices/pci0000:00/0000:00:1d.7/usb4/power/wakeup
> > enabled
> > /sys/devices/pci0000:00/0000:00:1d.7/power/wakeup
> > enabled
> > /sys/devices/pci0000:00/0000:00:1d.2/usb3/power/wakeup
> > enabled
> > /sys/devices/pci0000:00/0000:00:1d.1/usb2/power/wakeup
> > enabled
> > /sys/devices/pci0000:00/0000:00:1d.0/usb1/power/wakeup
> > enabled
> > trenn@stravinsky:/extern/trenn/packages/home:trenn> cat /proc/acpi/wakeup 
> > Device  S-state   Status   Sysfs node
> > PCI0      S5     disabled  no-bus:pci0000:00
> > 
> > I still think (from comments in drivers/base/power/sysfs.c, not sure
> > whether it really is that appropriate) it is wakeup sysfs file that
> > should be used for this.
> > I wonder why each device has a wakeup file, it should be enough to
> > create them dynamically if wakeup enable/disable is supported for a
> > specific device?
> > Also a second file is missing from which state (S3,S4,S5) the device can
> > wake the machine up.
> > 
> > If there can be multiple devices for one GPE, this information (the
> > power directory of multiple devices) could be linked together in sysfs?
> > E.g.
> > /sys/devices/pci0000:00/0000:00:1d.7/usb4/power/wakeup
> > is a link to:
> > /sys/devices/pci0000:00/0000:00:1d.2/usb3/power/wakeup
> > If both are using one wake-up GPE.
> > 
> > Also if the ACPI device caught through acpi_get_physical device is a PCI
> > bridge, it should get evaluated what is behind the bridge and this
> > device (e.g. a network card) should get the wakeup stuff set up, not the
> > bridge?
> > 
> > Does someone still look at this?
> > If not, shall I or is it on some queue?
> > Should this be discussed a bit more detailed first?
> > 
> >    Thomas
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

