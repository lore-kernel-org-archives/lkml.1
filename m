Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbZA0KnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbZA0KnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 05:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZA0Km4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 05:42:56 -0500
Received: from cwm83.internetdsl.tpnet.pl ([83.19.120.83]:2551 "EHLO
	szyszka.in.waw.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZA0Kmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 05:42:55 -0500
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2009 05:42:55 EST
Date: Tue, 27 Jan 2009 10:46:34 +0100
From: linux-kernel-owner@vger.kernel.org
To: lkml@vger.kernel.org, Takashi Sato <t-sato@yk.jp.nec.com>
Subject: FIFREEZE guarantees
Message-ID: <20090127094634.GA24368@szyszka.in.waw.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm confused about what 'freezing' a filesystem with FIFREEZE is 
supposed to do. I thought that it roughly the same a sync, that is the 
snapshot of filesystem taken between FIFREEZE and FITHAW should be error 
free.

It doesn't seem to work this way:
(I have ext3 filesystem on a LVM volume, mounted on /)
./fifreeze /                  (this just makes the FIFREEZE ioctl)
lvcreate -L 20642428k -n root_fscksnap -s /dev/system/root
  Rounding up size to full physical extent 19.69 GB
  Logical volume "root_fscksnap" created
./fithaw /                    (this just makes the FITHAW ioctl)
fsck.ext3 -f -n /dev/system/root_fscksnap -v -C0
  e2fsck 1.41.1 (01-Sep-2008)
  Pass 1: Checking inodes, blocks, and sizes
  Inodes that were part of a corrupted orphan linked list found.  Fix? no        
  Inode 460301 was part of the orphaned inode list.  IGNORED.
  ...
  Deleted inode 615223 has zero dtime.  Fix? no                                  
  ...
  /dev/system/root_fscksnap: ********** WARNING: Filesystem still has errors **********

Mounting the snapshot, however, allows the fsck to proceed without error:
./fifreeze /
lvcreate -L 20642428k -n root_fscksnap -s /dev/system/root
./fithaw /
mount -v -t ext3 /dev/system/root_fscksnap /dev/shm/fsmount.cP2A2a
  /dev/mapper/system-root_fscksnap on /dev/shm/fsmount.cP2A2a type ext3 (rw)
umount -v /dev/shm/fsmount.cP2A2a
  /dev/mapper/system-root_fscksnap umounted
fsck.ext3 -f -n /dev/system/root_fscksnap -v -C0
  ... file system clean ...

Looking for some enlightment,
Zbyszek

