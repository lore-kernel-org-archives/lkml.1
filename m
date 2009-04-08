Return-Path: <linux-kernel-owner+w=401wt.eu-S1761724AbZDHM1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761724AbZDHM1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZDHM1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:27:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:45215 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbZDHM1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:27:17 -0400
MIME-Version: 1.0
In-Reply-To: <20090408061901.GN5178@kernel.dk>
References: <20090407180411.GA4324@beardog.cca.cpqcorp.net> 
	<20090408061901.GN5178@kernel.dk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 8 Apr 2009 05:26:59 -0700
Message-ID: <ac3eb2510904080526h36673aa7qb5d530df33a60104@mail.gmail.com>
Subject: Re: [PATCH 1/1] cciss: resubmit export uid, model, vendor, rev to 
	sysfs
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LKML-SCSI <linux-scsi@vger.kernel.org>, andrew.patterson@hp.com,
       mike.miller@hp.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 7, 2009 at 23:19, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Apr 07 2009, Mike Miller (OS Dev) wrote:

> The patch looks fine to me, but my sysfs foo is very weak though. CC'ing
> Kay, perhaps he can help take a quick look at this.

>> + * Initialize sysfs for each logical drive.  This sets up and registers
>> + * the 'c#d#' directory for each individual logical drive under
>> + * /sys/bus/pci/devices/<dev/ccis#/. We also create a link from
>> + * /sys/block/cciss!c#d# to this entry.
>> + */
>> +static int cciss_create_ld_sysfs_entry(struct ctlr_info *h,
>> +                                    drive_info_struct *drv,
>> +                                    int drv_index)
>> +{
>> +     device_initialize(&drv->dev);
>> +     drv->dev.type = &cciss_dev_type;
>> +     dev_set_name(&drv->dev, "c%dd%d", h->ctlr, drv_index);
>> +     drv->dev.parent = &h->dev;
>> +     return device_add(&drv->dev);
>> +}

If I read that correctly, you are creating a hierarchy of devices
where the devices do not belong to any subsystem? This is what we need
to avoid in almost all cases, we need a "subsystem" link in sysfs.

I wold expect the cciss devices not to be a magic, silently created,
subdirectory of a pci device, but to have their own "cciss" bus in
sysfs, so the created devices get proper events at creation time. All
the cciss devices would show up in its own directory
/sys/bus/cciss/devices/*.

I think, you should name all "cciss bus devices" uniquely, and assign
them to a "cciss bus_type". We really do not want unclassified devices
in the chain of parent devices of a block device.

Or do I missing something here?

Kay
