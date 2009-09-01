Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbZIAQuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbZIAQuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbZIAQui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:50:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbZIAQui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:50:38 -0400
Date: Tue, 1 Sep 2009 12:50:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       dm-devel@redhat.com
Subject: Regarding dm-ioband tests
Message-ID: <20090901165011.GB3753@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryo,

I decided to play a bit more with dm-ioband and started doing some
testing. I am doing a simple two dd threads doing reads and don't seem
to be gettting the fairness. So thought will ask you what's the issue
here. Is there an issue with my testing procedure.

I got one 40G SATA drive (no hardware queuing). I have created two
partitions on that disk /dev/sdd1 and /dev/sdd2 and created two ioband
devices ioband1 and ioband2 on partitions sdd1 and sdd2 respectively. The
weights of ioband1 and ioband2 devices are 200 and 100 respectively. 

I am assuming that this setup will create two default groups and IO
going to partition sdd1 should get double the BW of partition sdd2.

But it looks like I am not gettting that behavior. Following is the output
of "dmsetup table" command. This snapshot has been taken every 2 seconds
while IO was going on. Column 9 seems to be containing how many sectors
of IO has been done on a particular io band device and group. Looking at
the snapshot, it does not look like that ioband1 default group got double
the BW of ioband2 default group.  

Am I doing something wrong here?

ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0

ioband2: 0 40355280 ioband 1 -1 96 0 11528 0 0 0
ioband1: 0 37768752 ioband 1 -1 82 0 9736 0 0 0

ioband2: 0 40355280 ioband 1 -1 748 2 93032 0 0 0
ioband1: 0 37768752 ioband 1 -1 896 0 112232 0 0 0

ioband2: 0 40355280 ioband 1 -1 1326 5 165816 0 0 0
ioband1: 0 37768752 ioband 1 -1 1816 0 228312 0 0 0

ioband2: 0 40355280 ioband 1 -1 1943 6 243712 0 0 0
ioband1: 0 37768752 ioband 1 -1 2692 0 338760 0 0 0

ioband2: 0 40355280 ioband 1 -1 2461 10 308576 0 0 0
ioband1: 0 37768752 ioband 1 -1 3618 0 455608 0 0 0

ioband2: 0 40355280 ioband 1 -1 3118 11 391352 0 0 0
ioband1: 0 37768752 ioband 1 -1 4406 0 555032 0 0 0

ioband2: 0 40355280 ioband 1 -1 3734 15 468760 0 0 0
ioband1: 0 37768752 ioband 1 -1 5273 0 664328 0 0 0

ioband2: 0 40355280 ioband 1 -1 4307 17 540784 0 0 0
ioband1: 0 37768752 ioband 1 -1 6181 0 778992 0 0 0

ioband2: 0 40355280 ioband 1 -1 4930 19 619208 0 0 0
ioband1: 0 37768752 ioband 1 -1 7028 0 885728 0 0 0

ioband2: 0 40355280 ioband 1 -1 5599 22 703280 0 0 0
ioband1: 0 37768752 ioband 1 -1 7815 0 985024 0 0 0

ioband2: 0 40355280 ioband 1 -1 6586 27 827456 0 0 0
ioband1: 0 37768752 ioband 1 -1 8327 0 1049624 0 0 0

Following are details of my test setup.
---------------------------------------
I took dm-ioband patch version 1.12.3 and applied on 2.6.31-rc6.

Created ioband devices using following command.
----------------------------------------------
echo "0 $(blockdev --getsize /dev/sdd1) ioband /dev/sdd1 1 0 0 none"
"weight 0 :200" | dmsetup create ioband1
echo "0 $(blockdev --getsize /dev/sdd2) ioband /dev/sdd2 1 0 0 none"
"weight 0 :100" | dmsetup create ioband2

mount /dev/mapper/ioband1 /mnt/sdd1
mount /dev/mapper/ioband2 /mnt/sdd2

Started two dd threads
======================
dd if=/mnt/sdd1/testzerofile1 of=/dev/null &
dd if=/mnt/sdd2/testzerofile1 of=/dev/null &

Output of dmsetup table command
================================
ioband2: 0 40355280 ioband 8:50 1 4 192 none weight 768 :100
ioband1: 0 37768752 ioband 8:49 1 4 192 none weight 768 :200

Thanks
Vivek
