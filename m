Return-Path: <linux-kernel-owner+w=401wt.eu-S933842AbZDISHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842AbZDISHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934587AbZDISHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:07:20 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:37295 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962AbZDISHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:07:17 -0400
Subject: Re: [PATCH 1/1] cciss: resubmit export uid, model, vendor, rev to 
 sysfs
From: Andrew Patterson <andrew.patterson@hp.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: ens Axboe <jens.axboe@oracle.com>,
       "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LKML-SCSI <linux-scsi@vger.kernel.org>
In-Reply-To: <ac3eb2510904091005q13e5b5a1j3907de22ad3df70c@mail.gmail.com>
References: <20090407180411.GA4324@beardog.cca.cpqcorp.net>
	 <20090408061901.GN5178@kernel.dk>
	 <ac3eb2510904080526h36673aa7qb5d530df33a60104@mail.gmail.com>
	 <1239258160.19984.217.camel@grinch>
	 <ac3eb2510904090719n730dededp54b25390a9087a79@mail.gmail.com>
	 <1239296221.19984.218.camel@grinch>
	 <ac3eb2510904091005q13e5b5a1j3907de22ad3df70c@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 12:07:13 -0600
Message-Id: <1239300433.19984.270.camel@grinch>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 10:05 -0700, Kay Sievers wrote:
> On Thu, Apr 9, 2009 at 09:57, Andrew Patterson <andrew.patterson@hp.com> wrote:
> > On Thu, 2009-04-09 at 07:19 -0700, Kay Sievers wrote:
> 
> >> I would need to see the output of:
> >>   /sbin/udevadm info --attribute-walk --path=/block/<disk-name>
> 
> >  looking at device '/block/cciss!c0d0':
> >    KERNEL=="cciss!c0d0"
> >    SUBSYSTEM=="block"
> >    DRIVER==""
> >    ATTR{range}=="16"
> >    ATTR{ext_range}=="16"
> >    ATTR{removable}=="0"
> >    ATTR{ro}=="0"
> >    ATTR{size}=="286611840"
> >    ATTR{capability}=="10"
> 
> The block device needs a parent, please assign the cciss bus device.
> It's the driverfs_dev in the genhd struct.
> 

This is already done in cciss_add_disk():

	disk->fops = &cciss_fops;
	disk->private_data = &h->drv[drv_index];
	disk->driverfs_dev = &h->drv[drv_index].dev;

I think my problem is I was assigning cciss_bus_type to the controller,
not the block device. I have fixed that.

> Please provide the output again, it will get much larger then.
> 
> Also, please disable CONFIG_SYSFS_DEPRECATED* in your kernel config.
> 

Done.

# /sbin/udevadm info --attribute-walk "--path=/block/cciss!c0d0"

Udevinfo starts with the device specified by the devpath and then
walks up the chain of parent devices. It prints for every device
found, all possible attributes in the udev rules key format.
A rule to match, can be composed by the attributes of the device
and the attributes from one single parent device.

'/devices/pci0000:4f/0000:4f:00.0/0000:50:00.0/0000:51:04.0/0000:8b:00.0/cciss0/c0d0/block/cciss!c0d0':
    KERNEL=="cciss!c0d0"
    SUBSYSTEM=="block"
    DRIVER==""
    ATTR{range}=="16"
    ATTR{ext_range}=="16"
    ATTR{removable}=="0"
    ATTR{ro}=="0"
    ATTR{size}=="286611840"
    ATTR{capability}=="10"
    ATTR{stat}=="      29       37     2112       52        0        0
0        0        0       52       52"

  looking at parent device
'/devices/pci0000:4f/0000:4f:00.0/0000:50:00.0/0000:51:04.0/0000:8b:00.0/cciss0/c0d0':
    KERNELS=="c0d0"
    SUBSYSTEMS=="cciss"
    DRIVERS==""
    ATTRS{unique_id}=="600508B1001044424654324558350012"
    ATTRS{model}=="LOGICAL VOLUME  "
    ATTRS{vendor}=="HP      "
    ATTRS{rev}=="5.20"

  looking at parent device
