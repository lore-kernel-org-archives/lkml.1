Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbXDEQdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbXDEQdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 12:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXDEQdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 12:33:11 -0400
Received: from tornado.reub.net ([210.185.126.1]:38924 "EHLO tornado.reub.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbXDEQdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 12:33:09 -0400
Message-ID: <461524BF.7050304@reub.net>
Date: Fri, 06 Apr 2007 02:33:03 +1000
From: Reuben Farrelly <reuben-linuxkernel@reub.net>
User-Agent: Thunderbird 2.0.0.0pre (Windows/20070404)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, neilb@suse.de
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: RAID1 "out of memory" error, was Re: 2.6.21-rc5-mm4
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
In-Reply-To: <20070402224745.71a25af7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 3/04/2007 3:47 PM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> 
> - The oops in git-net.patch has been fixed, so that tree has been restored. 
>   It is huge.
> 
> - Added the device-mapper development tree to the -mm lineup (Alasdair
>   Kergon).  It is a quilt tree, living at
>   ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/.
> 
> - Added davidel's signalfd stuff.

Looks like some damage, or maybe intolerance to on-disk damage, to RAID-1.

md1 is the first array on the disk, and it refuses to start up on boot, or after 
boot.

tornado ~ # cat /proc/mdstat
Personalities : [raid1]
md1 : inactive sda1[0] sdc1[1]
       208640 blocks

md3 : active raid1 sdc3[1] sda3[0]
       20008832 blocks [2/2] [UU]
       bitmap: 0/153 pages [0KB], 64KB chunk

md5 : active raid1 sdc5[1] sda5[0]
       10008384 blocks [2/2] [UU]
       bitmap: 4/153 pages [16KB], 32KB chunk

md6 : active raid1 sdc6[1] sda6[0]
       10008384 blocks [2/2] [UU]
       bitmap: 0/153 pages [0KB], 32KB chunk

md8 : active raid1 sdc8[1] sda8[0]
       1003904 blocks [2/2] [UU]
       bitmap: 0/123 pages [0KB], 4KB chunk

md10 : active raid1 sdc10[1] sda10[0]
       119933120 blocks [2/2] [UU]
       bitmap: 1/229 pages [4KB], 256KB chunk

md2 : active raid1 sdc2[1] sda2[0]
       100004544 blocks [2/2] [UU]
       bitmap: 10/191 pages [40KB], 256KB chunk

unused devices: <none>
tornado ~ #

tornado ~ # mdadm --examine /dev/sda1
/dev/sda1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : f5c2e565:5ed956c0:33b08c07:16154426
   Creation Time : Fri Feb  2 10:16:29 2007
      Raid Level : raid1
   Used Dev Size : 104320 (101.89 MiB 106.82 MB)
      Array Size : 104320 (101.89 MiB 106.82 MB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 1

     Update Time : Fri Apr  6 02:06:17 2007
           State : clean
Internal Bitmap : present
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : d3668aaa - correct
          Events : 0.368


       Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       33        1      active sync   /dev/sdc1
tornado ~ # mdadm --examine /dev/sdc1
/dev/sdc1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : f5c2e565:5ed956c0:33b08c07:16154426
   Creation Time : Fri Feb  2 10:16:29 2007
      Raid Level : raid1
   Used Dev Size : 104320 (101.89 MiB 106.82 MB)
      Array Size : 104320 (101.89 MiB 106.82 MB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 1

     Update Time : Fri Apr  6 02:06:17 2007
           State : clean
Internal Bitmap : present
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : d3668acc - correct
          Events : 0.368


       Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   /dev/sdc1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       33        1      active sync   /dev/sdc1
tornado ~ #


tornado ~ # mdadm --assemble /dev/md1 /dev/sda1 /dev/sdc1
mdadm: device /dev/md1 already active - cannot assemble it
tornado ~ # mdadm --run /dev/md1
mdadm: failed to run array /dev/md1: Cannot allocate memory
tornado ~ #

and looking at a dmesg, this is logged:

md: bind<sdc1>
md: bind<sda1>
raid1: raid set md1 active with 2 out of 2 mirrors
md1: bitmap initialized from disk: read 0/1 pages, set 0 bits, status: -12
md1: failed to create bitmap (-12)
md: pers->run() failed ...

tornado ~ # uname -a
Linux tornado 2.6.21-rc5-mm4 #1 SMP Thu Apr 5 23:47:42 EST 2007 x86_64 Intel(R) 
Pentium(R) 4 CPU 3.00GHz GenuineIntel GNU/Linux
tornado ~ #

The last known version that worked was 2.6.21-rc3-mm1 - I haven't been testing 
out the -mm releases so much lately.

Also, Andrew, can you please restart posting/cc'ing your -mm announcements to 
the linux-kernel-announce@vger.kernel.org list?  Seems this stopped around about 
2.6.20, it was handy.

.config is up at http://www.reub.net/files/kernel/configs/2.6.21-rc5-mm4

Thanks,
Reuben
