Return-Path: <linux-kernel-owner+w=401wt.eu-S1760076AbYFQWsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076AbYFQWsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757676AbYFQWse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:48:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36481 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbYFQWsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:48:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48583F3B.1090705@s5r6.in-berlin.de>
Date: Wed, 18 Jun 2008 00:48:27 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080614 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: Josh Boyer <jwboyer@gmail.com>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Recommendation for activating a deferred module init in the kernel
References: <48580116.9070504@am.sony.com>	<20080617190750.GA31224@logfs.org>	<485815F6.20507@am.sony.com>	<485816B3.3080800@am.sony.com>	<20080617202318.GC31224@logfs.org> <20080617163516.2be96400@vader.jdub.homelinux.org>
In-Reply-To: <20080617163516.2be96400@vader.jdub.homelinux.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Tue, 17 June 2008 12:55:31 -0700, Tim Bird wrote:
>>> Sorry - I responded too quickly.  I'm not sure I follow the
>>> original suggestion.  How would I call the open function of
>>> a module that is not initialized yet?

You will be able to open a character device file as soon as cdev_init() 
finished... when the Big Kernel Lock is not being taken around 
file_operations.open() anymore.

On Tue, 17 Jun 2008 11:28:29 -0700, Tim Bird wrote:
| One technique
| that we are forward-porting from an old kernel (and that I thought I
| might work on mainlining) is to compile modules statically into the
| kernel, but defer their initialization until after boot time.
...
| One of the main sub-systems that we defer initialization of this
| way is USB, and this saves quite a bit of time.  (Of course the
| same, or slightly more CPU cycles are eventually used during
| bootup time.  But this lets us get to user space quicker so we
| can start user-visible applications faster.)

What if you don't defer module initialization, but merely device probing?

$ ls /sys/bus/*/drivers_autoprobe
/sys/bus/acpi/drivers_autoprobe
/sys/bus/firewire/drivers_autoprobe
/sys/bus/i2c/drivers_autoprobe
/sys/bus/ide/drivers_autoprobe
/sys/bus/pci/drivers_autoprobe
/sys/bus/pci_express/drivers_autoprobe
/sys/bus/platform/drivers_autoprobe
/sys/bus/pnp/drivers_autoprobe
/sys/bus/scsi/drivers_autoprobe
/sys/bus/serio/drivers_autoprobe
/sys/bus/usb/drivers_autoprobe

If you set /sys/bus/foo/drivers_autoprobe to 0 (default is 1), then a 
/sys/bus/foo/drivers/bar will not be bound to devices.  You can trigger 
driver--device binding later per device by writing a device's bus ID 
into /sys/bus/foo/drivers/bar/bind, or by writing into 
/sys/bus/foo/drivers_probe (I guess; I only used the per-device way so far).

Now, since you want to do this with statically linked drivers, i.e. need 
to prevent probing before userspace and sysfs are up and running, you 
probably need to modify the bus types or/and the driver core so that the 
the less vital buses have drivers_autoprobe off by default.

On the other hand, maybe you want to have probes of some PCI drivers 
executed but not the probes of some other PCI drivers; uhci_hcd for 
example.  I guess you could achieve that by modifying 
drivers/pci/pci-driver.c::pci_bus_match().  E.g. add a sysfs attribute 
to pci-driver.c which, as long as containing its initial value, lets 
bus_match skip certain unwanted drivers (or match only whitelisted 
drivers).  Later, userspace writes into the extra sysfs attribute and 
into the standard driver core sysfs attributes to trigger the deferred 
driver probes.
-- 
Stefan Richter
-=====-==--- -==- =--=-
http://arcgraph.de/sr/
