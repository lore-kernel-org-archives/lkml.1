Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbYKNNRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbYKNNRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 08:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbYKNNRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 08:17:24 -0500
Received: from smtp.nokia.com ([192.100.122.230]:32451 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbYKNNRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 08:17:23 -0500
Message-ID: <491D7C4C.3090907@nokia.com>
Date: Fri, 14 Nov 2008 15:25:32 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Error testing ext3 on brd ramdisk
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Nov 2008 13:17:12.0922 (UTC) FILETIME=[4E77EBA0:01C9465B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am trying to test EXT3 on a ramdisk and after some number of mounts
(anywhere from 7 to 603 so far), I get errors from e2fsck like this:

/dev/ram0: HTREE directory inode 137 has an invalid root node.
HTREE INDEX CLEARED.
/dev/ram0: Entry 'f1770' in /work/p0/da/d1c61 (137) has deleted/unused inode 692.  CLEARED.
/dev/ram0: Entry 'fa37' in /work/p0/da/d1c61 (137) has deleted/unused inode 799.  CLEARED.
/dev/ram0: Entry 'c1686' in /work/p0/da/d1c61 (137) has deleted/unused inode 470.  CLEARED.
/dev/ram0: Entry 'c19b8' in /work/p0/da/d1c61 (137) has an incorrect filetype (was 3, should be 1).

/dev/ram0: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
       (i.e., without -a or -p options)


This is what I do:


modprobe brd rd_nr=1 rd_size=4096
mkfs.ext3 /dev/ram0
dmesg -n8
i=0
while (true); do
	i=`expr $i + 1`
	echo -------------------------------------------------------------
	echo Cycle $i
	date
	echo Mounting
	sleep 1
	mount -t ext3 /dev/ram0 /mnt/test_file_system || exit 1
	echo Removing old fsstress data
	rm -rf /mnt/test_file_system/work
	mkdir /mnt/test_file_system/work || exit 1
	echo Starting fsstress
	fsstress -d /mnt/test_file_system/work -p 3 -l 0 -n 100000000 &
	echo Sleeping 30 seconds
	sleep 30
	echo Stopping fsstress
	while (ps -e | grep fsstress);do
		pkill fsstress
		sleep 1
	done
	echo Unmounting
	umount /mnt/test_file_system || exit 1
	echo Checking
	sleep 1
	e2fsck -fvp /dev/ram0 || exit 1
done


It seems to happen ever since the introduction of brd (Feb '08).

Does anyone know what is going on?

Regards
Adrian

