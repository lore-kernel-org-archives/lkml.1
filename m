Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbYKNGaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbYKNGaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 01:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbYKNGaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 01:30:12 -0500
Received: from mga10.intel.com ([192.55.52.92]:37841 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750777AbYKNGaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 01:30:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,601,1220252400"; 
   d="scan'208";a="639075339"
Subject: Re: system fails to boot
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, tj@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, albcamus@gmail.com,
       pjones@redhat.com, alex.shi@intel.com
In-Reply-To: <20081114061847.GB2227@x200.localdomain>
References: <1226639781.2866.77.camel@ymzhang>
	 <20081114061847.GB2227@x200.localdomain>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Nov 2008 14:29:56 +0800
Message-Id: <1226644196.2866.83.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-11-14 at 09:18 +0300, Alexey Dobriyan wrote:
> On Fri, Nov 14, 2008 at 01:16:21PM +0800, Zhang, Yanmin wrote:
> > Jens,
> > 
> > We run into system boot failure with kernel 2.6.28-rc. We found it on a couple of
> > machines, including T61 notebook, nehalem machine, and another HPC NX6325 notebook.
> > All the machines use FedoraCore 8 or FedoraCore 9. With kernel prior to 2.6.28-rc,
> > system boot doesn't fail.
> > 
> > I debug it and locate the root cause. Pls. see
> > http://bugzilla.kernel.org/show_bug.cgi?id=11899
> > https://bugzilla.redhat.com/show_bug.cgi?id=471517
> > 
> > As a matter of fact, there are 2 bugs.
> > 
> > ﻿1)root=/dev/sda1, system boot randomly fails. Mostly, boot for 5
> > times and fails once. nash has a bug. Some of its functions misuse return value 0.
> > Sometimes, 0 means timeout and no uevent available. Sometimes, 0 means nash gets
> > an uevent, but the uevent isn't block-related (for exmaple, usb). If by coincidence,
> > kernel tells nash that uevents are available, but kernel also set timeout, nash
> > might stops collecting other uevents in queue if current uevent isn't block-related.
> > I work out a patch for nash to fix it. 
> > http://bugzilla.kernel.org/attachment.cgi?id=18858
> > 
> > 2) root=LABEL=/, system always can't boot. initrd init reports
> > switchroot fails. Here is an executation branch of nash when booting:
> >     (1) nash read /sys/block/sda/dev; Assume major is 8 (on my desktop)
> >     (2) nash query /proc/devices with the major number; It found line  "8 sd";
> >     (3) nash use 'sd' to search its own probe table to find device (DISK) type for the device
> >        and add it to its own list;
> >     (4) Later on, it probes all devices in its list to get filesystem labels;
> >        scsi register "8 sd" always.
> > When major is 259, nash fails to find the device(DISK) type. I enables CONFIG_DEBUG_BLOCK_EXT_DEVT=y
> > when compiling kernel, so 259 is picked up for device /dev/sda1, which causes nash to fail
> > to find device (DISK) type.
> > To fixing issue 2), I create a patch for nash and another patch for kernel.
> > http://bugzilla.kernel.org/attachment.cgi?id=18859
> > http://bugzilla.kernel.org/attachment.cgi?id=18837
> > 
> > Below is the patch for kernel 2.6.28-rc4. It registers blkext, a new block device in proc/devices.
> > 
> It's procfs-specific init, what's up?
nash (FC9 uses nash to explain the init script in initrd) reads /proc/devices to check the type of
root device. When ﻿CONFIG_DEBUG_BLOCK_EXT_DEVT=y, the root device MAJOR is 259. Current kernel doesn't
register block device for 259 in /proc/devices.

It's hard to explain in a short statement. Would you like to read it from
﻿http://bugzilla.kernel.org/show_bug.cgi?id=11899?


