Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452Ab0AXSzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0AXSzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 13:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856Ab0AXSzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 13:55:46 -0500
Received: from smtp.rozsnyo.com ([77.93.220.61]:39432 "EHLO smtp.rozsnyo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab0AXSzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 13:55:45 -0500
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jan 2010 13:55:45 EST
Message-ID: <4B5C963D.8040802@rozsnyo.com>
Date: Sun, 24 Jan 2010 19:49:33 +0100
From: =?UTF-8?B?IkluZy4gRGFuaWVsIFJvenNuecOzIg==?= <daniel@rozsnyo.com>
Organization: REAS
User-Agent: Thunderbird 2.0.0.23 (X11/20091216)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: bio too big - in nested raid setup
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
   I am having troubles with nested RAID - when one array is added to 
the other, the "bio too big device md0" messages are appearing:

bio too big device md0 (144 > 8)
bio too big device md0 (248 > 8)
bio too big device md0 (32 > 8)

   From internet searches I've found no solution or error like mine, 
just a note about data corruption when this is happening.

Description:

   My setup is the following - one 2TB and four 500GB drives. The goal 
is to have a mirror of the 2TB drive to a linear array of the other four 
drives.

   So.. the state without the error above is this:

# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md1 : active linear sdb1[0] sde1[3] sdd1[2] sdc1[1]
       1953535988 blocks super 1.1 0k rounding

md0 : active raid1 sda2[0]
       1953447680 blocks [2/1] [U_]
       bitmap: 233/233 pages [932KB], 4096KB chunk

unused devices: <none>

   With these block request sizes:

# cat /sys/block/md{0,1}/queue/max_{,hw_}sectors_kb
127
127
127
127

   Now, I add the four drive array to the mirror - and the system starts 
showing the bio error at any significant disk activity..  (probably 
writes only). The reboot/shutdown process is full of these errors.

   The step which messes up the system (ignore re-added, it happened the 
very first time I've constructed the 4 drive array a hour ago):

# mdadm /dev/md0 --add /dev/md1
mdadm: re-added /dev/md1

# cat /sys/block/md{0,1}/queue/max_{,hw_}sectors_kb
4
4
127
127

The dmesg is just showing this:

md: bind<md1>
RAID1 conf printout:
  --- wd:1 rd:2
  disk 0, wo:0, o:1, dev:sda2
  disk 1, wo:1, o:1, dev:md1
md: recovery of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 
KB/sec) for recovery.
md: using 128k window, over a total of 1953447680 blocks.


   And as soon as a write occures to the array:

bio too big device md0 (40 > 8)

   The removal of md1 from md0 does not help the situation, I need to 
reboot the machine.

   The md0 array bears LVM and inside it a root / swap / portage / 
distfiles and home logical volumes.

   My system is:

# uname -a
Linux desktop 2.6.32-gentoo-r1 #2 SMP PREEMPT Sun Jan 24 12:06:13 CET 
2010 i686 Intel(R) Xeon(R) CPU X3220 @ 2.40GHz GenuineIntel GNU/Linux


Thanks for any help,

Daniel

