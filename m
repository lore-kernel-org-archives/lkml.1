Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934480Ab0BYXG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:06:57 -0500
Received: from kroah.org ([198.145.64.141]:52876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934466Ab0BYXGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:06:50 -0500
Date: Thu, 25 Feb 2010 15:06:39 -0800
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Problem with auto-detecting a HV environment from within Linux
Message-ID: <20100225230639.GB20900@kroah.com>
References: <20100225164436.GA3310@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A4277@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100225173611.GA14124@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A5633@TK5EX14MBXC130.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF725B6A5633@TK5EX14MBXC130.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 06:37:05PM +0000, Haiyang Zhang wrote:
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Thursday, February 25, 2010 12:36 PM
> > What does the following command output in a HV virtual system:
> > 	grep . /sys/bus/acpi/devices/*/modalias
> 
> /sys/bus/acpi/devices/VMBus:00/modalias:acpi:VMBus:
> 
> > How about DMI data?  Does the Host export any info there?  Is there
> > anything in the /sys/class/dmi/id/ directory?  If so, can you send the
> > output of:
> > 	cat /sys/class/dmi/id/modalias
> 
> dmi:bvnAmericanMegatrendsInc.:bvr090004:bd03/19/2009:svnMicrosoftCorporation:pnVirtualMachine:pvr7.0:rvnMicrosoftCorporation:rnVirtualMachine:rvr7.0:cvnMicrosoftCorporation:ct3:cvr7.0:

Nice, can we rely on this to be static?  Will the following structure always
match properly?

static struct dmi_system_id __initdata microsoft_hyperv_table[] = {
	{
		.ident = "hyperv",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "MicrosoftCorporation"),
			DMI_MATCH(DMI_PRODUCT_NAME, "VirtualMachine"),
			DMI_MATCH(DMI_BOARD_NAME, "VirtualMachine"),
		},
	},
};

That would be good to match with, but I don't know if all distro tools
can properly handle DMI module stuff just yet.

> > And you are sure no PCI devices are present to key off of that are
> > never going to show up in a "physical" machine?
> 
> There is also a pci device as you said:
> 00:08.0 VGA compatible controller: Microsoft Corporation Device 5353 (prog-if 00 [VGA controller])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 11
>         Region 0: Memory at f8000000 (32-bit, non-prefetchable) [size=64M]

Ah, nice.  Can we rely on this always being present?

If so, what is the vendor and product id of this device?

Is it:
	Vendor id 0x1414
or:
	Vendor id 0x045e

Microsoft has both assigned to them, and probably others.

Is the device id 0x5353?

You can see this by doing the following:
	lspci -n | grep 08\\.0
what is the output of that?

thanks,

greg k-h
