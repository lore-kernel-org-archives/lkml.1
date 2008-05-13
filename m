Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbYEMIvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbYEMIvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757281AbYEMIu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:50:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:32872 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757239AbYEMIuz (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:50:55 -0400
Date: Tue, 13 May 2008 18:50:47 +1000
From: David Chinner <dgc@sgi.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [BUG] remount ro on loopback mount leaves unmountable filesystem behind
Message-ID: <20080513085047.GY155679365@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following steps will leave an unmountable filesystem
behind. This test "works" using ext3 or XFS. XFS version is
as follows replacing steps with ext3 specific commands results
in the same unmountable filesystem problem:

$ mount -t xfs /dev/sdb6 /mnt/scratch
$ mkdir /mnt/scratch/mnt
$ touch /mnt/scratch/img
$ mkfs.xfs -f -d file,name=/mnt/scratch/img,size=1g
$ mount -t xfs -o loop /mnt/scratch/img /mnt/scratch/mnt

All normal up to here. I can unmount everything just fine.

$ umount /mnt/scratch/mnt
$ umount /mnt/scratch
$

Same thing, but remounting the loop filesystem readonly
before unmounting:

$ mount -t xfs /dev/sdb6 /mnt/scratch
$ mkdir /mnt/scratch/mnt
$ touch /mnt/scratch/img
$ mkfs.xfs -f -d file,name=/mnt/scratch/img,size=1g
$ mount -t xfs -o loop /mnt/scratch/img /mnt/scratch/mnt
$ mount -t xfs -o remount,ro /mnt/scratch/img /mnt/scratch/mnt
$ umount /mnt/scratch/mnt
$ umount /mnt/scratch
umount: /mnt/scratch: device is busy
umount: /mnt/scratch: device is busy
$

At this point /mnt/scratch is unmountable. lsof shows no open
references to the filesytem, so it would seem to be a reference
count leak somewhere....

Reproduced on 2.6.25-rc3 on ia64 and x86_64, and UML on
2.6.26-pre-rc1. Found when changing XFSQA test 073 to host
loopback images and mounts mounts on something other than /tmp.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
