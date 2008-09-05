Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbYIEHiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbYIEHiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 03:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYIEHiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 03:38:08 -0400
Received: from rrzmta2.rz.uni-regensburg.de ([194.94.155.53]:4460 "EHLO
	rrzmta2.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbYIEHiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 03:38:07 -0400
From: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Organization: Universitaetsklinikum Regensburg
To: linux-kernel@vger.kernel.org
Date: Fri, 05 Sep 2008 09:37:42 +0200
MIME-Version: 1.0
Subject: Q: (2.6.16 & ext3) bad SMP load balancing when writing to ext3 on slow device
Message-ID: <48C0FDE7.29250.1500F344@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Content-Conformance: HerringScan-0.27/Sophos-P=4.29.0+V=4.29+U=2.07.201+R=05 May 2008+T=405569@20080905.073704Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while copying large remote files for an USB memory stick formatted with ext3 using 
scp, I noticed a stall in wrie speed. Looking at the system with top I saw:
top - 09:25:25 up 55 days, 23:49,  2 users,  load average: 11.09, 7.41, 4.43
Tasks: 128 total,   1 running, 127 sleeping,   0 stopped,   0 zombie
Cpu0  :  7.6%us,  0.3%sy,  0.0%ni,  0.0%id, 90.4%wa,  0.3%hi,  1.3%si,  0.0%st
Cpu1  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,100.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,100.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu3  :  0.0%us,  1.7%sy,  0.0%ni,  0.0%id, 98.3%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   1028044k total,  1017956k used,    10088k free,    34784k buffers
Swap:  2097140k total,      616k used,  2096524k free,   733100k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
11284 root      18   0 29168 1960 1504 D    2  0.2   0:11.81 scp
  137 root      15   0     0    0    0 D    0  0.0  14:16.59 pdflush
10865 root      15   0     0    0    0 D    0  0.0   0:00.50 kjournald
11355 root      15   0     0    0    0 D    0  0.0   0:00.09 pdflush
11396 root      15   0     0    0    0 D    0  0.0   0:00.12 pdflush
11397 root      15   0     0    0    0 D    0  0.0   0:00.06 pdflush
12007 root      15   0     0    0    0 D    0  0.0   0:00.02 pdflush
12070 root      16   0 23976 2376 1744 R    0  0.2   0:00.28 top
12294 root      15   0     0    0    0 D    0  0.0   0:00.00 pdflush
12295 root      15   0     0    0    0 D    0  0.0   0:00.02 pdflush
12296 root      15   0     0    0    0 D    0  0.0   0:00.02 pdflush
27490 root      10  -5     0    0    0 D    0  0.0   0:02.93 usb-storage

First, it's impressive that a singly copy job can raise the load to above 10, and 
the next thing is that writing to a slow device can make 4 CPUs (actually two with 
hyperthreading) busy. The pdflush daemons are expected to bring dirty blocks onto 
the device, I guess. Does it make any sense to make four CPUs busy with doing so?

Here's another snapshot showing the assigned CPU also:

top - 09:32:18 up 55 days, 23:56,  2 users,  load average: 10.63, 9.99, 6.78
Tasks: 127 total,   1 running, 126 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,100.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,100.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,  1.7%id, 98.3%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,100.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   1028044k total,  1017896k used,    10148k free,    18044k buffers
Swap:  2097140k total,      616k used,  2096524k free,   741616k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
  137 root      15   0     0    0    0 D    0  0.0  14:16.71 1 pdflush
 4299 root      17   0  5860  752  596 D    0  0.1   9:36.19 1 syslogd
10865 root      15   0     0    0    0 D    0  0.0   0:00.62 1 kjournald
11284 root      18   0 29168 1960 1504 D    0  0.2   0:14.76 3 scp
11355 root      15   0     0    0    0 D    0  0.0   0:00.19 0 pdflush
11396 root      15   0     0    0    0 D    0  0.0   0:00.24 1 pdflush
11397 root      15   0     0    0    0 D    0  0.0   0:00.22 1 pdflush
12294 root      15   0     0    0    0 D    0  0.0   0:00.11 1 pdflush
12295 root      15   0     0    0    0 D    0  0.0   0:00.14 1 pdflush
12296 root      15   0     0    0    0 D    0  0.0   0:00.13 1 pdflush
12591 root      16   0 23976 2376 1744 R    0  0.2   0:00.07 3 top
27490 root      10  -5     0    0    0 D    0  0.0   0:03.13 3 usb-storage

At times like shown, the scp seems to come to a complete halt. (Previously I had 
been using VFAT filesystem on the stick, and copy went much smoother, but the 
filesystem was full, so I tried another filesystem.)

Would anybody bee so kind to explain why the system looks like that? I'm not 
subscribed, so please honor the CC:.

Regards,
Ulrich Windl

