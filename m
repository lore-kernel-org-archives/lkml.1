Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbYCTCZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbYCTCZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 22:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYCTCZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 22:25:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:44206 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbYCTCZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 22:25:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,527,1199692800"; 
   d="scan'208";a="357544544"
Subject: Re: [PATCH] ACPI: Add sysfs interface for acpi device wakeup
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: trenn@suse.de
Cc: Zhang Rui <rui.zhang@intel.com>, Maxim Levitsky <maximlevitsky@gmail.com>,
       david-b@pacbell.net, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net, Holger Macht <hmacht@suse.de>
In-Reply-To: <1205931982.21619.301.camel@queen.suse.de>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
	 <1199688961.3551.19.camel@yangyi-dev.bj.intel.com>
	 <1199917306.9596.3.camel@yangyi-dev.bj.intel.com>
	 <200801100943.08780.maximlevitsky@gmail.com>
	 <1200039383.3749.124.camel@acpi-sony.sh.intel.com>
	 <1200009342.5389.12.camel@yangyi-dev.bj.intel.com>
	 <1205931982.21619.301.camel@queen.suse.de>
Content-Type: text/plain
Organization: Intel
Date: Wed, 19 Mar 2008 22:37:24 +0800
Message-Id: <1205937444.3842.82.camel@yangyi-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any news on this?
> I ran into a problem with the current implementation:
> 
> If one GPE is tight to several devices you get a message:
> echo XYZ >/tmp/acpi/wakeup
> ACPI: 'XXX' and 'XYZ' have the same GPE, can't disable/enable one
> seperately
> ACPI: 'YYY' and 'XYZ' have the same GPE, can't disable/enable one
> seperately
> and none of the devices are activated to be able to wake the machine up.
> Which I expect is wrong, all should be enabled/disabled then IMO, but
> it's probably not worth much fixing in /proc/acpi/...
"Can't disable/enable one seperately" is just a warning, all the devices
with the same GPE can be disabled/enabled once.

> 
> The correct interface to use seem to be:
> drivers/base/power/sysfs.c
wakeup flag in this driver is a generic software flag in "struct
device", but the wakeup flag you see in /proc/acpi/wakeup is a hardware
wakeup flag in ACPI device, all the wakeup events triggered by hardware
devices are handled by ACPI driver.

But i indeed regret wakeup flags in /sys/... and /proc/acpi/wakeup
haven't any association. They should be consolidated in my opinion.

Zhang Rui said they are doing it, but i didn't get any information about
progress, i completely agree it should be done ASAP.

If you need to enbale wakeup, you.d better enable wakeup flag in
both /proc/acpi/wakeup and /sys/..., i can use USB mouse to wake up my
machine from S3.

> But this is rather broken?
> Here an output of /proc/acpi/wakeup and /sys/...:
> for x in `find /sys/ |grep wakeup`;do if [ $(cat $x) ];then echo $x; cat $x;fi;done
> /sys/devices/pnp0/00:04/power/wakeup
> enabled
> /sys/devices/pci0000:00/0000:00:1d.7/usb4/4-5/power/wakeu
> enabled
> /sys/devices/pci0000:00/0000:00:1d.7/usb4/4-1/power/wakeup
> enabled
> /sys/devices/pci0000:00/0000:00:1d.7/usb4/power/wakeup
> enabled
> /sys/devices/pci0000:00/0000:00:1d.7/power/wakeup
> enabled
> /sys/devices/pci0000:00/0000:00:1d.2/usb3/power/wakeup
> enabled
> /sys/devices/pci0000:00/0000:00:1d.1/usb2/power/wakeup
> enabled
> /sys/devices/pci0000:00/0000:00:1d.0/usb1/power/wakeup
> enabled
> trenn@stravinsky:/extern/trenn/packages/home:trenn> cat /proc/acpi/wakeup 
> Device  S-state   Status   Sysfs node
> PCI0      S5     disabled  no-bus:pci0000:00
> 
> I still think (from comments in drivers/base/power/sysfs.c, not sure
> whether it really is that appropriate) it is wakeup sysfs file that
> should be used for this.
> I wonder why each device has a wakeup file, it should be enough to
> create them dynamically if wakeup enable/disable is supported for a
> specific device?
> Also a second file is missing from which state (S3,S4,S5) the device can
> wake the machine up.
> 
> If there can be multiple devices for one GPE, this information (the
> power directory of multiple devices) could be linked together in sysfs?
> E.g.
> /sys/devices/pci0000:00/0000:00:1d.7/usb4/power/wakeup
> is a link to:
> /sys/devices/pci0000:00/0000:00:1d.2/usb3/power/wakeup
> If both are using one wake-up GPE.
> 
> Also if the ACPI device caught through acpi_get_physical device is a PCI
> bridge, it should get evaluated what is behind the bridge and this
> device (e.g. a network card) should get the wakeup stuff set up, not the
> bridge?
> 
> Does someone still look at this?
> If not, shall I or is it on some queue?
> Should this be discussed a bit more detailed first?
> 
>    Thomas
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

