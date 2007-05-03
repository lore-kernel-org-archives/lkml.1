Return-Path: <linux-kernel-owner+w=401wt.eu-S1161001AbXECJIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161001AbXECJIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030802AbXECJIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:08:53 -0400
Received: from mail.syneticon.net ([213.239.212.131]:38109 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030778AbXECJIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:08:52 -0400
Message-ID: <4639A63F.9030300@wpkg.org>
Date: Thu, 03 May 2007 11:07:11 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: davidsen@tmr.com
Subject: Re: Add a norecovery option to ext3/4?
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:

> I wonder what happens if the device is really read-only and the o/s 
> tries to replay the journal as part of a r/o mount? I suspect the system 
> will refuse totally with an i/o error, not what you want.

I exported a ext3 volume via iSCSI, in read-only mode.
It is mounted on the iSCSI target already, so it makes sense to mount it 
*really* read-only on iSCSI initiator.

It is accessible to the iSCSI initiator as /dev/sdat - let's try to use it:


# mount /dev/sdat /mnt/1
mount: block device /dev/sdat is write-protected, mounting read-only
mount: wrong fs type, bad option, bad superblock on /dev/sdat,
        missing codepage or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so


# dmesg -c
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access unavailable, cannot proceed.



So, no go.

What about ext2 mount?

# mount -t ext2 /dev/sdat /mnt/1
mount: block device /dev/sdat is write-protected, mounting read-only
mount: wrong fs type, bad option, bad superblock on /dev/sdat,
        missing codepage or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

# dmesg -c
EXT2-fs: sdat: couldn't mount because of unsupported optional features (4).

Still, we're not able to mount the partition.


Now, we umount it on iSCSI target, and try to mount it again on the 
initiator - ext3 works:

# mount /dev/sdat /mnt/1
mount: block device /dev/sdat is write-protected, mounting read-only


ext2 works, too:

# umount /mnt/1
# mount -t ext2 /dev/sdat /mnt/1
mount: block device /dev/sdat is write-protected, mounting read-only


So, the only way to see data from an already mounted ext3 partition is 
(iSCSI target exports it to multiple iSCSI initiators):

- export it read-only
- umount it
- mount it as ext2
- mount on iSCSI initiators as either ext2 or ext3 (will be forced 
read-only)


Or:

- export it as read-only
- mount on iSCSI initiators as either ext2 or ext3 (will be forced 
read-only)
- mount it as ext3 on iSCSI target


Both ways can be certainly unwanted in some cases.


Certainly, I would like the "norecovery" option.



-- 
Tomasz Chmielewski
http://wpkg.org