'/devices/pci0000:4f/0000:4f:00.0/0000:50:00.0/0000:51:04.0/0000:8b:00.0/cciss0':
    KERNELS=="cciss0"
    SUBSYSTEMS==""
    DRIVERS==""

  looking at parent device
'/devices/pci0000:4f/0000:4f:00.0/0000:50:00.0/0000:51:04.0/0000:8b:00.0':
    KERNELS=="0000:8b:00.0"
    SUBSYSTEMS=="pci"
    DRIVERS=="cciss"
    ATTRS{vendor}=="0x103c"
    ATTRS{device}=="0x3230"
    ATTRS{subsystem_vendor}=="0x103c"
    ATTRS{subsystem_device}=="0x3223"
    ATTRS{class}=="0x010400"
    ATTRS{irq}=="67"

ATTRS{local_cpus}=="ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff"
    ATTRS{local_cpulist}=="0-511"

ATTRS{modalias}=="pci:v0000103Cd00003230sv0000103Csd00003223bc01sc04i00"
    ATTRS{numa_node}=="-1"
    ATTRS{broken_parity_status}=="0"
    ATTRS{msi_bus}==""

  looking at parent device
'/devices/pci0000:4f/0000:4f:00.0/0000:50:00.0/0000:51:04.0':
    KERNELS=="0000:51:04.0"
    SUBSYSTEMS=="pci"
    DRIVERS=="pcieport-driver"
    ATTRS{vendor}=="0x111d"
    ATTRS{device}=="0x801c"
    ATTRS{subsystem_vendor}=="0x0000"
    ATTRS{subsystem_device}=="0x0000"
    ATTRS{class}=="0x060400"
    ATTRS{irq}=="53"

ATTRS{local_cpus}=="ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff"
    ATTRS{local_cpulist}=="0-511"

ATTRS{modalias}=="pci:v0000111Dd0000801Csv00000000sd00000000bc06sc04i00"
    ATTRS{numa_node}=="-1"
    ATTRS{broken_parity_status}=="0"
    ATTRS{msi_bus}=="1"

  looking at parent device
'/devices/pci0000:4f/0000:4f:00.0/0000:50:00.0':
    KERNELS=="0000:50:00.0"
    SUBSYSTEMS=="pci"
    DRIVERS=="pcieport-driver"
    ATTRS{vendor}=="0x111d"
    ATTRS{device}=="0x801c"
    ATTRS{subsystem_vendor}=="0x0000"
    ATTRS{subsystem_device}=="0x0000"
    ATTRS{class}=="0x060400"
    ATTRS{irq}=="0"

ATTRS{local_cpus}=="ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff"
    ATTRS{local_cpulist}=="0-511"

ATTRS{modalias}=="pci:v0000111Dd0000801Csv00000000sd00000000bc06sc04i00"
    ATTRS{numa_node}=="-1"
    ATTRS{broken_parity_status}=="0"
    ATTRS{msi_bus}=="1"

  looking at parent device '/devices/pci0000:4f/0000:4f:00.0':
    KERNELS=="0000:4f:00.0"
    SUBSYSTEMS=="pci"
    DRIVERS=="pcieport-driver"
    ATTRS{vendor}=="0x103c"
    ATTRS{device}=="0x403b"
    ATTRS{subsystem_vendor}=="0x0000"
    ATTRS{subsystem_device}=="0x0000"
    ATTRS{class}=="0x060400"
    ATTRS{irq}=="51"

ATTRS{local_cpus}=="ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff"
    ATTRS{local_cpulist}=="0-511"

ATTRS{modalias}=="pci:v0000103Cd0000403Bsv00000000sd00000000bc06sc04i00"
    ATTRS{numa_node}=="-1"
    ATTRS{broken_parity_status}=="0"
    ATTRS{msi_bus}=="1"

  looking at parent device '/devices/pci0000:4f':
    KERNELS=="pci0000:4f"
    SUBSYSTEMS==""
    DRIVERS==""

> Thanks,
> Kay

Thanks for looking at this.

Andrew

