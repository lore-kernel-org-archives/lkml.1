Return-Path: <linux-kernel-owner+w=401wt.eu-S932441AbXE2U7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbXE2U7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764912AbXE2U71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:59:27 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:41135 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759680AbXE2U70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:59:26 -0400
Date: Tue, 29 May 2007 23:59:27 +0300
From: Dan Aloni <da-x@monatomic.org>
To: linux-usb-devel@lists.sourceforge.net
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Dealing with flaky USB storage devices and rootfs
Message-ID: <20070529205927.GA24808@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have a system where the rootfs is a partition on a USB device,
and I've noticed upon a few rare cases where the USB controller 
loses the connection to the USB device after some uptime (days,
weeks...), and the USB device reappears a very short time later.

It doesn't really matter why, I guess that USB controllers and
storage devices aren't always of the best quality - let's assume
that. The issue is that Linux currently makes it problematic
to recover the rootfs for several reasons.

If /dev/sda1 is mounted as root and the SCSI device goes into 
offline mode, it is quite impossible to get out of this situation.
At first, I had to disable the usermode helper that sends events 
to udev since it blocks on the dysfunction /dev/sda1. Afterwards, 
I noticed that the reappearing device is being assigned with 
/dev/sdb along with a new SCSI host. I guess the the VFS and 
block layer still keep a reference to the old scsi_disk and as 
a result sd doesn't free it.

So, I gave some thoughts about this, I and came up with two 
main solutions:

1) Improve the USB storage error handling - bind the already 
existing SCSI host to the USB port that has the device, e.g., 
if host2 got created for usb 5-3 then keep it that way for the 
sake of EH. /dev/sda1 should come to life when the USB device 
recovers, unless a few seconds have passed or some attributes 
(such as manufactor id or serial) have changed.

2) Block layer hack - Write a special layering block device 
driver that acts as a proxy to the currently functioning 
/dev/sd* which gets auto-detected by this block layer driver. 
md multipath for the 'poor', you might say..

I chose '2' for the time being. It was much easier than hacking
around the USB subsystem... Yes, I know rootfs on USB is an
uncommon use-case at the moment but I do like to know if there 
are some improvements planned in this area.

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
