Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYKQIVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYKQIVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYKQIUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:20:54 -0500
Received: from mga05.intel.com ([192.55.52.89]:56505 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751878AbYKQIUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:20:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,617,1220252400"; 
   d="scan'208";a="404454243"
Subject: Re: system fails to boot
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, tj@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, albcamus@gmail.com,
       pjones@redhat.com, alex.shi@intel.com, fedora-devel-list@redhat.com
In-Reply-To: <1226644196.2866.83.camel@ymzhang>
References: <1226639781.2866.77.camel@ymzhang>
	 <20081114061847.GB2227@x200.localdomain> <1226644196.2866.83.camel@ymzhang>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 16:19:55 +0800
Message-Id: <1226909995.2866.116.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-11-14 at 14:29 +0800, Zhang, Yanmin wrote:
> On Fri, 2008-11-14 at 09:18 +0300, Alexey Dobriyan wrote:
> > On Fri, Nov 14, 2008 at 01:16:21PM +0800, Zhang, Yanmin wrote:
> > > Jens,
> > > 
> > > We run into system boot failure with kernel 2.6.28-rc. We found it on a couple of
> > > machines, including T61 notebook, nehalem machine, and another HPC NX6325 notebook.
> > > All the machines use FedoraCore 8 or FedoraCore 9. With kernel prior to 2.6.28-rc,
> > > system boot doesn't fail.
> > > 
> > > I debug it and locate the root cause. Pls. see
> > > http://bugzilla.kernel.org/show_bug.cgi?id=11899
> > > https://bugzilla.redhat.com/show_bug.cgi?id=471517
> > > 
> > > As a matter of fact, there are 2 bugs.
> > > 
> > > 2) root=LABEL=/, system always can't boot. initrd init reports
> > > switchroot fails. Here is an executation branch of nash when booting:
> > >     (1) nash read /sys/block/sda/dev; Assume major is 8 (on my desktop)
> > >     (2) nash query /proc/devices with the major number; It found line  "8 sd";
> > >     (3) nash use 'sd' to search its own probe table to find device (DISK) type for the device
> > >        and add it to its own list;
> > >     (4) Later on, it probes all devices in its list to get filesystem labels;
> > >        scsi register "8 sd" always.
> > > When major is 259, nash fails to find the device(DISK) type. I enables CONFIG_DEBUG_BLOCK_EXT_DEVT=y
> > > when compiling kernel, so 259 is picked up for device /dev/sda1, which causes nash to fail
> > > to find device (DISK) type.
> > > To fixing issue 2), I create a patch for nash and another patch for kernel.
> > > http://bugzilla.kernel.org/attachment.cgi?id=18859
> > > http://bugzilla.kernel.org/attachment.cgi?id=18837
As for issue 2) with root=LABEL=/, I double-checked nash codes. That's really beyond what I imagined. I'm not
an expert of nash. kernel might allocate MINOR number from MAX_EXT_DEVT (259) for any type of disk
(cciss/ataraid/sd/ide/floppy/md ...), while nash assumes a MAJOR number is used by one of them exclusively.
In the other hand, nash probes scsi/ide/usb serially as long as the type is DEV_TYPE_DISK. I won't say
nash codes are not perfect, but nash is growing.

Peter Jones,

You maintain nash. What's your opinion?

-yanmin


