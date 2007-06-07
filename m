Return-Path: <linux-kernel-owner+w=401wt.eu-S933651AbXFGRSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651AbXFGRSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760492AbXFGRSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:18:14 -0400
Received: from bastart.eu.org ([87.230.120.248]:48985 "EHLO router.bastart.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761332AbXFGRSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:18:13 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jun 2007 13:18:11 EDT
Message-ID: <46683DF4.1040703@bastart.eu.org>
Date: Thu, 07 Jun 2007 19:18:44 +0200
From: Axel Gembe <ago@bastart.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 90.0.1.55
X-SA-Exim-Mail-From: ago@bastart.eu.org
Subject: Speed problem with device mapper or dm-crypt
X-SA-Exim-Version: 4.2.1 (built Thu, 26 Apr 2007 18:30:04 +0000)
X-SA-Exim-Scanned: Yes (on router.bastart.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My system is the latest Gentoo with kernel 2.6.22-rc3 on an Athlon XP box.
The kernel version didn't make a difference, I've only recently tried 
many 2.6 kernels.

I'm using the command

    cryptsetup -c aes -s 128 -h sha256 create crypt-theke /dev/hdg5

to create a encrypted mapper device on which an ext3 filesystem lives 
with these mount options:

    /dev/mapper/crypt-theke   /mnt/hd/wd200   ext3   noatime,noauto   0 0

The speed from the device is fine when I read from /dev/mapper/crypt-theke:

    cat /dev/mapper/crypt-theke > /dev/null

    this is very fast and produces this vmstat 1:
    procs -----------memory---------- ---swap-- -----io---- -system-- 
----cpu----
     r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us 
sy id wa
     1  1    160   8260 216060 367104    0    0 34560     0  533 1285  0 
81  0 19
     2  1    160   8608 248296 334100    0    0 34304     0  525 1273  1 
80  0 19
     1  1    160   8336 281056 301084    0    0 34560     0  535 1277  0 
82  0 18


but it is very sluggish when I read from /mnt/hd/wd200:

    cat /mnt/hd/wd200/bigfile > /dev/null

    this is lagging the whole system and produces this vmstat 1:
    procs -----------memory---------- ---swap-- -----io---- -system-- 
----cpu----
     r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us 
sy id wa
     1  1    160   8004 494120  65388    0    0  4248     0  550 1582  3 
14  0 83
     1  1    160   7764 490284  69484    0    0  4100     0  537 1364  0 
12  0 88
     1  1    160   7884 486448  73196    0    0  3716     0  503 1280  0 
12  0 88

This confuses me. Why would using a filesystem in between produce such 
high wait times ?
Is the IO cat makes any different ?

Here are some more values:

Reading from the underlying device:

    filesrv1 ~ # dd if=/dev/hdg5 of=/dev/null bs=1024 count=256000
    256000+0 records in
    256000+0 records out
    262144000 bytes (262 MB) copied, 4.35061 s, 60.3 MB/s

    Produced this vmstat 1:
    procs -----------memory---------- ---swap-- -----io---- -system-- 
----cpu----
     r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us 
sy id wa
     1  1    160   8428 388644 180548    0    0 26112     0  477 1128  1 
16 52 31
     2  0    160   7936 386904 180512    0    0 59008    88  753 1926  0 
41  0 59
     1  1    160   8164 404388 160256    0    0 59776     0  751 1911  2 
40  0 58
     2  0    160   7876 461776  99924    0    0 59520     0  754 1903  1 
41  0 58
     1  0    160   7804 507704  51560    0    0 51584     0  686 1722  0 
38 13 49

Reading from the mapper device:

    filesrv1 ~ # dd if=/dev/mapper/crypt-theke of=/dev/null bs=1024 
count=256000
    256000+0 records in
    256000+0 records out
    262144000 bytes (262 MB) copied, 7.8481 s, 33.4 MB/s

    Produced this vmstat 1:
    procs -----------memory---------- ---swap-- -----io---- -system-- 
----cpu----
     r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us 
sy id wa
     1  1    160   7664 527800  31244    0    0 28476    60  524 1135  1 
71 10 18
     1  1    160   7508 529224  30788    0    0 33024     0  532 1237  1 
77  0 22
     2  1    160   8412 534228  26708    0    0 32644    96  549 1240  1 
83  0 16
     2  0    160   8332 535992  26004    0    0 32768     0  539 1217  2 
80  0 18
     2  1    160   8412 537180  26020    0    0 32940     0  548 1257  2 
84  0 14
     3  1    160   8152 538752  26012    0    0 33280     8  525 1244  1 
77  0 22
     2  1    160   7660 540568  26016    0    0 32788     0  537 1302  1 
82  0 17
     1  0    160   8240 541296  25984    0    0 30336     0  516 1184  0 
74  8 18

Reading from a big file on the mounted filesystem:

    filesrv1 ~ # dd if=/mnt/hd/wd200/bigfile of=/dev/null bs=1024 
count=256000
    256000+0 records in
    256000+0 records out
    262144000 bytes (262 MB) copied, 67.2541 s, 3.9 MB/s

    Produced this vmstat 1:
    procs -----------memory---------- ---swap-- -----io---- -system-- 
----cpu----
     r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us 
sy id wa
     3  1    160   7556 264780 292864    0    0  4484   112  538 1576  4 
16  0 80
     1  1    160   7916 260816 296448    0    0  3588     0  492 1205  0 
12  0 88
     1  1    160   8036 256852 300288    0    0  3844     8  541 1307  
1  8  0 91
     1  1    160   7632 253272 304640    0    0  4356     0  527 1359  7 
14  0 79
     1  1    160   8348 248540 308608    0    0  3972     0  516 1261  
0  9  0 91
     1  1    160   8168 244964 312448    0    0  3844     0  501 1254  0 
12  0 88
     1  1    160   8352 240312 316848    0    0  4484     0  505 1241  0 
10  0 90
     1  1    160   7896 237764 320304    0    0  3588    48  490 1232  6 
12  0 82

