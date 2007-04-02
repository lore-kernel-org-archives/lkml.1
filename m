Return-Path: <linux-kernel-owner+w=401wt.eu-S965054AbXDBRyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965054AbXDBRyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 13:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXDBRyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 13:54:53 -0400
Received: from rwcrmhc14.comcast.net ([216.148.227.154]:57923 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbXDBRyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 13:54:52 -0400
X-Greylist: delayed 13521 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2007 13:54:52 EDT
From: dasperry@comcast.net (dave_sperry@ieee.org)
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Sperry <dave_sperry@ieee.org>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Poor UDP performance using 2.6.21-rc5-rt5
Date: Mon, 02 Apr 2007 17:50:49 +0000
Message-Id: <040220071750.11488.461142790008679B00002CE02206424413979D9D0A9F9C0E0B@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct  4 2006)
X-Authenticated-Sender: ZGFzcGVycnlAY29tY2FzdC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a new data point to add to the confusion.

The box I'm testing has 2 nics in it. The one I have been testing so far is:

00:08.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a3)

The other NIC is an Intel 1gig fiber 

09:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)

The Intel controller did not work 2.6.20 but under 2.6.21-rc5-rt8 it does.

Running the same netperf tests with the Intel NIC produces very different results for the RT case:


setup                    Thruput      CPU% 
Nvidia
2.6.21-rc5 vanilla       935          29%
   netperf @51
   hardirq @50
   softirq @50

Intel
2.6.21-rc5 vanilla       933          30%
   netperf @51
   hardirq @50
   softirq @50

##################################################
Nvidia
2.6.21-rc5-rt8           938          65%
   netperf @51
   hardirq @50
   softirq @50

Intel
2.6.21-rc5-rt8           938          34%
   netperf @51
   hardirq @50
   softirq @50

The Intel NIC seems to behave better under RT 

top for each NIC under test yields some interesting results:

Nvidia 2.6.21-rc5-rt8:
top - 11:03:46 up  1:23,  2 users,  load average: 1.75, 1.31, 0.70
Tasks: 167 total,   2 running, 165 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.8%us, 29.7%sy,  0.0%ni, 34.8%id,  0.0%wa, 22.1%hi, 10.6%si,  0.0%st
Mem:   2035436k total,   618276k used,  1417160k free,    31744k buffers
Swap:  3068372k total,        0k used,  3068372k free,   386060k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 4139 root     -52   0  6440  636  480 S   60  0.0   0:19.14 netperf
 2706 root     -51  -5     0    0    0 R   44  0.0   2:00.70 IRQ-8406
   19 root     -51   0     0    0    0 S   21  0.0   0:38.50 softirq-net-tx/
 4012 eadi      16   0  229m 6852 5584 S    1  0.3   0:05.39 multiload-apple
    6 root     -51   0     0    0    0 S    1  0.0   0:00.95 softirq-net-tx/
 3014 dbus      15   0 21352  896  548 S    1  0.0   0:00.04 dbus-daemon
    1 root      15   0 10308  668  552 S    0  0.0   0:00.74 init
    2 root      RT   0     0    0    0 S    0  0.0   0:00.00 migration/0
    3 root      RT   0     0    0    0 S    0  0.0   0:00.00 posix_cpu_timer
    4 root     -51   0     0    0    0 S    0  0.0   0:00.00 softirq-high/0
    5 root     -51   0     0    0    0 S    0  0.0   0:00.00 softirq-timer/0
    7 root     -51   0     0    0    0 S    0  0.0   0:00.00 softirq-net-rx/
    8 root     -51   0     0    0    0 S    0  0.0   0:00.01 softirq-block/0

########################
Intel 2.6.21-rc5-rt8
top - 11:10:27 up 3 min,  2 users,  load average: 0.00, 0.00, 0.00
Tasks: 167 total,   1 running, 166 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.5%us, 21.6%sy,  0.0%ni, 65.9%id,  0.0%wa,  3.0%hi,  9.0%si,  0.0%st
Mem:   2035436k total,   618012k used,  1417424k free,    29972k buffers
Swap:  3068372k total,        0k used,  3068372k free,   386084k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 3955 root     -52   0  6436  636  480 S   43  0.0   0:19.74 netperf
   20 root     -51   0     0    0    0 S   11  0.0   0:04.86 softirq-net-rx/
    7 root     -51   0     0    0    0 S    7  0.0   0:03.28 softirq-net-rx/
 2370 root     -51  -5     0    0    0 S    6  0.0   0:02.62 IRQ-8408
 3858 eadi      16   0  229m 6848 5584 S    1  0.3   0:01.45 multiload-apple
 3954 eadi      15   0 12712 1096  788 R    0  0.1   0:00.19 top
    1 root      15   0 10304  664  552 S    0  0.0   0:00.75 init
    2 root      RT   0     0    0    0 S    0  0.0   0:00.00 migration/0
    3 root      RT   0     0    0    0 S    0  0.0   0:00.00 posix_cpu_timer
    4 root     -51   0     0    0    0 S    0  0.0   0:00.00 softirq-high/0
    5 root     -51   0     0    0    0 S    0  0.0   0:00.00 softirq-timer/0
    6 root     -51   0     0    0    0 S    0  0.0   0:00.00 softirq-net-tx/
    8 root     -51   0     0    0    0 S    0  0.0   0:00.01 softirq-block/0
    9 root     -51   0     0    0    0 S    0  0.0   0:00.00 softirq-tasklet
   10 root     -51   0     0    0    0 S    0  0.0   0:00.00 softirq-sched/0
############################

I think there is some kind of bad behavior happening in the Nvidia driver
 with respect to softirq-net-tx and IRQ-8406.

Any thoughts? If you want I can post the oprofile from both test cases.

-Dave

